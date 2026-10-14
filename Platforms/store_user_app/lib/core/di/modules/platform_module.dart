// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// @module
// abstract class PlatformModule {
//   @preResolve
//   @Named('shared_preferences')
//   Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();

//   @Named('flutter_secure_storage')
//   FlutterSecureStorage get flutterSecureStorage => const FlutterSecureStorage(
//         aOptions: AndroidOptions(encryptedSharedPreferences: true),
//         iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
//       );
// }
