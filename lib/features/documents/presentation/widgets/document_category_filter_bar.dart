import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_type.dart';

class DocumentCategoryFilterBar extends StatelessWidget {
  const DocumentCategoryFilterBar({
    required this.selectedType,
    required this.onSelected,
    super.key,
  });

  final DocumentType? selectedType;
  final ValueChanged<DocumentType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _FilterChip(
            label: 'All',
            selected: selectedType == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSizes.sm),
          for (final type in DocumentType.values) ...[
            _FilterChip(
              label: type.label,
              selected: selectedType == type,
              onTap: () => onSelected(type),
            ),
            const SizedBox(width: AppSizes.sm),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.onPrimary
            : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: theme.colorScheme.primary,
      side: BorderSide(color: theme.colorScheme.outline),
      shape: const RoundedRectangleBorder(borderRadius: AppSizes.fieldRadius),
    );
  }
}
