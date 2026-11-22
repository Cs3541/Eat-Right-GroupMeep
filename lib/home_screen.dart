
import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';
import '../models/nutrition_goals_model.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _motivation() {
    final messages = [
      "Keep going, you're doing great!",
      "Consistency beats perfection.",
      "Have a healthy day!",
      "You’re doing better than you think.",
      "Your future self will thank you.",
    ];
    messages.shuffle();
    return messages.first;
  }

  @override
  Widget build(BuildContext context) {
    final presenter = AuthPresenter();
    final email = presenter.getCurrentUserEmail() ?? "Guest";

    // REPLACE WITH FUNCTION TO GET PLANNER + NUTRITION LOG MACROS
    const double caloriesConsumed = 0;
    const double fatConsumed = 0;
    const double carbohydratesConsumed = 0;
    const double proteinConsumed = 0;

    return Scaffold(
      backgroundColor: AppTheme.lightGreen,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: AppTheme.darkGreen,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppTheme.mediumGreen,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome back!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                  ),

                 
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: AppTheme.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.mutedRed,
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: AppTheme.mutedRed,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            Card(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: AppTheme.originalLightGreen,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.eco,
                      color: AppTheme.darkGreen,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _motivation(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontStyle: FontStyle.italic,
                          color: AppTheme.darkBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Today's Summary Card
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: AppTheme.originalLightGreen,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.today,
                          color: AppTheme.darkGreen,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Today's Summary",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkBrown,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    FutureBuilder<NutritionGoals?>(
                      future: NutritionGoals.fetchGoals(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.darkGreen,
                            ),
                          );
                        }

                        if (snapshot.hasError) {
                          return const Text(
                            'Unable to load nutrition goals.',
                            style: TextStyle(color: AppTheme.darkBrown),
                          );
                        }

                        final goals = snapshot.data;

                        if (goals == null) {
                          return const Text(
                            'Set your nutrition goals in your profile.',
                            style: TextStyle(color: AppTheme.darkBrown),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow(
                              'Calories',
                              '${caloriesConsumed.round()} / ${goals.calories} kcal',
                              AppTheme.darkGreen,
                            ),
                            _buildSummaryRow(
                              'Fat',
                              '${fatConsumed.round()} / ${goals.fat.round()} g',
                              AppTheme.mutedRed,
                            ),
                            _buildSummaryRow(
                              'Carbohydrates',
                              '${carbohydratesConsumed.round()} / ${goals.carbohydrates.round()} g',
                              AppTheme.mediumGreen,
                            ),
                            _buildSummaryRow(
                              'Protein',
                              '${proteinConsumed.round()} / ${goals.protein.round()} g',
                              AppTheme.darkBrown,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Nutrition Progress",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkBrown,
              ),
            ),

            const SizedBox(height: 20),

            
            FutureBuilder<NutritionGoals?>(
              future: NutritionGoals.fetchGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.darkGreen,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Text(
                    'Unable to load nutrition progress.',
                    style: TextStyle(color: AppTheme.darkBrown),
                  );
                }

                final goals = snapshot.data;

                if (goals == null) {
                  return const Text(
                    'Set your nutrition goals in your profile to see progress.',
                    style: TextStyle(color: AppTheme.darkBrown),
                  );
                }

                return Column(
                  children: [
                    _buildProgressBar(
                      'Calories',
                      caloriesConsumed,
                      goals.calories.toDouble(),
                      AppTheme.darkGreen,
                    ),
                    const SizedBox(height: 20),

                    _buildProgressBar(
                      'Fat',
                      fatConsumed,
                      goals.fat,
                      AppTheme.mutedRed,
                    ),
                    const SizedBox(height: 20),

                    _buildProgressBar(
                      'Carbohydrates',
                      carbohydratesConsumed,
                      goals.carbohydrates,
                      AppTheme.mediumGreen,
                    ),
                    const SizedBox(height: 20),

                    _buildProgressBar(
                      'Protein',
                      proteinConsumed,
                      goals.protein,
                      AppTheme.darkBrown,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "Keep going — you're building a healthier you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.darkBrown.withValues(alpha: 0.75),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.darkBrown,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
    String label,
    double consumed,
    double goal,
    Color color,
  ) {
    final progress = goal > 0
        ? (consumed / goal).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${consumed.round()} / ${goal.round()}',
          style: const TextStyle(
            color: AppTheme.darkBrown,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 14,
            backgroundColor: AppTheme.originalLightGreen,
            color: color,
          ),
        ),
      ],
    );
  }
}