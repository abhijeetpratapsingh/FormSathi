import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/settings/domain/usecases/app_lock_usecases.dart';
import 'di.dart';
import 'router.dart';

class FormSathiApp extends StatefulWidget {
  const FormSathiApp({super.key});

  @override
  State<FormSathiApp> createState() => _FormSathiAppState();
}

class _FormSathiAppState extends State<FormSathiApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed ||
        !sl.isRegistered<ShouldLockUseCase>()) {
      return;
    }
    sl<ShouldLockUseCase>()(DateTime.now()).then((shouldLock) {
      if (shouldLock && mounted) {
        AppRouter.router.go('/app-lock');
      }
    });
  }

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
