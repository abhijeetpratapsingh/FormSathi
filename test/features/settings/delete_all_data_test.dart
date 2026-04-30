import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/di.dart';
import 'package:formsathi/features/settings/domain/entities/app_lock_credential.dart';
import 'package:formsathi/features/settings/domain/entities/privacy_settings.dart';
import 'package:formsathi/features/settings/domain/entities/wipe_result.dart';
import 'package:formsathi/features/settings/domain/repositories/settings_repository.dart';
import 'package:formsathi/features/settings/domain/usecases/app_lock_usecases.dart';
import 'package:formsathi/features/settings/domain/usecases/privacy_usecases.dart';
import 'package:formsathi/features/settings/presentation/pages/settings_page.dart';
import 'package:formsathi/features/settings/presentation/widgets/delete_all_data_dialog.dart';

void main() {
  late _FakeSettingsRepository repository;

  setUp(() async {
    await sl.reset();
    repository = _FakeSettingsRepository();
    sl
      ..registerSingleton<SettingsRepository>(repository)
      ..registerFactory(() => GetPrivacySettingsUseCase(sl()))
      ..registerFactory(() => EnableAppLockUseCase(sl()))
      ..registerFactory(() => VerifyAppLockUseCase(sl()))
      ..registerFactory(() => DisableAppLockUseCase(sl()))
      ..registerFactory(() => ShouldLockUseCase(sl()))
      ..registerFactory(() => MarkPrivacyIntroSeenUseCase(sl()))
      ..registerFactory(() => SavePrivacySettingsUseCase(sl()))
      ..registerFactory(() => WipeLocalDataUseCase(sl()));
  });

  tearDown(sl.reset);

  testWidgets('delete dialog requires explicit confirmation', (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) =>
                    DeleteAllDataDialog(onConfirm: () => confirmed = true),
              );
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(confirmed, isFalse);

    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
  });

  testWidgets('settings delete action can read privacy cubit from page scope', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete all local data'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Delete all local data?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repository.wipeCount, 1);
  });
}

class _FakeSettingsRepository implements SettingsRepository {
  PrivacySettings settings = const PrivacySettings();
  AppLockCredential? credential;
  int wipeCount = 0;

  @override
  Future<void> deleteAppLockCredential() async {
    credential = null;
  }

  @override
  Future<AppLockCredential?> getAppLockCredential() async => credential;

  @override
  Future<PrivacySettings> getPrivacySettings() async => settings;

  @override
  Future<void> saveAppLockCredential(AppLockCredential credential) async {
    this.credential = credential;
  }

  @override
  Future<void> savePrivacySettings(PrivacySettings settings) async {
    this.settings = settings;
  }

  @override
  Future<WipeResult> wipeLocalData() async {
    wipeCount += 1;
    settings = const PrivacySettings();
    return const WipeResult(
      deletedInfo: true,
      deletedDocumentRecords: 0,
      deletedDocumentFiles: 0,
      deletedProcessedRecords: 0,
      deletedProcessedFiles: 0,
    );
  }
}
