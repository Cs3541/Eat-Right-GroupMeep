import 'package:flutter/material.dart';
import '../presenters/auth_presenter.dart';

//DOES THIS SHOW UP

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

    // Example progress values (replace with real data later)
    final calories = 0.70;
    final fat = 0.40;
    final sugar = 0.55;
    final protein = 0.30;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            // Welcome message
            Text(
              "Welcome back, $email!",
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Motivational quote card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _motivation(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Today's Summary Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Today's Summary",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("Calories: ${(calories * 2000).round()} / 2000 kcal"),
                    Text("Fat: ${(fat * 70).round()} / 70 g"),
                    Text("Sugar: ${(sugar * 90).round()} / 90 g"),
                    Text("Protein: ${(protein * 120).round()} / 120 g"),
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
              ),
            ),

            const SizedBox(height: 20),

            // Progress Bars
            _buildProgressBar("Calories", calories, Colors.purple),
            const SizedBox(height: 20),

            _buildProgressBar("Fat", fat, Colors.redAccent),
            const SizedBox(height: 20),

            _buildProgressBar("Sugar", sugar, Colors.orange),
            const SizedBox(height: 20),

            _buildProgressBar("Protein", protein, Colors.green),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "Keep going — you're building a healthier you.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 14,
            backgroundColor: Colors.grey.shade300,
            color: color,
          ),
        ),
      ],
    );
  }
}