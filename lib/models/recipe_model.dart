
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ingredient_model.dart';

class RecipeModel {
  final String title;
  final String recipeId;
  final String createdBy;
  double rating;
  final String imageTEMP;
  final List<String> tags;
  final int servings;
  final double time;
  final Map<double, Ingredient> ingredientsAmounts;
  final String directions;
  final String notes;

  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  RecipeModel(
    {
      required this.title,
      required this.recipeId,
      required this.createdBy,
      required this.rating,
      required this.imageTEMP,
      required this.tags,
      required this.servings,
      required this.time,
      required this.ingredientsAmounts,
      required this.directions,
      required this.notes,
    }
  );

  static Future<void> addRecipe(String title, double rating, String imageTEMP, List<String> tags, int servings, double time, Map<double, Ingredient> ingredientsAmounts, String directions, String notes) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;
    final newRef = _db.collection('recipes').doc();
    await newRef.set({
      'RecipeId': newRef.id,
      'title': title,
      'createdBy': userId,
      'rating': rating, 
      'imageTEMP': imageTEMP,
      'tags': tags,
      'servings': servings,
      'time': time,
      'ingredientAmounts': ingredientsAmounts,
      'directions': directions,
      'notes': notes,
    });
  }

  static Future<RecipeModel?> fetchRecipe(String recipeId) async {
    final snapshot = await _db.collection('recipes').where('RecipeId', isEqualTo: recipeId).get();
    if (snapshot.docs.isEmpty) return null;
    final data = snapshot.docs.first.data();
    return RecipeModel(
      title: data['title'],
      recipeId: data['RecipeId'],
      createdBy: data['createdBy'],
      rating: data['rating'],
      imageTEMP: data['imageTEMP'],
      tags: List<String>.from(data['tags']),
      servings: data['servings'],
      time: (data['time'] as num).toDouble(),
      ingredientsAmounts: Map<double, Ingredient>.from(data['ingredientAmounts']),
      directions: data['directions'],
      notes: data['notes'],
    );
  }

}