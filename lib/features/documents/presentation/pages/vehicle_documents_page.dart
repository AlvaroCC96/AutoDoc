import 'package:flutter/material.dart';

import '../../data/document_local_storage.dart';
import '../../domain/vehicle_document.dart';
import 'add_document_page.dart';

class VehicleDocumentsPage extends StatefulWidget {
  final String vehicleId;
  final String vehicleName;

  const VehicleDocumentsPage({
    super.key,
    required this.vehicleId,
    required this.vehicleName,
  });

  @override
  State<VehicleDocumentsPage> createState() => _VehicleDocumentsPageState();
}

class _VehicleDocumentsPageState extends State<VehicleDocumentsPage> {
  final DocumentLocalStorage _storage = DocumentLocalStorage();

  List<VehicleDocument> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    final allDocuments = await _storage.loadDocuments();

    if (!mounted) return;

    setState(() {
      _documents = allDocuments
          .where((doc) => doc.vehicleId == widget.vehicleId)
          .toList();
      _isLoading = false;
    });
  }

  Future<void> _persistAllDocuments(List<VehicleDocument> updatedVehicleDocs) async {
    final allDocuments = await _storage.loadDocuments();

    final documentsFromOtherVehicles = allDocuments
        .where((doc) => doc.vehicleId != widget.vehicleId)
        .toList();

    final merged = [...documentsFromOtherVehicles, ...updatedVehicleDocs];
    await _storage.saveDocuments(merged);
  }

  Future<void> _goToAddDocument() async {
    final document = await Navigator.of(context).push<VehicleDocument>(
      MaterialPageRoute(
        builder: (_) => AddDocumentPage(vehicleId: widget.vehicleId),
      ),
    );

    if (document == null) return;

    final updated = [..._documents, document];

    setState(() {
      _documents = updated;
    });

    await _persistAllDocuments(updated);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _statusLabel(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;

    if (difference < 0) return 'Vencido';
    if (difference <= 30) return 'Por vencer';
    return 'Vigente';
  }

  Color _statusColor(DateTime expiryDate) {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;

    if (difference < 0) return Colors.red;
    if (difference <= 30) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documentos - ${widget.vehicleName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _documents.isEmpty
                ? const Center(
                    child: Text('Aún no tienes documentos registrados'),
                  )
                : ListView.separated(
                    itemCount: _documents.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final document = _documents[index];
                      final statusColor = _statusColor(document.expiryDate);

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.description),
                          ),
                          title: Text(document.title),
                          subtitle: Text(
                            '${document.type}\nVence: ${_formatDate(document.expiryDate)}',
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            _statusLabel(document.expiryDate),
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToAddDocument,
        child: const Icon(Icons.add),
      ),
    );
  }
}