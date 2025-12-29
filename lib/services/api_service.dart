import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ApiService {
  // iOS Simulator -> "http://localhost:3000"
  // Android Emulator -> "http://10.0.2.2:3000"
  // Real Device -> "http://<LocalAPI>:3000"
  static const String baseUrl = "https://backend-safarsuraksha.onrender.com";

  /// Get current GPS location
  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied. Enable them in settings.");
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Send location → backend
  static Future<Map<String, dynamic>> sendLocation(String touristId) async {
    final pos = await getCurrentLocation();

    final response = await http.post(
      Uri.parse("$baseUrl/api/location"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "touristId": touristId,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send location: ${response.statusCode}");
    }
  }

  /// Send panic alert → backend
  static Future<Map<String, dynamic>> sendPanic(String touristId) async {
    final pos = await getCurrentLocation();

    final response = await http.post(
      Uri.parse("$baseUrl/api/panic"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "touristId": touristId,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to send panic alert: ${response.statusCode}");
    }
  }

  // Generate tourist ID : backend
  static Future<Map<String, dynamic>> generateTouristId(
      String touristId, String name, String tripStart, String tripEnd) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/generate-id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "touristId": touristId,
        "name": name,
        "tripStart": tripStart,
        "tripEnd": tripEnd,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to generate tourist ID");
    }
  }
}
