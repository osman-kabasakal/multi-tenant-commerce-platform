import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:store_user_app/core/di/injection_container.dart';
import 'package:store_user_app/core/navigation/app_router.gr.dart';
import 'package:store_user_app/core/services/logger/logger_service.dart';
import 'package:store_user_app/domain/entities/models/common/location_model/location_model.dart';
import 'package:store_user_app/domain/repositories/common/common_repository.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_common_button.dart';
import 'package:store_user_app/presentation/widgets/buttons/view/app_icon_button.dart';

import '../view_models/adress_detail.dart';

class LocationPickerWidget extends StatefulWidget {
  final double? lat;
  final double? long;
  final Function(AddressDetail) onAddressSelected;

  const LocationPickerWidget({
    super.key,
    required this.onAddressSelected,
    this.lat,
    this.long,
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  final MapController _mapController = MapController();
  LatLng? _currentCenter;
  bool _isLoading = false;
  String? _errorMessage;

  final Dio http = Dio();

  @override
  void initState() {
    super.initState();
    if (widget.lat != null && widget.long != null) {
      _currentCenter = LatLng(widget.lat!, widget.long!);
      // _mapController.move(_currentCenter!, 15);
    } else {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationPermissionDialog();
        return;
      }
      final position = await Geolocator.getCurrentPosition(
          locationSettings:
              LocationSettings(accuracy: LocationAccuracy.bestForNavigation));
      if (mounted) {
        setState(() {
          _currentCenter = LatLng(position.latitude, position.longitude);
        });

        _mapController.move(_currentCenter!, 17);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Konum alınamadı: ${e.toString()}';
        });
      }
    }
  }

  Future<AddressDetail?> _getReverseGeocodingData(LatLng location) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      var placemark =
          await placemarkFromCoordinates(location.latitude, location.longitude);

      // final response = await http.getUri<Map<String, dynamic>>(Uri.parse(
      //     'https://nominatim.openstreetmap.org/reverse?format=json&lat=${location.latitude}&lon=${location.longitude}&addressdetails=1'));

      if (placemark.isNotEmpty) {
        final address = placemark.first;
        final addressDetail = AddressDetail(
          country: address.country ?? '',
          city: address.administrativeArea ?? '',
          district: address.subAdministrativeArea ?? '',
          street: address.thoroughfare ?? '',
          neighbourhood: address.subLocality ?? '',
          postcode: address.postalCode ?? '',
          displayName: address.name ?? '',
          latitude: location.latitude,
          longitude: location.longitude,
        );
        // LoggerService.info(jsonEncode(addressDetail));
        return addressDetail;
      } else {
        throw Exception('Failed to load address data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Adres bilgisi alınamadı: ${e.toString()}';
        _isLoading = false;
      });
      return null;
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konum İzni Gerekli'),
          content: const Text(
              'Yeni adres eklemek için konum bilgilerinize ihtiyacımız var. '
              'Konum izni vermek istemezseniz ana sayfaya yönlendirileceksiniz.'),
          actions: [
            TextButton(
              onPressed: () {
                context.router.pushAndPopUntil(const HomeRoute(),
                    predicate: (route) => false);
              },
              child: const Text('Ana Sayfaya Dön'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _getCurrentLocation();
              },
              child: const Text('İzin Ver'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LayoutBuilder(builder: (context, lBox) {
            return SizedBox(
              width: lBox.maxWidth,
              height: lBox.maxHeight,
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  keepAlive: true,

                  initialCenter: _currentCenter ??
                      LatLng(41.0082, 28.9784), // İstanbul varsayılan
                  initialZoom: 17,
                  onMapEvent: (MapEvent event) {
                    if (event is MapEventMoveEnd) {
                      setState(() {
                        _currentCenter = event.camera.center;
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  // Sabit marker
                  const Center(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Material(
                color: Colors.red.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 110,
            right: 20,
            child: AppIconButton(
              icon: Icon(
                Icons.my_location,
                color: Colors.blueGrey,
                size: 50,
              ),
              onPressed: _getCurrentLocation,
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppCommonButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_currentCenter != null) {
                          final addressDetail =
                              await _getReverseGeocodingData(_currentCenter!);
                          if (addressDetail != null) {
                            try {
                              var commonRepository =
                                  await getIt.getAsync<CommonRepository>();
                              commonRepository.postCommonSaveCurrentPosition(
                                  LocationModel(
                                      latitude: _currentCenter!.latitude,
                                      longitude: _currentCenter!.longitude));
                              widget.onAddressSelected(addressDetail);
                            } catch (e) {
                              LoggerService.error(e.toString());
                            }
                          } else {
                            setState(() {
                              _errorMessage = 'Adres bilgisi alınamadı';
                              _isLoading = false;
                            });
                          }
                        }
                      },
                text: _isLoading ? 'Adres Yükleniyor...' : 'Bu Adresi Kullan',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    http.close(force: true);
    super.dispose();
  }
}
