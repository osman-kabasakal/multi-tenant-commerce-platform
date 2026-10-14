// import 'package:store_user_app/core/cache/cache_invalidate_event.dart';
// import 'package:store_user_app/core/data/events/entity_event_listener.dart';
// import 'package:store_user_app/core/di/injection_container.dart';
// import 'package:store_user_app/core/models/background_tasks/cancellation_token.dart';
// import 'package:store_user_app/core/models/cache/cache_invalidate_type.dart';
// import 'package:store_user_app/core/services/correlation/correlation_service.dart';

// class CacheInvalidateListener
//     extends EntityEventListener<CacheInvalidateEvent> {
//   @override
//   Future<void> onEntityEvent(
//       CacheInvalidateEvent event, CancellationToken cancellationToken) async {
//     var correlationService = await getIt.getAsync<CorrelationService>();
//     if (event.entity.type == CacheInvalidateType.all) {
//       var correlations = correlationService.getAllCorrelations();
//     } else if (event.entity.type == CacheInvalidateType.key) {
//       var registeredProviderId =
//           correlationService.getCorrelationForCacheKey(event.entity.key ?? '');
//     } else {}
//   }
// }
