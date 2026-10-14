// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_activation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountActivationControllerHash() =>
    r'7beaf1c13580edae20a560df682b16d9a0c30fc8';

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

abstract class _$AccountActivationController
    extends BuildlessAutoDisposeAsyncNotifier<AccountActivationViewModel> {
  late final String? token;
  late final String? email;

  FutureOr<AccountActivationViewModel> build(String? token, String? email);
}

/// See also [AccountActivationController].
@ProviderFor(AccountActivationController)
const accountActivationControllerProvider = AccountActivationControllerFamily();

/// See also [AccountActivationController].
class AccountActivationControllerFamily
    extends Family<AsyncValue<AccountActivationViewModel>> {
  /// See also [AccountActivationController].
  const AccountActivationControllerFamily();

  /// See also [AccountActivationController].
  AccountActivationControllerProvider call(String? token, String? email) {
    return AccountActivationControllerProvider(token, email);
  }

  @override
  AccountActivationControllerProvider getProviderOverride(
    covariant AccountActivationControllerProvider provider,
  ) {
    return call(provider.token, provider.email);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountActivationControllerProvider';
}

/// See also [AccountActivationController].
class AccountActivationControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AccountActivationController,
          AccountActivationViewModel
        > {
  /// See also [AccountActivationController].
  AccountActivationControllerProvider(String? token, String? email)
    : this._internal(
        () =>
            AccountActivationController()
              ..token = token
              ..email = email,
        from: accountActivationControllerProvider,
        name: r'accountActivationControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$accountActivationControllerHash,
        dependencies: AccountActivationControllerFamily._dependencies,
        allTransitiveDependencies:
            AccountActivationControllerFamily._allTransitiveDependencies,
        token: token,
        email: email,
      );

  AccountActivationControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.token,
    required this.email,
  }) : super.internal();

  final String? token;
  final String? email;

  @override
  FutureOr<AccountActivationViewModel> runNotifierBuild(
    covariant AccountActivationController notifier,
  ) {
    return notifier.build(token, email);
  }

  @override
  Override overrideWith(AccountActivationController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AccountActivationControllerProvider._internal(
        () =>
            create()
              ..token = token
              ..email = email,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        token: token,
        email: email,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    AccountActivationController,
    AccountActivationViewModel
  >
  createElement() {
    return _AccountActivationControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountActivationControllerProvider &&
        other.token == token &&
        other.email == email;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, token.hashCode);
    hash = _SystemHash.combine(hash, email.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AccountActivationControllerRef
    on AutoDisposeAsyncNotifierProviderRef<AccountActivationViewModel> {
  /// The parameter `token` of this provider.
  String? get token;

  /// The parameter `email` of this provider.
  String? get email;
}

class _AccountActivationControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AccountActivationController,
          AccountActivationViewModel
        >
    with AccountActivationControllerRef {
  _AccountActivationControllerProviderElement(super.provider);

  @override
  String? get token => (origin as AccountActivationControllerProvider).token;
  @override
  String? get email => (origin as AccountActivationControllerProvider).email;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
