import 'package:flutter/material.dart';
import 'recipe_page.dart';



class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final TextEditingController _searchController = TextEditingController();
  
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search & Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Search Bar at the top
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle search query changes here
              },
            ),
            const SizedBox(height: 16.0),

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
                const SizedBox(width: 12.0), // Spacing between dropdowns

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
            const SizedBox(height: 24.0),

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
                const SizedBox(width: 6.0), // Spacing between dropdowns

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
                const SizedBox(width: 6.0), // Spacing between dropdowns
              
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
                const SizedBox(width: 6.0), // Spacing between dropdowns

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
                const SizedBox(width: 6.0), // Spacing between dropdowns


              ],
            ),
            const SizedBox(height: 24.0),
            // Display area showing current selections
            
            // Button to navigate to the Recipe Page
            ElevatedButton(
              onPressed: () {
                // Navigate to the second page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RecipePage()),
                );
              },
              child: const Text('Go to Recipe Page'),
            ),
            // 1. Recipe Results
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10.0), // Rounds all 4 corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 30.0),
              child: const Center(
                child: Text('Recipe Results'),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Search: "${_searchController.text}"\n'
                  'Search By: ${_selectedSearch ?? "None"}\n'
                  'Sort By: ${_selectedSort ?? "None"}\n'
                  'Filter Meal Type: ${_filterMealType ?? "None"}\n'
                  'Filter Ethnicity: ${_filterEthnicity ?? "None"}\n'
                  'Filter Other: ${_filterOther ?? "None"}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
