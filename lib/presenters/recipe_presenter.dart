import '../models/recipe_model.dart';

class RecipePresenter {
    final List<RecipeModel> _recipes = [];

    List<RecipeModel> get recipes => _recipes;

    Future<void> loadRecipes() async {
      final fetched = await RecipeModel.fetchRecipes();
      _recipes.clear();
      _recipes.addAll(fetched);
    }

    Future<void> addRecipe(String title, String createdBy, /*double? rating, */ String image, String tags, double servings, double minutes, String ingredients, String directions, String notes) async {
      await RecipeModel.addRecipe(title, createdBy, /* rating, */ image, tags, servings, minutes, ingredients, directions, notes);
      // Note: The RecipeModel.addRecipe method does not include recipeId or rating as they are commented out in the model.
      _recipes.add(RecipeModel(title: title, /* recipeId: '', */ /* rating: rating, */ servings: servings, minutes: minutes, createdBy: createdBy, image: image, tags: tags, ingredients: ingredients, directions: directions, notes: notes));
      // Note: The RecipeModel constructor does not include recipeId or rating as they are commented out in the model.
      // This ensures that the local list of recipes stays in sync with the database.
    }
}
