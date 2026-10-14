// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productCatalogControllerHash() =>
    r'547ecac2d3cbf7752bf3824866d9ce2c399a3c62';

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

abstract class _$ProductCatalogController
    extends BuildlessAutoDisposeAsyncNotifier<CatalogState> {
  late final String? categoryId;
  late final String? vendorId;
  late final String? searchTerm;
  late final String? brandId;
  late final String? collectionId;
  late final bool priceFilterEnable;
  late final bool attributeFilterEnabled;

  FutureOr<CatalogState> build({
    String? categoryId,
    String? vendorId,
    String? searchTerm,
    String? brandId,
    String? collectionId,
    bool priceFilterEnable = true,
    bool attributeFilterEnabled = true,
  });
}

/// See also [ProductCatalogController].
@ProviderFor(ProductCatalogController)
const productCatalogControllerProvider = ProductCatalogControllerFamily();

/// See also [ProductCatalogController].
class ProductCatalogControllerFamily extends Family<AsyncValue<CatalogState>> {
  /// See also [ProductCatalogController].
  const ProductCatalogControllerFamily();

  /// See also [ProductCatalogController].
  ProductCatalogControllerProvider call({
    String? categoryId,
    String? vendorId,
    String? searchTerm,
    String? brandId,
    String? collectionId,
    bool priceFilterEnable = true,
    bool attributeFilterEnabled = true,
  }) {
    return ProductCatalogControllerProvider(
      categoryId: categoryId,
      vendorId: vendorId,
      searchTerm: searchTerm,
      brandId: brandId,
      collectionId: collectionId,
      priceFilterEnable: priceFilterEnable,
      attributeFilterEnabled: attributeFilterEnabled,
    );
  }

  @override
  ProductCatalogControllerProvider getProviderOverride(
    covariant ProductCatalogControllerProvider provider,
  ) {
    return call(
      categoryId: provider.categoryId,
      vendorId: provider.vendorId,
      searchTerm: provider.searchTerm,
      brandId: provider.brandId,
      collectionId: provider.collectionId,
      priceFilterEnable: provider.priceFilterEnable,
      attributeFilterEnabled: provider.attributeFilterEnabled,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productCatalogControllerProvider';
}

/// See also [ProductCatalogController].
class ProductCatalogControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProductCatalogController,
          CatalogState
        > {
  /// See also [ProductCatalogController].
  ProductCatalogControllerProvider({
    String? categoryId,
    String? vendorId,
    String? searchTerm,
    String? brandId,
    String? collectionId,
    bool priceFilterEnable = true,
    bool attributeFilterEnabled = true,
  }) : this._internal(
         () =>
             ProductCatalogController()
               ..categoryId = categoryId
               ..vendorId = vendorId
               ..searchTerm = searchTerm
               ..brandId = brandId
               ..collectionId = collectionId
               ..priceFilterEnable = priceFilterEnable
               ..attributeFilterEnabled = attributeFilterEnabled,
         from: productCatalogControllerProvider,
         name: r'productCatalogControllerProvider',
         debugGetCreateSourceHash:
             const bool.fromEnvironment('dart.vm.product')
                 ? null
                 : _$productCatalogControllerHash,
         dependencies: ProductCatalogControllerFamily._dependencies,
         allTransitiveDependencies:
             ProductCatalogControllerFamily._allTransitiveDependencies,
         categoryId: categoryId,
         vendorId: vendorId,
         searchTerm: searchTerm,
         brandId: brandId,
         collectionId: collectionId,
         priceFilterEnable: priceFilterEnable,
         attributeFilterEnabled: attributeFilterEnabled,
       );

  ProductCatalogControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoryId,
    required this.vendorId,
    required this.searchTerm,
    required this.brandId,
    required this.collectionId,
    required this.priceFilterEnable,
    required this.attributeFilterEnabled,
  }) : super.internal();

  final String? categoryId;
  final String? vendorId;
  final String? searchTerm;
  final String? brandId;
  final String? collectionId;
  final bool priceFilterEnable;
  final bool attributeFilterEnabled;

  @override
  FutureOr<CatalogState> runNotifierBuild(
    covariant ProductCatalogController notifier,
  ) {
    return notifier.build(
      categoryId: categoryId,
      vendorId: vendorId,
      searchTerm: searchTerm,
      brandId: brandId,
      collectionId: collectionId,
      priceFilterEnable: priceFilterEnable,
      attributeFilterEnabled: attributeFilterEnabled,
    );
  }

  @override
  Override overrideWith(ProductCatalogController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductCatalogControllerProvider._internal(
        () =>
            create()
              ..categoryId = categoryId
              ..vendorId = vendorId
              ..searchTerm = searchTerm
              ..brandId = brandId
              ..collectionId = collectionId
              ..priceFilterEnable = priceFilterEnable
              ..attributeFilterEnabled = attributeFilterEnabled,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoryId: categoryId,
        vendorId: vendorId,
        searchTerm: searchTerm,
        brandId: brandId,
        collectionId: collectionId,
        priceFilterEnable: priceFilterEnable,
        attributeFilterEnabled: attributeFilterEnabled,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProductCatalogController,
    CatalogState
  >
  createElement() {
    return _ProductCatalogControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductCatalogControllerProvider &&
        other.categoryId == categoryId &&
        other.vendorId == vendorId &&
        other.searchTerm == searchTerm &&
        other.brandId == brandId &&
        other.collectionId == collectionId &&
        other.priceFilterEnable == priceFilterEnable &&
        other.attributeFilterEnabled == attributeFilterEnabled;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoryId.hashCode);
    hash = _SystemHash.combine(hash, vendorId.hashCode);
    hash = _SystemHash.combine(hash, searchTerm.hashCode);
    hash = _SystemHash.combine(hash, brandId.hashCode);
    hash = _SystemHash.combine(hash, collectionId.hashCode);
    hash = _SystemHash.combine(hash, priceFilterEnable.hashCode);
    hash = _SystemHash.combine(hash, attributeFilterEnabled.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductCatalogControllerRef
    on AutoDisposeAsyncNotifierProviderRef<CatalogState> {
  /// The parameter `categoryId` of this provider.
  String? get categoryId;

  /// The parameter `vendorId` of this provider.
  String? get vendorId;

  /// The parameter `searchTerm` of this provider.
  String? get searchTerm;

  /// The parameter `brandId` of this provider.
  String? get brandId;

  /// The parameter `collectionId` of this provider.
  String? get collectionId;

  /// The parameter `priceFilterEnable` of this provider.
  bool get priceFilterEnable;

  /// The parameter `attributeFilterEnabled` of this provider.
  bool get attributeFilterEnabled;
}

class _ProductCatalogControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProductCatalogController,
          CatalogState
        >
    with ProductCatalogControllerRef {
  _ProductCatalogControllerProviderElement(super.provider);

  @override
  String? get categoryId =>
      (origin as ProductCatalogControllerProvider).categoryId;
  @override
  String? get vendorId => (origin as ProductCatalogControllerProvider).vendorId;
  @override
  String? get searchTerm =>
      (origin as ProductCatalogControllerProvider).searchTerm;
  @override
  String? get brandId => (origin as ProductCatalogControllerProvider).brandId;
  @override
  String? get collectionId =>
      (origin as ProductCatalogControllerProvider).collectionId;
  @override
  bool get priceFilterEnable =>
      (origin as ProductCatalogControllerProvider).priceFilterEnable;
  @override
  bool get attributeFilterEnabled =>
      (origin as ProductCatalogControllerProvider).attributeFilterEnabled;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
