import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:pedal_application/screens/home_screen.dart';

import '../controller/main_controller.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController _noteController = TextEditingController();
  bool _isPWD = false;
  bool _showProceedBtn = true;
  String _selectedPWDType = '';
  final Random random = Random();
  final MainController mainController = Get.put(MainController());
  bool _isLoading = false;
  bool _isLoadingConfirmBooking = false;
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

  double _etaMinutes = 0;
  double _priceValue = 0;

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

    Future<void> bookingHandler() async {
      final url = Uri.parse(
          'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/booking'); // Replace with your API URL

      final payload = {
        "driverId": null,
        "customerId": mainController.getCurrentUser().id,
        "isPwd": _isPWD,
        "pwdType": _selectedPWDType,
        "notes": "",
        "dateCompleted": null,
        "isActive": true,
        "bookingStatus": "IN-PROGRESS",
        "eta": _etaMinutes,
        "price": _priceValue,
        "startLocation": _fromController.text,
        "destination": _toController.text,
      };

      // Send POST request
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type':
                'application/json', // Required for sending JSON data
          },
          body: jsonEncode(payload), // Convert requestData to JSON
        );

        // Check the response status
        if (response.statusCode == 200) {
          setState(() {
            _isLoadingConfirmBooking = true;
          });

          Future.delayed(Duration(seconds: 3), () {
            Get.snackbar(
                'Success', // Title
                'Book Confirmed successfully!');
            setState(() {
              _isLoadingConfirmBooking = false;
            });
            Get.to(() => HomeScreen());
          });
        } else {
          print("ERROR HERE!");
          Get.snackbar(
            'Error',
            "User not found",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        print(e);
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking Screen"),
        backgroundColor: Colors.tealAccent[700],
      ),
      body: Center(
        child: Container(
          width: mobileWidth, // Fixed width similar to login page
          height: 800, // Dynamic height, adjusted like login page
          padding: const EdgeInsets.all(20.0), // Optional padding for better UI
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Custom Header
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    "Book Now! Your City Your Way!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent[700],
                    ),
                  ),
                ),
                // Map at the top of the screen
                Container(
                  height:
                      screenHeight * 0.35, // Make map height dynamic as well
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
                              zoom: 16.0,
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
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _buildLocationFields(),
                      const SizedBox(height: 50),
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

                                if (value != _isPWD) {
                                  _showProceedBtn = true;
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
                      if (_showProceedBtn) const SizedBox(height: 30),
                      if (_showProceedBtn)
                        ElevatedButton(
                          onPressed: _proceedBooking,
                          child: const Text("Proceed"),
                        ),
                      if (!_showProceedBtn) const SizedBox(height: 30),
                      if (!_showProceedBtn)
                        Container(
                          width: 350, // Set the width of the container
                          padding: EdgeInsets.all(
                              16), // Add padding inside the container
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Background color of the container
                            borderRadius:
                                BorderRadius.circular(16), // Rounded corners
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 4), // Shadow position
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the start
                            children: [
                              Text(
                                'Booking Details',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              _isLoading
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center, // Vertically center
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center, // Horizontally center
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 8,
                                        ),
                                        SizedBox(
                                            height:
                                                10), // Adds some spacing between the spinner and text
                                        Text("Calculating ETA and cost..."),
                                      ],
                                    ) // Shows the loading spinner
                                  : Column(
                                      children: [
                                        SizedBox(
                                            height:
                                                16), // Add spacing between title and content
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'ETA',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '15 mins', // Example ETA
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.grey,
                                          thickness: 1,
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _eta,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              _price, // Example cost
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                            ],
                          ),
                        ),
                      if (!_showProceedBtn && !_isLoading)
                        const SizedBox(height: 30),
                      if (!_showProceedBtn && !_isLoading)
                        ElevatedButton(
                          onPressed: () {
                            _showConfirmationDialog(context, bookingHandler);
                          },
                          child: const Text("Confirm Booking"),
                        ),
                    ],
                  ),
                )
                // Your existing content (location fields, summary, etc.)
              ],
            ),
          ),
        ),
      ),
    );
  }

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
    "Other" // Add "Other" option if needed
  ];
  String? otherInput; // To hold input if "Other" is selected
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
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, Function handler) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _isLoadingConfirmBooking
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertically center
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontally center
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 8,
                  ),
                  SizedBox(
                      height:
                          10), // Adds some spacing between the spinner and text
                  Text("Confirm Booking..."),
                ],
              ) // Shows the loading spinner
            : AlertDialog(
                title: Text('Confirm Booking'),
                content: Text('Are you sure you want to confirm the booking?'),
                actions: <Widget>[
                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('Cancel'),
                  ),
                  // Confirm button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      handler();
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildLocationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLocationField(
                controller: _fromController,
                hint: "Enter pickup location",
                onChanged: (value) {
                  _fetchPlaces(value, "from");
                  setState(() {
                    _showProceedBtn = true;
                  });
                },
                suggestions: _fromPlaceSuggestions,
                onSelectSuggestion: (place) async {
                  _fetchPlaceDetails(place['place_id'], (details) async {
                    setState(() async {
                      _fromLocation = LatLng(details['lat'], details['lng']);
                      // Await the icon loading here
                      BitmapDescriptor icon =
                          await BitmapDescriptor.fromAssetImage(
                        ImageConfiguration(size: Size(24, 24)),
                        'lib/assets/location-icon/car.png',
                      );
                      _markers.add(Marker(
                        markerId: const MarkerId('from_location'),
                        position: _fromLocation!,
                        icon: icon, // Use the icon after awaiting
                      ));
                      _mapController.animateCamera(
                          CameraUpdate.newLatLng(_fromLocation!));
                    });
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: _buildLocationField(
                controller: _toController,
                hint: "Enter drop-off location",
                onChanged: (value) {
                  _fetchPlaces(value, "to");
                  setState(() {
                    _showProceedBtn = true;
                  });
                },
                suggestions: _toPlaceSuggestions,
                onSelectSuggestion: (place) async {
                  _fetchPlaceDetails(place['place_id'], (details) async {
                    setState(() async {
                      _toLocation = LatLng(details['lat'], details['lng']);
                      // Await the icon loading here
                      BitmapDescriptor icon =
                          await BitmapDescriptor.fromAssetImage(
                        ImageConfiguration(size: Size(24, 24)),
                        'lib/assets/location-icon/destination.png',
                      );
                      _markers.add(Marker(
                        markerId: const MarkerId('to_location'),
                        position: _toLocation!,
                        icon: icon, // Use the icon after awaiting
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
    final url =
        'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/places?input=$query';

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
    final url =
        'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/places/details?place_id=$placeId';

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

  void _proceedBooking() {
    if (_fromController.text == '' ||
        _fromLocation == null ||
        _toController.text == '' ||
        _toLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both pickup and drop-off locations."),
        ),
      );
      return;
    }

    // Check if the note exceeds 500 characters
    if (_noteController.text.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note cannot exceed 500 characters."),
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
          color: Colors.black,
          points: value['routePoints'],
          width: 3, // Adjust this value for a thinner polyline (default is 10)
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
        _showProceedBtn = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });

      print(e.toString());
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

      setState(() {
        _etaMinutes = (duration / 60).toDouble();
        _priceValue = (baseFare +
                ratePerKm * (distance / 1000) +
                ratePerMinute * (duration / 60))
            .toDouble();
      });

      final eta = "${_etaMinutes.toStringAsFixed(0)} minutes";

      final price = "₱${_priceValue.toStringAsFixed(0)}";

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
