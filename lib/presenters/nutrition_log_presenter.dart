import '../models/nutrition_log_model.dart';
class NutritionLogPresenter {
  final List<NutritionLog> _nutritionLog =[];

  List<NutritionLog> get nutritionLog => _nutritionLog;

  Future<void> loadNutritionLogs() async {
    final fetched = await NutritionLog.fetchLogs();
    _nutritionLog..clear()..addAll(fetched);
  }

  Future<void> addNutritionLog(String date, String log, String calories, String proteins, String fats, String carbs) async {
    await NutritionLog.addLog(date, log, calories, proteins, fats, carbs);
    _nutritionLog.add(NutritionLog(date: date, log: log, calories: calories, proteins: proteins, fats: fats, carbs: carbs));
  }

  int get totalLogCount => _nutritionLog.length;
}