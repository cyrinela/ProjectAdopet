import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/ApiService.dart';

class AddDogScreen extends StatefulWidget {
  @override
  _AddDogScreenState createState() => _AddDogScreenState();
}

class _AddDogScreenState extends State<AddDogScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController distanceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController ownerIdController = TextEditingController();

  File? _selectedImage;
  Uint8List? _webImageBytes;

  final picker = ImagePicker();
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final dogData = {
        'name': nameController.text,
        'age': double.tryParse(ageController.text) ?? 0.0,
        'gender': genderController.text,
        'color': colorController.text,
        'weight': double.tryParse(weightController.text) ?? 0.0,
        'distance': distanceController.text,
        'description': descriptionController.text,
        'ownerId': ownerIdController.text,
      };

      try {
        await ApiService.addDog(dogData, _selectedImage, _webImageBytes);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Dog added successfully!")),
        );
        Navigator.pop(context);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add dog: $error")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Dog"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) => value!.isEmpty ? "Enter a name" : null,
                ),
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter age" : null,
                ),
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: "Gender"),
                ),
                TextFormField(
                  controller: colorController,
                  decoration: InputDecoration(labelText: "Color"),
                ),
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(labelText: "Weight"),
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: distanceController,
                  decoration: InputDecoration(labelText: "Distance"),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Description"),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: ownerIdController,
                  decoration: InputDecoration(labelText: "Owner ID"),
                ),
                SizedBox(height: 20),

                // Sélectionner une image
                GestureDetector(
                  onTap: _pickImage,
                  child: _webImageBytes != null || _selectedImage != null
                      ? kIsWeb
                          ? Image.memory(
                              _webImageBytes!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey[300],
                          child: Icon(Icons.camera_alt),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text("Add Dog"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
