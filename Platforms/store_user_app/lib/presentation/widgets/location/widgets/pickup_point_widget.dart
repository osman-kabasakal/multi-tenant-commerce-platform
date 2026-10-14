import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/config/theme/skeleton_styles.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/models/network/api_response.dart';
import 'package:store_user_app/domain/entities/models/checkout/checkout_pickup_point_model/checkout_pickup_point_model.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/domain/entities/models/common/state_province_model/state_province_model.dart';
import 'package:store_user_app/domain/repositories/country/country_repository.dart';
import 'package:store_user_app/presentation/widgets/layout/view/selectable_card.dart';
import 'package:store_user_app/presentation/widgets/skeletons/widgets/widgets.dart';

/// Varsayımsal Address modelinin özelliklerini kullandığımız yardımcı fonksiyon.
/// Uygulamanızda Address modelinin sahip olduğu alanlara göre düzenleyin.
String _formatAddress(AddressModel? address) {
  if (address == null) return "";
  // Örnek: street, city, district alanlarını kullanıyoruz.
  return "${address.address1 ?? ""},${address.address2 ?? ""} ${address.city ?? ""}, ${address.stateProvinceName ?? ""}";
}

/// CheckoutPickupPointModel verisini SelectableCard içerisinde gösterecek PickupPointWidget.
class PickupPointWidget extends StatelessWidget {
  final CheckoutPickupPointModel pickupPoint;
  final bool isSelected;
  final VoidCallback onTap;

  const PickupPointWidget({
    super.key,
    required this.pickupPoint,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableCard(
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ad bilgisi
          Text(
            pickupPoint.name ?? "Bilinmeyen Nokta",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          // Açıklama
          if (pickupPoint.description != null &&
              pickupPoint.description!.isNotEmpty)
            Text(
              pickupPoint.description!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const SizedBox(height: 4),
          // Adres bilgisi (varsayımsal Address modeline göre formatlanır)
          if (pickupPoint.address != null &&
              pickupPoint.address!.countryId != null)
            FutureBuilder<ApiResponse<List<StateProvinceModel>>?>(
                future: (() async => (await getIt.getAsync<CountryRepository>())
                    .getCountryGetStatesByCountryId(
                        pickupPoint.address!.countryId!, true))(),
                builder: (context, snapshot) {
                  if (isSnapshotLoading(snapshot)) {
                    return snapWidgetHelper(snapshot,
                        loadingWidget: Skeleton(
                            isLoading: true,
                            skeleton: SkeletonLine(
                              style: SkeletonLineStyle(
                                  height: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .fontSize!,
                                  width: double.infinity),
                            ),
                            child: SizedBox.shrink()));
                  }
                  var stateProvince = snapshot.data!.data
                      ?.where((element) =>
                          element.id == pickupPoint.address!.stateProvinceId)
                      .firstOrNull
                      ?.name;
                  return Text(
                    _formatAddress(
                        AddressModel.fromJson(pickupPoint.address!.toJson())
                            .copyWith(
                                address1: pickupPoint.address!.address1,
                                address2: pickupPoint.address!.address2,
                                city: pickupPoint.address!.city,
                                stateProvinceName: stateProvince,
                                countryName: 'Türkiye',
                                zipPostalCode:
                                    pickupPoint.address!.zipPostalCode)),
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }),
          const SizedBox(height: 4),
          // Pickup ücreti
          if (pickupPoint.pickupFee != null &&
              pickupPoint.pickupFee!.isNotEmpty)
            Text(
              "Ücret: ${pickupPoint.pickupFee}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
    );
  }
}
