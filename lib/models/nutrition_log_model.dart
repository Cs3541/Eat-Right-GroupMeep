import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionLog {
  final String date;
  final String log;
  NutritionLog({required this.date, required this.log});

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<NutritionLog>> fetchLogs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore.collection('nutriton logs').where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return NutritionLog(
        date: data['date'],
        log: data['log'],
      );
    }).toList();
  }

  static Future<void> addLog(String date, String log) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    await _firestore.collection('nutrition logs').add({
      'log': log,
      'date': date,
      'userId': userId,
    });
  }
}