import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
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
    return SegmentedButton<DocumentsViewMode>(
      segments: const [
        ButtonSegment(
          value: DocumentsViewMode.grid,
          icon: Icon(Icons.grid_view_rounded),
        ),
        ButtonSegment(
          value: DocumentsViewMode.list,
          icon: Icon(Icons.view_list_rounded),
        ),
      ],
      selected: {viewMode},
      onSelectionChanged: (_) => onToggle(),
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSizes.sm),
        ),
        visualDensity: VisualDensity.compact,
        side: WidgetStatePropertyAll(
          BorderSide(color: theme.colorScheme.outline),
        ),
      ),
    );
  }
}
