import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final int score;
  const ScoreCard({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Safety Score",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "$score / 100",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: score > 70 ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
