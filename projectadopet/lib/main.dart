import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/PetListing.dart'; // L'écran de la liste des animaux
import 'screens/Authentification.dart'; 
import 'screens/SignupScreen.dart'; 
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
      initialRoute: '/auth', 
      routes: {
        '/auth': (context) => SignInScreen(), 
        '/home': (context) => PetList(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}
