import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ingredient_model.dart';

class Recipe {
  final String title;
  int rating;
  final String imageTEMP;
  final List<String> tags;
  final int servings;
  final double time;
  final Map<double, Ingredient> ingredientAmounts;
  final String directions;
  final String notes;

  static final createdBy = FirebaseAuth.instance;

  static final _db = FirebaseDatabase.instance.ref();

  Recipe(
    {
      required this.title,
      required this.rating,
      required this.imageTEMP,
      required this.tags,
      required this.servings,
      required this.time,
      required this.ingredientAmounts,
      required this.directions,
      required this.notes,
    }
  );

  static Future<void> addRecipe(String title, int rating, String imageTEMP, List<String> tags, int servings, double time, Map<double, Ingredient> ingredientAmounts, String directions, String notes) async {
    final userId = createdBy.currentUser?.uid;
    if (userId == null) return;
    final newRef = _db.child('nutrition_logs/$userId').push();
    await newRef.set({
      'title': title,
      'rating': rating, 
      'imageTEMP': imageTEMP,
      'tags': tags,
      'servings': servings,
      'time': time,
      'ingredientAmounts': ingredientAmounts,
      'directions': directions,
      'notes': notes,
    });
  }
}