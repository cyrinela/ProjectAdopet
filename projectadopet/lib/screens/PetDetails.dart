import 'package:flutter/material.dart';
import '../models/dog.dart';
import 'UpdatePet.dart'; // Assurez-vous d'importer votre page d'édition
import '../services/ApiService.dart'; // Assurez-vous d'importer votre service API

class DogDetails extends StatefulWidget {
  final Dog dog;

  DogDetails({required this.dog});

  @override
  _DogDetailsState createState() => _DogDetailsState();
}

class _DogDetailsState extends State<DogDetails> {
  late Dog _dog;

  @override
  void initState() {
    super.initState();
    _dog = widget.dog; // Initialise avec les données du chien passé
  }

  // Rafraîchir les détails du chien
  Future<void> _refreshDogDetails(BuildContext context) async {
    try {
      Dog updatedDog = await ApiService.fetchDogById(_dog.id); // Remplacez par votre méthode d'appel API
      setState(() {
        _dog = updatedDog; // Mettez à jour l'objet chien avec les nouvelles données
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chien actualisé avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'actualisation des données.')),
      );
    }
  }

  // Supprimer le chien
  Future<void> _deleteDog(BuildContext context) async {
    try {
      await ApiService.deleteDog(_dog.id); // Appel à l'API pour supprimer le chien
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chien supprimé avec succès!')),
      );
      Navigator.pop(context); // Retourner à la page précédente après suppression
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du chien.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dog.name),
        centerTitle: true,
        actions: [
          // Icône pour éditer le chien
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPetPage(dogId: _dog.id), // Passe l'ID du chien à la page d'édition
                ),
              ).then((_) {
                _refreshDogDetails(context); // Rafraîchir les détails après modification
              });
            },
          ),
          // Icône pour supprimer le chien
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteDog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDogDetails(context), // Action de rafraîchissement
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du chien
              Container(
                height: 300,
                decoration: BoxDecoration(
                  image: _dog.imagePath.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage('http://localhost:3000/${_dog.imagePath}'),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: Colors.grey[200],
                ),
                child: _dog.imagePath.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _dog.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  _dog.distance,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Text(
                                  '12 min ago',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 160),
                                Text(
                                  '${_dog.age} | Playful',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: _dog.gender == 'Male' ? Colors.blue : Colors.pinkAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Text(
                            _dog.gender,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'About me',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _dog.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Quick Info',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickInfo('Age', '${_dog.age} yrs'),
                        _buildQuickInfo('Color', _dog.color),
                        _buildQuickInfo('Weight', '${_dog.weight} kg'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
