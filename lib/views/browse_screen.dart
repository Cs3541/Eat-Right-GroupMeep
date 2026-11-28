import 'package:flutter/material.dart';
import 'package:groupmeepeatright/models/recipe_model.dart';
import 'recipe_page.dart';
import 'create_recipe_screen.dart';
import '../presenters/recipe_presenter.dart';
import 'search_test.dart';

//Branching successful?

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final RecipePresenter presenter = RecipePresenter();
  bool _isLoading = true;

  
  List<RecipeModel> get recipes => presenter.recipes;
  
  List<RecipeModel> _filteredRecipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _filteredRecipes = recipes;
  }


  // 3. Filter logic triggered on text change
  void _runFilter(String enteredKeyword) {
    List<RecipeModel> results = [];
    if (enteredKeyword.isEmpty) {
      results = recipes;
    } else {
      results = recipes
          .where((recipe) =>
              recipe.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredRecipes = results;
    });
  }

  
  Future<void> _loadRecipes() async {
    await presenter.loadRecipes();
    setState(() => _isLoading = false);
  }
  
  // final TextEditingController _searchController = TextEditingController();
  
  // State for SearchBy dropdown
  String? _selectedSearch;
  final List<String> _searchOptions = ['Title', 'Creator'];

  // State for SortBy dropdown
  String? _selectedSort;
  final List<String> _sortOptions = ['Rating', 'Alphabetical(title)', 'Date Posted'];

  // State for FilterMealType dropdown
  String? _filterMealType;
  final List<String> _filterMealTypeOptions = ['Breakfast', 'Lunch', 'Dinner'];

  // State for FilterIngredients dropdown
  String? _filterIngredients;
  final List<String> _filterIngredientsOptions = ['Ingredient1', 'Ingredient2', 'Ingredient3'];

  // State for FilterEthnicity dropdown
  String? _filterEthnicity;
  final List<String> _filterEthnicityOptions = ['Italian', 'Mexican', 'Indian'];

  // State for FilterOther dropdown
  String? _filterOther;
  final List<String> _filterOtherOptions = ['Baked Goods', 'Pasta', 'Salads'];

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Search Bar at the top
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
            ),
            const SizedBox(height: 10.0),

            // 2. Two Dropdown Menus Next to Each Other
            Row(
              children: [
                // First Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSearch,
                    decoration: InputDecoration(
                      labelText: 'Search By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _searchOptions.map((String search) {
                      return DropdownMenuItem<String>(
                        value: search,
                        child: Text(search),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSearch = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12.0), // box for spacing

                // Second Dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedSort,
                    decoration: InputDecoration(
                      labelText: 'Sort By',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _sortOptions.map((String sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Text(sort, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSort = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10.0),

            const Text(
              "Filter:"
            ),
            // 3. Filter section
            Row(
              children: [
                // Filter by Meal Type
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filterMealType,
                    decoration: InputDecoration(
                      labelText: 'Meal Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _filterMealTypeOptions.map((String search) {
                      return DropdownMenuItem<String>(
                        value: search,
                        child: Text(search),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterMealType = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6.0), // box for spacing

                // Filter by Ingredients
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filterIngredients,
                    decoration: InputDecoration(
                      labelText: 'Ingredients',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _filterIngredientsOptions.map((String sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Text(sort, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterIngredients = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6.0), // box for spacing
              
                // Filter by Ethnicity
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filterEthnicity,
                    decoration: InputDecoration(
                      labelText: 'Ethnicity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _filterEthnicityOptions.map((String sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Text(sort, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterEthnicity = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6.0), // box for spacing

                // Filter by Other
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _filterOther,
                    decoration: InputDecoration(
                      labelText: 'Other',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                    ),
                    items: _filterOtherOptions.map((String sort) {
                      return DropdownMenuItem<String>(
                        value: sort,
                        child: Text(sort, overflow: TextOverflow.ellipsis),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _filterOther = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 6.0), // box for spacing


              ],
            ),
            const SizedBox(height: 10.0),
            
            // Button to navigate to the Recipe Page
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ItemSelectorScreen()),
                );
              },
              child: const Text('Go to Search Page'),
            ),
            
            
            // Button to navigate to the CreateRecipe Page
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateRecipeScreen()),
                );
              },
              child: const Text('Go to Create Recipe Page'),
            ),
            
            // Display area showing current selections
            Container(
              height: 100, // Required so Flutter knows when to scroll
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),

              child: _filteredRecipes.isNotEmpty? ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: _filteredRecipes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the recipe page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipePage(recipe: _filteredRecipes[index])
                          ),
                        );
                      },
                      child: Text(_filteredRecipes[index].title),
                    ),
                  );
                },
              ): const Text('No results found'),
            ), // End of Container for displaying filtered recipes
          ],
        ),
      ),
    );
  }
}
