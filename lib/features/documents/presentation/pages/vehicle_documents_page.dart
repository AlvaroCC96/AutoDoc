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
  State<VehicleDocumentsPage> createState() =>
      _VehicleDocumentsPageState();
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

  // 🔥 NUEVO: lógica de alertas
  void _checkExpiringDocuments(List<VehicleDocument> docs) {
    final now = DateTime.now();

    final expired = docs.where((doc) {
      return doc.expiryDate.isBefore(now);
    }).toList();

    final expiring = docs.where((doc) {
      final diff = doc.expiryDate.difference(now).inDays;
      return diff >= 0 && diff <= 30;
    }).toList();

    if (!mounted) return;

    if (expired.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tienes ${expired.length} documento(s) vencido(s)',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else if (expiring.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tienes ${expiring.length} documento(s) por vencer',
          ),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _loadDocuments() async {
    final allDocuments = await _storage.loadDocuments();

    if (!mounted) return;

    final vehicleDocs = allDocuments
        .where((doc) => doc.vehicleId == widget.vehicleId)
        .toList();

    setState(() {
      _documents = vehicleDocs;
      _isLoading = false;
    });

    // 🔥 clave: ejecutar después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkExpiringDocuments(vehicleDocs);
    });
  }

  Future<void> _persistAllDocuments(
    List<VehicleDocument> updatedVehicleDocs,
  ) async {
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

    // 🔥 también evaluar después de agregar
    _checkExpiringDocuments(updated);
  }

  Future<void> _deleteDocument(VehicleDocument document) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar documento'),
          content: Text(
            '¿Seguro que quieres eliminar "${document.title}"?',
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

    if (shouldDelete != true) return;

    final updated = _documents
        .where((item) => item.id != document.id)
        .toList();

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
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final document = _documents[index];
                      final statusColor =
                          _statusColor(document.expiryDate);

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
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'delete') {
                                _deleteDocument(document);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Eliminar'),
                              ),
                            ],
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