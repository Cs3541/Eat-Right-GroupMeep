// import '../models/energy_log_model.dart';
// class EnergyLogPresenter {
//   final List<EnergyLog> _energyLog = [];

//   List<EnergyLog> get energyLog => _energyLog;

//   Future<void> loadEnergyLogs() async {
//     final fetched = await EnergyLog.fetchEnergyLogs();
//     _energyLog..clear()..addAll(fetched);
//   }

//   Future<void> addEnergyLog(String dateEnergy, String logEnergy) async {
//     await EnergyLog.addEnergyLog(dateEnergy, logEnergy);
//     _energyLog.add(EnergyLog(dateEnergy: dateEnergy, logEnergy: logEnergy));
//   }

//   int get totalLogCount => _energyLog.length;

// }