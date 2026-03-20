import 'package:flutter/material.dart';
import '../../domain/vehicle.dart';
import 'add_vehicle_page.dart';
import 'vehicle_detail_page.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  final List<Vehicle> _vehicles = [
    const Vehicle(
      id: '1',
      nickname: 'Groove',
      brand: 'Chevrolet',
      model: 'Groove',
      plate: 'ABCD11',
      year: 2025,
    ),
  ];

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
      return;
    }

    if (result is Vehicle) {
      final index = _vehicles.indexWhere((item) => item.id == result.id);

      if (index == -1) return;

      setState(() {
        _vehicles[index] = result;
      });
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
        child: _vehicles.isEmpty
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
                      leading: const CircleAvatar(
                        child: Icon(Icons.directions_car),
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