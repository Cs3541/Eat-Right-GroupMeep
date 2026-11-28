import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RecipeModel {
  final String title;
  // final String recipeId;
  final String createdBy;
  // double? rating;
  final String image;
  final String tags;
  final double servings;
  final double minutes;
  final String ingredients;
  final String directions;
  final String notes;

  RecipeModel({required this.title, /* required this.recipeId, */ required this.createdBy, /* this.rating, */ required this.image, required this.tags, required this.servings, required this.minutes, required this.ingredients, required this.directions, required this.notes});

  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<List<RecipeModel>> fetchRecipes() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    final snapshot = await _firestore
      .collection('recipes')
      // .where('title', isEqualTo: title)
      .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return RecipeModel(
        title: data['title'],
        // recipeId: data['RecipeId'],
        createdBy: data['createdBy'],
        // rating: data['rating'],
        image: data['image'],
        tags: data['tags'],
        servings: (data['servings'] as num).toDouble(),
        minutes: (data['minutes'] as num).toDouble(),
        ingredients: data['ingredients'],
        directions: data['directions'],
        notes: data['notes'],
        );
      }).toList();
    }

    static Future<void> addRecipe(String title, String createdBy, /* double? rating, */ String image, String tags, double servings, double minutes, String ingredients, String directions, String notes) async {

      final newRef = _firestore.collection('recipes').doc();
      await newRef.set({
        // 'RecipeId': newRef.id,
        'title': title,
        'createdBy': createdBy,
        // 'rating': rating,
        'image': image,
        'tags': tags,
        'servings': servings,
        'minutes': minutes,
        'ingredients': ingredients,
        'directions': directions,
        'notes': notes,
      });
    }
}