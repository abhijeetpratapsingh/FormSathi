import '../entities/privacy_settings.dart';
import '../entities/wipe_result.dart';
import '../repositories/settings_repository.dart';

class MarkPrivacyIntroSeenUseCase {
  const MarkPrivacyIntroSeenUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call() async {
    final settings = await _repository.getPrivacySettings();
    await _repository.savePrivacySettings(
      settings.copyWith(firstRunPrivacySeen: true),
    );
  }
}

class SavePrivacySettingsUseCase {
  const SavePrivacySettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(PrivacySettings settings) =>
      _repository.savePrivacySettings(settings);
}

class WipeLocalDataUseCase {
  const WipeLocalDataUseCase(this._repository);

  final SettingsRepository _repository;

  Future<WipeResult> call() => _repository.wipeLocalData();
}
