import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/section_card.dart';
import '../widgets/feature_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.info_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.playStoreTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Text(
                    AppStrings.homeSubtitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
            FeatureCard(
              title: 'My Info',
              subtitle: 'Save once, copy anytime during form filling.',
              icon: Icons.badge_outlined,
              onTap: () => context.push('/my-info'),
            ),
            FeatureCard(
              title: 'My Documents',
              subtitle: 'Keep photo, signature, Aadhaar, PAN, and certificates ready.',
              icon: Icons.folder_copy_outlined,
              onTap: () => context.push('/documents'),
            ),
            FeatureCard(
              title: 'Tools',
              subtitle: 'Resize photos, compress images, and convert images to PDF.',
              icon: Icons.tune_rounded,
              onTap: () => context.push('/tools'),
            ),
          ],
        ),
      ),
    );
  }
}
