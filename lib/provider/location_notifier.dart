import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_time_loc/provider/location_state.dart';

final locationNotifierProvider =
    NotifierProvider<LocationNotifier, LocationState>(() => LocationNotifier());

class LocationNotifier extends Notifier<LocationState> {
  Timer? _timer;

  @override
  LocationState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return LocationState(
      currentLocation: null,
      polylineCoordinates: [],
      isTracking: false,
    );
  }

  Future<void> startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      state = state.copyWith(errorMessage: 'Location Service is Disabled');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == .denied) {
        state = state.copyWith(errorMessage: 'Location Permission is denied');
        return;
      }
    }

    if (permission == .deniedForever) {
      state = state.copyWith(
        errorMessage: 'Location permission are permanently denied',
      );
      return;
    }

    state = state.copyWith(isTracking: true, errorMessage: null);

    await _getMyLocationUpdate();

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _getMyLocationUpdate();
    });
  }

  Future<void> _getMyLocationUpdate() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: .high),
      );

      final newLatLong = LatLng(position.latitude, position.longitude);
      final updatedPolylineCoordinates = [
        ...state.polylineCoordinates,
        newLatLong,
      ];

      state = state.copyWith(
        currentLocation: newLatLong,
        polylineCoordinates: updatedPolylineCoordinates,
      );
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }

  void stopTracking() {
    _timer?.cancel();
    state = state.copyWith(isTracking: false);
  }
}
