import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/empty_state_card.dart';

class DocumentEmptyState extends StatelessWidget {
  const DocumentEmptyState({super.key, this.searching = false});

  final bool searching;

  @override
  Widget build(BuildContext context) {
    return EmptyStateCard(
      icon: searching ? Icons.search_off_rounded : Icons.folder_open_rounded,
      title: searching
          ? 'No matching documents'
          : 'Add your photo and documents',
      message: searching
          ? 'Try a different title or clear the category filter.'
          : AppStrings.documentsEmpty,
    );
  }
}
