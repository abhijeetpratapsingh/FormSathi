import 'package:equatable/equatable.dart';

class PrivacySettings extends Equatable {
  const PrivacySettings({
    this.firstRunPrivacySeen = false,
    this.appLockEnabled = false,
    this.lockTimeoutSeconds = 60,
    this.lastUnlockedAt,
    this.sensitiveMaskingEnabled = true,
    this.secureStorageVersion = 1,
  });

  final bool firstRunPrivacySeen;
  final bool appLockEnabled;
  final int lockTimeoutSeconds;
  final DateTime? lastUnlockedAt;
  final bool sensitiveMaskingEnabled;
  final int secureStorageVersion;

  PrivacySettings copyWith({
    bool? firstRunPrivacySeen,
    bool? appLockEnabled,
    int? lockTimeoutSeconds,
    DateTime? lastUnlockedAt,
    bool clearLastUnlockedAt = false,
    bool? sensitiveMaskingEnabled,
    int? secureStorageVersion,
  }) {
    return PrivacySettings(
      firstRunPrivacySeen: firstRunPrivacySeen ?? this.firstRunPrivacySeen,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      lockTimeoutSeconds: lockTimeoutSeconds ?? this.lockTimeoutSeconds,
      lastUnlockedAt: clearLastUnlockedAt
          ? null
          : (lastUnlockedAt ?? this.lastUnlockedAt),
      sensitiveMaskingEnabled:
          sensitiveMaskingEnabled ?? this.sensitiveMaskingEnabled,
      secureStorageVersion: secureStorageVersion ?? this.secureStorageVersion,
    );
  }

  @override
  List<Object?> get props => [
    firstRunPrivacySeen,
    appLockEnabled,
    lockTimeoutSeconds,
    lastUnlockedAt,
    sensitiveMaskingEnabled,
    secureStorageVersion,
  ];
}
