import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnergyLog {
  final String dateEnergy;
  final String logEnergy;
  EnergyLog({required this.dateEnergy, required this.logEnergy});

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<EnergyLog>> fetchEnergyLogs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore.collection('energy logs').where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return EnergyLog(
        dateEnergy: data['dateEnergy'],
        logEnergy: data['logEnergy'],
      );
    }).toList();
  }

  static Future<void> addEnergyLog(String dateEnergy, String logEnergy) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    await _firestore.collection('energy logs').add({
      'dateEnergy': dateEnergy,
      'logEnergy': logEnergy,
      'userId': userId,
    });
  }
}