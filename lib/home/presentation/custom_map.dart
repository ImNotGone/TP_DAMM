import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ser_manos_mobile/providers/location_provider.dart';

class CustomMap extends HookConsumerWidget {
  const CustomMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = useState<GoogleMapController?>(null);
    final center = useState<LatLng?>(null);
    final currentPosition = useState<Position?>(null);

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
      center.value = latLng;
      ref.read(locationNotifierProvider.notifier).setLocation(latLng);
    }

    useEffect(() {
      getUserLocation(center, currentPosition);
      return null;
    }, []);

    void onMapCreated(GoogleMapController controller) {
      mapController.value = controller;
    }

    return Scaffold(
      body: center.value == null
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
        height: double.infinity,
        child: GoogleMap(
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(
            target: center.value!,
            zoom: 15.0,
          ),
          // TODO: Poner los voluntariados en el mapa
          // markers: {},
        ),
      ),
    );
  }
}