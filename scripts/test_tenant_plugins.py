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
        project=build.ROOT/'Ecommerce/src/Plugins/Tax.FixedRate/Tax.FixedRate.csproj'
        for target,host in expected.items():
            output=subprocess.check_output(['dotnet','msbuild',str(project),'-nologo','-p:Configuration=Release',
                '-p:BuildType='+target,'-getProperty:BaseDir,OutDir'],cwd=build.ROOT,text=True)
            values=json.loads(output)['Properties']
            base=(project.parent/values['BaseDir'].replace('\\','/')).resolve()
            destination=(build.ROOT/'Ecommerce/src'/host/'Plugins').resolve()
            self.assertEqual(destination,base,target)
            self.assertEqual(destination/'Tax.FixedRate',(project.parent/values['OutDir'].replace('\\','/')).resolve(),target)

if __name__=='__main__': unittest.main()
