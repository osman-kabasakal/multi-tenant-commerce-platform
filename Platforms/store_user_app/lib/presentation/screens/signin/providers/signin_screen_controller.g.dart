// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signin_screen_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signinScreenControllerHash() =>
    r'6ee467b8755590f02558f324e3c08508c3f37326';

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

abstract class _$SigninScreenController
    extends BuildlessAutoDisposeAsyncNotifier<SigninViewModel> {
  late final String? returnUrl;

  FutureOr<SigninViewModel> build(String? returnUrl);
}

/// See also [SigninScreenController].
@ProviderFor(SigninScreenController)
const signinScreenControllerProvider = SigninScreenControllerFamily();

/// See also [SigninScreenController].
class SigninScreenControllerFamily extends Family<AsyncValue<SigninViewModel>> {
  /// See also [SigninScreenController].
  const SigninScreenControllerFamily();

  /// See also [SigninScreenController].
  SigninScreenControllerProvider call(String? returnUrl) {
    return SigninScreenControllerProvider(returnUrl);
  }

  @override
  SigninScreenControllerProvider getProviderOverride(
    covariant SigninScreenControllerProvider provider,
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
  String? get name => r'signinScreenControllerProvider';
}

/// See also [SigninScreenController].
class SigninScreenControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SigninScreenController,
          SigninViewModel
        > {
  /// See also [SigninScreenController].
  SigninScreenControllerProvider(String? returnUrl)
    : this._internal(
        () => SigninScreenController()..returnUrl = returnUrl,
        from: signinScreenControllerProvider,
        name: r'signinScreenControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$signinScreenControllerHash,
        dependencies: SigninScreenControllerFamily._dependencies,
        allTransitiveDependencies:
            SigninScreenControllerFamily._allTransitiveDependencies,
        returnUrl: returnUrl,
      );

  SigninScreenControllerProvider._internal(
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
  FutureOr<SigninViewModel> runNotifierBuild(
    covariant SigninScreenController notifier,
  ) {
    return notifier.build(returnUrl);
  }

  @override
  Override overrideWith(SigninScreenController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SigninScreenControllerProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<
    SigninScreenController,
    SigninViewModel
  >
  createElement() {
    return _SigninScreenControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SigninScreenControllerProvider &&
        other.returnUrl == returnUrl;
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
mixin SigninScreenControllerRef
    on AutoDisposeAsyncNotifierProviderRef<SigninViewModel> {
  /// The parameter `returnUrl` of this provider.
  String? get returnUrl;
}

class _SigninScreenControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SigninScreenController,
          SigninViewModel
        >
    with SigninScreenControllerRef {
  _SigninScreenControllerProviderElement(super.provider);

  @override
  String? get returnUrl => (origin as SigninScreenControllerProvider).returnUrl;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
