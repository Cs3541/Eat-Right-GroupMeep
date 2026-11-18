import 'package:flutter/material.dart';

// Define a custom Form widget.
class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retrieve Text Input')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(controller: myController),
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
                content: Text(myController.text),
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
// class ExampleIngredientModel {
//   final String name;
//   final String measurement;

//   ExampleIngredientModel({required this.name, required this.measurement});
// }

// class CreateRecipeScreen extends StatefulWidget {
//   const CreateRecipeScreen({super.key});

//   @override
//   State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
// }

// class _CreateRecipeScreenState extends State<CreateRecipeScreen> {


//   String title = 'Recipe Title';
//   final String recipeId = 'recipeID';
//   final String createdBy = 'John Chef';
//   double rating = 4.8;
//   String imageTEMP = 'img.jpg';
//   List<String> tags = ['tag1', 'tag2', 'tag3'];
//   int servings = 2;
//   double minutes = 30.0;
//   static final Map<double, ExampleIngredientModel> ingredientsAmounts = {
//     1.0: ExampleIngredientModel(name: 'butter', measurement: 'cup'),
//     2.0: ExampleIngredientModel(name: 'flour', measurement: 'lb'),
//     3.0: ExampleIngredientModel(name: 'sugar', measurement: 'g'),
//   };
//   String directions = 'Insert directions here';
//   String notes = 'Insert notes here';


//   final TextEditingController _titleController = TextEditingController();
  
//   @override
//   void dispose() {
//     _titleController.dispose();
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
          
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // 1. Search Bar at the top
//             TextField(
//               controller: _titleController,
//               decoration: InputDecoration(
//                 hintText: 'Title...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                 ),
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
//               ),
//               onChanged: (value) {
//                 // Handle title changes here
//               },
//             ),
//             const SizedBox(height: 16.0),

//             const SizedBox(height: 20),
//             Container(height: 300, color: Colors.green),
//             const SizedBox(height: 20),
//             Container(height: 300, color: Colors.orange),
//             Center(
//               child: Text(
//                 'Title: "${_titleController.text}"',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16.0, color: Colors.grey),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }