
class WorkersModel {
  String id;
  final String name;
  final List<String> role;
  final List<String> services;
  final String? profileImageUrl;

  WorkersModel({
    required this.id,
    required this.name,
    required this.role,
    required this.services,
    required this.profileImageUrl,
  });

  factory WorkersModel.fromJson(Map<String, dynamic> json) {
    return WorkersModel(
      id: json['id'],
      name: json['name'],
      role: List<String>.from(json['role']),
      services: List<String>.from(json['services']),
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'services': services,
      'profileImageUrl': profileImageUrl,
    };
  }
}
