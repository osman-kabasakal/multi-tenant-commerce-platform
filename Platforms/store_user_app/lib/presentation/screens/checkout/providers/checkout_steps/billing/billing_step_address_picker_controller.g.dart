// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_step_address_picker_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$billingStepAddressPickerControllerHash() =>
    r'631c760d385eed69a5b69e3607c08c6ff23f6931';

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

abstract class _$BillingStepAddressPickerController
    extends BuildlessAutoDisposeAsyncNotifier<AddressPickerViewModel> {
  late final CheckOutRouteData routeData;

  FutureOr<AddressPickerViewModel> build(CheckOutRouteData routeData);
}

/// See also [BillingStepAddressPickerController].
@ProviderFor(BillingStepAddressPickerController)
const billingStepAddressPickerControllerProvider =
    BillingStepAddressPickerControllerFamily();

/// See also [BillingStepAddressPickerController].
class BillingStepAddressPickerControllerFamily
    extends Family<AsyncValue<AddressPickerViewModel>> {
  /// See also [BillingStepAddressPickerController].
  const BillingStepAddressPickerControllerFamily();

  /// See also [BillingStepAddressPickerController].
  BillingStepAddressPickerControllerProvider call(CheckOutRouteData routeData) {
    return BillingStepAddressPickerControllerProvider(routeData);
  }

  @override
  BillingStepAddressPickerControllerProvider getProviderOverride(
    covariant BillingStepAddressPickerControllerProvider provider,
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
  String? get name => r'billingStepAddressPickerControllerProvider';
}

/// See also [BillingStepAddressPickerController].
class BillingStepAddressPickerControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BillingStepAddressPickerController,
          AddressPickerViewModel
        > {
  /// See also [BillingStepAddressPickerController].
  BillingStepAddressPickerControllerProvider(CheckOutRouteData routeData)
    : this._internal(
        () => BillingStepAddressPickerController()..routeData = routeData,
        from: billingStepAddressPickerControllerProvider,
        name: r'billingStepAddressPickerControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$billingStepAddressPickerControllerHash,
        dependencies: BillingStepAddressPickerControllerFamily._dependencies,
        allTransitiveDependencies:
            BillingStepAddressPickerControllerFamily._allTransitiveDependencies,
        routeData: routeData,
      );

  BillingStepAddressPickerControllerProvider._internal(
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
    covariant BillingStepAddressPickerController notifier,
  ) {
    return notifier.build(routeData);
  }

  @override
  Override overrideWith(BillingStepAddressPickerController Function() create) {
    return ProviderOverride(
      origin: this,
      override: BillingStepAddressPickerControllerProvider._internal(
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
    BillingStepAddressPickerController,
    AddressPickerViewModel
  >
  createElement() {
    return _BillingStepAddressPickerControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BillingStepAddressPickerControllerProvider &&
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
mixin BillingStepAddressPickerControllerRef
    on AutoDisposeAsyncNotifierProviderRef<AddressPickerViewModel> {
  /// The parameter `routeData` of this provider.
  CheckOutRouteData get routeData;
}

class _BillingStepAddressPickerControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BillingStepAddressPickerController,
          AddressPickerViewModel
        >
    with BillingStepAddressPickerControllerRef {
  _BillingStepAddressPickerControllerProviderElement(super.provider);

  @override
  CheckOutRouteData get routeData =>
      (origin as BillingStepAddressPickerControllerProvider).routeData;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
