import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EnergyLog {
  final String dateEnergy;
  final String logEnergy;

  EnergyLog(
    {
      required this.dateEnergy,
      required this.logEnergy,
    }
  );

  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<EnergyLog>> fetchEnergyLogs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];
    final List<EnergyLog> energyLogs = [];

    final snapshot = await _db.collection('energy_logs').doc(userId).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      data.forEach((key, value) {
        energyLogs.add(EnergyLog (
          dateEnergy: value['dateEnergy'],
          logEnergy: value['logEnergy'],
        ));
      });
    }
    return energyLogs;
  }

  static Future<void> addEnergyLog(String dateEnergy, String logEnergy) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final newRef = _db.collection('energy_logs').doc(userId);
    await newRef.set({
      'dateEnergy': dateEnergy,
      'logEnergy': logEnergy,
    });
  }


}