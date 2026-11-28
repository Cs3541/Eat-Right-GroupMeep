// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SelectedItem {
//   final String name;
//   final TextEditingController amountController;

//   SelectedItem({required this.name, String initialAmount = '1'})
//       : amountController = TextEditingController(text: initialAmount);

//   // Clean up the controller when the item is removed
//   void dispose() {
//     amountController.dispose();
//   }
// }

// class CreateRecipeScreen extends StatefulWidget {
//   const CreateRecipeScreen({super.key});

//   @override
//   State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
// }

// class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
//   // 1. Master list of all items
//   final List<String> _allItems = [
//     'Apples',
//     'Bananas',
//     'Cherries',
//     'Dates',
//     'Elderberries',
//     'Figs',
//     'Grapes',
//     'Carrots',
//     'Celery',
//     'Chicken Breasts',
//     'Olive Oils',
//     'Rices',
//     'Tomatoes',
//   ];

//   // 2. Your new list holding selected items + their amounts
//   final List<SelectedItem> _selectedItems = [];

//   void _addItem(String itemName) {
//     // Optional: Prevent duplicates
//     if (_selectedItems.any((item) => item.name == itemName)) return;

//     setState(() {
//       _selectedItems.add(SelectedItem(name: itemName));
//     });
//   }
  

//   void _removeItem(int index) {
//     setState(() {
//       _selectedItems[index].dispose();
//       _selectedItems.removeAt(index);
//     });
//   }

//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _imageController = TextEditingController();
//   final TextEditingController _ingredientsController = TextEditingController();
//   final TextEditingController _directionsController = TextEditingController();
//   final TextEditingController _notesController = TextEditingController();
//   final TextEditingController _servingsController = TextEditingController();
//   final TextEditingController _minutesController = TextEditingController();
//   final TextEditingController _tagsController = TextEditingController();
  


//   //Function to send data to Firestore
//   Future<void> _saveData() async {
//     final title = _titleController.text.trim();
//     final createdBy = FirebaseAuth.instance.currentUser;
//     final image = _imageController.text.trim();
//     final ingredients = _ingredientsController.text.trim();
//     final directions = _directionsController.text.trim();
//     final notes = _notesController.text.trim();
//     final tags = _tagsController.text.trim();
//     final servings = double.tryParse(_servingsController.text.trim()) ?? 0.0;
//     final minutes = double.tryParse(_minutesController.text.trim()) ?? 0.0;

//     if (title.isEmpty || image.isEmpty || ingredients.isEmpty || directions.isEmpty || notes.isEmpty || tags.isEmpty || servings <= 0 || minutes <= 0) return; // Prevent saving blank entries

//     try {
//       await FirebaseFirestore.instance.collection('recipes').add({
//         'title': title,
//         'createdBy': createdBy?.uid,
//         'image': image,
//         'ingredients': ingredients,
//         'directions': directions,
//         'notes': notes,
//         'tags': tags,
//         'servings': servings,
//         'minutes': minutes,
//         // 'createdAt': FieldValue.serverTimestamp(),
//       });

//       _titleController.clear();
//       _imageController.clear();
//       _ingredientsController.clear();
//       _directionsController.clear();
//       _notesController.clear();
//       _servingsController.clear();
//       _minutesController.clear();
//       _tagsController.clear(); // Clear the boxes after saving
//     } catch (e) {
//       debugPrint('Failed to write to Firestore: $e');
//     }
//   }


//   @override //cleanup controllers
//   void dispose() {
//     for (var item in _selectedItems) {
//       if (item is TextEditingController) {
//         item.dispose();
//       }
//     }
//     _titleController.dispose();
//     _imageController.dispose();
//     _ingredientsController.dispose();
//     _directionsController.dispose();
//     _notesController.dispose();
//     _servingsController.dispose();
//     _minutesController.dispose();
//     _tagsController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Recipe'),
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           tooltip: 'Close',
//           onPressed: () {
//             // Custom close logic or standard pop
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
          
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [

//             // Ingredients Search

//             Autocomplete<String>(
//               optionsBuilder: (TextEditingValue textEditingValue) {
//                 if (textEditingValue.text.isEmpty) {
//                   return const Iterable<String>.empty();
//                 }
//                 return _allItems.where((item) => item
//                     .toLowerCase()
//                     .contains(textEditingValue.text.toLowerCase()));
//               },
//               onSelected: (String selection) {
//                 _addItem(selection);
//               },
//               fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
//                 return TextField(
//                   controller: controller,
//                   focusNode: focusNode,
//                   decoration: const InputDecoration(
//                     labelText: 'Search items...',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),

//             SizedBox(
//               height: 200,
//               child: ListView.builder(
//                 itemCount: _selectedItems.length,
//                 itemBuilder: (context, index) {
//                   final item = _selectedItems[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 8),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 8),
//                       child: Row(
//                         children: [
//                           // Item Name
//                           Expanded(
//                             child: Text(
//                               item.name,
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ),
//                           // Amount Text Box
//                           SizedBox(
//                             width: 80,
//                             child: TextField(
//                               controller: item.amountController,
//                               keyboardType: TextInputType.number,
//                               textAlign: TextAlign.center,
//                               decoration: const InputDecoration(
//                                 labelText: 'Qty',
//                                 border: OutlineInputBorder(),
//                                 isDense: true,
//                               ),
//                             ),
//                           ),
//                           // Delete Button
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _removeItem(index),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 20),

//             // TITLE INPUT FIELD
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 hintText: 'Title...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle title changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // IMAGE INPUT
//             TextField(
//               controller: _imageController,
//               decoration: InputDecoration(
//                 hintText: 'Image URL...',
//                 prefixIcon: const Icon(Icons.image),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle image URL changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // SERVINGS INPUT
//             TextField(
//               controller: _servingsController,
//               decoration: InputDecoration(
//                 hintText: 'Servings...',
//                 prefixIcon: const Icon(Icons.people),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle servings changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // MINUTES INPUT
//             TextField(
//               controller: _minutesController,
//               decoration: InputDecoration(
//                 hintText: 'Minutes...',
//                 prefixIcon: const Icon(Icons.timer),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle minutes changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // INGREDIENTS INPUT
//             TextField(
//               controller: _ingredientsController,
//               decoration: InputDecoration(
//                 hintText: 'Ingredients...',
//                 prefixIcon: const Icon(Icons.list),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle ingredients changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // DIRECTIONS INPUT
//             TextField(
//               controller: _directionsController,
//               decoration: InputDecoration(
//                 hintText: 'Directions...',
//                 prefixIcon: const Icon(Icons.list),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle directions changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // NOTES INPUT
//             TextField(
//               controller: _notesController,
//               decoration: InputDecoration(
//                 hintText: 'Notes...',
//                 prefixIcon: const Icon(Icons.list),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle notes changes here
//               },
//             ),
//             const SizedBox(height: 10.0),

//             // TAGS INPUT
//             TextField(
//               controller: _tagsController,
//               decoration: InputDecoration(
//                 hintText: 'Tags...',
//                 prefixIcon: const Icon(Icons.tag),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle tags changes here
//               },
//             ),
//             const SizedBox(height: 10.0),
//             ElevatedButton(
//               onPressed: _saveData,
//               child: const Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }