import 'package:equatable/equatable.dart';

import '../../../../core/enums/document_category.dart';

class SavedDocument extends Equatable {
  const SavedDocument({
    required this.id,
    required this.title,
    required this.category,
    required this.localPath,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final DocumentCategory category;
  final String localPath;
  final DateTime createdAt;
  final DateTime updatedAt;

  SavedDocument copyWith({
    String? title,
    DocumentCategory? category,
    String? localPath,
    DateTime? updatedAt,
  }) {
    return SavedDocument(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      localPath: localPath ?? this.localPath,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, category, localPath, createdAt, updatedAt];
}
