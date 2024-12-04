import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pedal_application/screens/home_screen.dart';
import 'dart:math';

import '../controller/main_controller.dart';
import '../model/booking.model.dart';
import '../model/location.model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final random = Random();
  final mainController = Get.put(MainController());
  bool _isLoading = false;
  late GoogleMapController _mapController;
  static const LatLng _initialPosition =
      LatLng(37.7749, -122.4194); // San Francisco, CA
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {}; // Set to store polylines
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  List<dynamic> _fromPlaceSuggestions = [];
  List<dynamic> _toPlaceSuggestions = [];

  String _eta = "";
  String _price = "";

  LatLng? _fromLocation;
  LatLng? _toLocation;

  // Replace with your actual Google API Key
  final String _googleAPIKey = "AIzaSyBYSfMMUGh0UAI1cYJmA5zfoAyW8gCWYmU";

  // Philippine Pricing Constants
  final double baseFare = 40.0; // PHP 40
  final double ratePerKm = 15.0; // PHP 15 per kilometer
  final double ratePerMinute = 2.0; // PHP 2 per minute
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Screen"),
        backgroundColor: Colors.blue,
      ),
      body: _isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Horizontally center
              children: [
                CircularProgressIndicator(
                  strokeWidth: 8,
                ),
                SizedBox(
                    height:
                        10), // Adds some spacing between the spinner and text
                Text("Loading..."),
              ],
            ) // Shows the loading spinner
          : LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(40.0),
                            height: 300, // Fixed height for the map
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition,
                                zoom: 14,
                              ),
                              onMapCreated: (controller) {
                                _mapController = controller;
                              },
                              markers: _markers,
                              polylines:
                                  _polylines, // Add the polyline to the map
                            ),
                          ),
                          // Adjust to overlay UI below the map
                          Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                _buildLocationInput(
                                  label: "From",
                                  controller: _fromController,
                                  onPlaceSelected: (place) {
                                    _setMarker(
                                        place['lat'], place['lng'], "From");
                                    _fromLocation =
                                        LatLng(place['lat'], place['lng']);
                                    _calculateETAandPrice();
                                    _clearSuggestions('from');
                                    _updatePolyline();
                                  },
                                  suggestions: _fromPlaceSuggestions,
                                  onChanged: (query) {
                                    if (query.isNotEmpty) {
                                      _fetchPlaces(query, "from");
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                _buildLocationInput(
                                  label: "To",
                                  controller: _toController,
                                  onPlaceSelected: (place) {
                                    _setMarker(
                                        place['lat'], place['lng'], "To");
                                    _toLocation =
                                        LatLng(place['lat'], place['lng']);
                                    _calculateETAandPrice();
                                    _clearSuggestions('to');
                                    _updatePolyline();
                                  },
                                  suggestions: _toPlaceSuggestions,
                                  onChanged: (query) {
                                    if (query.isNotEmpty) {
                                      _fetchPlaces(query, "to");
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(_toController.text),
                                Text(_fromController.text),
                                _buildSummary(),
                                ElevatedButton(
                                  onPressed: () {
                                    if (_fromLocation == null ||
                                        _toLocation == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please complete your location and destination.")),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      _isLoading = true;

                                      final booking = Booking(
                                        bookingId:
                                            'bookingId${random.nextInt(100)}',
                                        driverId: "",
                                        customerId:
                                            mainController.getCurrentUser().id,
                                        isPwd: true,
                                        pwdType: "AGED",
                                        noteToDriver:
                                            "Pwede po patulong ako magbuhat ng gamit sa sasakyan.",
                                        dateCreated: DateTime.now(),
                                        dateCompleted: null,
                                        isActive: true,
                                        bookingStatus: "PICK-UP",
                                        distanceKM: 10.5,
                                        conversation: [],
                                        startLocation: Location(
                                          latitude: 14.5995,
                                          longitude: 120.9842,
                                          address:
                                              "Rizal Park, Ermita, Manila, Philippines",
                                          city: "Manila",
                                          state: "Metro Manila",
                                          country: "Philippines",
                                          postalCode: "1000",
                                        ),
                                        destination: Location(
                                          latitude: 14.5995,
                                          longitude: 120.9842,
                                          address:
                                              "Rizal Park, Ermita, Manila, Philippines",
                                          city: "Manila",
                                          state: "Metro Manila",
                                          country: "Philippines",
                                          postalCode: "1000",
                                        ),
                                      );
                                      mainController.addBooking(booking);
                                    });

                                    Get.snackbar(
                                      'Success',
                                      'Booking is now created!',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );

                                    Future.delayed(Duration(seconds: 3), () {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      Get.to(() => HomeScreen());
                                    });
                                  },
                                  child: const Text("Confirm Booking"),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildLocationInput({
    required String label,
    required TextEditingController controller,
    required Function(Map<String, dynamic> place) onPlaceSelected,
    required List<dynamic> suggestions,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
          if (suggestions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: Colors.white,
              height: 150,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final place = suggestions[index];
                  return ListTile(
                    title: Text(place['description']),
                    onTap: () {
                      controller.text = place['description'];
                      _fetchPlaceDetails(place['place_id'], onPlaceSelected);
                      _clearSuggestions(label);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _fetchPlaces(String query, String type) async {
    final url =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleAPIKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          if (type == "from") {
            _fromPlaceSuggestions = data['predictions'];
          } else {
            _toPlaceSuggestions = data['predictions'];
          }
        });
      } else {
        throw Exception(
            'Failed to load places: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  Future<void> _fetchPlaceDetails(String placeId,
      Function(Map<String, dynamic> place) onPlaceSelected) async {
    final detailsUrl =
        'https://cors-anywhere.herokuapp.com/https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleAPIKey';

    final response = await http.get(Uri.parse(detailsUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['result'] != null) {
        final result = data['result'];
        final lat = result['geometry']['location']['lat'];
        final lng = result['geometry']['location']['lng'];

        onPlaceSelected({'lat': lat, 'lng': lng});
      }
    } else {
      throw Exception('Failed to load place details');
    }
  }

  void _setMarker(double lat, double lng, String label) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(label),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: label,
          ),
        ),
      );
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14),
    );
  }

  Future<void> _fetchRoute(LatLng from, LatLng to) async {
    final url =
        'http://192.168.18.86:3000/directions?origin=${from.latitude},${from.longitude}&destination=${to.latitude},${to.longitude}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylinePoints = route['overview_polyline']['points'];
          final decodedPoints = _decodePolyline(polylinePoints);

          setState(() {
            _polylines.clear();
            _setPolyline(decodedPoints);
          });

          // Call to calculate pricing after the route is fetched
          _calculatePricing(route);
        }
      } else {
        throw Exception('Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
        index++;
      } while (byte >= 0x20);
      int deltaLat = ((result & 0x1F) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      result = 0;
      shift = 0;
      do {
        byte = encoded.codeUnitAt(index) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
        index++;
      } while (byte >= 0x20);

      int deltaLng = ((result & 0x1F) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  void _setPolyline(List<LatLng> points) {
    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId("route"),
        points: points,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  Future<void> _updatePolyline() async {
    if (_fromLocation != null && _toLocation != null) {
      await _fetchRoute(_fromLocation!, _toLocation!);
    }
  }

  // Calculate ETA and price
  void _calculateETAandPrice() async {
    if (_fromLocation != null && _toLocation != null) {
      await _fetchRoute(_fromLocation!, _toLocation!);
    }
  }

  // Calculate Pricing using Philippine fare model
  void _calculatePricing(Map<String, dynamic> route) {
    final legs = route['legs'][0];
    final distance = legs['distance']['value']; // in meters
    final duration = legs['duration']['value']; // in seconds

    final distanceKm = distance / 1000; // Convert meters to kilometers
    final durationMinutes = duration / 60; // Convert seconds to minutes

    // Pricing formula based on the Philippine model
    final distanceFare = distanceKm * ratePerKm;
    final timeFare = durationMinutes * ratePerMinute;

    final totalFare = baseFare + distanceFare + timeFare;

    setState(() {
      _eta = "ETA: ${(duration / 60).round()} minutes"; // ETA in minutes
      _price =
          "Price: PHP ${totalFare.toStringAsFixed(2)}"; // Display PHP price
    });
  }

  void _clearSuggestions(String type) {
    setState(() {
      if (type == 'from') {
        _fromPlaceSuggestions.clear();
      } else {
        _toPlaceSuggestions.clear();
      }
    });
  }

  // Summary display
  Widget _buildSummary() {
    return Column(
      children: [
        Text(_eta),
        Text(_price),
      ],
    );
  }
}
