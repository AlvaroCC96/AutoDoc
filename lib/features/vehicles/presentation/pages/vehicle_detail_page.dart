import 'package:flutter/material.dart';
import '../../domain/vehicle.dart';
import 'add_vehicle_page.dart';

class VehicleDetailPage extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleDetailPage({
    super.key,
    required this.vehicle,
  });

  @override
  State<VehicleDetailPage> createState() => _VehicleDetailPageState();
}

class _VehicleDetailPageState extends State<VehicleDetailPage> {
  late Vehicle _vehicle;

  @override
  void initState() {
    super.initState();
    _vehicle = widget.vehicle;
  }

  Future<void> _goToEditVehicle() async {
    final updatedVehicle = await Navigator.of(context).push<Vehicle>(
        MaterialPageRoute(
        builder: (_) => AddVehiclePage(initialVehicle: _vehicle),
        ),
    );

    if (updatedVehicle == null) return;

    setState(() {
        _vehicle = updatedVehicle;
    });
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar vehículo'),
          content: Text(
            '¿Seguro que quieres eliminar "${_vehicle.nickname}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true && context.mounted) {
      Navigator.of(context).pop({'deleted': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_vehicle.nickname),
        actions: [
          IconButton(
            onPressed: () async {
                final updatedVehicle = await Navigator.of(context).push<Vehicle>(
                MaterialPageRoute(
                    builder: (_) => AddVehiclePage(initialVehicle: _vehicle),
                ),
                );

                if (updatedVehicle == null) return;

                if (!mounted) return;

                setState(() {
                _vehicle = updatedVehicle;
                });

                Navigator.of(context).pop(updatedVehicle);
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _vehicle.nickname,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _InfoRow(label: 'Marca', value: _vehicle.brand),
                    _InfoRow(label: 'Modelo', value: _vehicle.model),
                    _InfoRow(label: 'Año', value: _vehicle.year.toString()),
                    _InfoRow(label: 'Patente', value: _vehicle.plate),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => _confirmDelete(context),
              icon: const Icon(Icons.delete),
              label: const Text('Eliminar vehículo'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}