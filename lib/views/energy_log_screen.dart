// import 'package:flutter/material.dart';
// import '../presenters/energy_log_presenter.dart';

// class EnergyLogScreen extends StatefulWidget {
//   const EnergyLogScreen({super.key});

//   @override
//   State<EnergyLogScreen> createState() => _EnergyLogScreenState();
// }

// class _EnergyLogScreenState extends State<EnergyLogScreen> {
//   final EnergyLogPresenter _presenter = EnergyLogPresenter();

//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }

//   Future<void> _loadData() async {
//     await _presenter.loadEnergyLogs();
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   Future<void> _loadEnergyLogs() async {
//     await _presenter.loadEnergyLogs();
//     setState(() => _isLoading = false);
//   }

//   void _showAddEnergyLogDialog() {
//     String newDate = '';
//     String newLog ='';
//     showAdaptiveDialog(
//       context: context,
//       builder: (BuildContext dialogContext) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title: const Text('Add log'),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextField(
//                     decoration: const InputDecoration(
//                       hintText: 'enter date',
//                     ),
//                     onChanged: (value) {
//                       newDate = value;
//                     },
//                   ),

//                   const SizedBox(height: 12),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text('Cancel'),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     if (newDate.trim().isNotEmpty != null) {
//                       await _presenter.addEnergyLog(newDate.trim(), newLog.trim());
//                       setState(() {});
//                       Navigator.pop(dialogContext);
//                     };
//                   },
//                   child: const Text('Add'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final energyLogs = _presenter.energyLog;
    
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Energy'),
//       ),
//       body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
//         itemCount: energyLogs.length,
//         itemBuilder: (context, index) {
//           final log = energyLogs[index];
//           return CheckboxListTile(
//             title: Text(log.dateEnergy),
//             subtitle: Text(log.logEnergy),
//             value: true,
//             onChanged: (_) async {
//               await _presenter.addEnergyLog(log.dateEnergy, log.logEnergy);
//               setState(() {});
//             },
//           );
//         }
//       )
//     );
//   }
// }