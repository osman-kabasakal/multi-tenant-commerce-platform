import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// The background isolate never opens Hive. Distinct pending/handled versions avoid losing a new push during refresh.
class CacheRefreshMarker {
  CacheRefreshMarker()
    : _directory =
          (() async => Directory(
            '${(await getApplicationSupportDirectory()).path}/client-cache-refresh-v1',
          ));
  CacheRefreshMarker.inDirectory(Directory directory)
    : _directory = (() async => directory);
  final Future<Directory> Function() _directory;

  Future<String?> _read(File file) async =>
      await file.exists() ? file.readAsString() : null;
  Future<void> _write(Directory directory, String name, String value) async {
    await directory.create(recursive: true);
    final temporary = File('${directory.path}/$name.${const Uuid().v4()}.tmp');
    try {
      await temporary.writeAsString(value, flush: true);
      await temporary.rename('${directory.path}/$name');
    } finally {
      if (await temporary.exists()) await temporary.delete();
    }
  }

  Future<void> mark() async =>
      _write(await _directory(), 'pending', const Uuid().v4());

  Future<bool> apply(Future<void> Function() refresh) async {
    final directory = await _directory();
    final pending = await _read(File('${directory.path}/pending'));
    if (pending == null ||
        pending == await _read(File('${directory.path}/handled'))) {
      return false;
    }
    await refresh();
    await _write(directory, 'handled', pending);
    return true;
  }
}
