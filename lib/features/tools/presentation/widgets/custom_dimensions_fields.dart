import 'package:flutter/material.dart';

class CustomDimensionsFields extends StatelessWidget {
  const CustomDimensionsFields({
    required this.width,
    required this.height,
    required this.onChanged,
    super.key,
  });

  final int? width;
  final int? height;
  final void Function(int? width, int? height) onChanged;

  @override
  Widget build(BuildContext context) {
    final widthController = TextEditingController(
      text: width?.toString() ?? '',
    );
    final heightController = TextEditingController(
      text: height?.toString() ?? '',
    );
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widthController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Width'),
            onChanged: (value) => onChanged(
              int.tryParse(value),
              int.tryParse(heightController.text),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: heightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Height'),
            onChanged: (value) => onChanged(
              int.tryParse(widthController.text),
              int.tryParse(value),
            ),
          ),
        ),
      ],
    );
  }
}
