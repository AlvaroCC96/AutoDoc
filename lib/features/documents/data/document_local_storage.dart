import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/vehicle_document.dart';

class DocumentLocalStorage {
  static const _documentsKey = 'vehicle_documents';

  Future<List<VehicleDocument>> loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_documentsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded
        .map((item) => VehicleDocument.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveDocuments(List<VehicleDocument> documents) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      documents.map((document) => document.toMap()).toList(),
    );

    await prefs.setString(_documentsKey, encoded);
  }
}