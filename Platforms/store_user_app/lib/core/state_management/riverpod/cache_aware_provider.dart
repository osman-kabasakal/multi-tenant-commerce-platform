import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:store_user_app/core/cache/cache_invalidate_event.dart';
import 'package:store_user_app/core/cache/cache_manager.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
import 'package:store_user_app/core/services/cache/cache_freshness_service.dart';

import '../../data/events/cache_invalidation_notifier.dart';
import '../../services/correlation/correlation_service.dart';

// Base implementation for cache invalidation logic shared by all provider types
mixin CacheInvalidationBase {
  late StreamSubscription<CacheInvalidateEvent> _cacheInvalidateSubscription;
  late String correlationId = '';
  late CorrelationService correlationService;
  late CancellationToken cancellationToken;

  /// Setup invalidation listener based on cache events
  void _setupInvalidationListener(Ref ref) {
    cancellationToken = CancellationToken();

    _cacheInvalidateSubscription = getIt
        .get<CacheInvalidationNotifier>()
        .invalidationStream
        .listen((event) {
          if (cancellationToken.isCancelled) return;
          if (event.entity.type == CacheInvalidateType.all) {
            ref.invalidateSelf();
          } else if (event.entity.type == CacheInvalidateType.key) {
            correlationService
                .getCorrelationForCacheKey(
                  event.entity.key ?? '',
                  correlationId,
                )
                .then((registeredProviderId) {
                  if (registeredProviderId == correlationId &&
                      !cancellationToken.isCancelled) {
                    ref.invalidateSelf();
                  }
                });
          } else {
            correlationService
                .getCorrelationsForCacheKeyPrefix(
                  event.entity.key ?? '',
                  correlationId,
                )
                .then((correlations) {
                  if (correlations.contains(correlationId) &&
                      !cancellationToken.isCancelled) {
                    ref.invalidateSelf();
                  }
                });
          }
        });
  }

  /// Clean up resources when provider is disposed
  void _setupOnDispose(Ref ref) {
    ref.onDispose(() {
      cancellationToken.cancel();
      _cacheInvalidateSubscription.cancel();
      correlationService.removeCorrelation(correlationId);
    });
  }

  Future<void> cacheFreshness([
    String? localCacheKey,
    CacheInvalidateType? type,
    bool forceInvalidate = true,
  ]) async {
    if (localCacheKey != null) {
      if (type == CacheInvalidateType.key) {
        return await (await getIt.getAsync<CacheManager>()).removeAsync(
          localCacheKey,
          publish: forceInvalidate,
        );
      } else if (type == CacheInvalidateType.prefix) {
        return await (await getIt.getAsync<CacheManager>()).removeByPrefix(
          localCacheKey,
          publish: forceInvalidate,
        );
      }
    } else if (type == CacheInvalidateType.all) {
      return await (await getIt.getAsync<CacheManager>()).clear(
        publish: forceInvalidate,
      );
    }
    var cacheKeys = await correlationService.getCacheKeysForCorrelation(
      correlationId,
    );

    for (var key in cacheKeys) {
      await (await getIt.getAsync<CacheManager>()).removeAsync(
        key,
        publish: forceInvalidate,
      );
    }
  }
}

/// For AutoDisposeAsyncNotifier providers
mixin CacheAwareAsyncProvider<T>
    on AutoDisposeAsyncNotifier<T>, CacheInvalidationBase {
  FutureOr<void> registerCorrelation() async {
    correlationService = await getIt.getAsync<CorrelationService>();
    correlationId = correlationService.createCorrelationId();

    _setupInvalidationListener(ref);
    _setupOnDispose(ref);
  }
}

/// For AutoDisposeFamilyAsyncNotifier providers
mixin CacheAwareAsyncFamilyProvider<T>
        // ignore: invalid_use_of_internal_member
        on
        BuildlessAutoDisposeAsyncNotifier<T>,
        CacheInvalidationBase {
  FutureOr<void> registerCorrelation() async {
    correlationService = await getIt.getAsync<CorrelationService>();
    correlationId = correlationService.createCorrelationId();

    _setupInvalidationListener(ref);
    _setupOnDispose(ref);
  }
}

/// For AutoDisposeNotifier providers
mixin CacheAwareProvider<T> on AutoDisposeNotifier<T>, CacheInvalidationBase {
  bool _onDisposeCalled = false;

  void registerCorrelation() {
    getIt.getAsync<CorrelationService>().then((service) {
      correlationService = service;

      if (_onDisposeCalled) return;

      correlationId = correlationService.createCorrelationId();
      _setupInvalidationListener(ref);

      ref.onDispose(() {
        _onDisposeCalled = true;
        _cacheInvalidateSubscription.cancel();
        correlationService.removeCorrelation(correlationId);
      });
    });
  }
}

/// For AutoDisposeFamilyNotifier providers
mixin CacheAwareFamilyProvider<TArgs, T>
    on AutoDisposeFamilyNotifier<T, TArgs>, CacheInvalidationBase {
  bool _onDisposeCalled = false;

  void registerCorrelation(TArgs arg) {
    getIt.getAsync<CorrelationService>().then((service) {
      correlationService = service;

      if (_onDisposeCalled) return;

      correlationId = correlationService.createCorrelationId();
      _setupInvalidationListener(ref);

      ref.onDispose(() {
        _onDisposeCalled = true;
        _cacheInvalidateSubscription.cancel();
        correlationService.removeCorrelation(correlationId);
      });
    });
  }
}
