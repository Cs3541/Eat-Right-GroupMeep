
import '../models/nutrition_goals_model.dart';

class NutritionGoalsPresenter {
  NutritionGoals? _goals;

  // Allows other screens to access the loaded goals.
  NutritionGoals? get goals => _goals;

  bool get hasGoals => _goals != null;

  Future<void> loadGoals() async {
    _goals = await NutritionGoals.fetchGoals();
  }

  Future<void> saveGoals(NutritionGoals goals) async {
    await NutritionGoals.saveGoals(goals);
    _goals = goals;
  }
}