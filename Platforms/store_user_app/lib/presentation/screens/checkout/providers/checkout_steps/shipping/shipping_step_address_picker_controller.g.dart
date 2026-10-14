// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_step_address_picker_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shippingStepAddressPickerControllerHash() =>
    r'ab089b642473b318fee18e742d10dafee1b67f40';

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

abstract class _$ShippingStepAddressPickerController
    extends BuildlessAutoDisposeAsyncNotifier<AddressPickerViewModel> {
  late final CheckOutRouteData routeData;

  FutureOr<AddressPickerViewModel> build(CheckOutRouteData routeData);
}

/// See also [ShippingStepAddressPickerController].
@ProviderFor(ShippingStepAddressPickerController)
const shippingStepAddressPickerControllerProvider =
    ShippingStepAddressPickerControllerFamily();

/// See also [ShippingStepAddressPickerController].
class ShippingStepAddressPickerControllerFamily
    extends Family<AsyncValue<AddressPickerViewModel>> {
  /// See also [ShippingStepAddressPickerController].
  const ShippingStepAddressPickerControllerFamily();

  /// See also [ShippingStepAddressPickerController].
  ShippingStepAddressPickerControllerProvider call(
    CheckOutRouteData routeData,
  ) {
    return ShippingStepAddressPickerControllerProvider(routeData);
  }

  @override
  ShippingStepAddressPickerControllerProvider getProviderOverride(
    covariant ShippingStepAddressPickerControllerProvider provider,
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
  String? get name => r'shippingStepAddressPickerControllerProvider';
}

/// See also [ShippingStepAddressPickerController].
class ShippingStepAddressPickerControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ShippingStepAddressPickerController,
          AddressPickerViewModel
        > {
  /// See also [ShippingStepAddressPickerController].
  ShippingStepAddressPickerControllerProvider(CheckOutRouteData routeData)
    : this._internal(
        () => ShippingStepAddressPickerController()..routeData = routeData,
        from: shippingStepAddressPickerControllerProvider,
        name: r'shippingStepAddressPickerControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$shippingStepAddressPickerControllerHash,
        dependencies: ShippingStepAddressPickerControllerFamily._dependencies,
        allTransitiveDependencies:
            ShippingStepAddressPickerControllerFamily
                ._allTransitiveDependencies,
        routeData: routeData,
      );

  ShippingStepAddressPickerControllerProvider._internal(
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
  FutureOr<AddressPickerViewModel> runNotifierBuild(
    covariant ShippingStepAddressPickerController notifier,
  ) {
    return notifier.build(routeData);
  }

  @override
  Override overrideWith(ShippingStepAddressPickerController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ShippingStepAddressPickerControllerProvider._internal(
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
    ShippingStepAddressPickerController,
    AddressPickerViewModel
  >
  createElement() {
    return _ShippingStepAddressPickerControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShippingStepAddressPickerControllerProvider &&
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
mixin ShippingStepAddressPickerControllerRef
    on AutoDisposeAsyncNotifierProviderRef<AddressPickerViewModel> {
  /// The parameter `routeData` of this provider.
  CheckOutRouteData get routeData;
}

class _ShippingStepAddressPickerControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ShippingStepAddressPickerController,
          AddressPickerViewModel
        >
    with ShippingStepAddressPickerControllerRef {
  _ShippingStepAddressPickerControllerProviderElement(super.provider);

  @override
  CheckOutRouteData get routeData =>
      (origin as ShippingStepAddressPickerControllerProvider).routeData;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
