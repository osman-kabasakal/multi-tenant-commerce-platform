#!/usr/bin/env python3
"""Check real BuildType/BaseDir evaluation and the complete plugin build inventory."""
import json
from pathlib import Path
import subprocess
import unittest
import xml.etree.ElementTree as ET
import build_ecommerce_plugins as build

class PluginBuildTests(unittest.TestCase):
    def test_inventory_covers_every_standard_and_admin_project_without_renaming_system_ids(self):
        actual={x.relative_to(build.ROOT) for x in build.projects('Installer')}
        expected={x.relative_to(build.ROOT) for kind in ('Plugins','AdminPlugins') for x in (build.ROOT/'Ecommerce/src'/kind).glob('*/*.csproj')}
        self.assertEqual(expected,actual)
        entries=ET.parse(build.ROOT/'Ecommerce/src/Build/ManagedTenantPlugins.props').getroot().findall('./ItemGroup/ManagedTenantPlugin')
        self.assertEqual(len(entries),len({x.findtext('SystemName') for x in entries}))
        self.assertEqual('ExternalAuth.Keycloak',next(x.findtext('SystemName') for x in entries if x.attrib['Include']=='Authentication.Keycloak'))

    def test_frontend_excludes_admin_projects_and_every_other_target_includes_them(self):
        standard=set((build.ROOT/'Ecommerce/src/Plugins').glob('*/*.csproj'))
        all_projects=set(build.projects('Installer'))
        self.assertEqual(standard,set(build.projects('Frontend')))
        for target in ('Backend','Installer','Background','Uploader'):
            self.assertEqual(all_projects,set(build.projects(target)))

    def test_msbuild_preserves_the_original_basedir_mapping(self):
        expected={'Frontend':'Web/Grand.Web.MultiTenant','Backend':'Web/Grand.Web.OnlyAdmin',
                  'Installer':'Installer/Grand.Installer.Cli','Background':'Cli/Grand.BackgroundJobExecuter',
                  'Uploader':'Installer/Grand.Data.Uploader'}
        for target,host in expected.items():
            destination=(build.ROOT/'Ecommerce/src'/host/'Plugins').resolve()
            for configuration in ('Debug','Release'):
                for project in build.projects(target):
                    with self.subTest(target=target,configuration=configuration,plugin=project.stem):
                        output=subprocess.check_output(['dotnet','msbuild',str(project),'-nologo',
                            '-p:Configuration='+configuration,'-p:BuildType='+target,
                            '-getProperty:BaseDir,TenantPluginRoot,OutDir,TargetPath,TargetFileName'],cwd=build.ROOT,text=True)
                        values=json.loads(output)['Properties']
                        base=(project.parent/values['BaseDir'].replace('\\','/')).resolve()
                        folder='ExternalAuth.Keycloak' if project.stem=='Authentication.Keycloak' else project.stem
                        self.assertEqual(destination,base)
                        self.assertEqual(destination,Path(values['TenantPluginRoot']).resolve())
                        self.assertEqual(destination/folder,(project.parent/values['OutDir'].replace('\\','/')).resolve())
                        self.assertEqual(destination/folder/values['TargetFileName'],
                            (project.parent/values['TargetPath'].replace('\\','/')).resolve())

    def test_publish_uses_the_same_plugin_root_for_each_host(self):
        hosts={'Frontend':'Web/Grand.Web.MultiTenant','Backend':'Web/Grand.Web.OnlyAdmin',
               'Installer':'Installer/Grand.Installer.Cli','Background':'Cli/Grand.BackgroundJobExecuter',
               'Uploader':'Installer/Grand.Data.Uploader'}
        for target,host in hosts.items():
            directory=build.ROOT/'Ecommerce/src'/host
            project=directory/(directory.name+'.csproj')
            for configuration in ('Debug','Release'):
                with self.subTest(target=target,configuration=configuration):
                    result=subprocess.check_output(['dotnet','msbuild',str(project),'-nologo',
                        '-p:Configuration='+configuration,'-p:BuildType='+target,
                        '-target:ResolveTenantPluginDestination',
                        '-getProperty:TenantPluginRoot,_TenantPluginDestination'],cwd=build.ROOT,text=True)
                    values=json.loads(result)['Properties']
                    self.assertEqual((directory/'Plugins').resolve(),Path(values['TenantPluginRoot']).resolve())
                    self.assertEqual(values['TenantPluginRoot'],values['_TenantPluginDestination'])

    def test_publish_rejects_missing_unknown_or_mismatched_build_type_before_building_plugins(self):
        project=build.ROOT/'Ecommerce/src/Installer/Grand.Installer.Cli/Grand.Installer.Cli.csproj'
        for target in ('','Fronted','Frontend','Backend','Background','Uploader'):
            with self.subTest(target=target):
                result=subprocess.run(['dotnet','msbuild',str(project),'-nologo',
                    '-p:BuildType='+target,'-target:ResolveTenantPluginDestination'],
                    cwd=build.ROOT,text=True,capture_output=True)
                self.assertNotEqual(0,result.returncode)
                expected='requires an explicit BuildType' if target in ('','Fronted') else 'Choose the matching host and BuildType'
                self.assertIn(expected,result.stdout+result.stderr)

if __name__=='__main__': unittest.main()
