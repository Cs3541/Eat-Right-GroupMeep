import 'package:flutter/material.dart';
import '../presenters/energy_log_presenter.dart';

class EnergyLogScreen extends StatefulWidget {
  const EnergyLogScreen({super.key});

  @override
  State<EnergyLogScreen> createState() => _EnergyLogScreenState();
}

class _EnergyLogScreenState extends State<EnergyLogScreen> {
  final EnergyLogPresenter _presenter = EnergyLogPresenter();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnergyLogs();
  }



  Future<void> _loadEnergyLogs() async {
    await _presenter.loadEnergyLogs();
    setState(() => _isLoading = false);
  }

  void _showAddEnergyLogDialog() {
    String newDate = '';
    String newLog ='';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Energy Log'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Date'),
                onChanged: (value) => newDate = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Energy Log"),
                onChanged: (value) => newLog = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newDate.trim().isNotEmpty) {
                  await _presenter.addEnergyLog(newDate.trim(), newLog);
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final energyLogs = _presenter.energyLog;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Energy Logs')),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: energyLogs.length,
        itemBuilder: (context, index) {
          final energyLog = energyLogs[index];
          return ListTile(
            title: Text(energyLog.dateEnergy),
            subtitle: energyLog.logEnergy != null ? Text(energyLog.logEnergy!) : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEnergyLogDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}