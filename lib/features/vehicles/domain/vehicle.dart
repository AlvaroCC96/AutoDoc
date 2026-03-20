class Vehicle {
  final String id;
  final String nickname;
  final String brand;
  final String model;
  final String plate;
  final int year;

  const Vehicle({
    required this.id,
    required this.nickname,
    required this.brand,
    required this.model,
    required this.plate,
    required this.year,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nickname': nickname,
      'brand': brand,
      'model': model,
      'plate': plate,
      'year': year,
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
    );
  }
}