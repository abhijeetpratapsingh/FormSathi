import 'package:hive/hive.dart';

import '../../../../core/services/hive_type_ids.dart';
import '../../domain/entities/app_lock_credential.dart';

@HiveType(typeId: HiveTypeIds.appLockCredential)
class AppLockCredentialModel extends HiveObject {
  AppLockCredentialModel({
    required this.credentialId,
    required this.pinVerifier,
    required this.createdAt,
    required this.updatedAt,
    required this.failedAttemptCount,
  });

  @HiveField(0)
  final String credentialId;
  @HiveField(1)
  final String pinVerifier;
  @HiveField(2)
  final DateTime createdAt;
  @HiveField(3)
  final DateTime updatedAt;
  @HiveField(4)
  final int failedAttemptCount;

  factory AppLockCredentialModel.fromEntity(AppLockCredential entity) =>
      AppLockCredentialModel(
        credentialId: entity.credentialId,
        pinVerifier: entity.pinVerifier,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        failedAttemptCount: entity.failedAttemptCount,
      );

  AppLockCredential toEntity() => AppLockCredential(
    credentialId: credentialId,
    pinVerifier: pinVerifier,
    createdAt: createdAt,
    updatedAt: updatedAt,
    failedAttemptCount: failedAttemptCount,
  );
}
