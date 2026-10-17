import copy
import unittest
from production_installer import require_component_changes, require_preserved_runtime


class InstallerReleaseBoundaryTests(unittest.TestCase):
    def test_unrelated_runtime_changes_cannot_reuse_the_old_binary(self):
        for path in ('Shared/Platform.Security/Contracts.cs', 'TenantManager/Program.cs', 'scripts/mobile_android.py', 'infra/production/Dockerfile', 'Ecommerce/src/Build/Grand.Common.props'):
            with self.subTest(path=path), self.assertRaises(ValueError):
                require_component_changes(['Ecommerce/src/Installer/Grand.Installer.Cli/Services/ManagedTenantDomain.cs', path])

    def test_tests_and_docs_alone_cannot_create_an_installer_release(self):
        with self.assertRaises(ValueError): require_component_changes(['docs/MOBILE.md', 'tests/LocalDemo.Tests/Fixture.cs'])

    def test_only_the_installer_component_and_nonruntime_evidence_may_change(self):
        require_component_changes(['Ecommerce/src/Installer/Grand.Installer.Cli/Services/ManagedTenantDomain.cs', 'scripts/production_installer.py', 'infra/production/InstallerPatch.Dockerfile', 'tests/LocalDemo.Tests/Fixture.cs', 'docs/MOBILE.md'])

    def test_the_original_runtime_settings_and_layers_must_survive(self):
        old = {'Config': {'User':'1001:1001','Env':['HOME=/tmp'],'Entrypoint':['/usr/local/bin/platform'],'Cmd':['worker'],'WorkingDir':'/app'}, 'RootFS':{'Layers':['root','runtime','sdk']}}
        patched = copy.deepcopy(old); patched['RootFS']['Layers'] += ['remove-installer','new-installer']; patched['Config']['Labels']={'org.opencontainers.image.revision':'a'*40}
        require_preserved_runtime(old,patched,'a'*40)
        for key,value in (('User','0'),('Env',[]),('Entrypoint',['/bin/sh']),('Cmd',['saas']),('WorkingDir','/')):
            changed=copy.deepcopy(patched);changed['Config'][key]=value
            with self.subTest(key=key), self.assertRaises(ValueError): require_preserved_runtime(old,changed,'a'*40)
        changed=copy.deepcopy(patched);changed['RootFS']['Layers'][0]='other-root'
        with self.assertRaises(ValueError): require_preserved_runtime(old,changed,'a'*40)
        with self.assertRaises(ValueError): require_preserved_runtime(old,patched,'b'*40)


if __name__ == '__main__': unittest.main()
