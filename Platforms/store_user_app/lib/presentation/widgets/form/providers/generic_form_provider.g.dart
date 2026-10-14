// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_form_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genericFormProviderHash() =>
    r'b6e4409268d79d6caea83767b5aae6cb17d2c504';

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

abstract class _$GenericFormProvider
    extends BuildlessAutoDisposeNotifier<FormProviderState> {
  late final AppFormController<dynamic> controller;

  FormProviderState build(AppFormController<dynamic> controller);
}

/// See also [GenericFormProvider].
@ProviderFor(GenericFormProvider)
const genericFormProviderProvider = GenericFormProviderFamily();

/// See also [GenericFormProvider].
class GenericFormProviderFamily extends Family<FormProviderState> {
  /// See also [GenericFormProvider].
  const GenericFormProviderFamily();

  /// See also [GenericFormProvider].
  GenericFormProviderProvider call(AppFormController<dynamic> controller) {
    return GenericFormProviderProvider(controller);
  }

  @override
  GenericFormProviderProvider getProviderOverride(
    covariant GenericFormProviderProvider provider,
  ) {
    return call(provider.controller);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'genericFormProviderProvider';
}

/// See also [GenericFormProvider].
class GenericFormProviderProvider
    extends
        AutoDisposeNotifierProviderImpl<
          GenericFormProvider,
          FormProviderState
        > {
  /// See also [GenericFormProvider].
  GenericFormProviderProvider(AppFormController<dynamic> controller)
    : this._internal(
        () => GenericFormProvider()..controller = controller,
        from: genericFormProviderProvider,
        name: r'genericFormProviderProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$genericFormProviderHash,
        dependencies: GenericFormProviderFamily._dependencies,
        allTransitiveDependencies:
            GenericFormProviderFamily._allTransitiveDependencies,
        controller: controller,
      );

  GenericFormProviderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.controller,
  }) : super.internal();

  final AppFormController<dynamic> controller;

  @override
  FormProviderState runNotifierBuild(covariant GenericFormProvider notifier) {
    return notifier.build(controller);
  }

  @override
  Override overrideWith(GenericFormProvider Function() create) {
    return ProviderOverride(
      origin: this,
      override: GenericFormProviderProvider._internal(
        () => create()..controller = controller,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        controller: controller,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<GenericFormProvider, FormProviderState>
  createElement() {
    return _GenericFormProviderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GenericFormProviderProvider &&
        other.controller == controller;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, controller.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GenericFormProviderRef
    on AutoDisposeNotifierProviderRef<FormProviderState> {
  /// The parameter `controller` of this provider.
  AppFormController<dynamic> get controller;
}

class _GenericFormProviderProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          GenericFormProvider,
          FormProviderState
        >
    with GenericFormProviderRef {
  _GenericFormProviderProviderElement(super.provider);

  @override
  AppFormController<dynamic> get controller =>
      (origin as GenericFormProviderProvider).controller;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
