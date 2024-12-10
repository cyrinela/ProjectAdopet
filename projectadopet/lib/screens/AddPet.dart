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

  @override
  void initState() {
    super.initState();
    ownerIdController.text = '675242673054e416f8cb0194'; 
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
        backgroundColor: Color(0xFF80C4E9), 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Nom du chien
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    prefixIcon: Icon(Icons.pets, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],  
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1),
                    ),
                  ),
                  validator: (value) => value!.isEmpty ? "Enter a name" : null,
                ),
                SizedBox(height: 10),

                
                TextFormField(
                  controller: ageController,
                  decoration: InputDecoration(
                    labelText: "Age",
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],  // Fond brun
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1), 
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? "Enter age" : null,
                ),
                SizedBox(height: 10),

               
                TextFormField(
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: "Gender",
                    prefixIcon: Icon(Icons.accessibility, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 10),

               
                TextFormField(
                  controller: colorController,
                  decoration: InputDecoration(
                    labelText: "Color",
                    prefixIcon: Icon(Icons.color_lens, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1),
                    ),
                  ),
                ),
                SizedBox(height: 10),

          
                TextFormField(
                  controller: weightController,
                  decoration: InputDecoration(
                    labelText: "Weight",
                    prefixIcon: Icon(Icons.scale, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1), 
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),

                
                TextFormField(
                  controller: distanceController,
                  decoration: InputDecoration(
                    labelText: "Distance",
                    prefixIcon: Icon(Icons.location_on, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1), 
                    ),
                  ),
                ),
                SizedBox(height: 10),

               
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: "Description",
                    prefixIcon: Icon(Icons.description, color: Colors.brown),
                    filled: true,
                    fillColor: Colors.brown[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF80C4E9), width: 2),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.brown, width: 1), 
                    ),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),

                
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF80C4E9),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  ),
                  child: Text(
                    "Add Dog",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
