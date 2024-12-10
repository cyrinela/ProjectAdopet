import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/dog.dart';
class ApiService {
  static const String baseApiUrl = 'http://localhost:3000/api';

  // Fonction pour ajouter un chien
  static Future<void> addDog(
      Map<String, dynamic> dogData, File? image, Uint8List? webImage) async {
    try {
      var uri = Uri.parse(baseApiUrl + '/add');
      var request = http.MultipartRequest('POST', uri);

      // Ajouter les données du chien
      dogData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Ajouter l'image (soit depuis un fichier, soit depuis des bytes)
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Envoyer la requête
      var response = await request.send();

      if (response.statusCode == 201) {
        print("Dog added successfully");
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Failed to add dog, status code: ${response.statusCode}");
        print("Response body: $responseBody");
        throw Exception("Failed to add dog");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error uploading dog data");
    }
  }

  // Fonction pour récupérer les chiens
  static Future<List<Dog>> fetchDogs({String url = '/dogs'}) async {
    try {
      final response = await http.get(Uri.parse(baseApiUrl + url));

      if (response.statusCode == 200) {
        if (response.body.isEmpty || response.body == 'null') {
          return [];
        }

        List<dynamic> data = json.decode(response.body);
        return data.map((dogJson) => Dog.fromJson(dogJson)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des chiens');
      }
    } catch (e) {
      print('Erreur lors de la récupération des chiens : $e');
      throw Exception('Erreur lors de la récupération des chiens : $e');
    }
  }

  // Fonction pour mettre à jour un chien
  static Future<void> updateDog(
      String dogId, Map<String, dynamic> dogData, File? image, Uint8List? webImage) async {
    try {
      // Créer l'URL avec l'ID du chien
      var uri = Uri.parse(baseApiUrl + '/update/$dogId');
      
      var request = http.MultipartRequest('PUT', uri);

      // Ajouter les données du chien
      dogData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Ajouter l'image (si elle est fournie)
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (webImage != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image',
          webImage,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      // Envoyer la requête
      var response = await request.send();

      if (response.statusCode == 200) {
        print("Dog updated successfully");
      } else {
        final responseBody = await response.stream.bytesToString();
        print("Failed to update dog, status code: ${response.statusCode}");
        print("Response body: $responseBody");
        throw Exception("Failed to update dog");
      }
    } catch (e) {
      print("Error: $e");
      throw Exception("Error updating dog data");
    }
  }

 static Future<Dog> fetchDogById(String dogId) async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/dog/$dogId'));

    if (response.statusCode == 200) {
      return Dog.fromJson(json.decode(response.body)); // Parsez la réponse en objet Dog
    } else {
      throw Exception('Failed to load dog data');
    }
  }

   // Méthode pour supprimer un chien
  static Future<void> deleteDog(String dogId) async {
    final url = Uri.parse('$baseApiUrl/delete/$dogId'); // URL de l'API avec l'ID du chien

    try {
      final response = await http.delete(url); // Requête DELETE

      if (response.statusCode == 200) {
        // Si la requête réussie, rien de spécial à faire
        return;
      } else {
        // Si la requête échoue, lancez une exception
        throw Exception('Failed to delete dog');
      }
    } catch (e) {
      print('Erreur lors de la suppression du chien: $e');
      rethrow; // Rethrow l'erreur pour la gestion dans l'UI
    }
  }
}
