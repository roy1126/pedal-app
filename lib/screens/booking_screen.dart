import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../controller/main_controller.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final Random random = Random();
  final MainController mainController = Get.put(MainController());
  bool _isLoading = false;
  late GoogleMapController _mapController;
  static const LatLng _initialPosition = LatLng(37.7749, -122.4194);
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

  final String _googleAPIKey = "AIzaSyBYSfMMUGh0UAI1cYJmA5zfoAyW8gCWYmU";

  final double baseFare = 40.0;
  final double ratePerKm = 15.0;
  final double ratePerMinute = 2.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Screen"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildLocationFields(),
                const SizedBox(height: 20),
                _buildSummary(),
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
            Icon(Icons.radio_button_checked, color: Colors.blue, size: 20),
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
                    });
                  });
                },
                onMapSelect: () => _selectOnMap((selectedLocation) {
                  setState(() {
                    _fromLocation = selectedLocation;
                    _fromController.text = "Location selected on map";
                  });
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.radio_button_off, color: Colors.green, size: 20),
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
                    });
                  });
                },
                onMapSelect: () => _selectOnMap((selectedLocation) {
                  setState(() {
                    _toLocation = selectedLocation;
                    _toController.text = "Location selected on map";
                  });
                }),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hint,
    required Function(String) onChanged,
    required List<dynamic> suggestions,
    required Function(Map<String, dynamic>) onSelectSuggestion,
    required VoidCallback onMapSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: IconButton(
              icon: Icon(Icons.map, color: Colors.blue),
              onPressed: onMapSelect,
            ),
          ),
          onChanged: onChanged,
        ),
        if (suggestions.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final place = suggestions[index];
              return ListTile(
                title: Text(place['description']),
                onTap: () => onSelectSuggestion(place),
              );
            },
          ),
      ],
    );
  }

  Future<void> _selectOnMap(Function(LatLng) onLocationSelected) async {
    final LatLng? selectedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSelectionScreen(),
      ),
    );

    if (selectedLocation != null) {
      onLocationSelected(selectedLocation);
    }
  }

  Future<void> _fetchPlaces(String query, String type) async {
    final url =
        'http://localhost:4000/places?input=$query'; // Local server for places

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
      }
    } catch (e) {
      print('Error fetching places: $e');
    }
  }

  Future<void> _fetchPlaceDetails(
      String placeId, Function(Map<String, dynamic>) onPlaceSelected) async {
    final url =
        'http://localhost:4000/places/details?place_id=$placeId'; // Ensure this is correct

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final lat = data['result']['geometry']['location']['lat'];
        final lng = data['result']['geometry']['location']['lng'];

        onPlaceSelected({'lat': lat, 'lng': lng});
      } else {
        print('Error fetching place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
  }

  Widget _buildSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_eta, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Text(_price,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  void _confirmBooking() {
    if (_fromLocation == null || _toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Please select both pickup and drop-off locations.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        double distance = 5.0; // Sample distance in km
        double duration = 10.0; // Sample duration in minutes
        _eta = "ETA: $duration mins";
        _price =
            "Price: \$${(baseFare + distance * ratePerKm + duration * ratePerMinute).toStringAsFixed(2)}";
        _isLoading = false;
      });
    });
  }
}

class MapSelectionScreen extends StatefulWidget {
  const MapSelectionScreen({super.key});

  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  late GoogleMapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  final bool _isLoading = true;
  static const LatLng _initialPosition = LatLng(37.7749, -122.4194);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location on Map")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng latLng) {
              Navigator.pop(context, latLng);
            },
          ),
        ],
      ),
    );
  }
}
