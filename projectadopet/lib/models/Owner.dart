
class Owner {
  final String name;
  final String bio;
  final String email;

  Owner({
    required this.name,
    required this.bio,
    required this.email,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      name: json['name'],
      bio: json['bio'] ?? "",
      email: json['email'] ?? "",
    );
  }
}