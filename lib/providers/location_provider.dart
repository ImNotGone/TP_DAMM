import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_provider.g.dart';

@Riverpod(keepAlive: true)
class LocationNotifier extends _$LocationNotifier {
  @override
  LatLng? build() {
    return null;
  }

  void setLocation(LatLng? latLng) {
    state = latLng;
  }

  void clearLocation() {
    state = null;
  }
}
