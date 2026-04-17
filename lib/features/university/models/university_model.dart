class UniversityModel {
  final String id;
  final String name;
  final String city;
  final String description;
  final String website;
  final String phone;
  final String email;

  UniversityModel({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.website,
    required this.phone,
    required this.email,
  });

  factory UniversityModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return UniversityModel(
      id: id,
      name: map['name'] ?? '',
      city: map['city'] ?? '',
      description: map['description'] ?? '',
      website: map['website'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
    );
  }
}