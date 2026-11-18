import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:groupmeepeatright/models/upload_nutrition.dart';
import 'package:groupmeepeatright/models/nutritionQuery.dart';

import 'firebase_options.dart';
import 'views/main_navigation.dart';
import 'views/login_screen.dart';

List<String> ingredientList = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //this code can upload the nutritional dataset, uncomment if you need to rebuild the data

  // await deleteAllNutritionDocs(onProgress: (n) => debugPrint('deleted $n'));
  // await uploadNutritionCsv(
  //   onProgress: (done, total) => debugPrint('$done / $total'),
  // );

  // ingredientList = await listFoods();
  // debugPrint('Loaded ${ingredientList.length} ingredients');

  runApp(const EatRightApp());
}

class EatRightApp extends StatelessWidget {
  const EatRightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EatRight',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
              child: Text(
                'Eat Right',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const MainNavigationScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
