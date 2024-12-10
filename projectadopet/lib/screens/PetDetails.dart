import 'package:flutter/material.dart';
import '../models/dog.dart';
import 'UpdatePet.dart';
import '../services/ApiService.dart'; 

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
    _dog = widget.dog;
  }

  Future<void> _refreshDogDetails(BuildContext context) async {
    try {
      Dog updatedDog = await ApiService.fetchDogById(_dog.id);
      setState(() {
        _dog = updatedDog;
      });
    
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'actualisation des données.')),
      );
    }
  }

  // Supprimer le chien
  Future<void> _deleteDog(BuildContext context) async {
    try {
      await ApiService.deleteDog(_dog.id); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chien supprimé avec succès!')),
      );
      Navigator.pop(context, true); 
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
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditPetPage(dogId: _dog.id), 
                ),
              ).then((_) {
                _refreshDogDetails(context); 
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteDog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshDogDetails(context), 
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
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  _dog.distance,
                                  style: TextStyle(
                                    color: Colors.black,
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
                            color: _dog.gender == 'Male' ? Colors.blue : Colors.pink,
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
                        color: Colors.brown, 
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _dog.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Quick Info',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown, 
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
