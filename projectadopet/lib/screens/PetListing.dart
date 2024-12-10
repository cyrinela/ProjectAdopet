import 'package:flutter/material.dart';
import '../models/dog.dart';
import '../services/ApiService.dart';
import 'PetDetails.dart';
import './AddPet.dart'; // Importer l'écran AddPetScreen

class PetList extends StatefulWidget {
  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  late Future<List<Dog>> dogsFuture;

  @override
  void initState() {
    super.initState();
    dogsFuture = ApiService.fetchDogs(); // Récupérer la liste des chiens
  }

  // Appeler cette méthode pour actualiser la liste après l'ajout d'un chien
  void refreshList() {
    setState(() {
      dogsFuture = ApiService.fetchDogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Chiens'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Naviguer vers l'écran d'accueil (/home)
              Navigator.pushReplacementNamed(context, '/home');
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
                child: Text(
                    'Erreur lors de la récupération des chiens : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Aucun chien disponible pour le moment.'));
          } else {
            final dogs = snapshot.data!;
            return ListView.builder(
              itemCount: dogs.length,
              itemBuilder: (context, index) {
                final dog = dogs[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DogDetails(dog: dog),
                        ),
                      ).then((refresh) {
                        if (refresh != null && refresh) {
                          refreshList(); // Rafraîchir la liste si nécessaire
                        }
                      });
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 3,
                            blurRadius: 6,
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
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '${dog.age} ans | Joueur',
                                    style: TextStyle(
                                      color: Colors.grey,
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
                                          color: Colors.grey,
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
                                    color: Colors.grey,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDogScreen(),
            ),
          ).then((_) {
            refreshList();
          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
