import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/services/auth/auth_service.dart';
import 'package:store_user_app/domain/entities/models/common/address_model/address_model.dart';
import 'package:store_user_app/presentation/widgets/layout/view/app_inifinite_scroll_list.dart';
import 'package:uuid/uuid.dart';

import 'address_card_widget.dart';

class AddressListWidget extends ConsumerStatefulWidget {
  final bool editable;
  final bool selectable;
  final FutureOr<void> Function(AddressModel)? onAddressSelected;
  final FutureOr<void> Function(AddressModel)? onAddressDeleted;
  final FutureOr<void> Function(AddressModel)? onAddressEdited;
  final Future<void> Function()? refresh;
  final List<AddressModel> addresses;
  const AddressListWidget({
    super.key,
    this.editable = true,
    this.selectable = true,
    this.onAddressSelected,
    this.onAddressDeleted,
    this.onAddressEdited,
    this.refresh,
    required this.addresses,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressListWidgetState();
}

class _AddressListWidgetState extends ConsumerState<AddressListWidget> {
  late final ValueNotifier<AddressModel?> _selectedAddress;
  // late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedAddress = ValueNotifier(null);
    // _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return AppInifiniteScrollList(
        key: Key(Uuid().v4()),
        // controller: _scrollController,
        isLoading: false,
        hasMore: false,
        onLoadMore: () async {},
        refresh: widget.refresh,
        itemCount: widget.addresses.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var address = widget.addresses[index];
          return AddressCardWidget(
            address: address,
            isSelected: _selectedAddress.value?.id == address.id,
            editable: address.id != null && widget.editable,
            selectable: widget.selectable,
            onSelected: () {
              _selectedAddress.value = address;
              return widget.onAddressSelected?.call(address);
            },
            onTap: address.id != null
                ? () async {
                    var authService = await getIt.getAsync<AuthService>();
                    var currentUserIsGuest = await authService.isGuest();
                    if (currentUserIsGuest) {
                      toasty(context,
                          'Adres güncelleme silme işlemleri için lütfen kayıt olunuz.');
                      return;
                    }
                    widget.onAddressEdited?.call(address);
                  }
                : null,
            onDelete: () async {
              var authService = await getIt.getAsync<AuthService>();
              var currentUserIsGuest = await authService.isGuest();
              if (currentUserIsGuest) {
                toasty(context,
                    'Adres güncelleme silme işlemleri için lütfen kayıt olunuz.');
                return;
              }
              widget.onAddressDeleted?.call(address);
            },
          );
        });
  }
}
