import 'package:flutter/material.dart';

import '../cubit/documents_state.dart';

class DocumentViewModeToggle extends StatelessWidget {
  const DocumentViewModeToggle({
    required this.viewMode,
    required this.onToggle,
    super.key,
  });

  final DocumentsViewMode viewMode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isList = viewMode == DocumentsViewMode.list;
    return Tooltip(
      message: isList ? 'Switch to grid view' : 'Switch to list view',
      child: Semantics(
        button: true,
        label: isList ? 'Switch to grid view' : 'Switch to list view',
        child: IconButton(
          onPressed: onToggle,
          icon: Icon(
            isList ? Icons.grid_view_rounded : Icons.view_list_rounded,
          ),
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
