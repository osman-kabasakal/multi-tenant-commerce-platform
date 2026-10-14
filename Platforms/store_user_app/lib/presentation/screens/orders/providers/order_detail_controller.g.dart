// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderDetailControllerHash() =>
    r'9d0bc53ea448d9915f11147bb604d7ff4cbce650';

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

abstract class _$OrderDetailController
    extends BuildlessAutoDisposeAsyncNotifier<OrderDetailViewModel> {
  late final String orderId;

  FutureOr<OrderDetailViewModel> build(String orderId);
}

/// See also [OrderDetailController].
@ProviderFor(OrderDetailController)
const orderDetailControllerProvider = OrderDetailControllerFamily();

/// See also [OrderDetailController].
class OrderDetailControllerFamily
    extends Family<AsyncValue<OrderDetailViewModel>> {
  /// See also [OrderDetailController].
  const OrderDetailControllerFamily();

  /// See also [OrderDetailController].
  OrderDetailControllerProvider call(String orderId) {
    return OrderDetailControllerProvider(orderId);
  }

  @override
  OrderDetailControllerProvider getProviderOverride(
    covariant OrderDetailControllerProvider provider,
  ) {
    return call(provider.orderId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderDetailControllerProvider';
}

/// See also [OrderDetailController].
class OrderDetailControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          OrderDetailController,
          OrderDetailViewModel
        > {
  /// See also [OrderDetailController].
  OrderDetailControllerProvider(String orderId)
    : this._internal(
        () => OrderDetailController()..orderId = orderId,
        from: orderDetailControllerProvider,
        name: r'orderDetailControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$orderDetailControllerHash,
        dependencies: OrderDetailControllerFamily._dependencies,
        allTransitiveDependencies:
            OrderDetailControllerFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  OrderDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  FutureOr<OrderDetailViewModel> runNotifierBuild(
    covariant OrderDetailController notifier,
  ) {
    return notifier.build(orderId);
  }

  @override
  Override overrideWith(OrderDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: OrderDetailControllerProvider._internal(
        () => create()..orderId = orderId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    OrderDetailController,
    OrderDetailViewModel
  >
  createElement() {
    return _OrderDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderDetailControllerProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<OrderDetailViewModel> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _OrderDetailControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          OrderDetailController,
          OrderDetailViewModel
        >
    with OrderDetailControllerRef {
  _OrderDetailControllerProviderElement(super.provider);

  @override
  String get orderId => (origin as OrderDetailControllerProvider).orderId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
