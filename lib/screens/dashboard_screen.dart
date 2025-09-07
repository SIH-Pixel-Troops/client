import 'package:flutter/material.dart';
import '../widgets/score_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final int safetyScore = 82;
  final bool isInHighRiskZone = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Safety Score Card
          ScoreCard(score: safetyScore),
          const SizedBox(height: 24),

          // High-risk Zone Alert
          if (isInHighRiskZone)
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
                        "⚠️ Alert: You are in a high-risk zone!",
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

          // Extra Info (Optional)
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text(
                    "Avoid isolated areas after dark and follow local authority guidelines for safer travel.",
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
