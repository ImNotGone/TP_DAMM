import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);

    final filteredVolunteerings = allVolunteerings?.values
        .where((volunteering) => volunteering.title
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(-34.563, -58.443), // Center on your preferred location
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            // Save controller for further interactions if needed
          },
          markers: _getCustomMarkers(),
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
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: UtilFloatingButton(onPressed: () {}),
                  ),
                  const SizedBox(height: 16,),
                  // TODO: carrousel slider
                ],
              )

            ],
          )
      ],
    );
  }

  Set<Marker> _getCustomMarkers() {
    return {
      const Marker(
        markerId: MarkerId('location1'),
        position: LatLng(-34.560, -58.440),
        infoWindow: InfoWindow(title: 'Hospital Pirovano'),
      ),
      // Add more markers as needed
    };
  }
}