// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_height_webview_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$autoHeightWebviewControllerHash() =>
    r'b23545ad12fb1ccae8daaba668afe92641a92b7c';

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

abstract class _$AutoHeightWebviewController
    extends BuildlessAutoDisposeNotifier<AutoHeightWebviewModel> {
  late final String html;

  AutoHeightWebviewModel build(String html);
}

/// See also [AutoHeightWebviewController].
@ProviderFor(AutoHeightWebviewController)
const autoHeightWebviewControllerProvider = AutoHeightWebviewControllerFamily();

/// See also [AutoHeightWebviewController].
class AutoHeightWebviewControllerFamily extends Family<AutoHeightWebviewModel> {
  /// See also [AutoHeightWebviewController].
  const AutoHeightWebviewControllerFamily();

  /// See also [AutoHeightWebviewController].
  AutoHeightWebviewControllerProvider call(String html) {
    return AutoHeightWebviewControllerProvider(html);
  }

  @override
  AutoHeightWebviewControllerProvider getProviderOverride(
    covariant AutoHeightWebviewControllerProvider provider,
  ) {
    return call(provider.html);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'autoHeightWebviewControllerProvider';
}

/// See also [AutoHeightWebviewController].
class AutoHeightWebviewControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          AutoHeightWebviewController,
          AutoHeightWebviewModel
        > {
  /// See also [AutoHeightWebviewController].
  AutoHeightWebviewControllerProvider(String html)
    : this._internal(
        () => AutoHeightWebviewController()..html = html,
        from: autoHeightWebviewControllerProvider,
        name: r'autoHeightWebviewControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$autoHeightWebviewControllerHash,
        dependencies: AutoHeightWebviewControllerFamily._dependencies,
        allTransitiveDependencies:
            AutoHeightWebviewControllerFamily._allTransitiveDependencies,
        html: html,
      );

  AutoHeightWebviewControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.html,
  }) : super.internal();

  final String html;

  @override
  AutoHeightWebviewModel runNotifierBuild(
    covariant AutoHeightWebviewController notifier,
  ) {
    return notifier.build(html);
  }

  @override
  Override overrideWith(AutoHeightWebviewController Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoHeightWebviewControllerProvider._internal(
        () => create()..html = html,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        html: html,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    AutoHeightWebviewController,
    AutoHeightWebviewModel
  >
  createElement() {
    return _AutoHeightWebviewControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AutoHeightWebviewControllerProvider && other.html == html;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, html.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AutoHeightWebviewControllerRef
    on AutoDisposeNotifierProviderRef<AutoHeightWebviewModel> {
  /// The parameter `html` of this provider.
  String get html;
}

class _AutoHeightWebviewControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          AutoHeightWebviewController,
          AutoHeightWebviewModel
        >
    with AutoHeightWebviewControllerRef {
  _AutoHeightWebviewControllerProviderElement(super.provider);

  @override
  String get html => (origin as AutoHeightWebviewControllerProvider).html;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
