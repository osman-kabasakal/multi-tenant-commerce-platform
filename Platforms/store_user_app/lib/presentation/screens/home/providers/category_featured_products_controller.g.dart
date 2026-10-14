// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_featured_products_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryFeaturedProductsHash() =>
    r'8a27c17dd6c7f3ff8c6eb60c860759e2c63a2c80';

/// See also [CategoryFeaturedProducts].
@ProviderFor(CategoryFeaturedProducts)
final categoryFeaturedProductsProvider = AutoDisposeAsyncNotifierProvider<
  CategoryFeaturedProducts,
  List<CategoryModel>
>.internal(
  CategoryFeaturedProducts.new,
  name: r'categoryFeaturedProductsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryFeaturedProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CategoryFeaturedProducts =
    AutoDisposeAsyncNotifier<List<CategoryModel>>;
String _$categoryFeaturedProductsControllerHash() =>
    r'5032d1de3ed2f393a95b0a9cd4c748180f4ff89d';

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

abstract class _$CategoryFeaturedProductsController
    extends BuildlessAutoDisposeNotifier<CategoryFeaturedProductsViewModel> {
  late final List<CategoryModel> categories;

  CategoryFeaturedProductsViewModel build(List<CategoryModel> categories);
}

/// See also [CategoryFeaturedProductsController].
@ProviderFor(CategoryFeaturedProductsController)
const categoryFeaturedProductsControllerProvider =
    CategoryFeaturedProductsControllerFamily();

/// See also [CategoryFeaturedProductsController].
class CategoryFeaturedProductsControllerFamily
    extends Family<CategoryFeaturedProductsViewModel> {
  /// See also [CategoryFeaturedProductsController].
  const CategoryFeaturedProductsControllerFamily();

  /// See also [CategoryFeaturedProductsController].
  CategoryFeaturedProductsControllerProvider call(
    List<CategoryModel> categories,
  ) {
    return CategoryFeaturedProductsControllerProvider(categories);
  }

  @override
  CategoryFeaturedProductsControllerProvider getProviderOverride(
    covariant CategoryFeaturedProductsControllerProvider provider,
  ) {
    return call(provider.categories);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'categoryFeaturedProductsControllerProvider';
}

/// See also [CategoryFeaturedProductsController].
class CategoryFeaturedProductsControllerProvider
    extends
        AutoDisposeNotifierProviderImpl<
          CategoryFeaturedProductsController,
          CategoryFeaturedProductsViewModel
        > {
  /// See also [CategoryFeaturedProductsController].
  CategoryFeaturedProductsControllerProvider(List<CategoryModel> categories)
    : this._internal(
        () => CategoryFeaturedProductsController()..categories = categories,
        from: categoryFeaturedProductsControllerProvider,
        name: r'categoryFeaturedProductsControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$categoryFeaturedProductsControllerHash,
        dependencies: CategoryFeaturedProductsControllerFamily._dependencies,
        allTransitiveDependencies:
            CategoryFeaturedProductsControllerFamily._allTransitiveDependencies,
        categories: categories,
      );

  CategoryFeaturedProductsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categories,
  }) : super.internal();

  final List<CategoryModel> categories;

  @override
  CategoryFeaturedProductsViewModel runNotifierBuild(
    covariant CategoryFeaturedProductsController notifier,
  ) {
    return notifier.build(categories);
  }

  @override
  Override overrideWith(CategoryFeaturedProductsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CategoryFeaturedProductsControllerProvider._internal(
        () => create()..categories = categories,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categories: categories,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<
    CategoryFeaturedProductsController,
    CategoryFeaturedProductsViewModel
  >
  createElement() {
    return _CategoryFeaturedProductsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CategoryFeaturedProductsControllerProvider &&
        other.categories == categories;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categories.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CategoryFeaturedProductsControllerRef
    on AutoDisposeNotifierProviderRef<CategoryFeaturedProductsViewModel> {
  /// The parameter `categories` of this provider.
  List<CategoryModel> get categories;
}

class _CategoryFeaturedProductsControllerProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          CategoryFeaturedProductsController,
          CategoryFeaturedProductsViewModel
        >
    with CategoryFeaturedProductsControllerRef {
  _CategoryFeaturedProductsControllerProviderElement(super.provider);

  @override
  List<CategoryModel> get categories =>
      (origin as CategoryFeaturedProductsControllerProvider).categories;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
