"""Offline safety/reconciliation tests; these do not establish live OCI deployment."""
import argparse
import base64
import datetime
import struct
import io
import hashlib
import types
import json
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch
import zipfile

import oracle
import oracle_remote


class OracleTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(); self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name).resolve(); self.root.chmod(0o700)
        self.value = {'deployment_id': 'commerce-test', 'region': 'eu-frankfurt-1',
                      'compartment_ocid': 'ocid1.compartment.oc1..example', 'availability_domain': 'Abcd:EU-FRANKFURT-1-AD-1',
                      'image_ocid': 'ocid1.image.oc1.eu-frankfurt-1.example', 'ssh_public_key': 'ssh-ed25519 ' + base64.b64encode(struct.pack('>I', 11) + b'ssh-ed25519' + struct.pack('>I', 32) + b'x' * 32).decode(),
                      'ssh_source_cidr': '8.8.8.8/32', 'compute_profile': 'always-free-arm', 'stop_at_utc': ''}

    def write(self, name, body):
        p = self.root / name; p.write_text(body); p.chmod(0o600); return p

    def load(self, value):
        return oracle.variables(self.write('variables.json', json.dumps(value)))

    def client(self):
        o = object.__new__(oracle.Oracle)
        o.state = self.root; o.value = self.value; o.args = argparse.Namespace(wait_seconds=0)
        return o

    def test_valid_public_only_variables(self):
        self.assertEqual(self.load(self.value), self.value)

    def test_rejects_broad_ssh_and_extra_secret_inputs(self):
        for change in [{'ssh_source_cidr': '0.0.0.0/0'}, {'ssh_source_cidr': '10.0.0.1/32'},
                       {'ssh_public_key': '-----BEGIN PRIVATE KEY-----'}, {'secret': 'never-upload'},
                       {'deployment_id': 'x;touch owned'}, {'region': 'a/../../b'}]:
            with self.subTest(change=change), self.assertRaises(ValueError):
                self.load({**self.value, **change})

    def test_rejects_public_private_config(self):
        p = self.write('variables.json', json.dumps(self.value)); p.chmod(0o644)
        with self.assertRaises(ValueError): oracle.variables(p)

    def test_rejects_symlink_ancestor(self):
        target = self.root / 'real'; target.mkdir(mode=0o700)
        p = target / 'state'; p.mkdir(mode=0o700)
        (self.root / 'link').symlink_to(target, target_is_directory=True)
        with self.assertRaises(ValueError): oracle.private_path(self.root / 'link/state', directory=True)

    def test_template_zip_never_contains_credentials_or_state(self):
        for name in oracle.TEMPLATE_FILES: self.write(name, name)
        self.write('operator.auto.tfvars', 'secret'); self.write('terraform.tfstate', 'secret')
        first = oracle.package(self.root, self.root / 'one.zip')
        second = oracle.package(self.root, self.root / 'two.zip')
        self.assertEqual(first, second)
        self.assertEqual((self.root / 'one.zip').read_bytes(), (self.root / 'two.zip').read_bytes())
        with zipfile.ZipFile(self.root / 'one.zip') as z:
            self.assertEqual(set(z.namelist()), set(oracle.TEMPLATE_FILES))

    def test_template_symlink_refused(self):
        for name in oracle.TEMPLATE_FILES: self.write(name, name)
        (self.root / 'main.tf').unlink(); (self.root / 'main.tf').symlink_to(self.write('secret', 'private'))
        with self.assertRaises(ValueError): oracle.package(self.root, self.root / 'out.zip')

    def test_lost_create_response_is_reconciled_without_duplicate(self):
        o = self.client(); created = []
        def lost():
            created.append({'id': 'owned'}); raise TimeoutError('lost response')
        with self.assertRaises(TimeoutError): o.once('stack', lambda: [], lost)
        self.assertEqual(o.once('stack', lambda: created, lost), {'id': 'owned'})
        self.assertEqual(len(created), 1)

    def test_uncertain_absent_mutation_is_not_repeated(self):
        o = self.client(); calls = []
        def lost(): calls.append(1); raise TimeoutError()
        with self.assertRaises(TimeoutError): o.once('stack', lambda: [], lost)
        with self.assertRaisesRegex(ValueError, 'uncertain'): o.once('stack', lambda: [], lost)
        self.assertEqual(calls, [1])

    def test_duplicate_ownership_match_refused(self):
        with self.assertRaises(ValueError): self.client().once('stack', lambda: [{}, {}], lambda: self.fail('must not create'))

    def test_existing_stack_variables_cannot_be_retargeted(self):
        o = self.client()
        stack = {'id': 'stack', 'lifecycle-state': 'ACTIVE', 'compartment-id': self.value['compartment_ocid'],
                 'freeform-tags': {'commerce-deployment': 'commerce-test', 'commerce-template-sha256': 'hash'},
                 'variables': {**self.value, 'image_ocid': 'different-image'}}
        calls = []
        def call(*parts): calls.append(parts); return [stack] if parts[2] == 'list' else stack
        o.call = call
        with self.assertRaisesRegex(ValueError, 'changed'): o.stack('hash', self.root / 'x.zip', self.root / 'vars.json')
        self.assertFalse(any('create' in c or 'update' in c for c in calls))

    def test_apply_uses_exact_reviewed_plan_and_normal_replay_no_create(self):
        o = self.client(); calls = []; jobs = []
        def call(*parts):
            calls.append(parts)
            if parts[2] == 'list': return jobs
            if parts[2] == 'create-apply-job':
                jobs.append({'id': 'job', 'stack-id': 'stack', 'operation': 'APPLY', 'lifecycle-state': 'SUCCEEDED', 'freeform-tags': {'commerce-operation': 'operation'}})
            return jobs[0]
        o.call = call
        self.assertEqual(o.job('stack', 'operation', 'apply', 'reviewed-plan'), 'job')
        self.assertEqual(o.job('stack', 'operation', 'apply', 'reviewed-plan'), 'job')
        create = [c for c in calls if 'create-apply-job' in c]
        self.assertEqual(len(create), 1)
        self.assertEqual(create[0][-4:], ('--execution-plan-strategy', 'FROM_PLAN_JOB_ID', '--execution-plan-job-id', 'reviewed-plan'))

    def test_pending_job_timeout_resumes_same_job(self):
        o = self.client(); calls = []
        job = {'id': 'existing', 'stack-id': 'stack', 'operation': 'PLAN', 'lifecycle-state': 'IN_PROGRESS', 'freeform-tags': {'commerce-operation': 'operation'}}
        def call(*parts): calls.append(parts); return [job] if parts[2] == 'list' else job
        o.call = call
        for _ in range(2):
            with self.assertRaisesRegex(ValueError, 'bounded wait'): o.job('stack', 'operation', 'plan')
        self.assertFalse(any('create-plan-job' in c for c in calls))

    def test_wrong_home_region_refused_before_image_request(self):
        o = self.client(); o.tenancy = 'tenancy'; calls = []
        def call(*parts): calls.append(parts); return [{'is-home-region': True, 'region-name': 'us-ashburn-1'}]
        o.call = call
        with self.assertRaisesRegex(ValueError, 'home region'): o.preflight()
        self.assertEqual(len(calls), 1)

    def test_strict_ssh_trust_and_no_agent_forwarding(self):
        key = self.write('key', 'private'); known = self.write('known_hosts', 'pinned')
        cmd = oracle.ssh_command('203.0.113.10', key, known)
        self.assertIn('StrictHostKeyChecking=yes', cmd); self.assertIn('ForwardAgent=no', cmd)
        self.assertIn('IdentitiesOnly=yes', cmd); self.assertIn('GlobalKnownHostsFile=/dev/null', cmd)
        with self.assertRaises(ValueError): oracle.ssh_command('host;touch owned', key, known)

    def test_real_git_bundle_excludes_ignored_credentials_and_dirty_edits(self):
        repo = self.root / 'repo'; repo.mkdir()
        def git(*args): return subprocess.check_output(['git', '-c', 'core.fsmonitor=false', *args], cwd=repo, stderr=subprocess.DEVNULL)
        git('init'); git('config', 'user.name', 'Offline Test'); git('config', 'user.email', 'test@example.invalid')
        (repo / '.gitignore').write_text('.local/\n')
        (repo / 'tracked.txt').write_text('committed source')
        git('add', '.'); git('commit', '-m', 'fixture')
        (repo / '.local').mkdir(); (repo / '.local/credentials.json').write_text('SECRET_NOT_FOR_TRANSPORT')
        (repo / 'tracked.txt').write_text('UNCOMMITTED_EDIT')
        bundle = self.root / 'source.bundle'; git('bundle', 'create', str(bundle), 'HEAD')
        clone = self.root / 'clone'
        subprocess.run(['git', 'clone', str(bundle), str(clone)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        self.assertFalse((clone / '.local').exists())
        self.assertEqual((clone / 'tracked.txt').read_text(), 'committed source')



    def test_cli_package_needs_no_oci_credentials_or_network(self):
        repo = self.root / 'repo'; (repo / 'infra/oracle').mkdir(parents=True)
        for name in oracle.TEMPLATE_FILES: (repo / 'infra/oracle' / name).write_text(name)
        variables = self.write('variables.json', json.dumps(self.value))
        with patch.object(oracle, 'ROOT', repo), patch.object(oracle, 'Oracle') as client, patch('sys.stdout', io.StringIO()), patch('sys.argv', [
            'oracle.py', 'package', '--variables', str(variables), '--state', str(self.root / 'state')]):
            oracle.main(); client.assert_not_called()
        self.assertTrue((self.root / 'state/terraform.zip').exists())
        self.assertEqual((self.root / 'state/variables.json').stat().st_mode & 0o777, 0o600)

    def test_cli_refuses_unreviewed_apply_before_creating_apply_job(self):
        repo = self.root / 'repo'; (repo / 'infra/oracle').mkdir(parents=True)
        for name in oracle.TEMPLATE_FILES: (repo / 'infra/oracle' / name).write_text(name)
        variables = self.write('variables.json', json.dumps(self.value))
        common = ['--variables', str(variables), '--state', str(self.root / 'state')]
        with patch.object(oracle, 'ROOT', repo), patch.object(oracle, 'Oracle') as client, patch('sys.stdout', io.StringIO()):
            client.return_value.stack.return_value = 'stack'
            client.return_value.job.return_value = 'reviewed-plan'
            with patch('sys.argv', ['oracle.py', 'plan', *common]): oracle.main()
            client.return_value.job.reset_mock()
            for extras in [[], ['--reviewed-plan', 'other-plan', '--always-free-budget-confirmed'], ['--reviewed-plan', 'reviewed-plan']]:
                with patch('sys.argv', ['oracle.py', 'apply', *common, *extras]), self.assertRaisesRegex(ValueError, 'exact'):
                    oracle.main()
            client.return_value.job.assert_not_called()

    def test_remote_receiver_replay_preserves_state_and_checks_commit(self):
        repo = self.root / 'repo'; (repo / 'scripts').mkdir(parents=True)
        def git(*args): return subprocess.check_output(['git', '-c', 'core.fsmonitor=false', *args], cwd=repo, stderr=subprocess.DEVNULL)
        git('init'); git('config', 'user.name', 'Offline Test'); git('config', 'user.email', 'test@example.invalid')
        (repo / 'scripts/production.py').write_text('# fixture: application invocation is observed, not executed')
        git('add', '.'); git('commit', '-m', 'fixture')
        revision = git('rev-parse', 'HEAD').decode().strip()
        bundle = self.root / 'source.bundle'; git('bundle', 'create', str(bundle), 'HEAD')
        body = bundle.read_bytes()
        home = self.root / 'home'; home.mkdir(mode=0o700)
        root = home / 'commerce-commerce-test'; root.mkdir(mode=0o700)
        (root / 'inputs').mkdir(mode=0o700)
        config = root / 'inputs/deployment.json'
        config.write_text(json.dumps({'DeploymentId': 'commerce-test', 'Providers': {'Mobile': {'Provider': 'Disabled'}}})); config.chmod(0o600)
        request = {'root': str(root), 'deployment': 'commerce-test', 'revision': revision}
        run = subprocess.run; calls = []
        def execute(command, **kwargs):
            if command[:2] in [['cloud-init', 'status'], ['docker', 'info']]: return subprocess.CompletedProcess(command, 0)
            if command[0] == 'python3':
                calls.append(command)
                return subprocess.CompletedProcess(command, 0)
            return run(command, **kwargs)
        with patch.object(oracle_remote.subprocess, 'run', side_effect=execute), patch('sys.stdout', io.StringIO()):
            for attempt in range(2):
                with patch.object(oracle_remote.sys, 'stdin', types.SimpleNamespace(buffer=io.BytesIO(body))):
                    oracle_remote.receive(request, home=home)
                if attempt == 0:
                    (root / 'state').mkdir(mode=0o700); (root / 'state/original-key').write_text('unchanged-test-key')
            self.assertEqual((root / 'state/original-key').read_text(), 'unchanged-test-key')
            self.assertEqual(calls[0], calls[1])
            self.assertEqual(calls[0][-1], str(root / 'state'))
            self.assertEqual((root / 'last-successful-revision').read_text().strip(), revision)
            (root / 'sources' / revision / 'scripts/production.py').write_text('changed')
            with patch.object(oracle_remote.sys, 'stdin', types.SimpleNamespace(buffer=io.BytesIO(body))), self.assertRaisesRegex(ValueError, 'edited'):
                oracle_remote.receive(request, home=home)
            self.assertEqual(len(calls), 2)

    def test_remote_receiver_does_not_adopt_foreign_directory(self):
        home = self.root / 'home'; home.mkdir(mode=0o700)
        root = home / 'commerce-commerce-test'; root.mkdir(mode=0o700)
        (root / 'foreign-data').write_text('must survive')
        with self.assertRaisesRegex(ValueError, 'adopt'):
            oracle_remote.receive({'root': str(root), 'deployment': 'commerce-test', 'revision': 'a' * 40}, home=home)
        self.assertEqual((root / 'foreign-data').read_text(), 'must survive')



    def test_cli_empty_list_output_is_supported_but_empty_create_is_uncertain(self):
        client = self.client(); client.base = ['oci']; client.log = self.root / 'operator.log'
        with patch.object(oracle.subprocess, 'run', return_value=subprocess.CompletedProcess(['oci'], 0, stdout=b'')):
            self.assertEqual(client.call('resource-manager', 'stack', 'list', '--all'), [])
            with self.assertRaisesRegex(ValueError, 'no resource response'):
                client.call('resource-manager', 'stack', 'create')



    def credit_value(self):
        deadline = (datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=5, minutes=50)).strftime('%Y-%m-%dT%H:%M:%SZ')
        return {**self.value, 'compute_profile': 'credit-minimal-amd64', 'stop_at_utc': deadline}

    def test_credit_profile_requires_bounded_future_deadline(self):
        value = self.credit_value()
        self.assertEqual(self.load(value), value)
        for deadline in ['', '2000-01-01T00:00:00Z', '2099-01-01T00:00:00Z', 'tomorrow']:
            with self.subTest(deadline=deadline), self.assertRaises(ValueError):
                self.load({**value, 'stop_at_utc': deadline})
        self.assertEqual(oracle.variables(self.write('expired.json', json.dumps({**value, 'stop_at_utc': '2000-01-01T00:00:00Z'})), allow_expired=True)['compute_profile'], 'credit-minimal-amd64')

    def test_free_profile_cannot_silently_enable_credit_schedule(self):
        with self.assertRaises(ValueError): self.load({**self.value, 'stop_at_utc': self.credit_value()['stop_at_utc']})
        with self.assertRaises(ValueError): self.load({**self.value, 'compute_profile': 'arbitrary-expensive-shape'})

    def test_credit_apply_cannot_use_free_budget_confirmation(self):
        repo = self.root / 'repo'; (repo / 'infra/oracle').mkdir(parents=True)
        for name in oracle.TEMPLATE_FILES: (repo / 'infra/oracle' / name).write_text(name)
        variables = self.write('credit.json', json.dumps(self.credit_value()))
        common = ['--variables', str(variables), '--state', str(self.root / 'state')]
        with patch.object(oracle, 'ROOT', repo), patch.object(oracle, 'Oracle') as client, patch('sys.stdout', io.StringIO()):
            client.return_value.stack.return_value = 'stack'; client.return_value.job.return_value = 'plan'
            with patch('sys.argv', ['oracle.py', 'plan', *common]): oracle.main()
            client.return_value.job.reset_mock()
            with patch('sys.argv', ['oracle.py', 'apply', *common, '--reviewed-plan', 'plan', '--always-free-budget-confirmed']), self.assertRaisesRegex(ValueError, 'matching'):
                oracle.main()
            client.return_value.job.assert_not_called()

    def test_credit_stop_targets_only_owned_isolated_instance(self):
        client = self.client(); client.value = self.credit_value(); calls = []
        child = {'id': 'isolated', 'freeform-tags': {'commerce-deployment': 'commerce-test'}, 'lifecycle-state': 'ACTIVE'}
        instance = {'id': 'ours', 'compartment-id': 'isolated', 'freeform-tags': child['freeform-tags'], 'lifecycle-state': 'RUNNING', 'shape': 'VM.Standard.E5.Flex'}
        def call(*parts):
            calls.append(parts)
            if parts[:3] == ('iam', 'compartment', 'list'): return [child]
            if parts[:3] == ('compute', 'instance', 'list'): return [instance, {**instance, 'id': 'foreign', 'freeform-tags': {}}]
            return {}
        client.call = call; client.stop_credit_instance()
        actions = [c for c in calls if c[:3] == ('compute', 'instance', 'action')]
        self.assertEqual(actions, [('compute', 'instance', 'action', '--instance-id', 'ours', '--action', 'SOFTSTOP')])

    def test_cli_stop_survives_template_upgrade_and_expired_deadline_but_refuses_retargeting(self):
        value = {**self.credit_value(), 'stop_at_utc': '2000-01-01T00:00:00Z'}
        variables = self.write('credit.json', json.dumps(value))
        state = self.root / 'state'; state.mkdir(mode=0o700)
        oracle.save(state / 'installation.json', {'stack': 'owned-stack', 'fingerprint': 'old-source'})
        oracle.save(state / 'variables.json', value)
        stack = {'compartment-id': value['compartment_ocid'], 'variables': value,
                 'freeform-tags': {'commerce-deployment': value['deployment_id']}}
        with patch.object(oracle, 'Oracle') as client, patch.object(oracle, 'package', side_effect=AssertionError('Stop cannot depend on current template')), patch('sys.stdout', io.StringIO()), patch('sys.argv', [
                'oracle.py', 'stop', '--variables', str(variables), '--state', str(state)]):
            client.return_value.call.return_value = stack
            oracle.main(); client.return_value.stop_credit_instance.assert_called_once()
            client.return_value.stop_credit_instance.reset_mock()
            client.return_value.call.return_value = {**stack, 'freeform-tags': {'commerce-deployment': 'foreign'}}
            with self.assertRaisesRegex(ValueError, 'original owned'): oracle.main()
            client.return_value.stop_credit_instance.assert_not_called()
            variables.write_text(json.dumps({**value, 'image_ocid': 'ocid1.image.oc1.eu-frankfurt-1.different'}))
            with self.assertRaisesRegex(ValueError, 'retarget'): oracle.main()
            client.return_value.stop_credit_instance.assert_not_called()

    def test_free_profile_emergency_stop_cannot_touch_resources(self):
        client = self.client(); client.call = lambda *args: self.fail('must not call OCI')
        with self.assertRaises(ValueError): client.stop_credit_instance()

    def test_credit_guard_rejects_foreign_targets_and_missing_stop_permission(self):
        client = self.client(); client.value = self.credit_value()
        outputs = {k: {'value': v} for k, v in {'instance_id': 'ours', 'resource_compartment_id': 'isolated', 'stop_schedule_id': 'schedule', 'stop_policy_id': 'policy'}.items()}
        schedule = {'compartment-id': 'isolated', 'lifecycle-state': 'ACTIVE', 'action': 'STOP_RESOURCE', 'recurrence-type': 'ICAL',
                    'recurrence-details': 'FREQ=HOURLY;INTERVAL=1', 'time-starts': client.value['stop_at_utc'],
                    'time-ends': (datetime.datetime.strptime(client.value['stop_at_utc'], '%Y-%m-%dT%H:%M:%SZ').replace(tzinfo=datetime.timezone.utc) + datetime.timedelta(hours=24)).isoformat(), 'resources': [{'id': 'ours'}], 'freeform-tags': {'commerce-deployment': 'commerce-test'}}
        statement = "Allow any-user to {INSTANCE_READ, INSTANCE_POWER_ACTIONS} in compartment id isolated where all {request.principal.type='resourceschedule', request.principal.id='schedule'}"
        policy = {'compartment-id': 'isolated', 'lifecycle-state': 'ACTIVE', 'statements': [statement]}
        client.call = lambda *parts: schedule if parts[0] == 'resource-scheduler' else policy
        client.verify_credit_guard(outputs)
        schedule['resources'].append({'id': 'foreign'})
        with self.assertRaises(ValueError): client.verify_credit_guard(outputs)
        schedule['resources'].pop(); policy['statements'] = ['Allow any-user to manage all-resources in tenancy']
        with self.assertRaises(ValueError): client.verify_credit_guard(outputs)



    def test_template_upgrade_keeps_inputs_and_recovers_lost_update_response(self):
        client = self.client(); calls = []
        old_hash, new_hash = 'old-template', 'new-template'
        old_fingerprint = hashlib.sha256((old_hash + json.dumps(self.value, sort_keys=True)).encode()).hexdigest()
        saved = {'stack': 'stack', 'fingerprint': old_fingerprint}
        stack = {'id': 'stack', 'compartment-id': self.value['compartment_ocid'], 'variables': self.value, 'lifecycle-state': 'ACTIVE',
                 'freeform-tags': {'commerce-deployment': 'commerce-test', 'commerce-template-sha256': old_hash}}
        def call(*parts):
            calls.append(parts)
            if parts[:3] == ('resource-manager', 'job', 'list'): return []
            if parts[:3] == ('resource-manager', 'stack', 'update'):
                stack['freeform-tags']['commerce-template-sha256'] = new_hash
                raise TimeoutError('lost response')
            return stack
        client.call = call
        with self.assertRaises(TimeoutError): client.update_template(saved, new_hash, self.root / 'new.zip')
        client.update_template(saved, new_hash, self.root / 'new.zip')
        self.assertEqual(len([c for c in calls if c[2] == 'update']), 1)
        self.assertEqual(stack['variables'], self.value)

    def test_template_upgrade_refuses_foreign_stack(self):
        client = self.client(); calls = []
        def call(*parts):
            calls.append(parts)
            return {'compartment-id': self.value['compartment_ocid'], 'variables': self.value, 'freeform-tags': {'commerce-deployment': 'foreign'}}
        client.call = call
        with self.assertRaises(ValueError): client.update_template({'stack': 'stack', 'fingerprint': 'old'}, 'new', self.root / 'new.zip')
        self.assertFalse(any(c[2] == 'update' for c in calls))

    def test_template_upgrade_waits_for_in_progress_job(self):
        client = self.client(); old_hash = 'old'
        saved = {'stack': 'stack', 'fingerprint': hashlib.sha256((old_hash + json.dumps(self.value, sort_keys=True)).encode()).hexdigest()}
        stack = {'compartment-id': self.value['compartment_ocid'], 'variables': self.value, 'freeform-tags': {'commerce-deployment': 'commerce-test', 'commerce-template-sha256': old_hash}}
        client.call = lambda *parts: [{'lifecycle-state': 'IN_PROGRESS'}] if parts[1] == 'job' else stack
        with self.assertRaisesRegex(ValueError, 'Wait'): client.update_template(saved, 'new', self.root / 'new.zip')
        self.assertFalse((self.root / 'template-upgrade.intent.json').exists())


if __name__ == '__main__': unittest.main()
