import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../tokens/text_style.dart';
import 'blue_header_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final GeoPoint location;

  const LocationCard({
    super.key,
    required this.address,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: AppLocalizations.of(context)!.location,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: SizedBox(
              height: 155,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(location.latitude, location.longitude),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('location'),
                    position: LatLng(location.latitude, location.longitude),
                  ),
                },
                zoomControlsEnabled: false,
                scrollGesturesEnabled: false,
                tiltGesturesEnabled: false,
                rotateGesturesEnabled: false,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    AppLocalizations.of(context)!.address.toUpperCase(),
                    style: SerManosTextStyle.overline()
                ),
                Text(
                    address,
                    style: SerManosTextStyle.body01()
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
