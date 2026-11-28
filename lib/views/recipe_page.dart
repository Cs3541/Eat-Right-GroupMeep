import 'package:flutter/material.dart';
import 'package:groupmeepeatright/models/recipe_model.dart';

class ExampleIngredientModel {
  final String name;
  final String measurement;

  ExampleIngredientModel({required this.name, required this.measurement});
}

class RecipePage extends StatefulWidget {
  final RecipeModel recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  State<RecipePage> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipePage> {


  String title = 'Recipe Title';
  final String recipeId = 'recipeID';
  final String createdBy = 'John Chef';
  double rating = 4.8;
  String imageTEMP = 'img.jpg';
  List<String> tags = ['tag1', 'tag2', 'tag3'];
  int servings = 2;
  double minutes = 30.0;
  static final Map<double, ExampleIngredientModel> ingredientsAmounts = {
    1.0: ExampleIngredientModel(name: 'butter', measurement: 'cup'),
    2.0: ExampleIngredientModel(name: 'flour', measurement: 'lb'),
    3.0: ExampleIngredientModel(name: 'sugar', measurement: 'g'),
  };
  String directions = 'Insert directions here';
  String notes = 'Insert notes here';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),


        // 1. OUTER COLUMN (Vertical)
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            //IMAGE
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: Center(
                child: Text(widget.recipe.image), //THIS IS WHERE THE IMAGE WILL GO
              ),
            ),

            //BOX FOR CREATOR, SERVINGS, TIME
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                //CREATED BY
                  Expanded(
                    child: Text('Posted by: ${widget.recipe.createdBy}'),
                  ),

                const SizedBox(width: 12.0), // Spacing between text

                //SERVINGS
                  Expanded(
                    child: Text('Serves: ${widget.recipe.servings}'),
                  ),

                const SizedBox(width: 12.0), // Spacing between text
                
                //TIME
                  Expanded(
                    child: Text('Minutes: ${widget.recipe.minutes}'),
                  ),

                ],
              ),
            ),

            // 2. MIDDLE ROW (Horizontal)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3A. FIRST INNER COLUMN (Red Outline)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Ingredients:'),
                              Text(ingredientsAmounts.entries.map((entry) => '${entry.value.name} (${entry.key} ${entry.value.measurement})').join(', ')),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Nutrition Info:'),
                              Text('insert nutrition info here'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                // 3B. SECOND INNER COLUMN (Red Outline)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Directions:'),
                              Text(widget.recipe.directions),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Notes:'),
                              Text(widget.recipe.notes),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            
            //Tags
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: Center(
                child: Text('Taglist: ${widget.recipe.tags}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
