import 'package:hive/hive.dart';

import '../models/app_lock_credential_model.dart';
import '../models/privacy_settings_model.dart';

class PrivacyLocalDataSource {
  PrivacyLocalDataSource({
    required Box<PrivacySettingsModel> settingsBox,
    required Box<AppLockCredentialModel> credentialBox,
  }) : _settingsBox = settingsBox,
       _credentialBox = credentialBox;

  static const _settingsKey = 'privacy_settings';
  static const _credentialKey = 'app_lock_credential';

  final Box<PrivacySettingsModel> _settingsBox;
  final Box<AppLockCredentialModel> _credentialBox;

  PrivacySettingsModel? getSettings() => _settingsBox.get(_settingsKey);

  Future<void> saveSettings(PrivacySettingsModel model) =>
      _settingsBox.put(_settingsKey, model);

  AppLockCredentialModel? getCredential() => _credentialBox.get(_credentialKey);

  Future<void> saveCredential(AppLockCredentialModel model) =>
      _credentialBox.put(_credentialKey, model);

  Future<void> deleteCredential() => _credentialBox.delete(_credentialKey);

  Future<void> clear() async {
    await _settingsBox.clear();
    await _credentialBox.clear();
  }
}
