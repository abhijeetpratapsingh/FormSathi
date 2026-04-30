import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/document_category.dart';

class DocumentCategoryFilterBar extends StatelessWidget {
  const DocumentCategoryFilterBar({
    required this.selectedCategory,
    required this.onSelected,
    super.key,
  });

  final DocumentCategory? selectedCategory;
  final ValueChanged<DocumentCategory?> onSelected;

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
            selected: selectedCategory == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: AppSizes.sm),
          for (final category in DocumentCategory.values) ...[
            _FilterChip(
              label: category.label,
              selected: selectedCategory == category,
              onTap: () => onSelected(category),
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
        color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: theme.colorScheme.primary,
      side: BorderSide(color: theme.colorScheme.outline),
      shape: RoundedRectangleBorder(borderRadius: AppSizes.fieldRadius),
    );
  }
}
