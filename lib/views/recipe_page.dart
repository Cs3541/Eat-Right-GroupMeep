import 'package:flutter/material.dart';
import '../presenters/recipe_presenter.dart';

class RecipePage extends StatelessWidget {

  final RecipePresenter presenter = RecipePresenter();
  RecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Page')),
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