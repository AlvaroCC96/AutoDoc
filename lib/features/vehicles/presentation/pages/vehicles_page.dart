import 'package:flutter/material.dart';
import 'dart:io';
import '../../data/vehicle_local_storage.dart';
import '../../domain/vehicle.dart';
import 'add_vehicle_page.dart';
import 'vehicle_detail_page.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final VehicleLocalStorage _storage = VehicleLocalStorage();

  List<Vehicle> _vehicles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final loadedVehicles = await _storage.loadVehicles();

    if (!mounted) return;

    setState(() {
      _vehicles = loadedVehicles;
      _isLoading = false;
    });
  }

  Future<void> _persistVehicles() async {
    await _storage.saveVehicles(_vehicles);
  }

  Future<void> _goToAddVehicle() async {
    final vehicle = await Navigator.of(context).push<Vehicle>(
      MaterialPageRoute(
        builder: (_) => const AddVehiclePage(),
      ),
    );

    if (vehicle == null) return;

    setState(() {
      _vehicles.add(vehicle);
    });

    await _persistVehicles();
  }

  Future<void> _goToVehicleDetail(Vehicle vehicle) async {
    final result = await Navigator.of(context).push<dynamic>(
      MaterialPageRoute(
        builder: (_) => VehicleDetailPage(vehicle: vehicle),
      ),
    );

    if (result == null) return;

    if (result is Map && result['deleted'] == true) {
      setState(() {
        _vehicles.removeWhere((item) => item.id == vehicle.id);
      });
      await _persistVehicles();
      return;
    }

    if (result is Vehicle) {
      final index = _vehicles.indexWhere((item) => item.id == result.id);

      if (index == -1) return;

      setState(() {
        _vehicles[index] = result;
      });

      await _persistVehicles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehículos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _vehicles.isEmpty
                ? const Center(
                    child: Text('Aún no tienes vehículos registrados'),
                  )
                : ListView.separated(
                    itemCount: _vehicles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final vehicle = _vehicles[index];

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: vehicle.photoPath != null
                                ? FileImage(File(vehicle.photoPath!))
                                : null,
                            child: vehicle.photoPath == null
                                ? const Icon(Icons.directions_car)
                                : null,
                          ),
                          title: Text(vehicle.nickname),
                          subtitle: Text(
                            '${vehicle.brand} ${vehicle.model} · ${vehicle.year}\nPatente: ${vehicle.plate}',
                          ),
                          isThreeLine: true,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => _goToVehicleDetail(vehicle),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddVehicle,
        child: const Icon(Icons.add),
      ),
    );
  }
}