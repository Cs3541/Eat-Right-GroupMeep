import 'package:flutter/material.dart';
import '../presenters/recipe_presenter.dart';

class RecipeListScreen extends StatefulWidget {
    const RecipeListScreen({super.key});

    @override
    State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
    final RecipePresenter presenter = RecipePresenter();
    bool _isLoading = true;

    @override
    void initState() {
        super.initState();
        _loadRecipes();
    }

    Future<void> _loadRecipes() async {
        await presenter.loadRecipes();
        setState(() => _isLoading = false);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Button List')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: buttonLabels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ElevatedButton(
              onPressed: () {
                print('Tapped: ${buttonLabels[index]}');
              },
              child: Text(buttonLabels[index]),
            ),
          );
        },
      ),
    );
  }
}