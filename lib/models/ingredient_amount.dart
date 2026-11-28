import '../models/ingredient_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IngredientAmount {
  final DocumentReference ingredient;
  final double amount;

  IngredientAmount({
    required this.ingredient,
    required this.amount,
  });

  // Create an object from a Firestore Map
  factory IngredientAmount.fromMap(Map<IngredientModel, dynamic> map) {
    return IngredientAmount(
      amount: (map['amount'] as num).toDouble(),
      ingredient: map['ingredient'] as DocumentReference,
    );
  }

  // Convert the object into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'ingredient': ingredient, // Stored as a native Firestore Reference type
    };
  }
}