class Dog {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String color;
  final double weight;
  final String distance;
  final String description;
  final String imagePath;

  Dog({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.color,
    required this.weight,
    required this.distance,
    required this.description,
    required this.imagePath
  });

  // Convertir les données du chien en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id, 
      'name': name,
      'age': age,
      'gender': gender,
      'color': color,
      'weight': weight,
      'distance': distance,
      'description': description,
      'imagePath': imagePath
    };
  }

  // Créer un objet Dog depuis un JSON
  factory Dog.fromJson(Map<String, dynamic> json) {
    return Dog(
      id: json['_id'],
      name: json['name'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
      color: json['color'] ?? '',
      weight: json['weight'] ?? 0.0,
      distance: json['distance'] ?? '',
      description: json['description'] ?? '',
      imagePath: json['imagePath'] ?? ''
    );
  }
}
