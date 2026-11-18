import '../models/nutrition_log_model.dart';
class NutritionLogPresenter {
  final List<NutritionLog> _nutritionLog =[];

  List<NutritionLog> get nutritionLog => _nutritionLog;

  Future<void> loadNutritionLogs() async {
    final fetched = await NutritionLog.fetchLogs();
    _nutritionLog..clear()..addAll(fetched);
  }

  Future<void> addNutritionLog(String date, String log, String iron, String calcium, String fats, String sugars, String calories) async {
    await NutritionLog.addLog(date, log, iron, calcium, fats, sugars, calories);
    _nutritionLog.add(NutritionLog(date: date, log: log, iron: iron, calcium: calcium, fats: fats, sugars: sugars, calories: calories));
  }

  int get totalLogCount => _nutritionLog.length;
}