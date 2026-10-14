// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipment_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shipmentDetailsControllerHash() =>
    r'ef63493b0e8e358e5a8be598f68e2b84a8adb76d';

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

abstract class _$ShipmentDetailsController
    extends BuildlessAutoDisposeAsyncNotifier<ShipmentDetailsModel> {
  late final String shipmentDetailId;

  FutureOr<ShipmentDetailsModel> build(String shipmentDetailId);
}

/// See also [ShipmentDetailsController].
@ProviderFor(ShipmentDetailsController)
const shipmentDetailsControllerProvider = ShipmentDetailsControllerFamily();

/// See also [ShipmentDetailsController].
class ShipmentDetailsControllerFamily
    extends Family<AsyncValue<ShipmentDetailsModel>> {
  /// See also [ShipmentDetailsController].
  const ShipmentDetailsControllerFamily();

  /// See also [ShipmentDetailsController].
  ShipmentDetailsControllerProvider call(String shipmentDetailId) {
    return ShipmentDetailsControllerProvider(shipmentDetailId);
  }

  @override
  ShipmentDetailsControllerProvider getProviderOverride(
    covariant ShipmentDetailsControllerProvider provider,
  ) {
    return call(provider.shipmentDetailId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'shipmentDetailsControllerProvider';
}

/// See also [ShipmentDetailsController].
class ShipmentDetailsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ShipmentDetailsController,
          ShipmentDetailsModel
        > {
  /// See also [ShipmentDetailsController].
  ShipmentDetailsControllerProvider(String shipmentDetailId)
    : this._internal(
        () => ShipmentDetailsController()..shipmentDetailId = shipmentDetailId,
        from: shipmentDetailsControllerProvider,
        name: r'shipmentDetailsControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$shipmentDetailsControllerHash,
        dependencies: ShipmentDetailsControllerFamily._dependencies,
        allTransitiveDependencies:
            ShipmentDetailsControllerFamily._allTransitiveDependencies,
        shipmentDetailId: shipmentDetailId,
      );

  ShipmentDetailsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.shipmentDetailId,
  }) : super.internal();

  final String shipmentDetailId;

  @override
  FutureOr<ShipmentDetailsModel> runNotifierBuild(
    covariant ShipmentDetailsController notifier,
  ) {
    return notifier.build(shipmentDetailId);
  }

  @override
  Override overrideWith(ShipmentDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShipmentDetailsControllerProvider._internal(
        () => create()..shipmentDetailId = shipmentDetailId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        shipmentDetailId: shipmentDetailId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ShipmentDetailsController,
    ShipmentDetailsModel
  >
  createElement() {
    return _ShipmentDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShipmentDetailsControllerProvider &&
        other.shipmentDetailId == shipmentDetailId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, shipmentDetailId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShipmentDetailsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ShipmentDetailsModel> {
  /// The parameter `shipmentDetailId` of this provider.
  String get shipmentDetailId;
}

class _ShipmentDetailsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ShipmentDetailsController,
          ShipmentDetailsModel
        >
    with ShipmentDetailsControllerRef {
  _ShipmentDetailsControllerProviderElement(super.provider);

  @override
  String get shipmentDetailId =>
      (origin as ShipmentDetailsControllerProvider).shipmentDetailId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
