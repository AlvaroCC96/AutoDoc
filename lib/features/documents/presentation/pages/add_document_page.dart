import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/document_types.dart';
import '../../domain/vehicle_document.dart';

class AddDocumentPage extends StatefulWidget {
  final String vehicleId;

  const AddDocumentPage({
    super.key,
    required this.vehicleId,
  });

  @override
  State<AddDocumentPage> createState() => _AddDocumentPageState();
}

class _AddDocumentPageState extends State<AddDocumentPage> {
  final _formKey = GlobalKey<FormState>();
  static const _uuid = Uuid();

  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedType;
  DateTime? _selectedExpiryDate;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickExpiryDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedExpiryDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _selectedExpiryDate = picked;
    });
  }

  void _saveDocument() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedType == null || _selectedExpiryDate == null) return;

    final document = VehicleDocument(
      id: _uuid.v4(),
      vehicleId: widget.vehicleId,
      type: _selectedType!,
      title: _titleController.text.trim(),
      expiryDate: _selectedExpiryDate!,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    Navigator.of(context).pop(document);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar documento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Tipo de documento',
                ),
                items: documentTypes
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Selecciona un tipo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  hintText: 'Ej: SOAP 2026',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa un título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Fecha de vencimiento'),
                subtitle: Text(
                  _selectedExpiryDate == null
                      ? 'Selecciona una fecha'
                      : _formatDate(_selectedExpiryDate!),
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _pickExpiryDate,
              ),
              if (_selectedExpiryDate == null)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Debes seleccionar una fecha',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  hintText: 'Opcional',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveDocument,
                icon: const Icon(Icons.save),
                label: const Text('Guardar documento'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}