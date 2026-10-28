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

    void _showAddRecipeDialog() {
        String title = '';
        String instructions = '';
        List<Ingredient> ingredients = [];

        showDialog(
            context: context,
            builder: (context) {
                return AlertDialog(
                    title: const Text('Add Recipe'),
                    content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            TextField(
                                decoration: const InputDecoration(labelText: 'Recipe Name'),
                                onChanged: (value) => title = value,
                            ),
                            TextField(
                                decoration: const InputDecoration(labelText: 'Instructions'),
                                onChanged: (value) => instructions = value,
                            ),
                        ],
                    ),
                    actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                        ),
                        TextButton(
                            onPressed: () async {
                                if(title.trim().isNotEmpty) {
                                    await presenter.addRecipe(title.trim(), instructions);
                                    setState(() {});
                                    Navigator.pop(context);
                                }
                            },
                            child: const Text('Add'),
                        ),
                    ],
                );
            },
        );
    }

    @override
    Widget build (BuildContext context) {
        final recipes = presenter.recipes;

        return Scaffold(
            appBar: AppBar(title: const Text('Recipes')),
            body: 
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return ListTile(
                          title: Text(recipe.name),
                          subtitle: 
                            recipe.description != null 
                              ? Text(recipe.description!) 
                              : null,
                      );
                  },
              ),
            floatingActionButton: FloatingActionButton(
                onPressed: _showAddRecipeDialog,
                child: const Icon(Icons.add),
            ),
        );
    }
}