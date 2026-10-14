import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:nb_utils/nb_utils.dart';

class ViewLocationWidget extends ConsumerWidget {
  final double lat;
  final double long;
  final double zoom;
  const ViewLocationWidget({
    super.key,
    required this.lat,
    required this.long,
    this.zoom = 17,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var packageInfo = getPackageInfo();
    return SnapHelperWidget(
        future: packageInfo,
        onSuccess: (snapshot) {
          return SizedBox(
            width: context.width(),
            height: context.width() / 2.2,
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                // keepAlive: false,
                initialCenter: LatLng(lat, long),
                initialZoom: zoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      snapshot.packageName ?? 'com.example.app',
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
        });
  }
}
