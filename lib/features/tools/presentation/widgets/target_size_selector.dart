import 'package:flutter/material.dart';

class TargetSizeSelector extends StatelessWidget {
  const TargetSizeSelector({
    required this.selectedKb,
    required this.onSelected,
    super.key,
  });

  final int? selectedKb;
  final ValueChanged<int?> onSelected;

  static const presets = [20, 50, 100, 300];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('No target'),
          selected: selectedKb == null,
          onSelected: (_) => onSelected(null),
        ),
        for (final kb in presets)
          ChoiceChip(
            label: Text('Under ${kb}KB'),
            selected: selectedKb == kb,
            onSelected: (_) => onSelected(kb),
          ),
      ],
    );
  }
}
