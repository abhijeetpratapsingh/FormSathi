import 'package:flutter/material.dart';

import 'my_info_input_field.dart';

class MyInfoDateField extends StatelessWidget {
  const MyInfoDateField({
    required this.controller,
    required this.onPickDate,
    super.key,
    this.fieldKey,
    this.onCopy,
  });

  final TextEditingController controller;
  final VoidCallback onPickDate;
  final Key? fieldKey;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return MyInfoInputField(
      label: 'DOB',
      controller: controller,
      fieldKey: fieldKey,
      readOnly: true,
      onTap: onPickDate,
      onCopy: onCopy,
      prefixIcon: Icons.calendar_today_outlined,
      helperText: 'Used for forms that require date of birth.',
      keyboardType: TextInputType.datetime,
    );
  }
}
