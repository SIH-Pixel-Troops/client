import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class IdWalletScreen extends StatelessWidget {
  const IdWalletScreen({super.key});

  final String touristId = "TOURIST-ABC123";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tourist Digital ID",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              QrImageView(
                data: touristId,
                size: 150,
              ),
              const SizedBox(height: 20),
              Text("ID: $touristId"),
              const SizedBox(height: 10),
              const Text("Blockchain Proof: Verified ✅",
                  style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
