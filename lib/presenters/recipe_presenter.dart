import '../models/recipe_model.dart';

class RecipePresenter {
    final List<RecipeModel> _recipes = [];

    List<RecipeModel> get recipes => _recipes;

    Future<void> loadRecipes() async {
      final fetched = await RecipeModel.fetchRecipes();
      _recipes.clear();
      _recipes.addAll(fetched);
    }

    Future<void> addRecipe(String title, String createdBy, /*double? rating, */ String image, String tags, /* int servings, double time, */ String ingredients, String directions, String notes) async {
      await RecipeModel.addRecipe(title, createdBy, /* rating, */ image, tags, /* servings, time, */ ingredients, directions, notes);
      _recipes.add(RecipeModel(title: title, /* recipeId: '', */ /* rating: rating, */ /* servings: servings, */ /* time: time, */ createdBy: createdBy, image: image, tags: tags, ingredients: ingredients, directions: directions, notes: notes));
      // Note: The RecipeModel constructor does not include recipeId, rating, servings, or time as they are commented out in the model.
    }
}
