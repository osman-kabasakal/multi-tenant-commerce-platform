import 'package:flutter_test/flutter_test.dart';
import 'package:store_user_app/core/config/tenant_firebase_identity.dart';

void main() {
  const tenant = '123456781234123412341234567890ab';
  TenantFirebaseIdentity identity({
    String id = tenant,
    String project = 'tenant-project',
    String app = '1:12345:android:abc123',
  }) => TenantFirebaseIdentity(
    tenantId: id,
    packageName: 'com.example.tenantapp',
    projectId: project,
    projectNumber: '12345',
    appId: app,
  );
  void verify(
    TenantFirebaseIdentity expected, {
    String package = 'com.example.tenantapp',
    String project = 'tenant-project',
    String number = '12345',
    String app = '1:12345:android:abc123',
    String platform = 'android',
  }) => expected.verify(
    nativePackageName: package,
    nativeProjectId: project,
    nativeProjectNumber: number,
    nativeAppId: app,
    platform: platform,
  );

  test(
    'accepts the installed Android tenant Firebase identity',
    () => verify(identity()),
  );
  test(
    'accepts the installed iOS tenant Firebase identity',
    () => verify(
      identity(app: '1:12345:ios:abc123'),
      app: '1:12345:ios:abc123',
      platform: 'ios',
    ),
  );
  test(
    'rejects a native package from another tenant',
    () => expect(
      () => verify(identity(), package: 'com.example.foreign'),
      throwsStateError,
    ),
  );
  test(
    'rejects another native Firebase project',
    () => expect(
      () => verify(identity(), project: 'foreign-project'),
      throwsStateError,
    ),
  );
  test(
    'rejects another Firebase sender project number',
    () => expect(() => verify(identity(), number: '99999'), throwsStateError),
  );
  test(
    'rejects another Firebase app in the same project',
    () => expect(
      () => verify(identity(), app: '1:12345:android:ffff'),
      throwsStateError,
    ),
  );
  test(
    'rejects an app for another platform',
    () => expect(() => verify(identity(), platform: 'ios'), throwsStateError),
  );
  for (final id in [
    '',
    '00000000000000000000000000000000',
    '12345678-1234-1234-1234-1234567890ab',
  ]) {
    test(
      'rejects a noncanonical or empty tenant $id',
      () => expect(() => verify(identity(id: id)), throwsStateError),
    );
  }
  test(
    'rejects a Firebase app outside the expected project number',
    () => expect(
      () => verify(
        identity(app: '1:99999:android:abc123'),
        app: '1:99999:android:abc123',
      ),
      throwsStateError,
    ),
  );
}
