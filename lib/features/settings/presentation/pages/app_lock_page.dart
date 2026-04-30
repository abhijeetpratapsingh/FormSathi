import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/app_lock_cubit.dart';

class AppLockPage extends StatefulWidget {
  const AppLockPage({super.key});

  @override
  State<AppLockPage> createState() => _AppLockPageState();
}

class _AppLockPageState extends State<AppLockPage> {
  late final AppLockCubit _cubit;
  final _controller = TextEditingController();
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cubit = AppLockCubit(
      enableAppLockUseCase: sl(),
      verifyAppLockUseCase: sl(),
      disableAppLockUseCase: sl(),
      shouldLockUseCase: sl(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.unlockRequired)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'PIN',
                  errorText: _error.isEmpty ? null : _error,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              FilledButton(
                onPressed: () async {
                  await _cubit.unlock(_controller.text);
                  if (_cubit.state.status == AppLockStatus.unlocked &&
                      context.mounted) {
                    context.go('/my-info');
                    return;
                  }
                  setState(() => _error = _cubit.state.errorMessage);
                },
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
