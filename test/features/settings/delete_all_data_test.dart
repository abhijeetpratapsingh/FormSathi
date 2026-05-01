import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/app/di.dart';
import 'package:formsathi/features/my_info/domain/entities/user_info.dart';
import 'package:formsathi/features/my_info/domain/repositories/my_info_repository.dart';
import 'package:formsathi/features/my_info/domain/usecases/get_user_info.dart';
import 'package:formsathi/features/my_info/domain/usecases/save_user_info.dart';
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
  late _FakeMyInfoRepository myInfoRepository;

  setUp(() async {
    await sl.reset();
    repository = _FakeSettingsRepository();
    myInfoRepository = _FakeMyInfoRepository();
    sl
      ..registerSingleton<MyInfoRepository>(myInfoRepository)
      ..registerSingleton<SettingsRepository>(repository)
      ..registerFactory(() => GetUserInfo(sl()))
      ..registerFactory(() => SaveUserInfo(sl()))
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

    await tester.tap(find.byTooltip('More actions'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Delete all info from this device'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Delete all local data?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();

    expect(repository.wipeCount, 1);
  });

  testWidgets('settings renders moved profile summary card', (tester) async {
    myInfoRepository.userInfo = const UserInfo(
      fullName: 'Asha Kumar',
      email: 'asha@example.com',
      phone: '+91 9999999999',
    );

    await tester.pumpWidget(const MaterialApp(home: SettingsPage()));
    await tester.pumpAndSettle();

    expect(find.text('Your Profile'), findsOneWidget);
    expect(find.text('Asha Kumar'), findsOneWidget);
    expect(
      find.text('Update your photo here, then manage full profile details from Info.'),
      findsOneWidget,
    );
    expect(find.text('Progress'), findsNothing);
    expect(find.text('Copy All'), findsNothing);
    expect(find.text('Retry Save'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);
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

class _FakeMyInfoRepository implements MyInfoRepository {
  UserInfo userInfo = const UserInfo();

  @override
  Future<void> clearUserInfo() async {
    userInfo = const UserInfo();
  }

  @override
  Future<UserInfo> getUserInfo() async => userInfo;

  @override
  Future<void> saveUserInfo(UserInfo userInfo) async {
    this.userInfo = userInfo;
  }
}
