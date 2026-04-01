import 'package:flutter/material.dart';

import 'my_info_input_field.dart';

class MyInfoDateField extends StatelessWidget {
  const MyInfoDateField({
    required this.controller,
    required this.onPickDate,
    super.key,
    this.onCopy,
  });

  final TextEditingController controller;
  final VoidCallback onPickDate;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return MyInfoInputField(
      label: 'DOB',
      controller: controller,
      readOnly: true,
      onTap: onPickDate,
      onCopy: onCopy,
      keyboardType: TextInputType.datetime,
    );
  }
}
