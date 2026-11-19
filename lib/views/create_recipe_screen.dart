import 'package:flutter/material.dart';

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

  @override
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
            const SizedBox(height: 16.0),

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
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text that the user has entered by using the
                // TextEditingController.
                content: Text(
                  'Title: "${_titleController.text}"\n'
                  'Image: "${_imageController.text}"\n'
                  'Ingredients: "${_ingredientsController.text}"\n'
                  'Directions: "${_directionsController.text}"\n'
                  'Notes: "${_notesController.text}"\n'
                  'Tags: "${_tagsController.text}"\n'
                  ),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}