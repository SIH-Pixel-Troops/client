import 'package:flutter/material.dart';

class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  final String touristId = "TOURIST-ABC123";
  final String mockLocation = "27.1767° N, 78.0081° E (Agra)";

  void _sendPanic(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Press the button below in case of emergency",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),

        // Circular Panic Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(60), // bigger circular button
            elevation: 10,
            shadowColor: Colors.redAccent,
          ),
          onPressed: () => _sendPanic(context),
          child: const Icon(Icons.sos, size: 60),
        ),

        const SizedBox(height: 20),
        const Text(
          "Your Tourist ID & live GPS will be shared automatically.",
          style: TextStyle(fontSize: 14, color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
