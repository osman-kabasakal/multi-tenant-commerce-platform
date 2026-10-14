import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../constants/app_constants.dart';

// /// Service for correlating cache keys with their operations
// @singleton
// class CorrelationService {
//   // Box that stores correlationId -> List<cacheKey> mappings
//   late final Box<List<String>> _correlationBox;

//   // Box that stores cacheKey -> correlationId mappings (for reverse lookup)
//   late final Box<String> _cacheKeyCorrelationBox;

//   @factoryMethod
//   static Future<CorrelationService> create() async {
//     return CorrelationService._();
//   }

//   CorrelationService._() {
//     _initAsync();
//   }

//   Future<void> _initAsync() async {
//     try {
//       // Open Hive boxes for correlation tracking
//       if (!Hive.isBoxOpen('correlation_keys')) {
//         _correlationBox = await Hive.openBox<List<String>>('correlation_keys');
//       } else {
//         _correlationBox = Hive.box<List<String>>('correlation_keys');
//       }

//       if (!Hive.isBoxOpen('cache_key_correlation')) {
//         _cacheKeyCorrelationBox =
//             await Hive.openBox<String>('cache_key_correlation');
//       } else {
//         _cacheKeyCorrelationBox = Hive.box<String>('cache_key_correlation');
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('CorrelationService init error: $e');
//       }
//     }
//   }

//   /// Creates a new correlation ID and returns it
//   String createCorrelationId() {
//     return const Uuid().v4();
//   }

//   /// Get the current correlation ID from the Zone
//   String? getCurrentCorrelationId() {
//     try {
//       return Zone.current[correlationIdZoneKey] as String?;
//     } catch (e) {
//       return null;
//     }
//   }

//   /// Set the current cache key in the Zone
//   void setCurrentCacheKey(String cacheKey) {
//     try {
//       // Get the current correlation ID
//       final correlationId = getCurrentCorrelationId();
//       if (correlationId != null) {
//         // Store in both mapping directions
//         _addCacheKeyToCorrelation(correlationId, cacheKey);
//         _cacheKeyCorrelationBox.put(cacheKey, correlationId);
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         debugPrint('CorrelationService.setCurrentCacheKey error: $e');
//       }
//     }
//   }

//   /// Run a function in a zone with the specified correlation ID
//   T runWithCorrelation<T>(String correlationId, T Function() callback) {
//     return runZoned(
//       () {
//         var zone = Zone.current;

//         return zone.run(callback);
//       },
//       zoneValues: {
//         correlationIdZoneKey: correlationId,
//       },
//     );
//   }

//   /// Get all cache keys associated with a correlation ID
//   List<String> getCacheKeysForCorrelation(String correlationId) {
//     return _correlationBox.get(correlationId) ?? [];
//   }

//   List<String> getAllCorrelations() {
//     return _correlationBox.keys.map((k) => k.toString()).toList();
//   }

//   /// Get the correlation ID for a cache key
//   String? getCorrelationForCacheKey(String cacheKey) {
//     return _cacheKeyCorrelationBox.get(cacheKey);
//   }

//   List<String?> getCorrelationsForCacheKeyPrefix(String cacheKeyPrefix) {
//     var cacheKeys = _cacheKeyCorrelationBox.keys
//         .where((k) => k.toString().startsWith(cacheKeyPrefix))
//         .toList();
//     return cacheKeys.map((key) => _cacheKeyCorrelationBox.get(key)).toList();
//   }

//   /// Get all cache keys for a list of correlation IDs
//   List<String> getAllCacheKeysForCorrelations(List<String> correlationIds) {
//     final result = <String>[];

//     for (final correlationId in correlationIds) {
//       final keys = getCacheKeysForCorrelation(correlationId);
//       result.addAll(keys);
//     }

//     return result;
//   }

//   /// Remove a correlation and all its associated cache keys
//   Future<void> removeCorrelation(String correlationId) async {
//     final cacheKeys = getCacheKeysForCorrelation(correlationId);

//     // Remove the reverse mappings
//     for (final cacheKey in cacheKeys) {
//       await _cacheKeyCorrelationBox.delete(cacheKey);
//     }

//     // Remove the correlation itself
//     await _correlationBox.delete(correlationId);
//   }

//   /// Add a cache key to a correlation mapping
//   void _addCacheKeyToCorrelation(String correlationId, String cacheKey) {
//     final existing = _correlationBox.get(correlationId) ?? [];
//     if (!existing.contains(cacheKey)) {
//       existing.add(cacheKey);
//       _correlationBox.put(correlationId, existing);
//     }
//   }

//   /// Run a repository method with correlation tracking
//   Future<T?> runRepositoryMethodWithCorrelation<T>(
//     String correlationId,
//     Future<T?> Function() repositoryMethod,
//   ) async {
//     return Future.microtask(
//         () async => await runWithCorrelation(correlationId, repositoryMethod));
//   }

//   @disposeMethod
//   void dispose() {
//     // Close Hive boxes if needed
//     if (_correlationBox.isOpen) {
//       _correlationBox.close();
//       _correlationBox.deleteFromDisk();
//     }

//     if (_cacheKeyCorrelationBox.isOpen) {
//       _cacheKeyCorrelationBox.close();
//       _correlationBox.deleteFromDisk();
//     }
//   }
// }

/// Service for correlating cache keys with their operations
@singleton
class CorrelationService {
  static Database? _database;
  static const String _correlationTableName = 'correlation_mapping';

  @factoryMethod
  static Future<CorrelationService> create() async {
    final service = CorrelationService._();
    await service._initAsync();
    return service;
  }

  CorrelationService._();

  Future<void> _initAsync() async {
    try {
      // Initialize SQLite database
      final databasesPath = await getDatabasesPath();
      final path = join(databasesPath, 'correlation_service.db');

      _database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          // Create tables
          await db.execute('''
            CREATE TABLE $_correlationTableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              correlation_id TEXT NOT NULL,
              cache_key TEXT NOT NULL,
              UNIQUE(correlation_id, cache_key)
            )
          ''');
          // Create indexes for faster lookups
          await db.execute(
              'CREATE INDEX correlation_id_index ON $_correlationTableName (correlation_id)');
          await db.execute(
              'CREATE INDEX cache_key_index ON $_correlationTableName (cache_key)');
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CorrelationService init error: $e');
      }
    }
  }

  /// Creates a new correlation ID and returns it
  String createCorrelationId() {
    return const Uuid().v4();
  }

  /// Get the current correlation ID from the Zone
  String? getCurrentCorrelationId() {
    try {
      return Zone.current[correlationIdZoneKey] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Set the current cache key in the Zone
  Future<void> setCurrentCacheKey(String cacheKey) async {
    try {
      // Get the current correlation ID
      final correlationId = getCurrentCorrelationId();
      if (correlationId != null) {
        // Store the mapping
        await _addCacheKeyToCorrelation(correlationId, cacheKey);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('CorrelationService.setCurrentCacheKey error: $e');
      }
    }
  }

  /// Run a function in a zone with the specified correlation ID
  T runWithCorrelation<T>(String correlationId, T Function() callback) {
    return runZoned(
      () {
        var zone = Zone.current;
        return zone.run(callback);
      },
      zoneValues: {
        correlationIdZoneKey: correlationId,
      },
    );
  }

  /// Get all cache keys associated with a correlation ID
  Future<List<String>> getCacheKeysForCorrelation(String correlationId) async {
    final db = _database;
    if (db == null) return [];

    final result = await db.query(
      _correlationTableName,
      columns: ['cache_key'],
      where: 'correlation_id = ?',
      whereArgs: [correlationId],
    );

    return result.map((row) => row['cache_key'] as String).toList();
  }

  Future<List<String>> getAllCorrelations() async {
    final db = _database;
    if (db == null) return [];

    final result = await db.rawQuery(
      'SELECT DISTINCT correlation_id FROM $_correlationTableName',
    );

    return result.map((row) => row['correlation_id'] as String).toList();
  }

  /// Get the correlation ID for a cache key
  Future<String?> getCorrelationForCacheKey(
      String cacheKey, String correlationId) async {
    final db = _database;
    if (db == null) return null;

    final result = await db.query(
      _correlationTableName,
      columns: ['correlation_id'],
      where: 'cache_key = ? AND correlation_id = ?',
      whereArgs: [cacheKey, correlationId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return result.first['correlation_id'] as String;
  }

  Future<List<String>> getCorrelationsForCacheKeyPrefix(
      String cacheKeyPrefix, String correlationId) async {
    final db = _database;
    if (db == null) return [];

    final result = await db.query(
      _correlationTableName,
      columns: ['correlation_id'],
      where: 'cache_key LIKE ? AND correlation_id = ?',
      whereArgs: ['$cacheKeyPrefix%', correlationId],
      distinct: true,
    );

    return result.map((row) => row['correlation_id'] as String).toList();
  }

  /// Get all cache keys for a list of correlation IDs
  Future<List<String>> getAllCacheKeysForCorrelations(
      List<String> correlationIds) async {
    if (correlationIds.isEmpty) return [];

    final db = _database;
    if (db == null) return [];

    // Create placeholders for SQL IN clause
    final placeholders = List.filled(correlationIds.length, '?').join(',');

    final result = await db.query(
      _correlationTableName,
      columns: ['cache_key'],
      where: 'correlation_id IN ($placeholders)',
      whereArgs: correlationIds,
      distinct: true,
    );

    return result.map((row) => row['cache_key'] as String).toList();
  }

  /// Remove a correlation and all its associated cache keys
  Future<void> removeCorrelation(String correlationId) async {
    final db = _database;
    if (db == null) return;

    await db.delete(
      _correlationTableName,
      where: 'correlation_id = ?',
      whereArgs: [correlationId],
    );
  }

  /// Add a cache key to a correlation mapping
  Future<void> _addCacheKeyToCorrelation(
      String correlationId, String cacheKey) async {
    final db = _database;
    if (db == null) return;

    await db.insert(
      _correlationTableName,
      {
        'correlation_id': correlationId,
        'cache_key': cacheKey,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore if already exists
    );
  }

  /// Run a repository method with correlation tracking
  Future<T?> runRepositoryMethodWithCorrelation<T>(
    String correlationId,
    Future<T?> Function() repositoryMethod,
  ) async {
    return Future.microtask(
        () async => await runWithCorrelation(correlationId, repositoryMethod));
  }

  @disposeMethod
  Future<void> dispose() async {
    // Close SQLite database if needed
    if (_database != null) {
      await _database!.execute('DELETE FROM $_correlationTableName');
      await _database!.execute(
          'UPDATE sqlite_sequence SET seq = 0 WHERE name = "$_correlationTableName"');
      await _database!.close();
      _database = null;
    }
  }
}
