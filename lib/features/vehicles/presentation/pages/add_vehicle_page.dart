import 'package:flutter/material.dart';
import '../../domain/vehicle.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();

  final _nicknameController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _yearController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    final vehicle = Vehicle(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nickname: _nicknameController.text.trim(),
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      plate: _plateController.text.trim().toUpperCase(),
      year: int.parse(_yearController.text.trim()),
    );

    Navigator.of(context).pop(vehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar vehículo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del vehículo',
                  hintText: 'Ej: Groove',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  hintText: 'Ej: Chevrolet',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la marca';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  hintText: 'Ej: Groove',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa el modelo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Año',
                    hintText: 'Ej: 2025',
                ),
                maxLength: 4,
                validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                        return 'Ingresa el año';
                    }

                    final yearText = value.trim();

                    // solo números
                    if (!RegExp(r'^\d+$').hasMatch(yearText)) {
                        return 'Solo números';
                    }

                    if (yearText.length != 4) {
                        return 'Debe tener 4 dígitos';
                    }

                    final year = int.parse(yearText);
                    if (year < 1900) {
                        return 'Debe ser mayor a 1900';
                    }

                    if (year > DateTime.now().year + 1) {
                        return 'Año no válido';
                    }
                    return null;
                },
            ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                    labelText: 'Patente',
                    hintText: 'Ej: ABCD11',
                ),
                maxLength: 6,
                validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                    return 'Ingresa la patente';
                    }

                    final plate = value.trim();

                    if (plate.length > 6) {
                    return 'Máximo 6 caracteres';
                    }

                    if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(plate)) {
                    return 'Solo letras y números';
                    }
                    return null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveVehicle,
                icon: const Icon(Icons.save),
                label: const Text('Guardar vehículo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}