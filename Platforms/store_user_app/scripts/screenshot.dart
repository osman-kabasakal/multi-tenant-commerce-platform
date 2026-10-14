import 'dart:convert';
import 'dart:io';

const filteredDeviceIDs = [];

class TestConfig {
  final String flavor;
  final String storeUrl;
  final String authUrl;
  final String authRealm;
  final String authClientId;
  final String storeLogo;
  final String appSignatureSha256;
  final String packageNameAndroid;
  final String packageNameIos;
  final String appTitle;

  TestConfig({
    required this.flavor,
    required this.storeUrl,
    required this.authUrl,
    required this.authRealm,
    required this.authClientId,
    required this.storeLogo,
    required this.appSignatureSha256,
    required this.packageNameAndroid,
    required this.packageNameIos,
    required this.appTitle,
  });

  // Convert configuration to dart-define parameters
  List<String> toDartDefines() {
    return [
      '--dart-define=STORE_URL=$storeUrl',
      '--dart-define=AUTH_URL=$authUrl',
      '--dart-define=AUTH_REALM=$authRealm',
      '--dart-define=AUTH_CLIENT_ID=$authClientId',
      '--dart-define=STORE_LOGO=$storeLogo',
      '--dart-define=APP_SIGNATURE_SHA256=$appSignatureSha256',
      '--dart-define=PACKAGE_NAME_ANDROID=$packageNameAndroid',
      '--dart-define=PACKAGE_NAME_IOS=$packageNameIos',
      '--dart-define=APP_TITLE=$appTitle',
    ];
  }

  @override
  String toString() {
    return '''
Test Configuration:
  Flavor: $flavor
  Store URL: $storeUrl
  Auth URL: $authUrl
  Auth Realm: $authRealm
  Auth Client ID: $authClientId
  Store Logo: $storeLogo
  App Signature SHA256: $appSignatureSha256
  Package Name Android: $packageNameAndroid
  Package Name iOS: $packageNameIos
  App Title: $appTitle
''';
  }
}

void main(List<String> arguments) async {
  print('-= Run Tests =-');
  var flavor = arguments[0];
  print(flavor);
  final screenshotsDir = Directory('screenshots');
  if (screenshotsDir.existsSync()) {
    screenshotsDir.deleteSync(recursive: true);
  }

  final startTime = DateTime.now();

  final iOsDevices = await getIOsDevices();
  await Process.run('open', [
    '/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app',
  ]);
  await shutdownIOsDevices(iOsDevices);

  final androidDevices = await getAndroidDevices();

  final devices = [
    androidDevices.firstWhere((a) => a.id == 'new_emulator_pixel_3a_api_34'),
    iOsDevices.firstWhere((i) => i.name == 'iPhone SE (3rd generation)'),
  ];
  devices.removeWhere((d) => filteredDeviceIDs.contains(d.id));

  for (final device in devices) {
    if (device.isAndroid) {
      await processAndroid(device, flavor);
    }

    if (device.isiOs) {
      await processIOs(device, flavor);
    }
  }

  final endTime = DateTime.now();
  final scriptTimeMillis =
      endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch;
  print('Done in ${Duration(milliseconds: scriptTimeMillis)}');
}

Future<void> shutdownIOsDevices(List<Device> devices) async {
  for (final device in devices) {
    await Process.run('xcrun', ['simctl', 'shutdown', device.id]);
  }
}

Future<void> processIOs(Device device, String flavor) async {
  print('Starting device ${device.name}');
  await Process.run('xcrun', ['simctl', 'boot', device.id]);

  await runTests(device, flavor);

  print('\tShutting down');
  await Process.run('xcrun', ['simctl', 'shutdown', device.id]);
}

Future<void> processAndroid(Device device, String flavor) async {
  print('Starting device ${device.name}');
  final process = await Process.start(
    'emulator',
    ['-avd', device.id, '-no-snapshot', '-dns-server', '8.8.8.8'],
    workingDirectory: '/workspace/Library/Android/sdk/tools',
  );
  await process.stdout
      .map((raw) => String.fromCharCodes(raw))
      .firstWhere(
        (log) => log.contains(
          'Increasing screen off timeout, logcat buffer size to 2M.',
        ),
      );

  await runTests(device, flavor);
  process.kill();
}

TestConfig parseConfig() {
  return TestConfig(
    flavor: '',
    storeUrl: const String.fromEnvironment('STORE_URL'),
    authUrl: const String.fromEnvironment('AUTH_URL'),
    authRealm: const String.fromEnvironment('AUTH_REALM'),
    authClientId: const String.fromEnvironment('AUTH_CLIENT_ID'),
    storeLogo: const String.fromEnvironment('STORE_LOGO'),
    appSignatureSha256: const String.fromEnvironment('APP_SIGNATURE_SHA256'),
    packageNameAndroid: const String.fromEnvironment('PACKAGE_NAME_ANDROID'),
    packageNameIos: const String.fromEnvironment('PACKAGE_NAME_IOS'),
    appTitle: const String.fromEnvironment('APP_TITLE'),
  );
}

Future<void> runTests(Device device, String flavor) async {
  var conf = parseConfig();
  // Function to stream process output in real-time
  Future<int> runTestWithRealtimeOutput(String locale) async {
    print('\n----------------------------------------------------');
    print('RUNNING TESTS FOR ${device.name} WITH LOCALE $locale');
    print('----------------------------------------------------\n');

    final process = await Process.start('flutter', [
      'drive',
      '--driver=test_driver/integration_test.dart',
      '--target=integration_test/main_test.dart',
      '--device-connection',
      'attached',
      '--dart-define',
      'DEVICE_NAME=${device.name}',
      '--dart-define',
      'LOCALE=$locale',
      ...conf.toDartDefines(),
      '--flavor',
      flavor,
    ]);

    // Stream stdout in real-time
    process.stdout.transform(utf8.decoder).listen((data) {
      print('[Test Output] $data');
    });

    // Stream stderr in real-time
    process.stderr.transform(utf8.decoder).listen((data) {
      print('[Test Error] $data');
    });

    // Wait for process to complete and return exit code
    return await process.exitCode;
  }

  // Run tests with English locale
  final enExitCode = await runTestWithRealtimeOutput('en_US');
  print('Tests with en_US completed with exit code: $enExitCode');

  // Run tests with Turkish locale
  final trExitCode = await runTestWithRealtimeOutput('tr_TR');
  print('Tests with tr_TR completed with exit code: $trExitCode');

  if (enExitCode != 0 || trExitCode != 0) {
    print('WARNING: One or more tests failed!');
  }
}

// Future<void> runTests(Device device, String flavor) async {
//   print('\tRunning tests en_US');
//   final resultEn = await Process.run('flutter', [
//     'drive',
//     '--driver=test_driver/integration_test.dart',
//     '--target=integration_test/main_test.dart',
//     '--device-connection',
//     'attached',
//     '--dart-define',
//     'DEVICE_NAME=${device.name}',
//     '--dart-define',
//     'LOCALE=en_US',
//     '--flavor',
//     flavor,
//     '--verbose'
//   ]);

//   if (resultEn.stderr != null) {
//     if (resultEn.stderr is String) {
//       print(resultEn.stderr);
//     } else {
//       print(resultEn.stderr);
//     }
//   }

//   if (resultEn.stdout is String) {
//     print(resultEn.stdout);
//   } else {
//     print(String.fromCharCodes(resultEn.stdout));
//   }

//   print('\tRunning tests tr_TR');
//   final resultTR = await Process.run('flutter', [
//     'drive',
//     '--driver=test_driver/integration_test.dart',
//     '--target=integration_test/main_test.dart',
//     '--device-connection',
//     'attached',
//     '--dart-define',
//     'DEVICE_NAME=${device.name}',
//     '--dart-define',
//     'LOCALE=tr_TR',
//     '--flavor',
//     flavor,
//     '--verbose'
//   ]);
//   process.stdout
//       .transform(utf8.decoder)
//       .listen((data) {
//         print('[Test Output] $data');
//       });

//     // Stream stderr in real-time
//     process.stderr
//       .transform(utf8.decoder)
//       .listen((data) {
//         print('[Test Error] $data');
//       });
//   if (resultTR.stderr != null) {
//     if (resultTR.stderr is String) {
//       print(resultTR.stderr);
//     } else {
//       print(resultTR.stderr);
//     }
//   }
//   if (resultTR.stdout is String) {
//     print(resultTR.stdout);
//   } else {
//     print(String.fromCharCodes(resultTR.stdout));
//   }
//   // print(result.stdout);
// }

Future<List<Device>> getAndroidDevices() async {
  final devices = <Device>[];

  final result = await Process.run('emulator', ['-list-avds']);
  String devicesListRaw = result.stdout;
  final devicesListRawLines = devicesListRaw.split('\n');
  for (final devicesListRawLine in devicesListRawLines.skip(1)) {
    if (devicesListRawLine.isNotEmpty) {
      devices.add(
        Device(
          name: devicesListRawLine,
          id: devicesListRawLine,
          type: DeviceType.android,
        ),
      );
    }
  }
  return devices;
}

Future<List<Device>> getIOsDevices() async {
  final devices = <Device>[];

  final result = await Process.run('xcrun', ['simctl', 'list']);
  String devicesListRaw = result.stdout;
  devicesListRaw = devicesListRaw.substring(
    devicesListRaw.indexOf('== Devices =='),
  );
  final devicesListRawLines = devicesListRaw.split('\n');
  final regex = RegExp(r'(\([-A-Z0-9]+)\)');

  for (final devicesListRawLine in devicesListRawLines) {
    if (regex.hasMatch(devicesListRawLine)) {
      final deviceId = regex
          .firstMatch(devicesListRawLine)!
          .group(0)!
          .replaceAll('(', '')
          .replaceAll(')', '');

      final deviceName =
          devicesListRawLine
              .substring(0, devicesListRawLine.indexOf(deviceId) - 1)
              .trim();

      devices.add(Device(name: deviceName, id: deviceId, type: DeviceType.iOs));
    }
  }
  return devices;
}

enum DeviceType { iOs, android }

class Device {
  final String name;
  final String id;
  final DeviceType type;

  Device({required this.name, required this.id, required this.type});

  bool get isAndroid => type == DeviceType.android;

  bool get isiOs => type == DeviceType.iOs;

  @override
  String toString() {
    return '$name{$id}';
  }
}
