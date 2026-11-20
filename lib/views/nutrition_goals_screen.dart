import 'package:flutter/material.dart';

import '../models/nutrition_goals_model.dart';
import '../presenters/nutrition_goals_presenter.dart';
import '../theme/app_theme.dart';

class NutritionGoalsScreen extends StatefulWidget {
  const NutritionGoalsScreen({super.key});

  @override
  State<NutritionGoalsScreen> createState() =>
      _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState
    extends State<NutritionGoalsScreen> {
  final NutritionGoalsPresenter _presenter =
      NutritionGoalsPresenter();

  final _formKey = GlobalKey<FormState>();

  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  // Load existing goals when the screen opens.
  Future<void> _loadGoals() async {
    try {
      await _presenter.loadGoals();

      final goals = _presenter.goals;

      if (goals != null) {
        _caloriesController.text = goals.calories.toString();
        _proteinController.text = goals.protein.toString();
        _carbsController.text =
            goals.carbohydrates.toString();
        _fatController.text = goals.fat.toString();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not load goals: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Validate and save nutrition goals.
  Future<void> _saveGoals() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final goals = NutritionGoals(
      calories: int.parse(_caloriesController.text),
      protein: double.parse(_proteinController.text),
      carbohydrates: double.parse(_carbsController.text),
      fat: double.parse(_fatController.text),
    );

    try {
      await _presenter.saveGoals(goals);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nutrition goals saved successfully!',
          ),
          backgroundColor: AppTheme.darkGreen,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not save goals: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildGoalField({
    required String label,
    required String unit,
    required TextEditingController controller,
    bool wholeNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
        ),
        decoration: InputDecoration(
          labelText: label,
          suffixText: unit,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter a $label target';
          }

          final number = double.tryParse(value);

          if (number == null ||
              !number.isFinite ||
              number <= 0) {
            return 'Enter a valid positive number';
          }

          if (wholeNumber &&
              number != number.roundToDouble()) {
            return 'Please enter a whole number';
          }

          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightGreen,

      appBar: AppBar(
        title: const Text(
          'Nutrition Goals',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppTheme.darkGreen,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const Center(
                      child: Icon(
                        Icons.track_changes,
                        size: 48,
                        color: AppTheme.mutedRed,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Center(
                      child: Text(
                        'Set Your Daily Goals',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Customize your daily nutrition goals. '
                      'You can update these goals whenever you need to.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.darkBrown
                            .withValues(alpha: 0.7),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Goal input card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daily Nutrition Targets',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                            ),

                            const SizedBox(height: 20),

                            _buildGoalField(
                              label: 'Daily Calories',
                              unit: 'kcal',
                              controller: _caloriesController,
                              wholeNumber: true,
                            ),

                            _buildGoalField(
                              label: 'Protein',
                              unit: 'g',
                              controller: _proteinController,
                            ),

                            _buildGoalField(
                              label: 'Carbohydrates',
                              unit: 'g',
                              controller: _carbsController,
                            ),

                            _buildGoalField(
                              label: 'Fat',
                              unit: 'g',
                              controller: _fatController,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed:
                            _isSaving ? null : _saveGoals,
                        icon: _isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(
                          _isSaving
                              ? 'Saving...'
                              : 'Save Goals',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}