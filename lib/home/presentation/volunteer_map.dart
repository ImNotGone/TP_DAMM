import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VolunteerMapScreen extends StatelessWidget {
  final void Function() onIconPressed;

  const VolunteerMapScreen({
    super.key,
    required this.onIconPressed
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(-34.563, -58.443), // Center on your preferred location
        zoom: 14.0,
      ),
      onMapCreated: (controller) {
        // Save controller for further interactions if needed
      },
      markers: _getCustomMarkers(),
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