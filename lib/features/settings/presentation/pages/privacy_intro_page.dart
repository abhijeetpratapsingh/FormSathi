import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/section_card.dart';
import '../cubit/privacy_cubit.dart';

class PrivacyIntroPage extends StatefulWidget {
  const PrivacyIntroPage({super.key});

  @override
  State<PrivacyIntroPage> createState() => _PrivacyIntroPageState();
}

class _PrivacyIntroPageState extends State<PrivacyIntroPage> {
  late final PrivacyCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = PrivacyCubit(
      getPrivacySettingsUseCase: sl(),
      markPrivacyIntroSeenUseCase: sl(),
      savePrivacySettingsUseCase: sl(),
      wipeLocalDataUseCase: sl(),
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.privacyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            const SectionCard(child: Text(AppStrings.privacyIntro)),
            const SizedBox(height: AppSizes.md),
            FilledButton(
              onPressed: () async {
                await _cubit.markIntroSeen();
                if (context.mounted) context.go('/my-info');
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
