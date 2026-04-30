import 'package:hive/hive.dart';

import '../models/saved_document_model.dart';

class DocumentsLocalDataSource {
  DocumentsLocalDataSource(this._box);

  final Box<SavedDocumentModel> _box;

  List<SavedDocumentModel> getDocuments() =>
      _box.values.toList(growable: false);

  Future<void> saveDocument(SavedDocumentModel model) =>
      _box.put(model.id, model);

  Future<void> deleteDocument(String id) => _box.delete(id);

  Future<void> clearDocuments() => _box.clear();

  Future<void> migrateCategoryOnlyDocuments() async {
    for (final item in _box.values) {
      if (item.documentTypeName != 'other') continue;
      final migrated = SavedDocumentModel(
        id: item.id,
        title: item.title,
        categoryName: item.categoryName,
        documentTypeName: _documentTypeNameForCategory(item.categoryName),
        localPath: item.localPath,
        originalFileName: item.originalFileName,
        mimeType: item.mimeType,
        fileSizeBytes: item.fileSizeBytes,
        width: item.width,
        height: item.height,
        pageCount: item.pageCount,
        sideName: item.sideName,
        notes: item.notes,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      );
      await _box.put(item.id, migrated);
    }
  }

  String _documentTypeNameForCategory(String categoryName) {
    return switch (categoryName) {
      'passportPhoto' => 'passportPhoto',
      'signature' => 'signature',
      'aadhaar' => 'aadhaar',
      'pan' => 'pan',
      'marksheet' => 'marksheet',
      'certificate' => 'certificate',
      _ => 'other',
    };
  }
}
