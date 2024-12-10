import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/PetListing.dart'; // L'écran de la liste des animaux
import 'screens/Authentification.dart'; // L'écran d'authentification
import 'screens/SignupScreen.dart'; // L'écran d'inscription
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Initialisation de Firebase
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdoPet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/auth', // La route initiale
      routes: {
        '/auth': (context) => SignInScreen(), // Écran d'authentification
        '/home': (context) => PetList(), // Écran de la liste des animaux
        '/signup': (context) => SignUpPage(), // Écran pour l'inscription
      },
    );
  }
}
