import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class NutritionGoals {
  final int calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final int water;

  NutritionGoals({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.water,
  });

  static final _db = FirebaseDatabase.instance.ref();
  static final _auth = FirebaseAuth.instance;

  // Retrieve the current user's nutrition goals.
  static Future<NutritionGoals?> fetchGoals() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final snapshot = await _db.child('nutrition_goals/$userId').get();

    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(
      snapshot.value as Map,
    );

    return NutritionGoals(
      calories: (data['calories'] as num).toInt(),
      protein: (data['protein'] as num).toDouble(),
      carbohydrates: (data['carbohydrates'] as num).toDouble(),
      fat: (data['fat'] as num).toDouble(),
      water: (data['water'] as num).toInt(),
    );
  }

  // Save or update the current user's nutrition goals.
  static Future<void> saveGoals(NutritionGoals goals) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('No user is currently logged in.');
    }

    await _db.child('nutrition_goals/$userId').set({
      'calories': goals.calories,
      'protein': goals.protein,
      'carbohydrates': goals.carbohydrates,
      'fat': goals.fat,
      'water': goals.water,
    });
  }
}