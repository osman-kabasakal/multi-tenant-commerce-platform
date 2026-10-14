// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$merchandiseReturnControllerHash() =>
    r'ea0687792e55412506b2275013f364d4e8b4dd24';

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

abstract class _$MerchandiseReturnController
    extends BuildlessAutoDisposeAsyncNotifier<MerchandiseReturnViewModel> {
  late final String orderId;

  FutureOr<MerchandiseReturnViewModel> build(String orderId);
}

/// See also [MerchandiseReturnController].
@ProviderFor(MerchandiseReturnController)
const merchandiseReturnControllerProvider = MerchandiseReturnControllerFamily();

/// See also [MerchandiseReturnController].
class MerchandiseReturnControllerFamily
    extends Family<AsyncValue<MerchandiseReturnViewModel>> {
  /// See also [MerchandiseReturnController].
  const MerchandiseReturnControllerFamily();

  /// See also [MerchandiseReturnController].
  MerchandiseReturnControllerProvider call(String orderId) {
    return MerchandiseReturnControllerProvider(orderId);
  }

  @override
  MerchandiseReturnControllerProvider getProviderOverride(
    covariant MerchandiseReturnControllerProvider provider,
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
  String? get name => r'merchandiseReturnControllerProvider';
}

/// See also [MerchandiseReturnController].
class MerchandiseReturnControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MerchandiseReturnController,
          MerchandiseReturnViewModel
        > {
  /// See also [MerchandiseReturnController].
  MerchandiseReturnControllerProvider(String orderId)
    : this._internal(
        () => MerchandiseReturnController()..orderId = orderId,
        from: merchandiseReturnControllerProvider,
        name: r'merchandiseReturnControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$merchandiseReturnControllerHash,
        dependencies: MerchandiseReturnControllerFamily._dependencies,
        allTransitiveDependencies:
            MerchandiseReturnControllerFamily._allTransitiveDependencies,
        orderId: orderId,
      );

  MerchandiseReturnControllerProvider._internal(
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
  FutureOr<MerchandiseReturnViewModel> runNotifierBuild(
    covariant MerchandiseReturnController notifier,
  ) {
    return notifier.build(orderId);
  }

  @override
  Override overrideWith(MerchandiseReturnController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MerchandiseReturnControllerProvider._internal(
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
    MerchandiseReturnController,
    MerchandiseReturnViewModel
  >
  createElement() {
    return _MerchandiseReturnControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MerchandiseReturnControllerProvider &&
        other.orderId == orderId;
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
mixin MerchandiseReturnControllerRef
    on AutoDisposeAsyncNotifierProviderRef<MerchandiseReturnViewModel> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _MerchandiseReturnControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MerchandiseReturnController,
          MerchandiseReturnViewModel
        >
    with MerchandiseReturnControllerRef {
  _MerchandiseReturnControllerProviderElement(super.provider);

  @override
  String get orderId => (origin as MerchandiseReturnControllerProvider).orderId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
