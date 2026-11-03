import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class NutritionLog {
  final String date;
  final String log;

  NutritionLog(
    {
      required this.date,
      required this.log,
    }
  );

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  static Future<List<NutritionLog>> fetchLogs() async {
    final userId - _auth.currentUser?.uid;
    if (userId == null) return [];

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      data.forEach((key, value) {
        nutritionLogs.add(NutritionLog (
          date: value['date'],
          log: value['log'],
        ));
      });
    }
    return nutritionLogs;
  }

  static Future<void> addLog(String date, String log) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final newRef = _db.child('nutrition_logs/$userId').push();
    await newRef.set({
      'date': date,
      'log': log,
    });
  }
}