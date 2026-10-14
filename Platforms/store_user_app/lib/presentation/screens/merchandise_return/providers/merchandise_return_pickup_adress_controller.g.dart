// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_pickup_adress_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$merchandiseReturnPickupAdressControllerHash() =>
    r'd8f41a89dd9c3842b084b26a552d15acd00a14b6';

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

abstract class _$MerchandiseReturnPickupAdressController
    extends BuildlessAutoDisposeAsyncNotifier<AddressPickerViewModel> {
  late final MerchandiseReturnModel initialModel;

  FutureOr<AddressPickerViewModel> build(MerchandiseReturnModel initialModel);
}

/// See also [MerchandiseReturnPickupAdressController].
@ProviderFor(MerchandiseReturnPickupAdressController)
const merchandiseReturnPickupAdressControllerProvider =
    MerchandiseReturnPickupAdressControllerFamily();

/// See also [MerchandiseReturnPickupAdressController].
class MerchandiseReturnPickupAdressControllerFamily
    extends Family<AsyncValue<AddressPickerViewModel>> {
  /// See also [MerchandiseReturnPickupAdressController].
  const MerchandiseReturnPickupAdressControllerFamily();

  /// See also [MerchandiseReturnPickupAdressController].
  MerchandiseReturnPickupAdressControllerProvider call(
    MerchandiseReturnModel initialModel,
  ) {
    return MerchandiseReturnPickupAdressControllerProvider(initialModel);
  }

  @override
  MerchandiseReturnPickupAdressControllerProvider getProviderOverride(
    covariant MerchandiseReturnPickupAdressControllerProvider provider,
  ) {
    return call(provider.initialModel);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'merchandiseReturnPickupAdressControllerProvider';
}

/// See also [MerchandiseReturnPickupAdressController].
class MerchandiseReturnPickupAdressControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MerchandiseReturnPickupAdressController,
          AddressPickerViewModel
        > {
  /// See also [MerchandiseReturnPickupAdressController].
  MerchandiseReturnPickupAdressControllerProvider(
    MerchandiseReturnModel initialModel,
  ) : this._internal(
        () =>
            MerchandiseReturnPickupAdressController()
              ..initialModel = initialModel,
        from: merchandiseReturnPickupAdressControllerProvider,
        name: r'merchandiseReturnPickupAdressControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$merchandiseReturnPickupAdressControllerHash,
        dependencies:
            MerchandiseReturnPickupAdressControllerFamily._dependencies,
        allTransitiveDependencies:
            MerchandiseReturnPickupAdressControllerFamily
                ._allTransitiveDependencies,
        initialModel: initialModel,
      );

  MerchandiseReturnPickupAdressControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialModel,
  }) : super.internal();

  final MerchandiseReturnModel initialModel;

  @override
  FutureOr<AddressPickerViewModel> runNotifierBuild(
    covariant MerchandiseReturnPickupAdressController notifier,
  ) {
    return notifier.build(initialModel);
  }

  @override
  Override overrideWith(
    MerchandiseReturnPickupAdressController Function() create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MerchandiseReturnPickupAdressControllerProvider._internal(
        () => create()..initialModel = initialModel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialModel: initialModel,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    MerchandiseReturnPickupAdressController,
    AddressPickerViewModel
  >
  createElement() {
    return _MerchandiseReturnPickupAdressControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MerchandiseReturnPickupAdressControllerProvider &&
        other.initialModel == initialModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MerchandiseReturnPickupAdressControllerRef
    on AutoDisposeAsyncNotifierProviderRef<AddressPickerViewModel> {
  /// The parameter `initialModel` of this provider.
  MerchandiseReturnModel get initialModel;
}

class _MerchandiseReturnPickupAdressControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MerchandiseReturnPickupAdressController,
          AddressPickerViewModel
        >
    with MerchandiseReturnPickupAdressControllerRef {
  _MerchandiseReturnPickupAdressControllerProviderElement(super.provider);

  @override
  MerchandiseReturnModel get initialModel =>
      (origin as MerchandiseReturnPickupAdressControllerProvider).initialModel;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
