import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/settings/domain/usecases/app_lock_usecases.dart';
import 'package:formsathi/features/settings/domain/usecases/privacy_usecases.dart';
import 'package:formsathi/features/settings/presentation/cubit/privacy_cubit.dart';

import 'fake_settings_repository.dart';

void main() {
  test('markIntroSeen persists privacy acknowledgement', () async {
    final repository = FakeSettingsRepository();
    final cubit = PrivacyCubit(
      getPrivacySettingsUseCase: GetPrivacySettingsUseCase(repository),
      markPrivacyIntroSeenUseCase: MarkPrivacyIntroSeenUseCase(repository),
      savePrivacySettingsUseCase: SavePrivacySettingsUseCase(repository),
      wipeLocalDataUseCase: WipeLocalDataUseCase(repository),
    );
    addTearDown(cubit.close);

    await cubit.markIntroSeen();

    expect(cubit.state.settings.firstRunPrivacySeen, isTrue);
  });
}
