import 'package:flutter/material.dart';

class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  final String touristId = "TOURIST-ABC123";
  final String mockLocation = "27.1767° N, 78.0081° E (Agra)";

  void _sendPanic(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("🚨 Panic Alert Sent"),
        content: Text(
          "Tourist ID: $touristId\n"
          "Last GPS: $mockLocation\n\n"
          "Authorities & emergency contacts have been notified (mock).",
        ),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        icon: const Icon(Icons.sos, size: 32),
        label: const Text("PANIC BUTTON", style: TextStyle(fontSize: 20)),
        onPressed: () => _sendPanic(context),
      ),
    );
  }
}
