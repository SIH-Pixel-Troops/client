import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ApiService {
  // ⚠️ Change this if testing on physical device
  // iOS Simulator -> "http://localhost:3000"
  // Android Emulator -> "http://10.0.2.2:3000"
  // Real Device -> "http://<YOUR_LOCAL_IP>:3000"
  static const String baseUrl = "http://localhost:3000";

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
}
