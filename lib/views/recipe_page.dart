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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Return to the previous page
            Navigator.pop(context);
          },
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}