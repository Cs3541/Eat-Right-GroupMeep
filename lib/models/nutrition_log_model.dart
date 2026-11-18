import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionLog {
  final String date;
  final String log;
  final String iron;
  final String calcium;
  final String fats;
  final String sugars;
  final String calories;
  NutritionLog({required this.date, required this.log, required this.iron, required this.calcium, required this.fats, required this.sugars, required this.calories});

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<NutritionLog>> fetchLogs() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore.collection('nutrition logs').where('userId', isEqualTo: userId).get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return NutritionLog(
        date: data['date'],
        log: data['log'],
        iron: data['iron'],
        calcium: data['calcium'],
        fats: data['fats'],
        sugars: data['sugars'],
        calories: data['calories'],
      );
    }).toList();
  }

  static Future<void> addLog(String date, String log, String iron, String calcium, String fats, String sugars, String calories) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    await _firestore.collection('nutrition logs').add({
      'log': log,
      'date': date,
      'iron': iron,
      'calcium': calcium,
      'fats': fats,
      'sugars': sugars,
      'calories': calories,
      'userId': userId,
    });
  }
}