import 'package:flutter/material.dart';
import 'screens/PetListing.dart';

void main() {
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
      home: PetList(),
    );
  }
}
