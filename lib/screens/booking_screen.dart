import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';

import '../controller/main_controller.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isPWD = false;
  String _selectedPWDType = '';
  final Random random = Random();
  final MainController mainController = Get.put(MainController());
  bool _isLoading = false;
  late GoogleMapController _mapController;
  LatLng? _initialPosition; // Make this dynamic
  final Set<Marker> _markers = <Marker>{};
  final Set<Polyline> _polylines = <Polyline>{};
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  List<dynamic> _fromPlaceSuggestions = [];
  List<dynamic> _toPlaceSuggestions = [];

  String _eta = "";
  String _price = "";

  LatLng? _fromLocation;
  LatLng? _toLocation;

  final double baseFare = 45.0;
  final double ratePerKm = 15.0;
  final double ratePerMinute = 2.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch current location
  }

  // Fetch user's current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location services are disabled.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied.")),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: MarkerId('initial_location'),
        position: _initialPosition!,
        infoWindow: InfoWindow(title: "Your Location"),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Define mobile screen dimensions
    double mobileWidth = 400; // Maximum width for mobile
    double mobileHeight = 600; // Maximum height for mobile

    // Apply scaling factors for mobile size, similar to login page
    double scalingFactor = 0.25; // 25% of screen height (can adjust)
    double minContainerSize = 400.0; // Minimum size for the booking container

    // Calculate the container size
    double containerHeight = screenHeight * scalingFactor;
    containerHeight =
        containerHeight < minContainerSize ? minContainerSize : containerHeight;
    containerHeight =
        containerHeight > mobileHeight ? mobileHeight : containerHeight;

    double containerWidth = mobileWidth; // Fixed width for mobile

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Screen"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          width: containerWidth, // Fixed width similar to login page
          height: containerHeight, // Dynamic height, adjusted like login page
          padding: const EdgeInsets.all(20.0), // Optional padding for better UI
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Map at the top of the screen
                Container(
                  height: 200, // Height for the map
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(12.0), // Apply rounded corners
                    child: _initialPosition == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          ) // Show loading until location is fetched
                        : GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: _initialPosition!,
                              zoom: 14.0,
                            ),
                            onMapCreated: (controller) {
                              setState(() {
                                _mapController = controller;
                              });
                            },
                            markers: _markers,
                            polylines: _polylines,
                          ),
                  ),
                ),
                const SizedBox(height: 5), // Space between the map and the form
                _buildContent(), // Your existing content (location fields, summary, etc.)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPWDDialog() async {
    // List of all PWD types
    List<String> pwdTypes = [
      "Vision Impairment",
      "Hearing Impairment",
      "Mental Illness",
      "Intellectual Disability",
      "Learning Disability",
      "Autism Spectrum Disorder",
      "Cerebral Palsy",
      "Orthopedic Disability",
      "Psychosocial Disability",
      "Blindness",
      "Disability Caused by Chronic Illness",
      "Leprosy Cured",
      "Locomotor Disability",
      "Muscular Dystrophy",
      "Physical Disability",
      "Acquired Brain Injury",
      "Attention Deficit Hyperactivity Disorder",
      "Chronic Illness",
      "Dwarfism",
      "Hemophilia",
      "Multiple Disabilities",
      "Sickle Cell Disease",
      "Speech Impairment",
      "Thalassemia",
      "Senior Citizen", // Keep other types as needed
      "Person with Disability",
      "Pregnant Woman",
      "Child Below 5 Years",
      "Other" // Add "Other" optio
    ];
    String? otherInput; // To hold input if "Other" is selected

    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Ensure the dialog cannot be dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select PWD Type'),
          content: SingleChildScrollView(
            // Ensure it can scroll if the list is long
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // ListTile for each PWD type
                ...pwdTypes.map((type) {
                  return ListTile(
                    title: Text(type),
                    onTap: () {
                      if (type == "Other") {
                        // Show the text field if "Other" is selected
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Enter Custom PWD Type'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  TextField(
                                    maxLength:
                                        20, // Limit the input to 20 characters
                                    onChanged: (value) {
                                      otherInput = value;
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'Custom PWD Type',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedPWDType = otherInput ?? '';
                                      });
                                      Navigator.of(context)
                                          .pop(); // Close the "Other" input dialog
                                      Navigator.of(context)
                                          .pop(); // Close the main dialog
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        // Select the predefined PWD type
                        setState(() {
                          _selectedPWDType = type;
                        });
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                _buildLocationFields(),
                const SizedBox(height: 10),
                _buildSummary(),
                Row(
                  children: [
                    const Text("Are you a PWD?"),
                    Radio<bool>(
                      value: true,
                      groupValue: _isPWD,
                      onChanged: (value) {
                        setState(() {
                          _isPWD = value!;
                          if (_isPWD) {
                            _showPWDDialog(); // Show PWD selection dialog
                          }
                        });
                      },
                    ),
                    const Text("Yes"),
                    Radio<bool>(
                      value: false,
                      groupValue: _isPWD,
                      onChanged: (value) {
                        setState(() {
                          _isPWD = value!;
                        });
                      },
                    ),
                    const Text("No"),
                  ],
                ),
                ElevatedButton(
                  onPressed: _confirmBooking,
                  child: const Text("Confirm Booking"),
                ),
              ],
            ),
          );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.radio_button_checked,
                color: Colors.blue, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLocationField(
                controller: _fromController,
                hint: "Enter pickup location",
                onChanged: (value) => _fetchPlaces(value, "from"),
                suggestions: _fromPlaceSuggestions,
                onSelectSuggestion: (place) {
                  _fetchPlaceDetails(place['place_id'], (details) {
                    setState(() {
                      _fromLocation = LatLng(details['lat'], details['lng']);
                      _markers.add(Marker(
                        markerId: const MarkerId('from_location'),
                        position: _fromLocation!,
                      ));
                      _mapController.animateCamera(
                          CameraUpdate.newLatLng(_fromLocation!));
                    });
                  });
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _setCurrentLocationAsFrom,
              tooltip: 'Use my location',
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.radio_button_off, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLocationField(
                controller: _toController,
                hint: "Enter drop-off location",
                onChanged: (value) => _fetchPlaces(value, "to"),
                suggestions: _toPlaceSuggestions,
                onSelectSuggestion: (place) {
                  _fetchPlaceDetails(place['place_id'], (details) {
                    setState(() {
                      _toLocation = LatLng(details['lat'], details['lng']);
                      _markers.add(Marker(
                        markerId: const MarkerId('to_location'),
                        position: _toLocation!,
                      ));
                      _mapController
                          .animateCamera(CameraUpdate.newLatLng(_toLocation!));
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

// New method to set the current location as the "from" location
  Future<void> _setCurrentLocationAsFrom() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final LatLng currentLocation =
        LatLng(position.latitude, position.longitude);
    setState(() {
      _fromController.text =
          'Current Location'; // Optionally set the text to "Current Location"
      _fromLocation = currentLocation;
      _markers.add(Marker(
        markerId: const MarkerId('from_location'),
        position: currentLocation,
      ));
      _mapController.animateCamera(CameraUpdate.newLatLng(currentLocation));
    });
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    required List<dynamic> suggestions,
    required Function(Map<String, dynamic>) onSelectSuggestion,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          onChanged: onChanged,
        ),
        if (suggestions.isNotEmpty && controller.text.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final place = suggestions[index];
              return ListTile(
                title: Text(place['description']),
                onTap: () {
                  controller.text = place['description'];
                  onSelectSuggestion(place);
                  setState(() {
                    suggestions.clear();
                  });
                },
              );
            },
          ),
      ],
    );
  }

  Future<void> _fetchPlaces(String query, String type) async {
    final url = 'http://localhost:4000/places?input=$query';

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
        throw Exception('Failed to fetch places');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch places: $e")),
      );
    }
  }

  Future<void> _fetchPlaceDetails(
      String placeId, Function(Map<String, dynamic>) onPlaceSelected) async {
    final url = 'http://localhost:4000/places/details?place_id=$placeId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = data['result']['geometry']['location']['lat'];
        final lng = data['result']['geometry']['location']['lng'];

        onPlaceSelected({'lat': lat, 'lng': lng});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch place details.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching place details: $e")),
      );
    }
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_eta,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(_price,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _confirmBooking() {
    if (_fromLocation == null || _toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both pickup and drop-off locations."),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _fetchTravelDetails(_fromLocation!, _toLocation!).then((value) {
      setState(() {
        _eta = value['eta'];
        _price = value['price'];
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.green,
          points: value['routePoints'],
          width: 4, // Adjust this value for a thinner polyline (default is 10)
        ));

        _moveCameraToRoute(value['routePoints']);

        // Apply PWD discount if applicable
        if (_isPWD) {
          double originalPrice = double.parse(
              value['price'].replaceAll('₱', '').replaceAll(',', ''));
          double discountedPrice = originalPrice * 0.8; // Apply 20% discount
          _price =
              "₱${discountedPrice.toStringAsFixed(0)}"; // Update price with discount
        }

        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching travel details.")),
      );
    });
  }

  void _moveCameraToRoute(List<LatLng> routePoints) {
    if (routePoints.isEmpty) return;

    double latMin = routePoints[0].latitude;
    double latMax = routePoints[0].latitude;
    double lngMin = routePoints[0].longitude;
    double lngMax = routePoints[0].longitude;

    for (var point in routePoints) {
      latMin = min(latMin, point.latitude);
      latMax = max(latMax, point.latitude);
      lngMin = min(lngMin, point.longitude);
      lngMax = max(lngMax, point.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(latMin, lngMin),
      northeast: LatLng(latMax, lngMax),
    );

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  Future<Map<String, dynamic>> _fetchTravelDetails(
      LatLng from, LatLng to) async {
    final String apiKey =
        '5b3ce3597851110001cf62483a5657d52fa942079916e1e42b33a209'; // Replace with your OpenRouteService API Key
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final segments = data['features'][0]['properties']['segments'];

      final distance = (segments[0]['distance'] ?? 0).toDouble();
      final duration = (segments[0]['duration'] ?? 0).toDouble();

      final eta = "${(duration / 60).toStringAsFixed(0)} minutes";

      final price =
          "₱${(baseFare + ratePerKm * (distance / 1000) + ratePerMinute * (duration / 60)).toStringAsFixed(0)}";

      final routePoints =
          (data['features'][0]['geometry']['coordinates'] as List)
              .map((coords) => LatLng(coords[1], coords[0]))
              .toList();

      return {'eta': eta, 'price': price, 'routePoints': routePoints};
    } else {
      throw Exception('Failed to fetch travel details');
    }
  }
}
