import 'package:hive/hive.dart';

import '../../../../core/services/hive_type_ids.dart';
import '../../domain/entities/privacy_settings.dart';

@HiveType(typeId: HiveTypeIds.privacySettings)
class PrivacySettingsModel extends HiveObject {
  PrivacySettingsModel({
    required this.firstRunPrivacySeen,
    required this.appLockEnabled,
    required this.lockTimeoutSeconds,
    required this.lastUnlockedAt,
    required this.sensitiveMaskingEnabled,
    required this.secureStorageVersion,
  });

  @HiveField(0)
  final bool firstRunPrivacySeen;
  @HiveField(1)
  final bool appLockEnabled;
  @HiveField(2)
  final int lockTimeoutSeconds;
  @HiveField(3)
  final DateTime? lastUnlockedAt;
  @HiveField(4)
  final bool sensitiveMaskingEnabled;
  @HiveField(5)
  final int secureStorageVersion;

  factory PrivacySettingsModel.fromEntity(PrivacySettings entity) =>
      PrivacySettingsModel(
        firstRunPrivacySeen: entity.firstRunPrivacySeen,
        appLockEnabled: entity.appLockEnabled,
        lockTimeoutSeconds: entity.lockTimeoutSeconds,
        lastUnlockedAt: entity.lastUnlockedAt,
        sensitiveMaskingEnabled: entity.sensitiveMaskingEnabled,
        secureStorageVersion: entity.secureStorageVersion,
      );

  PrivacySettings toEntity() => PrivacySettings(
    firstRunPrivacySeen: firstRunPrivacySeen,
    appLockEnabled: appLockEnabled,
    lockTimeoutSeconds: lockTimeoutSeconds,
    lastUnlockedAt: lastUnlockedAt,
    sensitiveMaskingEnabled: sensitiveMaskingEnabled,
    secureStorageVersion: secureStorageVersion,
  );
}
