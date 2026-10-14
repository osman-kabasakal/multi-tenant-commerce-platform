import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:store_user_app/core/config/theme/theme.dart';
import 'package:store_user_app/core/constants/colors.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/theme/theme_controller.dart';
import 'package:store_user_app/core/utils/extensions/build_context_extensions.dart';
import 'package:store_user_app/core/utils/extensions/datetime_extensions.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_details_model/merchandise_return_details_model.dart';
import 'package:store_user_app/domain/entities/models/orders/merchandise_return_details_model/merchandise_return_note/merchandise_return_note.dart';
import 'package:store_user_app/presentation/screens/merchandise_return/providers/merchandise_return_details_controller.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_animated_loading_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_error_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_summary_row_widget.dart';
import 'package:store_user_app/presentation/widgets/app/widgets/app_widget.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_card_title.dart';

@RoutePage()
class MerchandiseReturnDetailsScreen extends HookConsumerWidget {
  final String merchandiseReturnId;

  const MerchandiseReturnDetailsScreen({
    super.key,
    @PathParam('merchandiseReturnId') required this.merchandiseReturnId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(
      merchandiseReturnDetailsControllerProvider(merchandiseReturnId),
    );

    return Scaffold(
      appBar: fdCommonAppBarWidget(context, titleText: 'İade Detayları'),
      body: detailsAsync.when(
        data:
            (details) =>
                details.returnNumber != null && details.returnNumber! > 0
                    ? _buildDetailsContent(context, details, ref)
                    : const Center(
                      child: Text(
                        'İade talebi bulunamadı.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
        loading: () => const Center(child: AppAnimatedLoadingWidget()),
        error:
            (error, stack) => AppErrorWidget(
              message: error.toString(),
              type: ErrorType.error,
              onRetry:
                  () => ref.refresh(
                    merchandiseReturnDetailsControllerProvider(
                      merchandiseReturnId,
                    ),
                  ),
            ),
      ),
    );
  }

  Widget _buildDetailsContent(
    BuildContext context,
    MerchandiseReturnDetailsModel model,
    WidgetRef ref,
  ) {
    return RefreshIndicator(
      onRefresh:
          () =>
              ref
                  .read(
                    merchandiseReturnDetailsControllerProvider(
                      merchandiseReturnId,
                    ).notifier,
                  )
                  .refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with return number and status
              Text(
                'İade Talebi #${model.returnNumber} - ${model.merchandiseReturnStatus?.name}',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Creation date
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCardTitle.primary(
                      title: 'İade Bilgileri',
                      hasDivider: true,
                    ),
                    const SizedBox(height: 8),
                    AppSummaryRowWidget(
                      'Oluşturulma Tarihi',
                      (model.createdOnUtc ?? DateTime.now()).formattedDateTime,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Return Items
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppCardTitle.primary(
                      title: 'İade Edilen Ürünler',
                      hasDivider: true,
                    ),
                    const SizedBox(height: 16),
                    _buildReturnItemsTable(context, model),
                  ],
                ),
              ),

              // Comments if available
              if (model.comments != null && model.comments!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCardTitle.primary(
                          title: 'Açıklama',
                          hasDivider: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          model.comments!,
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),

              // Pickup Date if available
              if (model.showPickupDate! && model.pickupDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCardTitle.primary(
                          title: 'Alınacak Tarih',
                          hasDivider: true,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: colorPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              model.pickupDate!.formattedDate,
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              // Pickup Address if available
              if (model.showPickupAddress! && model.pickupAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCardTitle.primary(
                          title: 'Alım Adresi',
                          hasDivider: true,
                        ),
                        const SizedBox(height: 8),
                        _buildAddressDetails(context, model.pickupAddress!),
                      ],
                    ),
                  ),
                ),

              // Merchandise Return Notes if available
              if (model.merchandiseReturnNotes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppCardTitle.primary(
                          title: 'İade Notları',
                          hasDivider: true,
                        ),
                        const SizedBox(height: 8),
                        _buildReturnNotes(
                          context,
                          model.merchandiseReturnNotes!,
                          ref,
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReturnItemsTable(
    BuildContext context,
    MerchandiseReturnDetailsModel model,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        headingTextStyle: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color:
              getIt<ThemeController>().isDarkMode
                  ? Colors.white
                  : Colors.black87,
        ),
        dataTextStyle: context.textTheme.bodyMedium,
        columns: const [
          DataColumn(label: Text('Ürün')),
          DataColumn(label: Text('Adet'), numeric: true),
          DataColumn(label: Text('Fiyat')),
          DataColumn(label: Text('İade Nedeni')),
          DataColumn(label: Text('Talep Edilen İşlem')),
        ],
        rows:
            model.merchandiseReturnItems!.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: 150,
                      child: Text(
                        item.productName ?? '',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  DataCell(Text('${item.quantity}')),
                  DataCell(
                    Text(
                      item.productPrice ?? '',
                      style: context.textTheme.bodySmall!.copyWith(
                        fontFamily: '',
                      ),
                    ),
                  ),
                  DataCell(Text(item.reasonForReturn ?? '')),
                  DataCell(Text(item.requestedAction ?? '')),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAddressDetails(BuildContext context, AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        Text(
          '${address.firstName} ${address.lastName}',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        // Email
        if (address.email != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.email_outlined, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(address.email!)),
              ],
            ),
          ),

        // Phone
        if (address.phoneEnabled == true && address.phoneNumber != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.phone_outlined, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(address.phoneNumber!)),
              ],
            ),
          ),

        // Company
        if (address.companyEnabled == true &&
            address.company != null &&
            address.company!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.business_outlined, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(address.company!)),
              ],
            ),
          ),

        // Address lines
        if (address.streetAddressEnabled == true && address.address1 != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(address.address1!)),
              ],
            ),
          ),

        if (address.streetAddress2Enabled == true &&
            address.address2 != null &&
            address.address2!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Text(address.address2!),
            ),
          ),

        // City, State, Zip
        if ((address.cityEnabled == true && address.city != null) ||
            (address.stateProvinceEnabled == true &&
                address.stateProvinceName != null) ||
            (address.zipPostalCodeEnabled == true &&
                address.zipPostalCode != null))
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    [
                      if (address.cityEnabled == true && address.city != null)
                        address.city,
                      if (address.stateProvinceEnabled == true &&
                          address.stateProvinceName != null)
                        address.stateProvinceName,
                      if (address.zipPostalCodeEnabled == true &&
                          address.zipPostalCode != null)
                        address.zipPostalCode,
                    ].where((e) => e != null && e.isNotEmpty).join(', '),
                  ),
                ),
              ],
            ),
          ),

        // Country
        if (address.countryEnabled == true &&
            address.countryName != null &&
            address.countryName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 24),
                Expanded(child: Text(address.countryName!)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildReturnNotes(
    BuildContext context,
    List<MerchandiseReturnNote> notes,
    WidgetRef ref,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notes.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final note = notes[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (note.createdOn ?? DateTime.now()).formattedDateTime,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                // if (note.showAddMerchandiseReturnNote == true)
                //   IconButton(
                //     icon: const Icon(Icons.add_comment, size: 20),
                //     onPressed: () {
                //       // Bu kısım ileride eklenebilir - not ekleme fonksiyonalitesi
                //     },
                //   ),
              ],
            ),
            const SizedBox(height: 4),
            Html(
              data: note.note ?? '',
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(context.textTheme.bodyMedium!.fontSize!),
                  fontFamily: AppTheme.fontFamily,
                ),
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppCommonButton(
                text: 'Not İndir',
                bgColor: colorPrimary,
                onPressed: () {
                  ref
                      .read(
                        merchandiseReturnDetailsControllerProvider(
                          merchandiseReturnId,
                        ).notifier,
                      )
                      .downloadMerchandiseReturnNote(note.id!);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
