// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'component_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$customerRecomendedProductsHash() =>
    r'c8c6a5e437d3bd74914fbc1c0180fe2e6b6f63b5';

/// See also [CustomerRecomendedProducts].
@ProviderFor(CustomerRecomendedProducts)
final customerRecomendedProductsProvider = AutoDisposeAsyncNotifierProvider<
  CustomerRecomendedProducts,
  List<ProductOverviewModel>
>.internal(
  CustomerRecomendedProducts.new,
  name: r'customerRecomendedProductsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerRecomendedProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CustomerRecomendedProducts =
    AutoDisposeAsyncNotifier<List<ProductOverviewModel>>;
String _$suggestedProductsHash() => r'bb246094edd0d6e43512793a182623984095e7b5';

/// See also [SuggestedProducts].
@ProviderFor(SuggestedProducts)
final suggestedProductsProvider = AutoDisposeAsyncNotifierProvider<
  SuggestedProducts,
  List<ProductOverviewModel>
>.internal(
  SuggestedProducts.new,
  name: r'suggestedProductsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suggestedProductsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SuggestedProducts =
    AutoDisposeAsyncNotifier<List<ProductOverviewModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
