import 'Owner.dart';

class Dog {
  final int id;
  final String name;
  final double age;
  final String gender;
  final String color;
  final double weight;
  final String location;
  final String image;
  final String about;
  final Owner owner;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.location,
    required this.image,
    required this.about,
    required this.owner,
  });
}
