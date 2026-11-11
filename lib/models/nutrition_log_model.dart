import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionLog {
  final String date;
  final String log;
  final String calories;
  final String proteins;
  final String fats;
  final String carbs;
  NutritionLog({required this.date, required this.log, required this.calories, required this.proteins, required this.fats, required this.carbs});

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
        calories: data['calories'],
        proteins: data['proteins'],
        fats: data['fats'],
        carbs: data['carbs']
      );
    }).toList();
  }

  static Future<void> addLog(String date, String log, String calories, String proteins, String fats, String carbs) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    await _firestore.collection('nutrition logs').add({
      'log': log,
      'date': date,
      'calories': calories,
      'proteins': proteins,
      'fats': fats,
      'carbs': carbs,
      'userId': userId,
    });
  }
}