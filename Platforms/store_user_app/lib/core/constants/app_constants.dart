import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

const correlationIdZoneKey = #correlationId;
const cacheKeyZoneKey = #cacheKey;
final myAppKey = GlobalKey<State<ProviderScope>>();
const String waitingTasksLockKey = 'connectivityWaitingTasks';
