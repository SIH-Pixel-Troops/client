import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/score_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int safetyScore = 0;
  String alertMessage = "";
  bool isLoading = true;
  final String touristId = "TOURIST-ABC123";

  Future<void> _fetchLocationUpdate() async {
    setState(() => isLoading = true);

    try {
      final data = await ApiService.sendLocation(touristId);
      setState(() {
        safetyScore = data["safetyScore"];
        if (data["alerts"] != null && data["alerts"].isNotEmpty) {
          alertMessage = data["alerts"][0]["message"];
        } else {
          alertMessage = "";
        }
      });
    } catch (e) {
      setState(() {
        alertMessage = "❌ Failed to fetch location: $e";
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Safety Score
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ScoreCard(score: safetyScore),
          const SizedBox(height: 24),

          // High-risk Zone Alert
          if (alertMessage.isNotEmpty)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.red, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        alertMessage,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Travel Advisory
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Travel Advisory",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Avoid isolated areas after dark and follow local authority guidelines for safer travel.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Refresh Button
          ElevatedButton.icon(
            onPressed: _fetchLocationUpdate,
            icon: const Icon(Icons.refresh),
            label: const Text("Update Location"),
          ),
        ],
      ),
    );
  }
}
