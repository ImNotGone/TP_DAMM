import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/location_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/floating.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:widget_to_marker/widget_to_marker.dart';
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
    final selectedIcon = useState(BitmapDescriptor.defaultMarker);
    final nonSelectedIcon = useState(BitmapDescriptor.defaultMarker);

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);
    final location = useState<LatLng?>(null);
    final currentPosition = useState<Position?>(null);

    final carouselController = useMemoized(() => CarouselSliderController(), []);


    final filteredVolunteerings = allVolunteerings.value?.values
        .where((volunteering) => volunteering.title
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));

    Future<void> getUserLocation(ValueNotifier<LatLng?> center, ValueNotifier<Position?> currentPosition) async {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
          return;
        }
      }

      currentPosition.value = await Geolocator.getCurrentPosition();
      final latLng = LatLng(currentPosition.value!.latitude, currentPosition.value!.longitude);
      location.value = latLng;
      ref.read(locationNotifierProvider.notifier).setLocation(latLng);
    }

    void createMarkers() async {
      selectedIcon.value = await const Icon(
        Icons.location_on,
        size: 32,
        color: SerManosColors.secondary200,
      ).toBitmapDescriptor();

      nonSelectedIcon.value = await const Icon(
        Icons.location_on_outlined,
        size: 32,
        color: SerManosColors.secondary200,
      ).toBitmapDescriptor();

      final newMarkers = <Marker> {};
      for (var i = 0; i < filteredVolunteerings!.length; i++) {
        final v = filteredVolunteerings[i];
        newMarkers.add(
          Marker(
            markerId: MarkerId(v.uid),
            position: LatLng(v.location.latitude, v.location.longitude),
            icon: currentCardIndex.value == i
                ? selectedIcon.value
                : nonSelectedIcon.value,
            onTap: () {
              currentCardIndex.value = i;
              carouselController.animateToPage(i);
            }
          ),
        );
      }
      markers.value = newMarkers;
    }

    useEffect(() {
      getUserLocation(location, currentPosition);
      return null;
    }, []);

    useEffect(() {
      createMarkers();
      return null;
    }, [currentCardIndex.value]);


    // obelisco
    LatLng initialLocation = const LatLng(-34.603851, -58.381775);
    if (mapController.value != null && filteredVolunteerings != null && filteredVolunteerings.isNotEmpty) {
      mapController.value!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              filteredVolunteerings[currentCardIndex.value].location.latitude,
              filteredVolunteerings[currentCardIndex.value].location.longitude,
            ),
          )
      );
      initialLocation = LatLng(
        filteredVolunteerings[currentCardIndex.value].location.latitude,
        filteredVolunteerings[currentCardIndex.value].location.longitude,
      );
    }

    return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialLocation,
                zoom: 14.0,
              ),
              onMapCreated: (controller) {
                mapController.value = controller;
              },
              mapToolbarEnabled: false,
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
                        child: UtilFloatingButton(onPressed:
                            location.value == null
                            ? null
                      : () => {
                              mapController.value?.animateCamera(
                                CameraUpdate.newLatLng(location.value!)
                              )
                          },
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: filteredVolunteerings?.isEmpty ?? true
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: NoVolunteering(
                                    isSearching: searchQuery.value.isNotEmpty,
                                  )
                                )
                              : CarouselSlider.builder(
                                  itemCount: filteredVolunteerings!.length,
                                  itemBuilder: (context, index, realIndex) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: VolunteerCard(
                                        volunteeringId: filteredVolunteerings[index].uid,
                                      ),
                                    );
                                  },
                                  carouselController: carouselController,
                                  options: CarouselOptions(
                                      height: 242,
                                      viewportFraction: 0.9,
                                      enableInfiniteScroll: false,
                                      onPageChanged: (i, r) => currentCardIndex.value = i
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