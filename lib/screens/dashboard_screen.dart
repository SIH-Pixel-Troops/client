import 'package:flutter/material.dart';
import '../widgets/score_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final int safetyScore = 82;
  final bool isInHighRiskZone = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScoreCard(score: safetyScore),
          const SizedBox(height: 20),
          if (isInHighRiskZone)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "⚠️ Alert: You are in a high-risk zone!",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
