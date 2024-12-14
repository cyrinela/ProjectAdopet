import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../services/ApiService.dart';
import 'PetDetails.dart';
import './AddPet.dart';

class PetList extends StatefulWidget {
  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  late Future<List<Dog>> dogsFuture;

  @override
  void initState() {
    super.initState();
    dogsFuture = ApiService.fetchDogs();
  }

  // Méthode de rafraîchissement de la liste des chiens
  void refreshList() {
    setState(() {
      dogsFuture = ApiService.fetchDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Our Little Friends',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Color(0xFF80C4E9),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Dog>>(
        future: dogsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 80,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Une erreur est survenue lors de la récupération des chiens.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${snapshot.error}', // Affiche le message d'erreur détaillé
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Relancer la récupération des données
                      refreshList();
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Réessayer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF80C4E9),
                    ),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Aucun chien disponible pour le moment.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final dogs = snapshot.data!;
            return ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: GestureDetector(
                    onTap: () {
                      // Navigation vers PetDetails
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DogDetails(dog: dog),
                        ),
                      ).then((_) {
                        refreshList();
                      });
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: dog.imagePath.isNotEmpty
                                  ? Image.network(
                                      'http://localhost:3000/${dog.imagePath}',
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.pets,
                                      size: 130,
                                      color: Colors.grey,
                                    ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    dog.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color(0xFF6F4F29),
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${dog.age} ans | Joueur',
                                    style: TextStyle(
                                      color: Color(0xFF6F4F29),
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '${dog.distance} km away',
                                        style: TextStyle(
                                          color: Color(0xFF6F4F29),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: dog.gender == 'Male'
                                        ? Colors.blue
                                        : Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  child: Text(
                                    dog.gender,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  '12 min ago',
                                  style: TextStyle(
                                    color: Color(0xFF6F4F29),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigation vers AddDogScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDogScreen(),
            ),
          ).then((_) {
            // Rafraîchir après avoir ajouté un chien
            refreshList();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF80C4E9),
      ),
    );
  }
}
