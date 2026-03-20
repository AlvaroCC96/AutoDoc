class VehicleDocument {
  final String id;
  final String vehicleId;
  final String type;
  final String title;
  final DateTime expiryDate;
  final String? notes;

  const VehicleDocument({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.expiryDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'type': type,
      'title': title,
      'expiryDate': expiryDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory VehicleDocument.fromMap(Map<String, dynamic> map) {
    return VehicleDocument(
      id: map['id'] as String,
      vehicleId: map['vehicleId'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      expiryDate: DateTime.parse(map['expiryDate'] as String),
      notes: map['notes'] as String?,
    );
  }
}