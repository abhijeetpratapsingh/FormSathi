import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class PinSetupSheet extends StatefulWidget {
  const PinSetupSheet({required this.onSubmit, super.key});

  final Future<void> Function(String pin, String confirmation) onSubmit;

  @override
  State<PinSetupSheet> createState() => _PinSetupSheetState();
}

class _PinSetupSheetState extends State<PinSetupSheet> {
  final _pin = TextEditingController();
  final _confirmation = TextEditingController();

  @override
  void dispose() {
    _pin.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Set PIN', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSizes.md),
          TextField(
            controller: _pin,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'PIN'),
          ),
          const SizedBox(height: AppSizes.sm),
          TextField(
            controller: _confirmation,
            obscureText: true,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Confirm PIN'),
          ),
          const SizedBox(height: AppSizes.md),
          FilledButton(
            onPressed: () async {
              await widget.onSubmit(_pin.text, _confirmation.text);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
  }
}
