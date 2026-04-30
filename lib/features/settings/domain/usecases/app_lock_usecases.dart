import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';

import '../entities/app_lock_credential.dart';
import '../entities/privacy_settings.dart';
import '../repositories/settings_repository.dart';

class GetPrivacySettingsUseCase {
  const GetPrivacySettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<PrivacySettings> call() => _repository.getPrivacySettings();
}

class EnableAppLockUseCase {
  const EnableAppLockUseCase(this._repository, {Uuid? uuid})
    : _uuid = uuid ?? const Uuid();

  final SettingsRepository _repository;
  final Uuid _uuid;

  Future<void> call(String pin) async {
    final now = DateTime.now();
    final credential = AppLockCredential(
      credentialId: _uuid.v4(),
      pinVerifier: _hashPin(pin),
      createdAt: now,
      updatedAt: now,
    );
    await _repository.saveAppLockCredential(credential);
    final settings = await _repository.getPrivacySettings();
    await _repository.savePrivacySettings(
      settings.copyWith(appLockEnabled: true, lastUnlockedAt: now),
    );
  }
}

class VerifyAppLockUseCase {
  const VerifyAppLockUseCase(this._repository);

  final SettingsRepository _repository;

  Future<bool> call(String pin) async {
    final credential = await _repository.getAppLockCredential();
    if (credential == null) return false;
    final matches = credential.pinVerifier == _hashPin(pin);
    if (matches) {
      final settings = await _repository.getPrivacySettings();
      await _repository.savePrivacySettings(
        settings.copyWith(lastUnlockedAt: DateTime.now()),
      );
      await _repository.saveAppLockCredential(
        credential.copyWith(failedAttemptCount: 0, updatedAt: DateTime.now()),
      );
      return true;
    }
    await _repository.saveAppLockCredential(
      credential.copyWith(
        failedAttemptCount: credential.failedAttemptCount + 1,
        updatedAt: DateTime.now(),
      ),
    );
    return false;
  }
}

class DisableAppLockUseCase {
  const DisableAppLockUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call() async {
    await _repository.deleteAppLockCredential();
    final settings = await _repository.getPrivacySettings();
    await _repository.savePrivacySettings(
      settings.copyWith(appLockEnabled: false, clearLastUnlockedAt: true),
    );
  }
}

class ShouldLockUseCase {
  const ShouldLockUseCase(this._repository);

  final SettingsRepository _repository;

  Future<bool> call(DateTime now) async {
    final settings = await _repository.getPrivacySettings();
    if (!settings.appLockEnabled) return false;
    final lastUnlockedAt = settings.lastUnlockedAt;
    if (lastUnlockedAt == null) return true;
    return now.difference(lastUnlockedAt).inSeconds >=
        settings.lockTimeoutSeconds;
  }
}

String _hashPin(String pin) {
  return sha256.convert(utf8.encode('formsathi:$pin')).toString();
}
