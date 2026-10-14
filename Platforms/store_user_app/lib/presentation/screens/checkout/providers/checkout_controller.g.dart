// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$checkoutControllerHash() =>
    r'ce0124c6d92f7fddab4ceef51ddaaeb10868126d';

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

abstract class _$CheckoutController
    extends BuildlessAutoDisposeAsyncNotifier<CheckoutState> {
  late final CheckOutRouteData checkoutRouteData;

  FutureOr<CheckoutState> build(CheckOutRouteData checkoutRouteData);
}

/// See also [CheckoutController].
@ProviderFor(CheckoutController)
const checkoutControllerProvider = CheckoutControllerFamily();

/// See also [CheckoutController].
class CheckoutControllerFamily extends Family<AsyncValue<CheckoutState>> {
  /// See also [CheckoutController].
  const CheckoutControllerFamily();

  /// See also [CheckoutController].
  CheckoutControllerProvider call(CheckOutRouteData checkoutRouteData) {
    return CheckoutControllerProvider(checkoutRouteData);
  }

  @override
  CheckoutControllerProvider getProviderOverride(
    covariant CheckoutControllerProvider provider,
  ) {
    return call(provider.checkoutRouteData);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'checkoutControllerProvider';
}

/// See also [CheckoutController].
class CheckoutControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CheckoutController,
          CheckoutState
        > {
  /// See also [CheckoutController].
  CheckoutControllerProvider(CheckOutRouteData checkoutRouteData)
    : this._internal(
        () => CheckoutController()..checkoutRouteData = checkoutRouteData,
        from: checkoutControllerProvider,
        name: r'checkoutControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$checkoutControllerHash,
        dependencies: CheckoutControllerFamily._dependencies,
        allTransitiveDependencies:
            CheckoutControllerFamily._allTransitiveDependencies,
        checkoutRouteData: checkoutRouteData,
      );

  CheckoutControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.checkoutRouteData,
  }) : super.internal();

  final CheckOutRouteData checkoutRouteData;

  @override
  FutureOr<CheckoutState> runNotifierBuild(
    covariant CheckoutController notifier,
  ) {
    return notifier.build(checkoutRouteData);
  }

  @override
  Override overrideWith(CheckoutController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CheckoutControllerProvider._internal(
        () => create()..checkoutRouteData = checkoutRouteData,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        checkoutRouteData: checkoutRouteData,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CheckoutController, CheckoutState>
  createElement() {
    return _CheckoutControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CheckoutControllerProvider &&
        other.checkoutRouteData == checkoutRouteData;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, checkoutRouteData.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CheckoutControllerRef
    on AutoDisposeAsyncNotifierProviderRef<CheckoutState> {
  /// The parameter `checkoutRouteData` of this provider.
  CheckOutRouteData get checkoutRouteData;
}

class _CheckoutControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CheckoutController,
          CheckoutState
        >
    with CheckoutControllerRef {
  _CheckoutControllerProviderElement(super.provider);

  @override
  CheckOutRouteData get checkoutRouteData =>
      (origin as CheckoutControllerProvider).checkoutRouteData;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
