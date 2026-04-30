import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/services/hive_adapters.dart';
import 'package:formsathi/core/services/hive_type_ids.dart';
import 'package:formsathi/features/documents/data/datasources/documents_local_data_source.dart';
import 'package:formsathi/features/documents/data/models/saved_document_model.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('formsathi_hive_docs');
    Hive.init(temp.path);
    if (!Hive.isAdapterRegistered(HiveTypeIds.savedDocument)) {
      Hive.registerAdapter(SavedDocumentModelAdapter());
    }
  });

  tearDown(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });

  test('migrates category-only records to matching document types', () async {
    final box = await Hive.openBox<SavedDocumentModel>('documents');
    final now = DateTime(2026);
    await box.put(
      'doc-1',
      SavedDocumentModel(
        id: 'doc-1',
        title: 'Old signature',
        categoryName: 'signature',
        documentTypeName: 'other',
        localPath: '/tmp/signature.jpg',
        createdAt: now,
        updatedAt: now,
      ),
    );

    await DocumentsLocalDataSource(box).migrateCategoryOnlyDocuments();

    final migrated = box.get('doc-1')!;
    expect(migrated.documentTypeName, 'signature');
    expect(migrated.categoryName, 'signature');
  });

  test(
    'round-trips typed document fields without corrupting string reads',
    () async {
      final box = await Hive.openBox<SavedDocumentModel>('documents');
      final now = DateTime(2026, 5);
      await box.put(
        'doc-2',
        SavedDocumentModel(
          id: 'doc-2',
          title: 'Aadhaar front',
          categoryName: 'aadhaar',
          documentTypeName: 'aadhaar',
          localPath: '/tmp/aadhaar-front.jpg',
          originalFileName: 'aadhaar-front.jpg',
          mimeType: 'image/jpeg',
          fileSizeBytes: 2048,
          width: 1200,
          height: 800,
          pageCount: null,
          sideName: 'front',
          notes: 'Clear scan',
          createdAt: now,
          updatedAt: now,
        ),
      );

      await box.close();
      final reopened = await Hive.openBox<SavedDocumentModel>('documents');
      final document = reopened.get('doc-2')!;

      expect(document.documentTypeName, 'aadhaar');
      expect(document.localPath, '/tmp/aadhaar-front.jpg');
      expect(document.originalFileName, 'aadhaar-front.jpg');
      expect(document.mimeType, 'image/jpeg');
      expect(document.fileSizeBytes, 2048);
      expect(document.width, 1200);
      expect(document.height, 800);
      expect(document.sideName, 'front');
      expect(document.notes, 'Clear scan');
    },
  );
}
