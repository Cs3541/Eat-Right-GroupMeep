import 'package:flutter/material.dart';
import '../presenters/nutrition_log_presenter.dart';

class NutritionLogScreen extends StatefulWidget {
  const NutritionLogScreen({super.key});

  @override
  State<NutritionLogScreen> createState() => _NutritionLogScreenState();
}

class _NutritionLogScreenState extends

 State<NutritionLogScreen> {
  final NutritionLogPresenter _presenter = NutritionLogPresenter();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
  await _presenter.loadNutritionLogs();

  if (!mounted) return;

  setState(() {
    _isLoading = false;
    // Keep your existing screen updates here
  });
}

  Future<void> _loadNutritionLogs() async {
    await _presenter.loadNutritionLogs();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddNutritionLogDialog() {
    String newDate = '';
    String newLog ='';
    String newIron ='';
    String newCalcium ='';
    String newFats ='';
    String newSugars ='';
    String newCalories ='';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Nutrition Log'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Date'),
                onChanged: (value) => newDate = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Nutrition Logs"),
                onChanged: (value) => newLog = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Iron'),
                onChanged: (value) => newIron = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Calcium'),
                onChanged: (value) => newCalcium = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Fats'),
                onChanged: (value) => newFats = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Sugars'),
                onChanged: (value) => newSugars = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Calories'),
                onChanged: (value) => newCalories = value,
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
                  await _presenter.addNutritionLog(newDate.trim(), newLog, newIron, newCalcium, newFats, newSugars, newCalories);
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
    final nutritionLogs = _presenter.nutritionLog;
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition Logs')),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ListView.builder(
        itemCount: nutritionLogs.length,
        itemBuilder: ((context, index) {
          final nutritionLog = nutritionLogs[index];
          return ListTile(
            title: Text(nutritionLog.date),
            subtitle: nutritionLog.log != null ? Text(nutritionLog.log!) : null,
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNutritionLogDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}