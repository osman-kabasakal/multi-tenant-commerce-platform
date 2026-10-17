"""The static UI directory exception must not exempt secrets or generated children."""
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

class SourceGuardTests(unittest.TestCase):
    def test_source_build_directories_keep_secret_and_nested_output_guards(self):
        root=Path(__file__).resolve().parents[1]
        with tempfile.TemporaryDirectory() as directory:
            sandbox=Path(directory);(sandbox/'scripts').mkdir();shutil.copyfile(root/'scripts/check_public_source.py',sandbox/'scripts/check_public_source.py')
            subprocess.run(['git','init','-q',str(sandbox)],check=True)
            allowed=['Ecommerce/src/Build/Grand.Common.props','Ecommerce/src/Web/Grand.SharedUIResources/wwwroot/administration/build/css/custom.css']
            forbidden=['Ecommerce/src/Web/Grand.SharedUIResources/wwwroot/administration/build/config/appsettings.json','other/build/custom.css','Ecommerce/src/Build/private.key','Ecommerce/src/Web/Grand.SharedUIResources/wwwroot/administration/build/fonts/private.p8','Ecommerce/src/Web/Grand.SharedUIResources/wwwroot/administration/build/nested/obj/cache.json']
            for name in allowed+forbidden:
                path=sandbox/name;path.parent.mkdir(parents=True,exist_ok=True);path.write_text('fixture')
            subprocess.run(['git','add','--',*allowed],cwd=sandbox,check=True)
            command=[sys.executable,str(sandbox/'scripts/check_public_source.py')]
            self.assertEqual(0,subprocess.run(command,capture_output=True).returncode)
            for name in forbidden:
                subprocess.run(['git','add','--',name],cwd=sandbox,check=True)
                result=subprocess.run(command,capture_output=True,text=True);self.assertNotEqual(0,result.returncode);self.assertIn(name,result.stderr)
                subprocess.run(['git','rm','--cached','--',name],cwd=sandbox,check=True,stdout=subprocess.DEVNULL)

if __name__=='__main__':unittest.main()
