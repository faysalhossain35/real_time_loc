import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState {
  final LatLng? currentLocation;
  final List<LatLng> polylineCoordinates;
  final bool isTracking;
  final String? errorMessage;

  LocationState({
    this.currentLocation,
    required this.polylineCoordinates,
    this.isTracking = false,
    this.errorMessage,
  });

  LocationState copyWith({
    LatLng? currentLocation,
    List<LatLng>? polylineCoordinates,
    bool? isTracking,
    String? errorMessage,
  }) {
    return LocationState(
      currentLocation: currentLocation ?? this.currentLocation,
      polylineCoordinates: polylineCoordinates ?? this.polylineCoordinates,
      isTracking: isTracking ?? this.isTracking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
