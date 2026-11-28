import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  // 1. Master list of all items
  final List<String> _allIngredients = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
  ];

  // 2. List that holds the filtered results
  List<String> _filteredIngredients = [];

  // 2. List that holds the selected ingredients
  List<String> _selectedIngredients = [];

  @override
  void initState() {
    super.initState();
    // Show all items initially
    _filteredIngredients = _allIngredients;
  }

  // 3. Filter logic triggered on text change
  void _runFilter(String enteredKeyword) {
    List<String> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allIngredients;
    } else {
      results = _allIngredients
          .where((item) =>
              item.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredIngredients = results;
    });
  }


  // Add or remove item from the new list
  void _toggleSelection(String ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
  }

  // Function to handle ingredient selection
  void _selectIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.add(ingredient);
      _ingredientsController.text = _selectedIngredients.join(', ');
    });
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  


  //Function to send data to Firestore
  Future<void> _saveData() async {
    final title = _titleController.text.trim();
    final createdBy = FirebaseAuth.instance.currentUser;
    final image = _imageController.text.trim();
    final ingredients = _ingredientsController.text.trim();
    final directions = _directionsController.text.trim();
    final notes = _notesController.text.trim();
    final tags = _tagsController.text.trim();
    final servings = double.tryParse(_servingsController.text.trim()) ?? 0.0;
    final minutes = double.tryParse(_minutesController.text.trim()) ?? 0.0;

    if (title.isEmpty || image.isEmpty || ingredients.isEmpty || directions.isEmpty || notes.isEmpty || tags.isEmpty || servings <= 0 || minutes <= 0) return; // Prevent saving blank entries

    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': title,
        'createdBy': createdBy?.uid,
        'image': image,
        'ingredients': ingredients,
        'directions': directions,
        'notes': notes,
        'tags': tags,
        'servings': servings,
        'minutes': minutes,
        // 'createdAt': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _imageController.clear();
      _ingredientsController.clear();
      _directionsController.clear();
      _notesController.clear();
      _servingsController.clear();
      _minutesController.clear();
      _tagsController.clear(); // Clear the boxes after saving
    } catch (e) {
      debugPrint('Failed to write to Firestore: $e');
    }
  }


  @override //cleanup controllers
  void dispose() {
    _titleController.dispose();
    _imageController.dispose();
    _ingredientsController.dispose();
    _directionsController.dispose();
    _notesController.dispose();
    _servingsController.dispose();
    _minutesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Recipe'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close',
          onPressed: () {
            // Custom close logic or standard pop
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Ingredients Search
            TextField(
              onChanged: (value) => _runFilter(value),
              onTap: () {
                // Show the ingredient list when the field is tapped
              },
              decoration: const InputDecoration(
                labelText: 'Search Ingredients',
                suffixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),

            // Display the New List (Selected Items)
            if (_selectedIngredients.isNotEmpty) ...[
              const Text(
                'Selected List:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8.0,
                children: _selectedIngredients.map((item) {
                  return Chip(
                    label: Text(item),
                    onDeleted: () => _toggleSelection(item),
                  );
                }).toList(),
              ),
              const Divider(height: 24),
            ],

            SizedBox(
              height: 200,
              child: ListView.builder(
                itemCount: _filteredIngredients.length,
                itemBuilder: (context, index) {
                  final ingredient = _filteredIngredients[index];
                  final isSelected = _selectedIngredients.contains(ingredient);
                  return ListTile(
                    title: Text(ingredient),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.add_circle_outline,
                      color: isSelected ? Colors.green : null,
                    ),
                    onTap: () => _toggleSelection(ingredient),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // TITLE INPUT FIELD
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Title...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle title changes here
              },
            ),
            const SizedBox(height: 10.0),

            // IMAGE INPUT
            TextField(
              controller: _imageController,
              decoration: InputDecoration(
                hintText: 'Image URL...',
                prefixIcon: const Icon(Icons.image),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle image URL changes here
              },
            ),
            const SizedBox(height: 10.0),

            // SERVINGS INPUT
            TextField(
              controller: _servingsController,
              decoration: InputDecoration(
                hintText: 'Servings...',
                prefixIcon: const Icon(Icons.people),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle servings changes here
              },
            ),
            const SizedBox(height: 10.0),

            // MINUTES INPUT
            TextField(
              controller: _minutesController,
              decoration: InputDecoration(
                hintText: 'Minutes...',
                prefixIcon: const Icon(Icons.timer),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle minutes changes here
              },
            ),
            const SizedBox(height: 10.0),

            // INGREDIENTS INPUT
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(
                hintText: 'Ingredients...',
                prefixIcon: const Icon(Icons.list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle ingredients changes here
              },
            ),
            const SizedBox(height: 10.0),

            // DIRECTIONS INPUT
            TextField(
              controller: _directionsController,
              decoration: InputDecoration(
                hintText: 'Directions...',
                prefixIcon: const Icon(Icons.list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle directions changes here
              },
            ),
            const SizedBox(height: 10.0),

            // NOTES INPUT
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Notes...',
                prefixIcon: const Icon(Icons.list),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle notes changes here
              },
            ),
            const SizedBox(height: 10.0),

            // TAGS INPUT
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                hintText: 'Tags...',
                prefixIcon: const Icon(Icons.tag),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              ),
              onChanged: (value) {
                // Handle tags changes here
              },
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}