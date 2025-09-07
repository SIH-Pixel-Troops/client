import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class IdWalletScreen extends StatelessWidget {
  const IdWalletScreen({super.key});

  final String touristId = "TOURIST-ABC123";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Tourist Digital ID",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              QrImageView(
                data: touristId,
                size: 180,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Text("ID: $touristId",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Text(
                "Blockchain Proof: Verified ✅",
                style: TextStyle(color: Colors.green.shade400, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
