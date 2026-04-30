import 'package:flutter/material.dart';

class DeleteAllDataDialog extends StatelessWidget {
  const DeleteAllDataDialog({required this.onConfirm, super.key});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete all local data?'),
      content: const Text(
        'This removes saved info, documents, and processed files from this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
