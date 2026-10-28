import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ingredient_model.dart';
import 'tag_model.dart';


class Recipe {
    final String title;
    final User postedBy;
    final String instructions;
    final List<Ingredient>? ingredients;
    final List<Tag>? tags;

    Recipe({required this.title, required this.postedBy, required this.instructions, this.ingredients, this.tags});

    static final _firestore = FirebaseFirestore.instance;

    static Future<List<Recipe>> fetchRecipes() async {

      final snapshot = await _firestore.collection('recipes').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Recipe(
          title: data['title'],
          postedBy: data['postedBy'],
          instructions: data['instructions'],
          ingredients: data['ingredients'],
          tags: data['tags'],
        );
      }).toList();
    }

    static Future<void> addRecipe(String title, User postedBy, String instructions, List<Ingredient>? ingredients, List<Tag>? tags) async {
      await _firestore.collection('recipes').add({
        'title': title,
        'postedBy': postedBy,
        'instructions': instructions,
        'ingredients': ingredients,
        'tags': tags,
      });
    }
}