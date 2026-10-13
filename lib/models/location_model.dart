// lib/models/location_model.dart

class LocationModel {
  final String id;
  final String name;

  LocationModel({
    required this.id,
    required this.name,
  });

  // Firebase Ready
  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
