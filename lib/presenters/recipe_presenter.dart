import '../models/recipe_model.dart';
import '../models/ingredient_model.dart';
import '../models/tag_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipePresenter {
    final List<Recipe> _recipes = [];

    List<Recipe> get recipes => _recipes;

    Future<void> loadRecipes() async {
      final fetched = await Recipe.fetchRecipes();
      _recipes.clear();
      _recipes.addAll(fetched);
    }

    Future<void> addRecipe(String title, User postedBy, String instructions, List<Ingredient>? ingredients, List<Tag>? tags) async {
      await Recipe.addRecipe(title, postedBy, instructions, ingredients, tags);
      _recipes.add(Recipe(title: title, postedBy: postedBy, instructions: instructions, ingredients: ingredients, tags: tags));
    }
}