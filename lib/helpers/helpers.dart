import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Helper function to decode a Google Maps polyline encoded string.
List<LatLng> decodePolyline(String polyline) {
  var points = <LatLng>[];
  var index = 0;
  var len = polyline.length;
  var lat = 0;
  var lng = 0;

  while (index < len) {
    int shift = 0;
    int result = 0;
    int byte;
    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      byte = polyline.codeUnitAt(index++) - 63;
      result |= (byte & 0x1F) << shift;
      shift += 5;
    } while (byte >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    points.add(LatLng(lat / 1E5, lng / 1E5));
  }

  return points;
}
