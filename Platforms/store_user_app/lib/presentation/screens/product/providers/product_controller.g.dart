// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productControllerHash() => r'1df821ecf6d4af81c3f97f11f4cb53c5e891c75e';

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

abstract class _$ProductController
    extends BuildlessAutoDisposeAsyncNotifier<ProductDetailViewModel> {
  late final String productId;

  FutureOr<ProductDetailViewModel> build(String productId);
}

/// See also [ProductController].
@ProviderFor(ProductController)
const productControllerProvider = ProductControllerFamily();

/// See also [ProductController].
class ProductControllerFamily
    extends Family<AsyncValue<ProductDetailViewModel>> {
  /// See also [ProductController].
  const ProductControllerFamily();

  /// See also [ProductController].
  ProductControllerProvider call(String productId) {
    return ProductControllerProvider(productId);
  }

  @override
  ProductControllerProvider getProviderOverride(
    covariant ProductControllerProvider provider,
  ) {
    return call(provider.productId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productControllerProvider';
}

/// See also [ProductController].
class ProductControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProductController,
          ProductDetailViewModel
        > {
  /// See also [ProductController].
  ProductControllerProvider(String productId)
    : this._internal(
        () => ProductController()..productId = productId,
        from: productControllerProvider,
        name: r'productControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productControllerHash,
        dependencies: ProductControllerFamily._dependencies,
        allTransitiveDependencies:
            ProductControllerFamily._allTransitiveDependencies,
        productId: productId,
      );

  ProductControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.productId,
  }) : super.internal();

  final String productId;

  @override
  FutureOr<ProductDetailViewModel> runNotifierBuild(
    covariant ProductController notifier,
  ) {
    return notifier.build(productId);
  }

  @override
  Override overrideWith(ProductController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductControllerProvider._internal(
        () => create()..productId = productId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        productId: productId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProductController,
    ProductDetailViewModel
  >
  createElement() {
    return _ProductControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductControllerProvider && other.productId == productId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, productId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProductDetailViewModel> {
  /// The parameter `productId` of this provider.
  String get productId;
}

class _ProductControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProductController,
          ProductDetailViewModel
        >
    with ProductControllerRef {
  _ProductControllerProviderElement(super.provider);

  @override
  String get productId => (origin as ProductControllerProvider).productId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
