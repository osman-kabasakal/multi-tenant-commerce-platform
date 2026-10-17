import 'package:store_user_app/core/config/local_demo.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/cache/remote_cache.dart';
import 'package:store_user_app/core/constants/app_constants.dart';
import 'package:store_user_app/core/data/events/event_bus.dart';
import 'package:store_user_app/core/network/dio/interceptors/cachekey_tracker_interceptor.dart';
import 'package:store_user_app/core/services/Security/connectivity_monitor.dart';
import 'package:store_user_app/core/services/auth/app_tokens_refresh_event.dart';
import 'package:store_user_app/core/services/cache/cache_change_notice.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';
import 'package:store_user_app/core/services/cache/cache_refresh_marker.dart';
import 'package:store_user_app/domain/cache/cache_manager_impl.dart';

const first = '00000000-0000-0000-0000-000000000001';
const second = '00000000-0000-0000-0000-000000000002';
const tenant = '00000000000000000000000000000001';
final timestamp = DateTime.utc(2026, 10, 17).toIso8601String();

Future<void> until(bool Function() condition) async {
  final limit = DateTime.now().add(const Duration(seconds: 3));
  while (!condition()) {
    if (DateTime.now().isAfter(limit)) {
      fail('The isolated client-cache operation did not complete.');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

class MemoryCache extends Fake implements CacheManager {
  final keys = <String, DateTime>{};
  final removed = <String>[];
  int cleared = 0;
  @override
  Future<List<({String key, DateTime createdDate})>> getAllCacheKeys() async =>
      keys.entries.map((e) => (key: e.key, createdDate: e.value)).toList();
  @override
  Future<void> removeAsync(String key, {bool publish = true}) async {
    removed.add(key);
    keys.remove(key);
  }

  @override
  Future<void> clear({bool publish = true}) async {
    cleared++;
    keys.clear();
  }
}

class MemoryRemote extends Fake implements RemoteCache {
  final values = <String, dynamic>{};
  @override
  Future<T?> get<T>(String key) async => values[key] as T?;
  @override
  Future<void> set<T>(String key, T value, [Duration? lifetime]) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }

  @override
  Future<void> clear() async {
    values.clear();
  }

  @override
  Future<bool> isValid(String key) async => values.containsKey(key);
}

class FakeSocket extends Fake implements WebSocket {
  final events = StreamController<dynamic>.broadcast();
  bool closed = false;
  @override
  StreamSubscription<dynamic> listen(
    void Function(dynamic)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => events.stream.listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  @override
  Future<void> close([int? code, String? reason]) async {
    closed = true;
    if (!events.isClosed) await events.close();
  }
}

class Adapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];
  bool stale = false;
  String correlation = first;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? body,
    Future<void>? cancel,
  ) async {
    requests.add(options);
    final data =
        options.data is String ? jsonDecode(options.data) : options.data;
    final items = data is Map ? data['StaleCacheItems'] as List : const [];
    return ResponseBody.fromString(
      jsonEncode(
        options.method == 'GET'
            ? {'ok': true}
            : {
              'StaleCorrelationIds':
                  stale
                      ? items.map((item) => item['CorrelationId']).toList()
                      : [],
              'AsOf': timestamp,
            },
      ),
      200,
      headers: {
        'content-type': ['application/json'],
        'x-correlation-id': [
          options.extra['fixtureCorrelation'] as String? ?? correlation,
        ],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

class RealHttp extends HttpOverrides {}

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  late Directory temporary;
  late Box<List<String>> box;
  late CacheKeyTrackerInterceptor tracker;
  late CacheRefreshMarker marker;
  late MemoryCache cache;
  late ConnectivityMonitor monitor;
  late Dio dio;
  late Adapter adapter;
  CacheFreshnessService? service;
  final sockets = <FakeSocket>[];
  setUp(() async {
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    temporary = await Directory.systemTemp.createTemp('client-cache-test-');
    Hive.init(temporary.path);
    box = await Hive.openBox<List<String>>('relations');
    tracker = CacheKeyTrackerInterceptor(box);
    marker = CacheRefreshMarker.inDirectory(
      Directory('${temporary.path}/refresh'),
    );
    cache = MemoryCache();
    monitor = ConnectivityMonitor();
    monitor.connectionStatus.value = [ConnectivityResult.wifi];
    adapter = Adapter();
    dio = Dio(BaseOptions(baseUrl: 'https://fixture.invalid'))
      ..httpClientAdapter = adapter;
    sockets.clear();
  });
  tearDown(() async {
    service?.dispose();
    service = null;
    for (final socket in sockets) {
      await socket.close();
    }
    dio.close(force: true);
    await Hive.close();
    await temporary.delete(recursive: true);
  });
  CacheFreshnessService start({Future<WebSocket?> Function()? connect}) =>
      service = CacheFreshnessService.forTesting(
        cache,
        dio,
        tracker,
        monitor,
        EventBus(),
        marker: marker,
        connect:
            connect ??
            () async {
              final socket = FakeSocket();
              sockets.add(socket);
              return socket;
            },
      );

  test(
    'Dio lowercase response headers are persisted before returning, and composite requests retain both dependencies',
    () async {
      dio.interceptors.add(tracker);
      await runZoned(
        () => dio.get('/one'),
        zoneValues: {cacheKeyZoneKey: 'composite'},
      );
      expect(tracker.getRelatedRemoteKeys('composite'), [first]);
      adapter.correlation = second;
      await runZoned(
        () => dio.get('/two'),
        zoneValues: {cacheKeyZoneKey: 'composite'},
      );
      expect(tracker.getRelatedRemoteKeys('composite'), [first, second]);
      await box.close();
      box = await Hive.openBox<List<String>>('relations');
      expect(box.get('composite'), [first, second]);
    },
  );
  test(
    'polling responses cannot replace caller correlation metadata',
    () async {
      await box.put('owned', [first]);
      dio.interceptors.add(tracker);
      adapter.correlation = second;
      await runZoned(
        () => dio.get(
          '/poll',
          options: Options(extra: {'skipCacheTracking': true}),
        ),
        zoneValues: {cacheKeyZoneKey: 'owned'},
      );
      expect(tracker.getRelatedRemoteKeys('owned'), [first]);
    },
  );
  test(
    'concurrent responses preserve every dependency in the same local cache entry',
    () async {
      dio.interceptors.add(tracker);
      await Future.wait(
        List.generate(30, (i) {
          final id =
              '00000000-0000-0000-0000-${(i + 1).toString().padLeft(12, '0')}';
          return runZoned(
            () => dio.get(
              '/parallel',
              options: Options(extra: {'fixtureCorrelation': id}),
            ),
            zoneValues: {cacheKeyZoneKey: 'parallel'},
          );
        }),
      );
      expect(tracker.getRelatedRemoteKeys('parallel').length, 30);
    },
  );

  test(
    'the payload parser bounds malformed input and enforces tenant ownership',
    () {
      final data = {
        'Type': 'cache_invalidation',
        'TenantId': tenant,
        'CorrelationIds': jsonEncode([first, first, second]),
        'RefreshCacheTime': timestamp,
      };
      expect(CacheChangeNotice.push(data, expectedTenant: tenant)!.ids, [
        first,
        second,
      ]);
      expect(
        CacheChangeNotice.push({
          ...data,
          'TenantId': 'f' * 32,
        }, expectedTenant: tenant),
        isNull,
      );
      expect(
        CacheChangeNotice.push({
          ...data,
          'CorrelationIds': 'not-json',
        }, expectedTenant: tenant),
        isNull,
      );
      expect(
        CacheChangeNotice.socket(
          jsonEncode({
            'correlationIds': List.filled(101, first),
            'timestamp': timestamp,
          }),
        ),
        isNull,
      );
      expect(
        CacheChangeNotice.socket(
          jsonEncode({
            'correlationIds': ['another-customer'],
            'timestamp': timestamp,
          }),
        ),
        isNull,
      );
    },
  );
  test(
    'a background marker survives a new instance and preserves a new push arriving during refresh',
    () async {
      await marker.mark();
      var count = 0;
      final restarted = CacheRefreshMarker.inDirectory(
        Directory('${temporary.path}/refresh'),
      );
      expect(
        await restarted.apply(() async {
          count++;
          await marker.mark();
        }),
        isTrue,
      );
      expect(
        await restarted.apply(() async {
          count++;
        }),
        isTrue,
      );
      expect(
        await restarted.apply(() async {
          count++;
        }),
        isFalse,
      );
      expect(count, 2);
      expect(
        Directory(
          '${temporary.path}/refresh',
        ).listSync().whereType<File>().any((f) => f.path.endsWith('.tmp')),
        isFalse,
      );
    },
  );
  test('failed background refresh is not acknowledged', () async {
    await marker.mark();
    await expectLater(
      marker.apply(() async {
        throw StateError('local fixture failure');
      }),
      throwsStateError,
    );
    expect(await marker.apply(() async {}), isTrue);
  });
  test('cold online startup checks cached data and opens one socket', () async {
    await box.put('catalog', [first]);
    cache.keys['catalog'] = DateTime.now();
    adapter.stale = true;
    start();
    await until(() => cache.removed.contains('catalog') && sockets.length == 1);
    expect(tracker.getRelatedRemoteKeys('catalog'), isEmpty);
    expect(adapter.requests.single.path, '/StaleCache/stale-cache-keys');
  });
  test(
    'unknown old cache metadata is evicted instead of silently considered current',
    () async {
      cache.keys['old-release-entry'] = DateTime.now();
      start();
      await until(() => cache.removed.contains('old-release-entry'));
      expect(adapter.requests, isEmpty);
    },
  );
  test(
    'more than one hundred correlations are deduplicated and batched by correlation count',
    () async {
      final ids = List.generate(
        123,
        (i) => '00000000-0000-0000-0000-${(i + 1).toString().padLeft(12, '0')}',
      );
      await box.put('many-a', ids.take(90).toList());
      await box.put('many-b', ids.skip(70).toList());
      cache.keys.addAll({'many-a': DateTime.now(), 'many-b': DateTime.now()});
      start();
      await until(() => adapter.requests.length >= 3);
      final batches =
          adapter.requests
              .take(3)
              .map(
                (r) =>
                    ((r.data is String
                                ? jsonDecode(r.data)
                                : r.data)['StaleCacheItems']
                            as List)
                        .length,
              )
              .toList();
      expect(batches, [50, 50, 23]);
    },
  );
  test(
    'offline and paused states stop work; reconnect and resume immediately verify pending changes',
    () async {
      monitor.connectionStatus.value = [ConnectivityResult.none];
      start();
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(sockets, isEmpty);
      monitor.connectionStatus.value = [ConnectivityResult.wifi];
      await until(() => sockets.length == 1);
      service!.didChangeAppLifecycleState(AppLifecycleState.paused);
      await until(() => sockets.first.closed);
      final count = adapter.requests.length;
      await Future<void>.delayed(const Duration(milliseconds: 70));
      expect(adapter.requests.length, count);
      await marker.mark();
      service!.didChangeAppLifecycleState(AppLifecycleState.resumed);
      await until(() => cache.cleared == 1 && sockets.length == 2);
    },
  );
  test(
    'socket failure retries without stopping the HTTP freshness timer',
    () async {
      var attempts = 0;
      start(
        connect: () async {
          attempts++;
          if (attempts == 1) throw StateError('local connection failure');
          final socket = FakeSocket();
          sockets.add(socket);
          return socket;
        },
      );
      await until(() => sockets.length == 1);
      expect(attempts, 2);
      sockets.first.events.addError(StateError('local disconnection'));
      await until(() => sockets.length == 2);
    },
  );
  test(
    'a socket completing after pause is closed and never attached',
    () async {
      final pending = Completer<WebSocket?>();
      start(connect: () => pending.future);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      service!.didChangeAppLifecycleState(AppLifecycleState.paused);
      final late = FakeSocket();
      sockets.add(late);
      pending.complete(late);
      await until(() => late.closed);
    },
  );
  test('socket messages invalidate each affected local key once', () async {
    await box.put('shared', [first, second]);
    cache.keys['shared'] = DateTime.now();
    start();
    await until(() => sockets.length == 1);
    sockets.single.events.add(
      jsonEncode({
        'correlationIds': [first, second, first],
        'timestamp': timestamp,
      }),
    );
    await until(() => cache.removed.isNotEmpty);
    expect(cache.removed, ['shared']);
  });
  test(
    'logout disconnects the current customer and clears persisted cache state',
    () async {
      start(
        connect: () async {
          final socket = FakeSocket();
          sockets.add(socket);
          return socket;
        },
      );
      await until(() => sockets.length == 1);
      EventBus().publish(AuthSessionEndedEvent());
      await until(() => cache.cleared == 1 && sockets.first.closed);
    },
  );
  test(
    'invalidated in-flight acquisitions are not written back to Hive cache',
    () async {
      final remote = MemoryRemote();
      final manager = await CacheManagerImpl.create(remote, EventBus());
      final pending = Completer<String?>();
      final read = manager.getAsync<String>('racing', () => pending.future);
      await Future<void>.delayed(Duration.zero);
      await manager.removeAsync('racing');
      pending.complete('old');
      expect(await read, 'old');
      expect(remote.values, isEmpty);
      expect(await manager.getAllCacheKeys(), isEmpty);
    },
  );
  test(
    'a newer concurrent acquisition cannot be overwritten by an older completion',
    () async {
      final remote = MemoryRemote();
      final manager = await CacheManagerImpl.create(remote, EventBus());
      final old = Completer<String?>();
      final older = manager.setAsync<String>('same', () => old.future);
      expect(await manager.setAsync<String>('same', () async => 'new'), 'new');
      old.complete('old');
      await older;
      expect(remote.values['same'], 'new');
    },
  );
  test(
    'actual native WebSocket uses bearer headers, no query credentials, and the supported protocol',
    () async {
      await HttpOverrides.runWithHttpOverrides(() async {
        final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
        final seen = Completer<void>();
        WebSocket? accepted;
        final subscription = server.listen((request) async {
          expect(request.uri.path, '/api/ws/fcm');
          expect(request.uri.hasQuery, isFalse);
          if (LocalDemo.enabled && LocalDemo.tenantHost.isNotEmpty) {
            expect(
              request.headers.value(HttpHeaders.hostHeader),
              LocalDemo.tenantHost,
            );
          }
          expect(
            request.headers.value(HttpHeaders.authorizationHeader),
            'Bearer local-fixture',
          );
          accepted = await WebSocketTransformer.upgrade(
            request,
            protocolSelector:
                (protocols) =>
                    protocols.contains('stale-cache-websocket-protocol')
                        ? 'stale-cache-websocket-protocol'
                        : null,
          );
          accepted!.listen((_) {}, onDone: () => accepted!.close());
          accepted!.add(
            jsonEncode({
              'correlationIds': [first],
              'timestamp': timestamp,
            }),
          );
          seen.complete();
        });
        try {
          final socket = await CacheFreshnessService.openSocket(
            Uri.parse('http://127.0.0.1:${server.port}'),
            'local-fixture',
            null,
          );
          await seen.future;
          expect(CacheChangeNotice.socket(await socket.first)!.ids, [first]);
          await socket.close();
        } finally {
          await accepted?.close();
          await subscription.cancel();
          await server.close(force: true);
        }
      }, RealHttp());
    },
  );
}
