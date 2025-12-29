import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  /// Production backend URL
  static const String baseUrl =
      "10.0.2.2:3000"; // Use localhost for Android emulator

  // ============================
  // 🔐 Headers (Firebase Auth)
  // ============================
  static Future<Map<String, String>> _headers() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const {
        "Content-Type": "application/json",
      };
    }

    final token = await user.getIdToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ============================
  // 📍 Location Utilities
  // ============================
  static Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception("Location services are disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Location permission denied");
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ============================
  // 📡 Send Location
  // ============================
  static Future<Map<String, dynamic>> sendLocation(String touristId) async {
    final pos = await _getCurrentLocation();

    final response = await http.post(
      Uri.parse("$baseUrl/api/location"),
      headers: await _headers(),
      body: jsonEncode({
        "touristId": touristId,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send location (${response.statusCode})");
    }

    return jsonDecode(response.body);
  }

  // ============================
  // 🚨 Panic Alert
  // ============================
  static Future<Map<String, dynamic>> sendPanic(String touristId) async {
    final pos = await _getCurrentLocation();

    final response = await http.post(
      Uri.parse("$baseUrl/api/panic"),
      headers: await _headers(),
      body: jsonEncode({
        "touristId": touristId,
        "latitude": pos.latitude,
        "longitude": pos.longitude,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to send panic alert");
    }

    return jsonDecode(response.body);
  }

  // ============================
  // 🆔 Generate Tourist ID (ONE-TIME)
  // ============================
  static Future<Map<String, dynamic>> generateTouristId({
    required String touristId,
    required String name,
    required String tripStart,
    required String tripEnd,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/generate-id"),
      headers: await _headers(),
      body: jsonEncode({
        "touristId": touristId,
        "name": name,
        "tripStart": tripStart,
        "tripEnd": tripEnd,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Failed to generate tourist ID (${response.statusCode})",
      );
    }

    /*
      Expected response:
      {
        touristId,
        blockchainProof,
        transactionHash,
        mode
      }
    */

    return jsonDecode(response.body);
  }
}
