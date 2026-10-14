import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/form/app_form_controller.dart';
import 'package:store_user_app/core/services/form/form_builder.dart';
import 'package:store_user_app/core/services/form/form_field.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/collection_extensions.dart';
import 'package:store_user_app/domain/entities/models/catalog/catalog_paging_filtering_model/specification_filter_item/specification_filter_item.dart';
import 'package:store_user_app/presentation/form_builders/filter_specification_attribute_form_builder.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/form/widgets/generic_form.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_bottom_navigation.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';
import 'package:store_user_app/presentation/widgets/layout/view/base_bottom_sheet.dart';
import 'package:store_user_app/presentation/widgets/products/view_models/filter_state.dart';
import 'package:store_user_app/presentation/widgets/products/widgets/category_filter_dropdown.dart';

typedef _FormBuilderPacket<T> = ({
  FormBuilder<T> formBuilder,
  AppFormController<T> formController
});

class FilterButtomSheet extends StatefulHookConsumerWidget {
  final FilterState filterState;
  const FilterButtomSheet({super.key, required this.filterState});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FilterButtomSheetState();
}

class _FilterButtomSheetState extends ConsumerState<FilterButtomSheet> {
  late final ValueNotifier<FilterState> tempFilter;

  late final fieldFocusNodes = <String, FocusNode>{};

  @override
  void initState() {
    super.initState();
    tempFilter = ValueNotifier(widget.filterState);
  }

  @override
  dispose() {
    tempFilter.dispose();
    // for (var element in _formControllers.entries) {
    //   element.value.formController.dispose();
    // }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant FilterButtomSheet oldWidget) {
    if (oldWidget.filterState != widget.filterState) {
      tempFilter.value = widget.filterState;
      _reInitializeFormBuilders();
    }
    // tempFilter.value = widget.filterState;
    super.didUpdateWidget(oldWidget);
  }

  void _reInitializeFormBuilders() {
    for (var reinitializeFormController
        in _reinitializeFormControllers.entries) {
      if (_formControllers.containsKey(reinitializeFormController.key)) {
        var formPacket = _formControllers[reinitializeFormController.key]!;

        formPacket.formBuilder.build().forEach((f) {
          if (fieldFocusNodes.containsKey(f.name)) {
            fieldFocusNodes.remove(f.name);
          }
        });
        _formControllers.remove(reinitializeFormController.key);
        _getFormBuilder(
          reinitializeFormController.key,
          tempFilter.value,
          reinitializeFormController.value.fieldBuilder,
          onFieldChange: reinitializeFormController.value.onFieldChange,
          onFieldFocusChange:
              reinitializeFormController.value.onFieldFocusChange,
          onDispose: reinitializeFormController.value.onDispose,
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    // _reInitializeFormBuilders();
    super.didChangeDependencies();
  }

  FocusNode _getFieldFocus(String fieldName) {
    if (!fieldFocusNodes.containsKey(fieldName)) {
      fieldFocusNodes[fieldName] = FocusNode();
    }
    return fieldFocusNodes[fieldName]!;
  }

  late final _formControllers = <String, _FormBuilderPacket>{};
  late final _reinitializeFormControllers = <String,
      ({
    void Function(FormBuilder<FilterState>) fieldBuilder,
    void Function(String, dynamic)? onFieldChange,
    void Function(String, bool)? onFieldFocusChange,
    void Function()? onDispose,
  })>{};

  _FormBuilderPacket<FilterState> _getFormBuilder(
    String formName,
    FilterState model,
    void Function(FormBuilder<FilterState>) fieldBuilder, {
    void Function(String, dynamic)? onFieldChange,
    void Function(String, bool)? onFieldFocusChange,
    void Function()? onDispose,
  }) {
    if (!_formControllers.containsKey(formName)) {
      final formBuilder = FormBuilder<FilterState>(model);
      fieldBuilder(formBuilder);
      final formController = AppFormController<FilterState>(
        formBuilder.build(),
        onFieldChange: onFieldChange,
        onFieldFocusChange: onFieldFocusChange,
        onDispose: () {
          onDispose?.call();
          if (kDebugMode) {
            debugPrint('Form disposed: $formName');
          }
          // fieldFocusNodes.forEach((key, value) {
          //   value.dispose();
          // });
        },
      );
      if (!_reinitializeFormControllers.containsKey(formName)) {
        _reinitializeFormControllers[formName] = (
          fieldBuilder: fieldBuilder,
          onFieldChange: onFieldChange,
          onFieldFocusChange: onFieldFocusChange,
          onDispose: onDispose,
        );
      }
      _formControllers[formName] =
          (formBuilder: formBuilder, formController: formController);
    }

    return (
      formBuilder:
          _formControllers[formName]!.formBuilder as FormBuilder<FilterState>,
      formController: _formControllers[formName]!.formController
          as AppFormController<FilterState>
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseBottomSheet(
      width: MediaQuery.of(context).size.width,
      title: 'Uygulanabilecek Filtreler',
      contentBuilder: (context) {
        return Column(
          children: [
            // Categories
            if (tempFilter.value.allCategories.isNotEmpty) ...[
              RepaintBoundary(
                child: CategoryFilterDropdown(
                  initialCategories: tempFilter.value.allCategories,
                  selectedCategoryId: tempFilter.value.selectedCategory,
                  onCategorySelected: (category) {
                    tempFilter.value = tempFilter.value
                        .copyWith(selectedCategory: category?.id ?? '');
                  },
                ),
              ),
              const Divider(),
            ],

            if (widget.filterState.availableCollections.isNotEmpty) ...[
              Builder(builder: (context) {
                var formPacket = _getFormBuilder(
                  'collection',
                  widget.filterState,
                  (formBuilder) {
                    formBuilder.addDropDownField(
                        'collection',
                        (m) => m.selectedCollectionId,
                        (m) => m.availableCollections,
                        (o) => o.text ?? '',
                        (o) => o.value,
                        focusNode: _getFieldFocus('collection'),
                        label: 'Kaleksiyonlarda Ara');
                  },
                  onFieldChange: (fieldName, value) {
                    tempFilter.value = tempFilter.value
                        .copyWith(selectedCollectionId: value as String?);
                  },
                );
                return GenericForm(
                  formBuilder: formPacket.formBuilder,
                  formController: formPacket.formController,
                );
              }),
              const Divider(),
            ],

            if (widget.filterState.availableVendors.isNotEmpty) ...[
              Builder(builder: (context) {
                var formPacket = _getFormBuilder(
                  'vendor',
                  tempFilter.value,
                  (formBuilder) {},
                  onFieldChange: (fieldName, value) {
                    tempFilter.value = tempFilter.value.copyWith(
                      vendorId: value as String?,
                    );
                  },
                );

                return GenericForm(
                  formBuilder: formPacket.formBuilder,
                  formController: formPacket.formController,
                );
              }),
              const Divider(),
            ],

            // Price Range
            if (tempFilter.value.priceFilterEnebale) ...[
              AppCardTitle.primary(
                title: 'Fiyat Aralığı',
                hasDivider: false,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Builder(builder: (context) {
                      var formPacket = _getFormBuilder(
                          'minPrice', tempFilter.value, (formBuilder) {
                        formBuilder
                            .addField(
                              'minPrice',
                              (m) => m.minPrice != null && m.minPrice! > 0
                                  ? NumberFormat.currency(
                                          locale: 'tr_TR',
                                          name: '',
                                          decimalDigits: 2,
                                          symbol: '')
                                      .format(m.minPrice)
                                  : '',
                              label: 'Min',
                              type: FormFieldType.price,
                              focusNode: _getFieldFocus('minPrice'),
                            )
                            .setHintText('Min');
                      }, onFieldChange: (p0, p1) {
                        tempFilter.value = tempFilter.value.copyWith(
                          minPrice: double.tryParse(p1 ?? ''),
                        );
                      });
                      return GenericForm(
                        formBuilder: formPacket.formBuilder,
                        formController: formPacket.formController,
                      );
                      // return GenericForm(
                      //   formBuilder: (FormBuilder<FilterState>(tempFilter.value)
                      //     ..addField(
                      //       'minPrice',
                      //       (m) => m.minPrice != null && m.minPrice! > 0
                      //           ? NumberFormat.currency(
                      //                   locale: 'tr_TR',
                      //                   name: '',
                      //                   decimalDigits: 0,
                      //                   symbol: '')
                      //               .format(m.minPrice)
                      //           : '',
                      //       label: 'Min',
                      //       type: FormFieldType.price,
                      //       focusNode: _getFieldFocus('minPrice'),
                      //     ).setHintText('Min')),
                      //   onFieldChange: (p0, p1) {
                      //     tempFilter.value = tempFilter.value.copyWith(
                      //       minPrice: double.tryParse(p1 ?? ''),
                      //     );
                      //   },
                      // );
                    }),
                  ),
                  Expanded(
                      flex: 1,
                      child: const Text(' - ', textAlign: TextAlign.center)),
                  Expanded(
                    flex: 2,
                    child: Builder(builder: (context) {
                      var formPacket = _getFormBuilder(
                          'maxPrice', tempFilter.value, (formBuilder) {
                        formBuilder
                            .addField(
                                'maxPrice',
                                (m) => m.maxPrice != null && m.maxPrice! > 0
                                    ? NumberFormat.currency(
                                            locale: 'tr_TR',
                                            name: '',
                                            decimalDigits: 2,
                                            symbol: '')
                                        .format(m.maxPrice)
                                    : '',
                                label: 'Max',
                                focusNode: _getFieldFocus('maxPrice'),
                                type: FormFieldType.price)
                            .setHintText('Max');
                      }, onFieldChange: (p0, p1) {
                        tempFilter.value = tempFilter.value.copyWith(
                          maxPrice: double.tryParse(p1 ?? ''),
                        );
                      });
                      return GenericForm(
                        formBuilder: formPacket.formBuilder,
                        formController: formPacket.formController,
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Rating Filter
            AppCardTitle.primary(
              title: 'Değerlendirme',
              hasDivider: false,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: tempFilter.value.ratingOptions
                  .map((r) => double.tryParse(r.value ?? ''))
                  .where((element) => element != null)
                  .map((rating) {
                return ValueListenableBuilder(
                  valueListenable: tempFilter,
                  builder: (context, state, child) {
                    return FilterChip(
                      label: child!,
                      selected: state.rating == rating,
                      onSelected: (selected) {
                        tempFilter.value = tempFilter.value.copyWith(
                          rating: selected ? rating : null,
                        );
                      },
                      backgroundColor: Colors.transparent,
                      selectedColor: colorPrimary.withValues(alpha: 0.2),
                      checkmarkColor: colorPrimary,
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$rating',
                        style: context.textTheme.labelSmall,
                      ),
                      Icon(Icons.star,
                          size: context.textTheme.labelSmall!.fontSize),
                      Text(
                        ' ve üzeri',
                        style: context.textTheme.labelSmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Show specification-based filters if available
            if (widget.filterState.attributeFilterEnbaled) ...[
              ..._buildSpecFilters(tempFilter),
            ],
          ],
        );
      },
      footerBuilder: (context) {
        return AppBottomNavigation(
          child: Row(
            children: [
              Expanded(
                child: AppCommonButton(
                  text: 'Vazgeç',
                  height: 48,
                  bgColor: getIt<ThemeController>().isDarkMode
                      ? borderDark
                      : primaryColor100,
                  textColor: getIt<ThemeController>().isDarkMode
                      ? colorWhite1
                      : colorPrimary,
                  onPressed: () => context.router.maybePop(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppCommonButton(
                  text: 'Seç',
                  height: 48,
                  onPressed: () => context.router.maybePop(tempFilter.value),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSpecFilters(ValueNotifier<FilterState> tempFilter) {
    if (tempFilter.value.attributeFilterEnbaled) {
      var allFilters = <SpecificationFilterItem>[
        ...tempFilter.value.alreadyFilteredItems,
        ...tempFilter.value.notFilteredItems,
      ];
      if (allFilters.isEmpty) {
        return [];
      }
      var filterFormBuilder = FilterSpecificationAttributeFormBuilder(
          allFilters.groupBy((e) => e.specificationAttributeSeName ?? ''));

      late var formController = AppFormController(
        filterFormBuilder.build(),
        onFieldChange: (fieldName, value) {
          var filters = allFilters
              .where((element) =>
                  element.specificationAttributeSeName == fieldName)
              .toList();
          tempFilter.value = tempFilter.value.copyWith(
            alreadyFilteredItems: [
              ...tempFilter.value.alreadyFilteredItems.where((element) =>
                  element.specificationAttributeSeName != fieldName),
              ...filters.where((element) => value.contains(
                  element.specificationAttributeOptionSeName.toString())),
            ],
          );
        },
      );

      tempFilter.value.alreadyFilteredItems
          .groupBy((e) => e.specificationAttributeSeName)
          .forEach((key, value) {
        formController.updateField(
            key!,
            value.map((e) => e.specificationAttributeOptionSeName).toList(),
            true);
      });
      return [
        GenericForm(
          formBuilder: filterFormBuilder,
          formController: formController,
        ),
        const Divider(),
      ];
    }

    return [];
  }
}
