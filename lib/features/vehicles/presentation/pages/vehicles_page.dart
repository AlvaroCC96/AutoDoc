import 'package:flutter/material.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicles = [
      {
        'name': 'Groove',
        'brand': 'Chevrolet',
        'model': 'Groove',
        'plate': 'ABCD11',
        'year': '2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis vehículos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: vehicles.isEmpty
            ? const Center(
                child: Text('Aún no tienes vehículos registrados'),
              )
            : ListView.separated(
                itemCount: vehicles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.directions_car),
                      ),
                      title: Text(vehicle['name']!),
                      subtitle: Text(
                        '${vehicle['brand']} ${vehicle['model']} · ${vehicle['year']}\nPatente: ${vehicle['plate']}',
                      ),
                      isThreeLine: true,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}