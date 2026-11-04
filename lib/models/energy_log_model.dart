import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class EnergyLog {
  final String dateEnergy;
  final String logEnergy;

  EnergyLog(
    {
      required this.dateEnergy,
      required this.logEnergy,
    }
  );

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  static Future<List<EnergyLog>> fetchEnergyLogs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];
    final List<EnergyLog> energyLogs = [];

    final snapshot = await _db.child('energy_logs/$userId').get();
    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
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
    final newRef = _db.child('energy_logs/$userId').push();
    await newRef.set({
      'date': dateEnergy,
      'log': logEnergy,
    });
  }


}