import 'package:hive/hive.dart';

import '../models/saved_document_model.dart';

class DocumentsLocalDataSource {
  DocumentsLocalDataSource(this._box);

  final Box<SavedDocumentModel> _box;

  List<SavedDocumentModel> getDocuments() => _box.values.toList(growable: false);

  Future<void> saveDocument(SavedDocumentModel model) => _box.put(model.id, model);

  Future<void> deleteDocument(String id) => _box.delete(id);
}
