import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_time_loc/provider/location_notifier.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final locationState = ref.watch(locationNotifierProvider);

    ref.listen(locationNotifierProvider.select((s) => s.currentLocation), (
      previous,
      next,
    ) {
      if (next != null && _mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newLatLngZoom(next, 16));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Real-Time Location Tracker'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              final notifier = ref.read(locationNotifierProvider.notifier);
              if (locationState.isTracking) {
                notifier.stopTracking();
              } else {
                notifier.startTracking();
              }
            },
            icon: Icon(
              locationState.isTracking ? Icons.stop : Icons.play_arrow,
            ),
            tooltip: locationState.isTracking
                ? 'Stop Tracking'
                : 'Start Tracking',
          ),
        ],
      ),

      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(23.8103, 90.4125),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: locationState.currentLocation == null
                ? {}
                : {
                    Marker(
                      markerId: MarkerId('current_location'),
                      position: locationState.currentLocation!,
                      infoWindow: InfoWindow(
                        title: 'My Current Location',
                        snippet:
                            '${locationState.currentLocation!.latitude.toStringAsFixed(4)}, '
                            '${locationState.currentLocation!.longitude.toStringAsFixed(4)}',
                      ),
                    ),
                  },
            polylines: {
              Polyline(
                polylineId: PolylineId('polyline_id'),
                color: Colors.redAccent,
                points: locationState.polylineCoordinates,
              ),
            },
          ),

          if (locationState.errorMessage != null)
            Positioned(
              bottom: 24,
              left: 24,
              right: 24,

              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  locationState.errorMessage!,
                  style: TextStyle(color: Colors.white, fontWeight: .bold),
                  textAlign: .center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
