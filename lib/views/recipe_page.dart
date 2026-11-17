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
        title: Text(title),
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


        // 1. OUTER COLUMN (Vertical)
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [

            //IMAGE
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.black),
            //     // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
            //   ),
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
            //   child: const Center(
            //     child: Text('<Yummy food picture>'), //THIS IS WHERE THE IMAGE WILL GO
            //   ),
            // ),

            //BOX FOR CREATOR, SERVINGS, TIME
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                //CREATED BY
                  Expanded(
                    child: Text('Posted by: $createdBy'),
                  ),

                const SizedBox(width: 12.0), // Spacing between text

                //SERVINGS
                  Expanded(
                    child: Text('Serves: $servings'),
                  ),

                const SizedBox(width: 12.0), // Spacing between text
                
                //TIME
                  Expanded(
                    child: Text('Time: $minutes'),
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
                          // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
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
                          // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
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
                          // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Directions:'),
                              Text(directions),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text('Notes:'),
                              Text(notes),
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
                // borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: Center(
                child: Text('Taglist: $tags'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}