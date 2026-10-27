import 'package:flutter/material.dart';
import '../presenters/nutrition_log_presenter.dart';

class NutritionLogScreen extends StatefulWidget {
  const NutritionLogScreen({super.key});

  @override
  State<NutritionLogScreen> createState() => _NutritionLogScreenState();
}

class _NutritionLogScreenState extends State<NutritionLogScreen> {
  final NutritionLogPresenter _presenter = NutritionLogPresenter();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void _loadData() async {
    await _presenter.loadNutritionLogs();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadNutritionLogs() async {
    await _presenter.loadNutritionLogs();
    setState(() => _isLoading = false);
  }

  void _showAddNutritionLogDialog() {
    String newDate = '';
    showAdaptiveDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add log'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'enter date',
                    ),
                    onChanged: (value) {
                      newDate = value;
                    },
                  ),
                  const SizedBox(height: 12),


                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (newDate.trim().isNotEmpty != null) {
                      await _presenter.addNutritionLog(newDate.trim());
                      setState(() {});
                      Navigator.pop(dialogContext);
                    },
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nutritionLogs = _presenter.nutritionLog;
    
    return Scaffold(
      appBar: AppBar(
      ],)
    )
  }
}