import 'package:flutter/material.dart';

class MyInfoInputField extends StatelessWidget {
  const MyInfoInputField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.readOnly = false,
    this.obscureText = false,
    this.displayText,
    this.onTap,
    this.onCopy,
    this.onToggleVisibility,
    this.validator,
  });

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool readOnly;
  final bool obscureText;
  final String? displayText;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;
  final VoidCallback? onToggleVisibility;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final suffixIcons = <Widget>[];
    if (onCopy != null) {
      suffixIcons.add(
        IconButton(
          icon: const Icon(Icons.copy_rounded),
          tooltip: 'Copy $label',
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: onCopy,
        ),
      );
    }
    if (onToggleVisibility != null) {
      suffixIcons.add(
        IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          tooltip: obscureText ? 'Show $label' : 'Hide $label',
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          onPressed: onToggleVisibility,
        ),
      );
    }

    final displayText = this.displayText;
    if (displayText != null) {
      return TextFormField(
        initialValue: displayText,
        readOnly: true,
        onTap: onTap,
        decoration: _decoration(suffixIcons),
      );
    }

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines,
      readOnly: readOnly,
      obscureText: obscureText,
      onTap: onTap,
      validator: validator,
      decoration: _decoration(suffixIcons),
    );
  }

  InputDecoration _decoration(List<Widget> suffixIcons) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      suffixIcon: suffixIcons.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: suffixIcons),
            ),
    );
  }
}
