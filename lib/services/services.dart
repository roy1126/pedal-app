import 'dart:convert';
import 'package:http/http.dart' as http;


class GoogleMapService {
  final String apiKey;

  GoogleMapService(this.apiKey);

  Future<List<String>> getPlaceSuggestions(String input) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['predictions'].map((p) => p['description']));
    } else {
      throw Exception("Failed to fetch suggestions");
    }
  }

  Future<Map<String, dynamic>> getDirections(String origin, String destination) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch directions");
    }
  }

  Future<Map<String, dynamic>> getDistanceMatrix(String origin, String destination) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origin&destinations=$destination&key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch distance matrix");
    }
  }
}
