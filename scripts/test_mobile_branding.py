"""Cloud-free branding boundaries; real generator acceptance is an explicit separate smoke run."""
import copy
import hashlib
import json
from pathlib import Path
import struct
import tempfile
import unittest
import zipfile
import zlib
from unittest.mock import patch

import mobile_ios as ios
import smoke_mobile_ios as ios_probe

import mobile_android as mobile


def png(red=180, green=80, blue=40, size=512):
    def chunk(name, value):
        return struct.pack('>I',len(value))+name+value+struct.pack('>I',zlib.crc32(name+value)&0xffffffff)
    return b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',size,size,8,2,0,0,0))+chunk(b'IDAT',zlib.compress((b'\0'+bytes((red,green,blue))*size)*size))+chunk(b'IEND',b'')


class BrandingTests(unittest.TestCase):
    def fixture(self, root):
        inputs=root/'inputs';inputs.mkdir();(inputs/'branding').mkdir()
        app=root/'app';app.mkdir();(app/'assets').mkdir();(app/'pubspec.yaml').write_text('flutter:\n  assets:\n    - assets/\n')
        android=png();ios=png(20,100,200);a=hashlib.sha256(android).hexdigest();i=hashlib.sha256(ios).hexdigest()
        for digest,content in ((a,android),(i,ios)):(inputs/'branding'/(digest+'.image')).write_bytes(content)
        value={'android':dict(logo=a,icon=a,splash=a),'ios':dict(logo=i,icon=i,splash=i)}
        return app,inputs,value,android,ios

    def test_each_platform_packages_its_own_frozen_logo_and_icon_without_remote_urls(self):
        for platform in ('android','ios'):
            with self.subTest(platform=platform),tempfile.TemporaryDirectory() as folder:
                app,inputs,value,android,ios=self.fixture(Path(folder))
                prepared=mobile.prepare_branding({'branding':value},inputs,app,platform)
                self.assertEqual((app/prepared['storeLogo']).read_bytes(),android if platform=='android' else ios)
                self.assertEqual(prepared['brandingSha256'],mobile.branding_digest(value))
                icon=json.loads((app/'platform_launcher_icons.yaml').read_text())['flutter_launcher_icons']
                splash=json.loads((app/'platform_native_splash.yaml').read_text())['flutter_native_splash']
                self.assertTrue(icon[platform]);self.assertTrue(splash[platform]);self.assertFalse(icon['ios' if platform=='android' else 'android'])
                self.assertIn('assets/tenant_branding/',(app/'pubspec.yaml').read_text())

    def test_one_changed_image_cannot_be_substituted_for_an_immutable_snapshot(self):
        with tempfile.TemporaryDirectory() as folder:
            app,inputs,value,android,ios=self.fixture(Path(folder))
            (inputs/'branding'/(value['android']['logo']+'.image')).write_bytes(ios)
            with self.assertRaises(ValueError):mobile.prepare_branding({'branding':value},inputs,app,'android')

    def test_paths_and_extra_slots_are_refused_before_reading_image_files(self):
        with tempfile.TemporaryDirectory() as folder:
            app,inputs,value,*_=self.fixture(Path(folder))
            for changed in ('../../foreign','https://foreign.example.test/logo.png','A'*64):
                wrong=copy.deepcopy(value);wrong['android']['logo']=changed
                with self.subTest(changed=changed),self.assertRaises(ValueError):mobile.branding_digest(wrong)
            wrong=copy.deepcopy(value);wrong['android']['path']='secret'
            with self.assertRaises(ValueError):mobile.branding_digest(wrong)

    def test_missing_branding_preserves_legacy_preparation(self):
        self.assertEqual(mobile.prepare_branding({},Path('/unused'),Path('/unused'),'android'),{})
        self.assertEqual(mobile.branding_commands('/flutter',{}),[])

    def test_compiled_apk_must_contain_exact_selected_image_bytes(self):
        with tempfile.TemporaryDirectory() as folder:
            app,inputs,value,android,ios=self.fixture(Path(folder));binary=Path(folder)/'app.apk'
            with zipfile.ZipFile(binary,'w') as archive:
                for role in ('logo','icon','splash'):archive.writestr('assets/flutter_assets/assets/tenant_branding/'+role+'.png',android)
            mobile.verify_branding_assets(binary,{'branding':value})
            wrong=copy.deepcopy(value);wrong['android']['logo']=wrong['ios']['logo']
            with self.assertRaises(ValueError):mobile.verify_branding_assets(binary,{'branding':wrong})

    def test_ios_preparation_freezes_public_sources_separately_from_generated_branding(self):
        with tempfile.TemporaryDirectory(dir=Path(tempfile.gettempdir()).resolve()) as folder:
            root=Path(folder);manifest_path=ios_probe.fixture_inputs(root/'inputs')
            manifest=mobile.read_json(manifest_path);content=png();digest=hashlib.sha256(content).hexdigest()
            (root/'inputs/branding').mkdir();(root/'inputs/branding'/(digest+'.image')).write_bytes(content)
            manifest['branding']={platform:dict(logo=digest,icon=digest,splash=digest) for platform in ('android','ios')}
            manifest_path.write_text(json.dumps(manifest))
            expected=mobile.hash_sources(ios.source_entries(ios.ROOT))
            original_pubspec=mobile.file_hash(ios.ROOT/'Platforms/store_user_app/pubspec.yaml')
            with patch.object(ios.common,'run_private'):
                workspace,tenant=ios.prepare(manifest_path,manifest_path.parent,root/'workspace','ABCDE12345',2)
            self.assertEqual(tenant['sourceHash'],expected)
            self.assertEqual(tenant['brandingSha256'],mobile.branding_digest(manifest['branding']))
            self.assertEqual(mobile.file_hash(ios.ROOT/'Platforms/store_user_app/pubspec.yaml'),original_pubspec)
            self.assertNotEqual(mobile.file_hash(workspace/'Platforms/store_user_app/pubspec.yaml'),original_pubspec)
            self.assertEqual(mobile.read_json(workspace/'tenant.defines.json')['STORE_LOGO'],'assets/tenant_branding/logo.png')

    def test_png_dimension_bomb_is_rejected_before_generator_execution(self):
        with tempfile.TemporaryDirectory() as folder:
            content=bytearray(png());content[16:20]=struct.pack('>I',1000000)
            image=Path(folder)/'image';image.write_bytes(content)
            with self.assertRaises(ValueError):mobile.branding_image(image,hashlib.sha256(content).hexdigest())


if __name__=='__main__':unittest.main()
