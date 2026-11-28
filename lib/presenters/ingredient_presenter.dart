import '../models/ingredient_model.dart';

class IngredientPresenter {
    final List<IngredientModel> _ingredients = [];

    List<IngredientModel> get ingredients => _ingredients;

    Future<void> loadIngredients() async {
      final fetched = await IngredientModel.fetchIngredients();
      _ingredients.clear();
      _ingredients.addAll(fetched);
    }
}
