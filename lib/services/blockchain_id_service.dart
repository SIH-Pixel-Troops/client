import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlockchainIdService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Save blockchain ID under current user
  Future<void> saveBlockchainId({
    required String touristId,
    required String tripHash,
    required String? transactionHash,
    required String mode,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final uid = user.uid;

    await _db.collection('users').doc(uid).set({
      "blockchain": {
        "touristId": touristId,
        "tripHash": tripHash,
        "transactionHash": transactionHash,
        "mode": mode,
      },
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Fetch blockchain ID if exists
  Future<Map<String, dynamic>?> getBlockchainId() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _db.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;

    return doc.data()?['blockchain'];
  }
}
