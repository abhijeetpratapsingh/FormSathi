import 'dart:io';

import 'package:flutter/material.dart';

class SelectedPdfImagesList extends StatelessWidget {
  const SelectedPdfImagesList({
    required this.imagePaths,
    required this.onReorder,
    required this.onRemove,
    super.key,
  });

  final List<String> imagePaths;
  final void Function(int oldIndex, int newIndex) onReorder;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagePaths.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final path = imagePaths[index];
        return Card(
          key: ValueKey(path),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(path),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(path.split('/').last),
            subtitle: Text('Page ${index + 1}'),
            trailing: IconButton(
              onPressed: () => onRemove(index),
              icon: const Icon(Icons.close),
            ),
          ),
        );
      },
    );
  }
}
