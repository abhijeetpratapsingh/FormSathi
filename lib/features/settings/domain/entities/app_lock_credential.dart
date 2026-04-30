import 'package:equatable/equatable.dart';

class AppLockCredential extends Equatable {
  const AppLockCredential({
    required this.credentialId,
    required this.pinVerifier,
    required this.createdAt,
    required this.updatedAt,
    this.failedAttemptCount = 0,
  });

  final String credentialId;
  final String pinVerifier;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int failedAttemptCount;

  AppLockCredential copyWith({
    String? pinVerifier,
    DateTime? updatedAt,
    int? failedAttemptCount,
  }) {
    return AppLockCredential(
      credentialId: credentialId,
      pinVerifier: pinVerifier ?? this.pinVerifier,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      failedAttemptCount: failedAttemptCount ?? this.failedAttemptCount,
    );
  }

  @override
  List<Object?> get props => [
    credentialId,
    pinVerifier,
    createdAt,
    updatedAt,
    failedAttemptCount,
  ];
}
