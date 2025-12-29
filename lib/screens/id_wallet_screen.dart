import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/api_service.dart';
import '../services/blockchain_id_service.dart';

class IdWalletScreen extends StatefulWidget {
  const IdWalletScreen({super.key});

  @override
  State<IdWalletScreen> createState() => _IdWalletScreenState();
}

class _IdWalletScreenState extends State<IdWalletScreen> {
  String? qrData;
  String? blockchainProof;
  bool isLoading = true;

  final _blockchainService = BlockchainIdService();

  @override
  void initState() {
    super.initState();
    _loadOrGenerateQr();
  }

  // ============================
  // CORE LOGIC (FIXED)
  // ============================
  Future<void> _loadOrGenerateQr() async {
    try {
      // 🔐 Ensure user is logged in
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      // 1️⃣ Check Firestore first
      final existing = await _blockchainService.getBlockchainId();

      if (existing != null) {
        // ♻️ Reuse stored blockchain ID
        final payload = jsonEncode({
          "touristId": existing["touristId"],
          "transactionHash": existing["transactionHash"],
          "proof": existing["tripHash"],
          "mode": existing["mode"],
        });

        setState(() {
          qrData = payload;
          blockchainProof = existing["tripHash"];
          isLoading = false;
        });

        return;
      }

      // 2️⃣ Generate NEW blockchain ID (only once)
      final touristId = "TOURIST-${DateTime.now().millisecondsSinceEpoch}";

      final data = await ApiService.generateTouristId(
        touristId: touristId,
        name: "John Doe",
        tripStart: "2025-09-08",
        tripEnd: "2025-09-15",
      );

      // 3️⃣ Save to Firestore (CRITICAL STEP)
      await _blockchainService.saveBlockchainId(
        touristId: data["touristId"],
        tripHash: data["blockchainProof"],
        transactionHash: data["transactionHash"],
        mode: data["mode"],
      );

      // 4️⃣ Build QR payload
      final qrPayload = jsonEncode({
        "touristId": data["touristId"],
        "transactionHash": data["transactionHash"],
        "proof": data["blockchainProof"],
        "mode": data["mode"],
      });

      setState(() {
        qrData = qrPayload;
        blockchainProof = data["blockchainProof"];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("QR generation error: $e");
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
      return const Center(child: Text("❌ Failed to load Tourist ID"));
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
              Text(
                "Blockchain Proof:",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              SelectableText(
                blockchainProof!,
                style: const TextStyle(
                  fontSize: 9.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
