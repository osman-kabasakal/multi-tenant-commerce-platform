// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reviews_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productReviewsControllerHash() =>
    r'1c4393c4bbd59f635509d8afabc4ffc1856237ce';

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

abstract class _$ProductReviewsController
    extends BuildlessAutoDisposeAsyncNotifier<ProductReviewsViewModel> {
  late final ProductReviewsModel initialReviews;

  FutureOr<ProductReviewsViewModel> build(ProductReviewsModel initialReviews);
}

/// See also [ProductReviewsController].
@ProviderFor(ProductReviewsController)
const productReviewsControllerProvider = ProductReviewsControllerFamily();

/// See also [ProductReviewsController].
class ProductReviewsControllerFamily
    extends Family<AsyncValue<ProductReviewsViewModel>> {
  /// See also [ProductReviewsController].
  const ProductReviewsControllerFamily();

  /// See also [ProductReviewsController].
  ProductReviewsControllerProvider call(ProductReviewsModel initialReviews) {
    return ProductReviewsControllerProvider(initialReviews);
  }

  @override
  ProductReviewsControllerProvider getProviderOverride(
    covariant ProductReviewsControllerProvider provider,
  ) {
    return call(provider.initialReviews);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productReviewsControllerProvider';
}

/// See also [ProductReviewsController].
class ProductReviewsControllerProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ProductReviewsController,
          ProductReviewsViewModel
        > {
  /// See also [ProductReviewsController].
  ProductReviewsControllerProvider(ProductReviewsModel initialReviews)
    : this._internal(
        () => ProductReviewsController()..initialReviews = initialReviews,
        from: productReviewsControllerProvider,
        name: r'productReviewsControllerProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$productReviewsControllerHash,
        dependencies: ProductReviewsControllerFamily._dependencies,
        allTransitiveDependencies:
            ProductReviewsControllerFamily._allTransitiveDependencies,
        initialReviews: initialReviews,
      );

  ProductReviewsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.initialReviews,
  }) : super.internal();

  final ProductReviewsModel initialReviews;

  @override
  FutureOr<ProductReviewsViewModel> runNotifierBuild(
    covariant ProductReviewsController notifier,
  ) {
    return notifier.build(initialReviews);
  }

  @override
  Override overrideWith(ProductReviewsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductReviewsControllerProvider._internal(
        () => create()..initialReviews = initialReviews,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        initialReviews: initialReviews,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ProductReviewsController,
    ProductReviewsViewModel
  >
  createElement() {
    return _ProductReviewsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductReviewsControllerProvider &&
        other.initialReviews == initialReviews;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, initialReviews.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ProductReviewsControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ProductReviewsViewModel> {
  /// The parameter `initialReviews` of this provider.
  ProductReviewsModel get initialReviews;
}

class _ProductReviewsControllerProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ProductReviewsController,
          ProductReviewsViewModel
        >
    with ProductReviewsControllerRef {
  _ProductReviewsControllerProviderElement(super.provider);

  @override
  ProductReviewsModel get initialReviews =>
      (origin as ProductReviewsControllerProvider).initialReviews;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
