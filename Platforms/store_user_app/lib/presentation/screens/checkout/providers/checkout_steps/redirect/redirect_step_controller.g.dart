// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redirect_step_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$redirectStepControllerHash() =>
    r'7334bccdcc2d696f28e15ee9fa8c78ee66fcf4e9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$RedirectStepController
    extends BuildlessAutoDisposeAsyncNotifier<RedirectStepViewModel> {
  late final CheckOutRouteData routeData;

  FutureOr<RedirectStepViewModel> build(CheckOutRouteData routeData);
}

/// See also [RedirectStepController].
@ProviderFor(RedirectStepController)
const redirectStepControllerProvider = RedirectStepControllerFamily();

/// See also [RedirectStepController].
class RedirectStepControllerFamily
    extends Family<AsyncValue<RedirectStepViewModel>> {
  /// See also [RedirectStepController].
  const RedirectStepControllerFamily();

  /// See also [RedirectStepController].
  RedirectStepControllerProvider call(CheckOutRouteData routeData) {
    return RedirectStepControllerProvider(routeData);
  }

  @override
  RedirectStepControllerProvider getProviderOverride(
    covariant RedirectStepControllerProvider provider,
  ) {
    return call(provider.routeData);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'redirectStepControllerProvider';
}

/// See also [RedirectStepController].
class RedirectStepControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          RedirectStepController,
          RedirectStepViewModel
        > {
  /// See also [RedirectStepController].
  RedirectStepControllerProvider(CheckOutRouteData routeData)
    : this._internal(
        () => RedirectStepController()..routeData = routeData,
        from: redirectStepControllerProvider,
        name: r'redirectStepControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$redirectStepControllerHash,
        dependencies: RedirectStepControllerFamily._dependencies,
        allTransitiveDependencies:
            RedirectStepControllerFamily._allTransitiveDependencies,
        routeData: routeData,
      );

  RedirectStepControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.routeData,
  }) : super.internal();

  final CheckOutRouteData routeData;

  @override
  FutureOr<RedirectStepViewModel> runNotifierBuild(
    covariant RedirectStepController notifier,
  ) {
    return notifier.build(routeData);
  }

  @override
  Override overrideWith(RedirectStepController Function() create) {
    return ProviderOverride(
      origin: this,
      override: RedirectStepControllerProvider._internal(
        () => create()..routeData = routeData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        routeData: routeData,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    RedirectStepController,
    RedirectStepViewModel
  >
  createElement() {
    return _RedirectStepControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RedirectStepControllerProvider &&
        other.routeData == routeData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, routeData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RedirectStepControllerRef
    on AutoDisposeAsyncNotifierProviderRef<RedirectStepViewModel> {
  /// The parameter `routeData` of this provider.
  CheckOutRouteData get routeData;
}

class _RedirectStepControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RedirectStepController,
          RedirectStepViewModel
        >
    with RedirectStepControllerRef {
  _RedirectStepControllerProviderElement(super.provider);

  @override
  CheckOutRouteData get routeData =>
      (origin as RedirectStepControllerProvider).routeData;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
