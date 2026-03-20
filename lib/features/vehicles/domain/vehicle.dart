class Vehicle {
  final String id;
  final String nickname;
  final String brand;
  final String model;
  final String plate;
  final int year;
  final String? photoPath;

  const Vehicle({
    required this.id,
    required this.nickname,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
    this.photoPath,
  });

  Vehicle copyWith({
    String? id,
    String? nickname,
    String? brand,
    String? model,
    String? plate,
    int? year,
    String? photoPath,
  }) {
    return Vehicle(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      plate: plate ?? this.plate,
      year: year ?? this.year,
      photoPath: photoPath ?? this.photoPath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'brand': brand,
      'model': model,
      'plate': plate,
      'year': year,
      'photoPath': photoPath,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as String,
      nickname: map['nickname'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      plate: map['plate'] as String,
      year: map['year'] as int,
      photoPath: map['photoPath'] as String?,
    );
  }
}