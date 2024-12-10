import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../models/dog.dart';
import '../services/ApiService.dart';

class EditPetPage extends StatefulWidget {
  final String dogId;

  EditPetPage({required this.dogId});

  @override
  _EditPetPageState createState() => _EditPetPageState();
}

class _EditPetPageState extends State<EditPetPage> {
  late String name, gender, color, distance, description, imagePath, ownerId;
  late double weight;
  late int age;
  late String _imageUrl;
  bool isLoading = true;
  File? _selectedImage;
  Uint8List? _webImageBytes;

  final picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDogData();
  }

  Future<void> _fetchDogData() async {
    try {
      Dog dog = await ApiService.fetchDogById(widget.dogId);
      setState(() {
        name = dog.name;
        age = dog.age;
        gender = dog.gender;
        color = dog.color;
        weight = dog.weight;
        distance = dog.distance;
        description = dog.description;
        imagePath = dog.imagePath;
        ownerId = dog.ownerId;
        _imageUrl = dog.imagePath;
        _nameController.text = dog.name;
        _ageController.text = dog.age.toString();
        _genderController.text = dog.gender;
        _colorController.text = dog.color;
        _weightController.text = dog.weight.toString();
        _distanceController.text = dog.distance;
        _descriptionController.text = dog.description;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to fetch dog data: $e")));
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = Uint8List.fromList(bytes);
        });
      } else {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }
  }

  Future<void> _updateDog() async {
    try {
      if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Name and Age are required")));
        return;
      }

      int updatedAge = int.parse(_ageController.text);
      double updatedWeight = double.parse(_weightController.text);

      Map<String, dynamic> dogData = {
        'name': _nameController.text,
        'age': updatedAge,
        'gender': _genderController.text,
        'color': _colorController.text,
        'weight': updatedWeight,
        'distance': _distanceController.text,
        'description': _descriptionController.text,
        'imagePath': imagePath,
        'ownerId': ownerId,
      };

      await ApiService.updateDog(widget.dogId, dogData, _selectedImage, _webImageBytes);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Dog updated successfully")));

      // Retour à la page précédente avec un signal pour rafraîchir
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to update dog: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Dog'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Dog ID: ${widget.dogId}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            )
                          : _webImageBytes != null
                              ? Image.memory(
                                  _webImageBytes!,
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.cover,
                                )
                              : _imageUrl.isNotEmpty
                                  ? Image.network(
                                      'http://localhost:3000/${_imageUrl}', // Utiliser l'URL complète ici
                                      width: 130,
                                      height: 130,
                                      fit: BoxFit.cover,  // Ajustement de l'image
                                    )
                                  : Container(
                                      width: 130,
                                      height: 130,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.camera_alt),
                                    ),
                    ),
                    SizedBox(height: 16),
                    _buildTextField('Name', _nameController),
                    _buildTextField('Age', _ageController, isNumeric: true),
                    _buildTextField('Gender', _genderController),
                    _buildTextField('Color', _colorController),
                    _buildTextField('Weight', _weightController, isNumeric: true),
                    _buildTextField('Distance', _distanceController),
                    _buildTextField('Description', _descriptionController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateDog,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: isNumeric
          ? TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      inputFormatters: isNumeric
          ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))]
          : [],
    );
  }
}
