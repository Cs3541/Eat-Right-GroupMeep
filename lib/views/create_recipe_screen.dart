import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _directionsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
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

    if (title.isEmpty || image.isEmpty || ingredients.isEmpty || directions.isEmpty || notes.isEmpty || tags.isEmpty) return; // Prevent saving blank entries

    try {
      await FirebaseFirestore.instance.collection('recipes').add({
        'title': title,
        'createdBy': createdBy?.uid,
        'image': image,
        'ingredients': ingredients,
        'directions': directions,
        'notes': notes,
        'tags': tags,
        // 'createdAt': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _imageController.clear();
      _ingredientsController.clear();
      _directionsController.clear();
      _notesController.clear();
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
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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