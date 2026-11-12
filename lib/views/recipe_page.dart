import 'package:flutter/material.dart';
import '../presenters/recipe_presenter.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final RecipePresenter _presenter;

  bool _isLoading = false;
  RecipeModel? _recipe;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _presenter = RecipePresenter(this);
    _presenter.loadRecipe('123'); // Trigger presenter action
  }

  @override
  void showLoading() {
    // This method is called by the presenter to indicate loading state
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  }

  @override
  void hideLoading() {
    // This method is called by the presenter to hide loading state
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showRecipe(RecipeModel recipe) {
    // This method is called by the presenter to display the recipe
    setState(() {
      _recipe = recipe;
    });
  }

  @override
  void showError(String message) {
    // This method is called by the presenter to display an error message
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MVP in Flutter')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _errorMessage != null
                ? Text(_errorMessage!, style: const TextStyle(color: Colors.red))
                : _recipe != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Title: ${_recipe!.title}'),
                          Text('Rating: ${_recipe!.rating}'),
                        ],
                      )
                    : const Text('No recipe data'),
      ),
    );
  }
}

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