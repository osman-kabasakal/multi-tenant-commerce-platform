// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchandise_return_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$merchandiseReturnDetailsControllerHash() =>
    r'7e75cd41b80e3794f4a00c9f63549c87ce47f9aa';

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

abstract class _$MerchandiseReturnDetailsController
    extends BuildlessAutoDisposeAsyncNotifier<MerchandiseReturnDetailsModel> {
  late final String merchandiseReturnId;

  FutureOr<MerchandiseReturnDetailsModel> build(String merchandiseReturnId);
}

/// See also [MerchandiseReturnDetailsController].
@ProviderFor(MerchandiseReturnDetailsController)
const merchandiseReturnDetailsControllerProvider =
    MerchandiseReturnDetailsControllerFamily();

/// See also [MerchandiseReturnDetailsController].
class MerchandiseReturnDetailsControllerFamily
    extends Family<AsyncValue<MerchandiseReturnDetailsModel>> {
  /// See also [MerchandiseReturnDetailsController].
  const MerchandiseReturnDetailsControllerFamily();

  /// See also [MerchandiseReturnDetailsController].
  MerchandiseReturnDetailsControllerProvider call(String merchandiseReturnId) {
    return MerchandiseReturnDetailsControllerProvider(merchandiseReturnId);
  }

  @override
  MerchandiseReturnDetailsControllerProvider getProviderOverride(
    covariant MerchandiseReturnDetailsControllerProvider provider,
  ) {
    return call(provider.merchandiseReturnId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'merchandiseReturnDetailsControllerProvider';
}

/// See also [MerchandiseReturnDetailsController].
class MerchandiseReturnDetailsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          MerchandiseReturnDetailsController,
          MerchandiseReturnDetailsModel
        > {
  /// See also [MerchandiseReturnDetailsController].
  MerchandiseReturnDetailsControllerProvider(String merchandiseReturnId)
    : this._internal(
        () =>
            MerchandiseReturnDetailsController()
              ..merchandiseReturnId = merchandiseReturnId,
        from: merchandiseReturnDetailsControllerProvider,
        name: r'merchandiseReturnDetailsControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$merchandiseReturnDetailsControllerHash,
        dependencies: MerchandiseReturnDetailsControllerFamily._dependencies,
        allTransitiveDependencies:
            MerchandiseReturnDetailsControllerFamily._allTransitiveDependencies,
        merchandiseReturnId: merchandiseReturnId,
      );

  MerchandiseReturnDetailsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.merchandiseReturnId,
  }) : super.internal();

  final String merchandiseReturnId;

  @override
  FutureOr<MerchandiseReturnDetailsModel> runNotifierBuild(
    covariant MerchandiseReturnDetailsController notifier,
  ) {
    return notifier.build(merchandiseReturnId);
  }

  @override
  Override overrideWith(MerchandiseReturnDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MerchandiseReturnDetailsControllerProvider._internal(
        () => create()..merchandiseReturnId = merchandiseReturnId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        merchandiseReturnId: merchandiseReturnId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    MerchandiseReturnDetailsController,
    MerchandiseReturnDetailsModel
  >
  createElement() {
    return _MerchandiseReturnDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MerchandiseReturnDetailsControllerProvider &&
        other.merchandiseReturnId == merchandiseReturnId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, merchandiseReturnId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MerchandiseReturnDetailsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<MerchandiseReturnDetailsModel> {
  /// The parameter `merchandiseReturnId` of this provider.
  String get merchandiseReturnId;
}

class _MerchandiseReturnDetailsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          MerchandiseReturnDetailsController,
          MerchandiseReturnDetailsModel
        >
    with MerchandiseReturnDetailsControllerRef {
  _MerchandiseReturnDetailsControllerProviderElement(super.provider);

  @override
  String get merchandiseReturnId =>
      (origin as MerchandiseReturnDetailsControllerProvider)
          .merchandiseReturnId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
