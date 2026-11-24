import '../models/recipe_model.dart';

class RecipePresenter {
    final List<RecipeModel> _recipes = [];

    List<RecipeModel> get recipes => _recipes;

    Future<void> loadRecipes() async {
      final fetched = await RecipeModel.fetchRecipes();
      _recipes.clear();
      _recipes.addAll(fetched);
    }

    Future<void> addRecipe(String title, String createdBy, /*double? rating, */ String imageTEMP, String tags, /* int servings, double time, */ String ingredients, String directions, String notes) async {
      await RecipeModel.addRecipe(title, createdBy, /* rating, */ imageTEMP, tags, /* servings, time, */ ingredients, directions, notes);
      _recipes.add(RecipeModel(title: title, /* recipeId: '', */ /* rating: rating, */ /* servings: servings, */ /* time: time, */ createdBy: createdBy, imageTEMP: imageTEMP, tags: tags, ingredients: ingredients, directions: directions, notes: notes));
      // Note: The RecipeModel constructor does not include recipeId, rating, servings, or time as they are commented out in the model.
    }
}





// import 'package:groupmeepeatright/views/recipe_page.dart';

// import '../models/recipe_model.dart';

// class RecipePresenter {
//   final RecipePage _view;

//   RecipePresenter(this._view);

//   // Example method triggered by user interaction in the UI
//   Future<void> loadRecipe(String recipeId) async {
//     _view.showLoading();

//     try {
//       // Simulate fetching data from a Model/Repository
//       // UserModel model = await repository.fetchUser(userId);
//       Recipe mockRecipe = Recipe(
//         recipeId: recipeId,
//         title: 'Sample Recipe',
//         createdBy: 'Sample User',
//         rating: 4.5,
//         imageTEMP: 'sample_image.jpg',
//         tags: ['tag1', 'tag2'],
//         servings: 4,
//         time: 30,
//         ingredientsAmounts: {},
//         directions: 'direction1, direction2',
//         notes: 'Sample notes',
//       );

//       _view.hideLoading();
//       _view.showRecipe(mockRecipe);
//     } catch (e) {
//       _view.hideLoading();
//       _view.showError('Failed to load recipe: $e');
//     }
//   }
// }
