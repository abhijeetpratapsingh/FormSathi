import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

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
    this.helperText,
    this.prefixIcon,
    this.textInputAction,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.enabled = true,
    this.fieldKey,
    this.focusNode,
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
  final String? helperText;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final int? maxLength;
  final bool enabled;
  final Key? fieldKey;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final suffixIcons = <Widget>[];
    if (onCopy != null) {
      suffixIcons.add(
        IconButton(
          icon: const Icon(Icons.copy_rounded),
          tooltip: 'Copy $label',
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          onPressed: onCopy,
        ),
      );
    }
    if (onToggleVisibility != null) {
      suffixIcons.add(
        IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          tooltip: obscureText ? 'Show $label' : 'Hide $label',
          constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
          onPressed: onToggleVisibility,
        ),
      );
    }

    final displayText = this.displayText;
    if (displayText != null) {
      return _FieldFrame(
        label: label,
        child: TextFormField(
          key: fieldKey,
          initialValue: displayText,
          focusNode: focusNode,
          readOnly: true,
          enabled: enabled,
          onTap: onTap,
          autovalidateMode: autovalidateMode,
          decoration: _decoration(suffixIcons),
        ),
      );
    }

    return _FieldFrame(
      label: label,
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        autofillHints: autofillHints,
        maxLength: maxLength,
        textCapitalization: textCapitalization,
        maxLines: maxLines,
        readOnly: readOnly,
        enabled: enabled,
        obscureText: obscureText,
        onTap: onTap,
        validator: validator,
        autovalidateMode: autovalidateMode,
        textInputAction: textInputAction,
        decoration: _decoration(suffixIcons),
      ),
    );
  }

  InputDecoration _decoration(List<Widget> suffixIcons) {
    return InputDecoration(
      labelText: null,
      hintText: hintText ?? label,
      helperText: helperText,
      prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      suffixIcon: suffixIcons.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsetsDirectional.only(end: 4),
              child: Row(mainAxisSize: MainAxisSize.min, children: suffixIcons),
            ),
    );
  }
}

class _FieldFrame extends StatelessWidget {
  const _FieldFrame({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2, bottom: 7),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.foreground.withValues(alpha: 0.76),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppSizes.fieldRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
