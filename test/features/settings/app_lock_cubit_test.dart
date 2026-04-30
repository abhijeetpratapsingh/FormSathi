import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/settings/domain/usecases/app_lock_usecases.dart';
import 'package:formsathi/features/settings/presentation/cubit/app_lock_cubit.dart';

import 'fake_settings_repository.dart';

void main() {
  test('enable and unlock app lock with matching PIN', () async {
    final repository = FakeSettingsRepository();
    final cubit = AppLockCubit(
      enableAppLockUseCase: EnableAppLockUseCase(repository),
      verifyAppLockUseCase: VerifyAppLockUseCase(repository),
      disableAppLockUseCase: DisableAppLockUseCase(repository),
      shouldLockUseCase: ShouldLockUseCase(repository),
    );
    addTearDown(cubit.close);

    await cubit.enable('1234', '1234');
    expect(cubit.state.status, AppLockStatus.unlocked);

    await cubit.unlock('1234');
    expect(cubit.state.status, AppLockStatus.unlocked);
  });

  test('rejects mismatched setup PINs', () async {
    final repository = FakeSettingsRepository();
    final cubit = AppLockCubit(
      enableAppLockUseCase: EnableAppLockUseCase(repository),
      verifyAppLockUseCase: VerifyAppLockUseCase(repository),
      disableAppLockUseCase: DisableAppLockUseCase(repository),
      shouldLockUseCase: ShouldLockUseCase(repository),
    );
    addTearDown(cubit.close);

    await cubit.enable('1234', '4321');

    expect(cubit.state.errorMessage, isNotEmpty);
    expect(repository.credential, isNull);
  });
}
