#!/usr/bin/env python3
"""Actions-independent Oracle Resource Manager provisioning and verified SSH deployment."""
import argparse
import base64
import struct
import configparser
import fcntl
import hashlib
import ipaddress
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import sys
import tempfile
import time
import uuid
import zipfile

ROOT = Path(__file__).resolve().parents[1]
TEMPLATE_FILES = ('main.tf', 'cloud-init.yaml', '.terraform.lock.hcl')
FIELDS = {'deployment_id', 'region', 'compartment_ocid', 'availability_domain', 'image_ocid', 'ssh_public_key', 'ssh_source_cidr'}
TERMINAL = {'SUCCEEDED', 'FAILED', 'CANCELED'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def private_path(path, directory=False):
    path = Path(os.path.abspath(path))
    require(not any(p.is_symlink() for p in (path, *path.parents)), 'Private paths cannot contain symlinks.')
    if directory and not path.exists():
        path.mkdir(mode=0o700, parents=True)
    require(path.exists() and (path.is_dir() if directory else path.is_file()), 'Required private path is missing.')
    require(path.stat().st_uid == os.getuid() and not path.stat().st_mode & 0o077, 'Private paths must belong to this operator with mode 0700/0600.')
    return path


def save(path, data):
    require(not path.is_symlink(), 'Refusing to overwrite a symlink.')
    with tempfile.NamedTemporaryFile('w', dir=path.parent, delete=False) as f:
        json.dump(data, f, indent=2); f.write('\n'); f.flush(); os.fsync(f.fileno())
    os.replace(f.name, path)


def variables(path):
    value = json.loads(private_path(path).read_text())
    require(set(value) == FIELDS and all(isinstance(v, str) for v in value.values()), 'Use exactly the documented Oracle string variables; no credentials or extra Terraform inputs.')
    require(re.fullmatch(r'[a-z][a-z0-9-]{2,39}', value['deployment_id']), 'Invalid deployment ID.')
    require(re.fullmatch(r'[a-z]+-[a-z]+-\d+', value['region']), 'Invalid OCI region.')
    for field, kind in [('compartment_ocid', '(?:compartment|tenancy)'), ('image_ocid', 'image')]:
        require(re.fullmatch(r'ocid1\.' + kind + r'\.oc1\.[A-Za-z0-9.-]+', value[field]), 'Invalid OCI resource ID.')
    require(re.fullmatch(r'[A-Za-z0-9:._-]+', value['availability_domain']), 'Invalid availability domain.')
    require(re.fullmatch(r'ssh-ed25519 [A-Za-z0-9+/=]+(?: [^\r\n]+)?', value['ssh_public_key']), 'Supply only an Ed25519 public key.')
    key = base64.b64decode(value['ssh_public_key'].split()[1], validate=True)
    expected_prefix = struct.pack('>I', 11) + b'ssh-ed25519' + struct.pack('>I', 32)
    require(key.startswith(expected_prefix) and len(key) == len(expected_prefix) + 32, 'Invalid Ed25519 public-key encoding.')
    cidr = ipaddress.ip_network(value['ssh_source_cidr'], strict=True)
    require(cidr.version == 4 and cidr.prefixlen == 32 and cidr.network_address.is_global, 'SSH requires the operator/CI public IPv4 /32.')
    return value


def package(template, target):
    # Explicit allowlist: never package the checkout, .local, tfstate or OCI credentials.
    digest = hashlib.sha256()
    with zipfile.ZipFile(target, 'w', zipfile.ZIP_DEFLATED) as archive:
        for name in TEMPLATE_FILES:
            path = template / name
            require(path.is_file() and not path.is_symlink(), 'Required pinned Terraform template file is missing.')
            body = path.read_bytes()
            digest.update(name.encode() + b'\0' + body)
            info = zipfile.ZipInfo(name, (2026, 1, 1, 0, 0, 0)); info.compress_type = zipfile.ZIP_DEFLATED
            archive.writestr(info, body)
    return digest.hexdigest()


class Oracle:
    def __init__(self, args, value, state):
        self.args, self.value, self.state = args, value, state
        self.log = state / 'operator.log'
        self.base = [args.oci, '--config-file', str(private_path(args.oci_config)), '--profile', args.profile,
                     '--region', value['region'], '--output', 'json', '--no-retry']
        cfg = configparser.ConfigParser(interpolation=None); cfg.read(args.oci_config)
        require(args.profile in cfg, 'The selected OCI profile is missing.')
        self.tenancy = cfg[args.profile]['tenancy']
        require(re.fullmatch(r'ocid1.tenancy.oc1\.[A-Za-z0-9.-]+', self.tenancy), 'Invalid OCI tenancy.')
        self.base += ['--auth', 'security_token' if cfg[args.profile].get('security_token_file') else 'api_key']

    def call(self, *parts, raw=False):
        # Captured output stays in the private operator directory, not CI logs.
        with self.log.open('ab') as log:
            result = subprocess.run([*self.base, *parts], stdout=subprocess.PIPE, stderr=log, timeout=180)
            require(result.returncode == 0, 'OCI request failed; inspect the private operator.log. An ambiguous mutation is never automatically repeated.')
        if raw:
            return result.stdout
        # OCI CLI --all emits no JSON for an empty collection. Only list calls may do this.
        if not result.stdout.strip():
            require(len(parts) >= 3 and parts[2] == 'list', 'OCI returned no resource response; preserve the recorded mutation intent and reconcile explicitly.')
            return []
        return json.loads(result.stdout)['data']

    def preflight(self):
        regions = self.call('iam', 'region-subscription', 'list', '--tenancy-id', self.tenancy, '--all')
        require(any(r['is-home-region'] and r['region-name'] == self.value['region'] for r in regions), 'Always Free provisioning is restricted to the tenancy home region.')
        image = self.call('compute', 'image', 'get', '--image-id', self.value['image_ocid'])
        require(image['operating-system'] == 'Canonical Ubuntu' and image['operating-system-version'] == '24.04', 'Select the documented official Ubuntu 24.04 ARM64 image.')
        require(image.get('display-name', '').startswith('Canonical-Ubuntu-24.04-aarch64-'), 'The pinned image must be the official ARM64 Ubuntu platform image.')

    def once(self, name, lookup, create):
        """Reconcile by operation tags after a lost response; never blindly repeat a create."""
        found = lookup()
        require(len(found) <= 1, 'Multiple owned resources match; reconcile explicitly in Oracle Console.')
        if found:
            return found[0]
        intent = self.state / (name + '.intent.json')
        require(not intent.exists(), 'A previous create has an uncertain outcome. Wait, then rerun to reconcile its tag; inspect Oracle Console if still absent. Do not delete intent/state to retry.')
        save(intent, {'operation': name, 'submittedAt': time.time()})
        return create()

    def stack(self, template_hash, zip_path, variables_path):
        ident = self.value['deployment_id']
        def find():
            return [s for s in self.call('resource-manager', 'stack', 'list', '--compartment-id', self.value['compartment_ocid'], '--all')
                    if s['lifecycle-state'] != 'DELETED' and s.get('freeform-tags', {}).get('commerce-deployment') == ident]
        tags = {'commerce-deployment': ident, 'commerce-template-sha256': template_hash}
        stack = self.once('stack', find, lambda: self.call('resource-manager', 'stack', 'create',
            '--compartment-id', self.value['compartment_ocid'], '--display-name', ident, '--config-source', str(zip_path),
            '--terraform-version', '1.5.x', '--variables', 'file://' + str(variables_path), '--freeform-tags', json.dumps(tags)))
        actual = self.call('resource-manager', 'stack', 'get', '--stack-id', stack['id'])
        require(actual.get('freeform-tags') == tags and actual.get('variables') == self.value and actual['compartment-id'] == self.value['compartment_ocid'],
                'The existing stack template/variables/ownership changed. Refusing adoption or automatic replacement.')
        return actual['id']

    def job(self, stack, operation, kind, plan=None):
        tags = {'commerce-operation': operation}
        def find():
            return [j for j in self.call('resource-manager', 'job', 'list', '--stack-id', stack, '--all')
                    if j.get('freeform-tags', {}).get('commerce-operation') == operation]
        parts = ['resource-manager', 'job', 'create-' + kind + '-job', '--stack-id', stack, '--freeform-tags', json.dumps(tags)]
        if kind == 'apply':
            parts += ['--execution-plan-strategy', 'FROM_PLAN_JOB_ID', '--execution-plan-job-id', plan]
        job = self.once('job-' + operation, find, lambda: self.call(*parts))
        require(job['stack-id'] == stack and job['operation'] == kind.upper(), 'The saved Oracle job does not match this operation.')
        deadline = time.monotonic() + self.args.wait_seconds
        while True:
            job = self.call('resource-manager', 'job', 'get', '--job-id', job['id'])
            status = job['lifecycle-state']
            if status in TERMINAL:
                require(status == 'SUCCEEDED', 'Oracle job ' + status + '. Inspect Console; use plan --new-plan after resolving capacity/provider errors. Data is retained.')
                return job['id']
            require(time.monotonic() < deadline, 'The bounded wait expired. Rerun the same command to resume the existing job.')
            print('Oracle ' + kind + ': ' + status + '; existing job retained.', flush=True)
            time.sleep(10)


def ssh_command(host, identity, known_hosts):
    ipaddress.IPv4Address(host)
    return ['ssh', '-F', '/dev/null', '-i', str(private_path(identity)), '-o', 'BatchMode=yes', '-o', 'IdentitiesOnly=yes',
            '-o', 'StrictHostKeyChecking=yes', '-o', 'UserKnownHostsFile=' + str(private_path(known_hosts)),
            '-o', 'GlobalKnownHostsFile=/dev/null', '-o', 'ForwardAgent=no', '-o', 'ClearAllForwardings=yes',
            '-o', 'ConnectTimeout=15', 'ubuntu@' + host]


def deploy(args, state, outputs):
    require(outputs['deployment_id']['value'] == args.deployment_id, 'Terraform outputs refer to another deployment.')
    require(re.fullmatch(r'ocid1.instance.oc1\.[A-Za-z0-9.-]+', outputs['instance_id']['value']), 'Invalid instance output.')
    ssh = ssh_command(outputs['public_ip']['value'], args.identity, args.known_hosts)
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    require(re.fullmatch('[0-9a-f]{40}', revision), 'Deploy a committed source revision.')
    # The remote production operator reads its own private configuration. Never put secrets in Terraform or a Git bundle.
    remote = '/home/ubuntu/commerce-' + args.deployment_id
    request = {'revision': revision, 'deployment': args.deployment_id, 'root': remote}
    with tempfile.TemporaryDirectory(dir=state) as temporary:
        bundle = Path(temporary) / 'source.bundle'
        with (state / 'deployment.log').open('ab') as log:
            subprocess.run(['git', 'bundle', 'create', str(bundle), 'HEAD'], cwd=ROOT, stdout=log, stderr=log, check=True, timeout=180)
            # The receiver is itself read from committed HEAD, never an uncommitted/ignored local file.
            receiver = subprocess.check_output(['git', 'show', revision + ':scripts/oracle_remote.py'], cwd=ROOT)
            code = 'import json,sys; p=json.loads(' + repr(json.dumps(request)) + ');\n' + receiver.decode()
            command = 'python3 -c ' + shlex.quote(code)
            with bundle.open('rb') as source:
                subprocess.run([*ssh, command], stdin=source, stdout=log, stderr=log, check=True, timeout=args.deploy_timeout)
    print('Deployment and public HTTPS verification passed. Private local diagnostics: ' + str(state / 'deployment.log'))


def main():
    os.umask(0o077)
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['package', 'plan', 'apply', 'deploy'])
    parser.add_argument('--variables', type=Path, required=True)
    parser.add_argument('--state', type=Path, required=True)
    parser.add_argument('--oci', default='oci')
    parser.add_argument('--oci-config', type=Path, default=Path.home() / '.oci/config')
    parser.add_argument('--profile', default='DEFAULT')
    parser.add_argument('--wait-seconds', type=int, default=1800)
    parser.add_argument('--new-plan', action='store_true')
    parser.add_argument('--reviewed-plan')
    parser.add_argument('--always-free-budget-confirmed', action='store_true')
    parser.add_argument('--identity', type=Path)
    parser.add_argument('--known-hosts', type=Path)
    parser.add_argument('--deploy-timeout', type=int, default=7200)
    args = parser.parse_args()
    value = variables(args.variables); args.deployment_id = value['deployment_id']
    state = private_path(args.state, directory=True)
    require(state != ROOT and (ROOT not in state.parents or ROOT / '.local' in state.parents), 'Keep private Oracle state outside Git or under ignored .local.')
    with (state / 'operator.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        template_hash = package(ROOT / 'infra/oracle', state / 'terraform.zip')
        fingerprint = hashlib.sha256((template_hash + json.dumps(value, sort_keys=True)).encode()).hexdigest()
        path = state / 'installation.json'
        saved = json.loads(private_path(path).read_text()) if path.exists() else {'fingerprint': fingerprint}
        require(saved['fingerprint'] == fingerprint, 'Original Oracle inputs/template changed. Existing infrastructure is retained; perform an explicit reviewed migration.')
        save(path, saved); save(state / 'variables.json', value)
        if args.action == 'package':
            print('Private Resource Manager ZIP and variables prepared; no cloud calls.'); return
        oracle = Oracle(args, value, state); oracle.preflight()
        stack = oracle.stack(template_hash, state / 'terraform.zip', state / 'variables.json')
        saved['stack'] = stack; save(path, saved)
        if args.action == 'plan':
            if args.new_plan:
                jobs = oracle.call('resource-manager', 'job', 'list', '--stack-id', stack, '--all')
                require(all(j['lifecycle-state'] in TERMINAL for j in jobs), 'An Oracle job is still active. Resume it before making a new plan.')
                saved = {'fingerprint': fingerprint, 'stack': stack}
            saved.setdefault('planOperation', uuid.uuid4().hex); save(path, saved)
            saved['plan'] = oracle.job(stack, saved['planOperation'], 'plan'); save(path, saved)
            print('Review this exact plan in Oracle Console, then pass --reviewed-plan: ' + saved['plan']); return
        require('plan' in saved, 'Run plan and review its output before applying or deploying.')
        if args.action == 'apply':
            require(args.reviewed_plan == saved['plan'] and args.always_free_budget_confirmed,
                    'Pass the exact --reviewed-plan and --always-free-budget-confirmed after checking remaining tenancy allowance and the reviewed plan.')
            saved.setdefault('applyOperation', uuid.uuid4().hex); save(path, saved)
            saved['apply'] = oracle.job(stack, saved['applyOperation'], 'apply', saved['plan']); save(path, saved)
        require('apply' in saved, 'Apply the reviewed plan first.')
        job = oracle.call('resource-manager', 'job', 'get', '--job-id', saved['apply'])
        require(job['stack-id'] == stack and job['lifecycle-state'] == 'SUCCEEDED', 'The saved apply job is not successful for this stack.')
        state_path = state / 'terraform-state.json'
        oracle.call('resource-manager', 'job', 'get-job-tf-state', '--job-id', saved['apply'], '--file', str(state_path), raw=True)
        outputs = json.loads(state_path.read_text())['outputs']
        save(state / 'outputs.json', outputs)
        if args.action == 'deploy':
            require(args.identity and args.known_hosts, 'Deploy requires an SSH identity and independently verified known_hosts file.')
            deploy(args, state, outputs)
        else:
            print('Owned infrastructure applied; private outputs saved. Finish DNS/TLS/private input and host-key verification before deploy.')


if __name__ == '__main__':
    try:
        main()
    except (ValueError, OSError, subprocess.SubprocessError, KeyError, configparser.Error) as error:
        # Do not print commands, provider responses, private config values or tracebacks into CI.
        print(str(error) if isinstance(error, ValueError) else 'Oracle operation failed (' + type(error).__name__ + '); inspect private diagnostics. State and data retained.', file=sys.stderr)
        raise SystemExit(1)
