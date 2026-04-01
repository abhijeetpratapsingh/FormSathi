import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'router.dart';

class FormSathiApp extends StatelessWidget {
  const FormSathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Photo Resize & PDF for Forms – FormSathi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: AppRouter.router,
    );
  }
}
