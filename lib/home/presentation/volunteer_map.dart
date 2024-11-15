import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/floating.dart';
import '../../providers/volunteering_provider.dart';
import '../../shared/cells/cards/volunteer_card.dart';
import '../../shared/molecules/components/no_volunteering.dart';
import '../../shared/molecules/inputs/search_bar.dart';

class VolunteerMapScreen extends HookConsumerWidget {
  final void Function() onIconPressed;

  const VolunteerMapScreen({
    super.key,
    required this.onIconPressed
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');
    final mapController = useState<GoogleMapController?>(null);
    final currentCardIndex = useState<int>(0);
    final markers = useState(<Marker>{});
    final selectedMarker = useState(BitmapDescriptor.defaultMarker);
    final notSelectedMarker = useState(BitmapDescriptor.defaultMarker);

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);

    final filteredVolunteerings = allVolunteerings?.values
        .where((volunteering) => volunteering.title
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));


    var i = 0;
    filteredVolunteerings?.forEach(
        (v) {
          final marker = Marker(
            markerId: MarkerId(v.uid),
            position: LatLng(v.location.latitude, v.location.longitude),
            icon: i == currentCardIndex.value ? selectedMarker.value:notSelectedMarker.value
          );
          markers.value.add(marker);
          i++;
        }
    );

    if (mapController.value != null && filteredVolunteerings != null && filteredVolunteerings.isNotEmpty) {
      mapController.value!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              filteredVolunteerings[currentCardIndex.value].location.latitude,
              filteredVolunteerings[currentCardIndex.value].location.longitude,
            ),
          )
      );
    }

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(-34.563, -58.443), // Center on your preferred location
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            // Save controller for further interactions if needed
            mapController.value = controller;
          },
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          markers: markers.value,
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // pongo el padding aca pq las tarjetas se extienden hasta el borde de la pantalla -> no tienen padding horizontal
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: UtilSearchBar(
                    onIconPressed: onIconPressed,
                    onSearchChanged: (query) {
                      searchQuery.value = query;
                    },
                    icon: Icons.list,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: UtilFloatingButton(onPressed: () => {
                        // TODO: posicion actual del usuario
                      },
                    ),
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: filteredVolunteerings?.isEmpty ?? true
                          ? const NoVolunteering()
                          : CarouselSlider(
                        items: filteredVolunteerings!.map((volunteering) =>
                            VolunteerCard(volunteeringId: volunteering.uid)).toList(),
                        options: CarouselOptions(
                            height: 242,
                            viewportFraction: 0.9,
                            enableInfiniteScroll: false
                        ),
                      ),
                  )
                ],
              )

            ],
          )
      ],
    );
  }
}