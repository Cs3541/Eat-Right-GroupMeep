import 'package:flutter/material.dart';

class LearnDashboard extends StatelessWidget {
  const LearnDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Learn"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Articles",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),
                title: const Text("Healthy Eating Tips"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.article),
                title: const Text("Benefits of Drinking Water"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Videos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill),
                title: const Text("Nutrition Basics"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.play_circle_fill),
                title: const Text("Meal Prep for Beginners"),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}