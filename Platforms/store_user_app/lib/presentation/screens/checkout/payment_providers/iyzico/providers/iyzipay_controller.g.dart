// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iyzipay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$iyzipayControllerHash() => r'32f40e7b9d159e052dcdd8cff9f36597aba13ed3';

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

abstract class _$IyzipayController
    extends BuildlessAutoDisposeAsyncNotifier<IyzipayStateModel> {
  late final PaymentInfoStepModel paymentInfoModel;

  FutureOr<IyzipayStateModel> build(PaymentInfoStepModel paymentInfoModel);
}

/// See also [IyzipayController].
@ProviderFor(IyzipayController)
const iyzipayControllerProvider = IyzipayControllerFamily();

/// See also [IyzipayController].
class IyzipayControllerFamily extends Family<AsyncValue<IyzipayStateModel>> {
  /// See also [IyzipayController].
  const IyzipayControllerFamily();

  /// See also [IyzipayController].
  IyzipayControllerProvider call(PaymentInfoStepModel paymentInfoModel) {
    return IyzipayControllerProvider(paymentInfoModel);
  }

  @override
  IyzipayControllerProvider getProviderOverride(
    covariant IyzipayControllerProvider provider,
  ) {
    return call(provider.paymentInfoModel);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'iyzipayControllerProvider';
}

/// See also [IyzipayController].
class IyzipayControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          IyzipayController,
          IyzipayStateModel
        > {
  /// See also [IyzipayController].
  IyzipayControllerProvider(PaymentInfoStepModel paymentInfoModel)
    : this._internal(
        () => IyzipayController()..paymentInfoModel = paymentInfoModel,
        from: iyzipayControllerProvider,
        name: r'iyzipayControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$iyzipayControllerHash,
        dependencies: IyzipayControllerFamily._dependencies,
        allTransitiveDependencies:
            IyzipayControllerFamily._allTransitiveDependencies,
        paymentInfoModel: paymentInfoModel,
      );

  IyzipayControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.paymentInfoModel,
  }) : super.internal();

  final PaymentInfoStepModel paymentInfoModel;

  @override
  FutureOr<IyzipayStateModel> runNotifierBuild(
    covariant IyzipayController notifier,
  ) {
    return notifier.build(paymentInfoModel);
  }

  @override
  Override overrideWith(IyzipayController Function() create) {
    return ProviderOverride(
      origin: this,
      override: IyzipayControllerProvider._internal(
        () => create()..paymentInfoModel = paymentInfoModel,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        paymentInfoModel: paymentInfoModel,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<IyzipayController, IyzipayStateModel>
  createElement() {
    return _IyzipayControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IyzipayControllerProvider &&
        other.paymentInfoModel == paymentInfoModel;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, paymentInfoModel.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IyzipayControllerRef
    on AutoDisposeAsyncNotifierProviderRef<IyzipayStateModel> {
  /// The parameter `paymentInfoModel` of this provider.
  PaymentInfoStepModel get paymentInfoModel;
}

class _IyzipayControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          IyzipayController,
          IyzipayStateModel
        >
    with IyzipayControllerRef {
  _IyzipayControllerProviderElement(super.provider);

  @override
  PaymentInfoStepModel get paymentInfoModel =>
      (origin as IyzipayControllerProvider).paymentInfoModel;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
