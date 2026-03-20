import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../domain/vehicle.dart';

class VehicleLocalStorage {
  static const _vehiclesKey = 'vehicles';

  Future<List<Vehicle>> loadVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_vehiclesKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded
        .map((item) => Vehicle.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveVehicles(List<Vehicle> vehicles) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      vehicles.map((vehicle) => vehicle.toMap()).toList(),
    );

    await prefs.setString(_vehiclesKey, encoded);
  }

  Future<void> clearVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_vehiclesKey);
  }
}