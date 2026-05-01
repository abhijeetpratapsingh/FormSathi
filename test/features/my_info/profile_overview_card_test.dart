import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/my_info/presentation/widgets/profile_overview_card.dart';

void main() {
  testWidgets('profile overview card keeps progress and workflow actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOverviewCard(
            completion: 0.5,
            segments: const [true, false, false, true],
            nextStep: 'Complete contact details',
            autosaveLabel: 'Changes pending',
            autosaveIcon: Icons.cloud_off_outlined,
            autosaveTone: ProfileOverviewTone.warning,
            displayName: 'Asha Kumar',
            onTap: () {},
            onRetrySave: () {},
            onCopyAll: () {},
          ),
        ),
      ),
    );

    expect(find.text('My Info'), findsOneWidget);
    expect(find.text('Asha Kumar'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Complete contact details'), findsOneWidget);
    expect(find.text('Copy All'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.byTooltip('Changes pending'), findsOneWidget);
    expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsNothing);
  });

  testWidgets('profile overview shows spinner while saving', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProfileOverviewCard(
            completion: 1,
            segments: const [true, true, true, true],
            nextStep: 'Profile is form-ready',
            autosaveLabel: 'Saving...',
            autosaveIcon: Icons.sync_rounded,
            autosaveTone: ProfileOverviewTone.info,
            displayName: 'Asha Kumar',
            onTap: () {},
            onRetrySave: null,
            onCopyAll: () {},
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byTooltip('Saving...'), findsOneWidget);
  });
}
