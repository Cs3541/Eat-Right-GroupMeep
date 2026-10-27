import '../models/nutrition_log_model.dart';
class NutritionLogPresenter {
  final List<NutritionLog> _nutritionLog =[];

  List<NutritionLog> get nutritionLog => _nutritionLog;

  Future<void> loadNutritionLogs() async {
    final fetched = await NutritionLog.fetchLogs();
    _nutritionLog..clear()..addAll(fetched);
  }

  Future<void> addNutritionLog(String date, String log) async {
    await NutritionLog.addLog(date, log);
    _nutritionLog.add(NutritionLog(date: date, log: log));
  }

  int get totalLogCount => _nutritionLog.length;
}