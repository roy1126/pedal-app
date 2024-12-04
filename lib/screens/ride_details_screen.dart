import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideDetailsScreen extends StatelessWidget {
  final LatLng fromLocation;
  final LatLng toLocation;
  final double distance;
  final double fare;

  const RideDetailsScreen({
    required this.fromLocation,
    required this.toLocation,
    required this.distance,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ride Details")),
      body: Column(
        children: [
          // Map View
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: fromLocation,
                zoom: 12.0,
              ),
              markers: {
                Marker(markerId: MarkerId("from"), position: fromLocation),
                Marker(markerId: MarkerId("to"), position: toLocation),
              },
              polylines: {
                Polyline(
                  polylineId: PolylineId("route"),
                  points: [fromLocation, toLocation],
                  color: Colors.blue,
                  width: 5,
                ),
              },
            ),
          ),

          // Ride Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "From: ${fromLocation.latitude}, ${fromLocation.longitude}"),
                Text("To: ${toLocation.latitude}, ${toLocation.longitude}"),
                Text("Distance: ${distance.toStringAsFixed(2)} km"),
                Text("Fare: PHP ${fare.toStringAsFixed(2)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
