import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';
import 'enterprise_top_bar.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    super.key,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EnterpriseTopBar(title: title, actions: actions, compact: true),
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(AppSizes.md), child: body),
      ),
    );
  }
}
