import 'package:cloud_firestore/cloud_firestore.dart';


class Ingredient {
    final String ingredientName;
    final double baseServingSize;
    final String? dietaryWarnings;

    //BELOW IS STUFF AVERAGE NUTRITION SHEETS CONTAIN. GOOD FOR FUTURE NUTRITION TRACKING BUT PROBABLY TOO COMPLICATED THIS EARLY.
    // final double calories;
    // final double totalFat;
    // final double saturatedFat;
    // final double cholesteral;
    // final double sodium;
    // final double potassium;
    // final double carbohydrates;
    // final double dietaryFiber;
    // final double sugars;
    // final double protien;
    // final double vitaminA;
    // final double vitaminC;
    // final double calcium;
    // final double iron;

    Ingredient({required this.ingredientName, required this.baseServingSize, this.dietaryWarnings});

    
    static final _firestore = FirebaseFirestore.instance;

    static Future<List<Ingredient>> fetchIngredients() async {

      final snapshot = await _firestore.collection('ingredients').get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Ingredient(
          ingredientName: data['ingredientName'],
          baseServingSize: data['baseServingSize'],
          dietaryWarnings: data['dietaryWarnings'],
        );
      }).toList();
    }

    static Future<void> addIngredient(Ingredient ingredient) async {
      await _firestore.collection('ingredients').add({
        'ingredientName': ingredient.ingredientName,
        'baseServingSize': ingredient.baseServingSize,
        'dietaryWarnings': ingredient.dietaryWarnings,
      });
    }
}