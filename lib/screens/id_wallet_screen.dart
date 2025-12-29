import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/api_service.dart';

class IdWalletScreen extends StatefulWidget {
  const IdWalletScreen({super.key});

  @override
  State<IdWalletScreen> createState() => _IdWalletScreenState();
}

class _IdWalletScreenState extends State<IdWalletScreen> {
  String? qrData;
  String? blockchainProof;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateQr();
  }

Future<void> _generateQr() async {
  try {
    final data = await ApiService.generateTouristId(
      "TOURIST-ABC123",
      "John Doe",
      "2025-09-08",
      "2025-09-15",
    );

    // ✅ Frontend constructs QR payload
    final qrPayload = jsonEncode({
      "touristId": data["touristId"],
      "name": data["name"],
      "tripStart": data["tripStart"],
      "tripEnd": data["tripEnd"],
      "transactionHash": data["transactionHash"],
      "proof": data["blockchainProof"],
      "mode": data["mode"]
    });

    setState(() {
      qrData = qrPayload;
      blockchainProof = data["blockchainProof"];
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      isLoading = false;
      qrData = null;
      blockchainProof = null;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (qrData == null) {
      return const Center(child: Text("❌ Failed to generate QR"));
    }

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
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
                data: qrData!,
                size: 180,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Text("Blockchain Proof:", style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 8),
              Center(
                child: SelectableText(
                  blockchainProof!,
                  style: const TextStyle(fontSize: 9.4, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
