// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signupControllerHash() => r'cea48500a9cf0ae415581f81d6d7ddefe88a6b17';

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

abstract class _$SignupController
    extends BuildlessAutoDisposeAsyncNotifier<SignupViewModel> {
  late final String? returnUrl;

  FutureOr<SignupViewModel> build(String? returnUrl);
}

/// See also [SignupController].
@ProviderFor(SignupController)
const signupControllerProvider = SignupControllerFamily();

/// See also [SignupController].
class SignupControllerFamily extends Family<AsyncValue<SignupViewModel>> {
  /// See also [SignupController].
  const SignupControllerFamily();

  /// See also [SignupController].
  SignupControllerProvider call(String? returnUrl) {
    return SignupControllerProvider(returnUrl);
  }

  @override
  SignupControllerProvider getProviderOverride(
    covariant SignupControllerProvider provider,
  ) {
    return call(provider.returnUrl);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'signupControllerProvider';
}

/// See also [SignupController].
class SignupControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SignupController,
          SignupViewModel
        > {
  /// See also [SignupController].
  SignupControllerProvider(String? returnUrl)
    : this._internal(
        () => SignupController()..returnUrl = returnUrl,
        from: signupControllerProvider,
        name: r'signupControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$signupControllerHash,
        dependencies: SignupControllerFamily._dependencies,
        allTransitiveDependencies:
            SignupControllerFamily._allTransitiveDependencies,
        returnUrl: returnUrl,
      );

  SignupControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.returnUrl,
  }) : super.internal();

  final String? returnUrl;

  @override
  FutureOr<SignupViewModel> runNotifierBuild(
    covariant SignupController notifier,
  ) {
    return notifier.build(returnUrl);
  }

  @override
  Override overrideWith(SignupController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SignupControllerProvider._internal(
        () => create()..returnUrl = returnUrl,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        returnUrl: returnUrl,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SignupController, SignupViewModel>
  createElement() {
    return _SignupControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SignupControllerProvider && other.returnUrl == returnUrl;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, returnUrl.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SignupControllerRef
    on AutoDisposeAsyncNotifierProviderRef<SignupViewModel> {
  /// The parameter `returnUrl` of this provider.
  String? get returnUrl;
}

class _SignupControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SignupController,
          SignupViewModel
        >
    with SignupControllerRef {
  _SignupControllerProviderElement(super.provider);

  @override
  String? get returnUrl => (origin as SignupControllerProvider).returnUrl;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
