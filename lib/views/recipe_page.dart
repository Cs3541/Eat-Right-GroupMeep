import 'package:flutter/material.dart';

class ExampleIngredientModel {
  final String name;
  final String measurement;

  ExampleIngredientModel({required this.name, required this.measurement});
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipePage> {


  static const String title = 'Recipe Title';
  static const String recipeId = 'recipeID';
  static const String createdBy = 'John Chef' ;
  static const double rating = 4.8;
  static const String imageTEMP = 'img.jpg';
  static const List<String> tags = ['tag1', 'tag2', 'tag3'];
  static const int servings = 2;
  static const double minutes = 30.0;
  static final Map<double, ExampleIngredientModel> ingredientsAmounts = {
    1.0: ExampleIngredientModel(name: 'butter', measurement: 'cup'),
    2.0: ExampleIngredientModel(name: 'flour', measurement: 'lb'),
    3.0: ExampleIngredientModel(name: 'sugar', measurement: 'g'),
  };
  static const String directions = 'Insert directions here';
  static const String notes = 'Insert notes here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Posted by: $createdBy'),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: const Center(
                child: Text('<Yummy food picture>'), //THIS IS WHERE THE IMAGE WILL GO
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              
              child: Row(
                children: [
                Expanded(
                  child: Text('Posted by: $createdBy'),
                ),
                const SizedBox(width: 12.0), // Spacing between text
                Expanded(
                  child: Text('Serves: $servings'),
                ),
                const SizedBox(width: 12.0), // Spacing between text
                Expanded(
                  child: Text('Time: $minutes'),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}