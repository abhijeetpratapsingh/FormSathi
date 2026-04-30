import 'package:hive/hive.dart';

import '../../features/documents/data/models/saved_document_model.dart';
import '../../features/my_info/data/models/user_info_model.dart';
import '../../features/settings/data/models/app_lock_credential_model.dart';
import '../../features/settings/data/models/privacy_settings_model.dart';
import '../../features/tools/data/models/processed_file_model.dart';

class UserInfoModelAdapter extends TypeAdapter<UserInfoModel> {
  @override
  final int typeId = 0;

  @override
  UserInfoModel read(BinaryReader reader) {
    return UserInfoModel(
      fullName: reader.readString(),
      fatherName: reader.readString(),
      motherName: reader.readString(),
      dob: reader.read(),
      gender: reader.readString(),
      phone: reader.readString(),
      email: reader.readString(),
      address: reader.readString(),
      city: reader.readString(),
      state: reader.readString(),
      pinCode: reader.readString(),
      aadhaar: reader.readString(),
      pan: reader.readString(),
      schoolCollege: reader.readString(),
      qualification: reader.readString(),
      category: reader.readString(),
      nationality: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoModel obj) {
    writer
      ..writeString(obj.fullName)
      ..writeString(obj.fatherName)
      ..writeString(obj.motherName)
      ..write(obj.dob)
      ..writeString(obj.gender)
      ..writeString(obj.phone)
      ..writeString(obj.email)
      ..writeString(obj.address)
      ..writeString(obj.city)
      ..writeString(obj.state)
      ..writeString(obj.pinCode)
      ..writeString(obj.aadhaar)
      ..writeString(obj.pan)
      ..writeString(obj.schoolCollege)
      ..writeString(obj.qualification)
      ..writeString(obj.category)
      ..writeString(obj.nationality);
  }
}

class SavedDocumentModelAdapter extends TypeAdapter<SavedDocumentModel> {
  @override
  final int typeId = 1;

  @override
  SavedDocumentModel read(BinaryReader reader) {
    final id = reader.readString();
    final title = reader.readString();
    final categoryName = reader.readString();
    final next = reader.read();
    if (next is String) {
      final maybeNext = _tryRead(reader);
      if (maybeNext is DateTime) {
        final updatedAt = _tryRead(reader) as DateTime? ?? maybeNext;
        return SavedDocumentModel(
          id: id,
          title: title,
          categoryName: categoryName,
          localPath: next,
          createdAt: maybeNext,
          updatedAt: updatedAt,
        );
      }
      return SavedDocumentModel(
        id: id,
        title: title,
        categoryName: categoryName,
        documentTypeName: next,
        localPath: maybeNext as String? ?? '',
        originalFileName: _tryRead(reader) as String? ?? '',
        mimeType: _tryRead(reader) as String? ?? '',
        fileSizeBytes: _tryRead(reader) as int? ?? 0,
        width: _tryRead(reader) as int?,
        height: _tryRead(reader) as int?,
        pageCount: _tryRead(reader) as int?,
        sideName: _tryRead(reader) as String? ?? 'none',
        notes: _tryRead(reader) as String? ?? '',
        createdAt: _tryRead(reader) as DateTime? ?? DateTime.now(),
        updatedAt: _tryRead(reader) as DateTime? ?? DateTime.now(),
      );
    }
    return SavedDocumentModel(
      id: id,
      title: title,
      categoryName: categoryName,
      localPath: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedDocumentModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.categoryName)
      ..writeString(obj.documentTypeName)
      ..writeString(obj.localPath)
      ..writeString(obj.originalFileName)
      ..writeString(obj.mimeType)
      ..write(obj.fileSizeBytes)
      ..write(obj.width)
      ..write(obj.height)
      ..write(obj.pageCount)
      ..writeString(obj.sideName)
      ..writeString(obj.notes)
      ..write(obj.createdAt)
      ..write(obj.updatedAt);
  }
}

class ProcessedFileModelAdapter extends TypeAdapter<ProcessedFileModel> {
  @override
  final int typeId = 2;

  @override
  ProcessedFileModel read(BinaryReader reader) {
    return ProcessedFileModel(
      id: reader.readString(),
      typeName: reader.readString(),
      localPath: reader.readString(),
      createdAt: reader.read() as DateTime,
      metadata: Map<String, String>.from(reader.readMap()),
      sourceDocumentId: _tryRead(reader) as String?,
      presetId: _tryRead(reader) as String?,
      fileSizeBytes: _tryRead(reader) as int? ?? 0,
      width: _tryRead(reader) as int?,
      height: _tryRead(reader) as int?,
      pageCount: _tryRead(reader) as int?,
      failureMessage: _tryRead(reader) as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, ProcessedFileModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.typeName)
      ..writeString(obj.localPath)
      ..write(obj.createdAt)
      ..writeMap(obj.metadata)
      ..write(obj.sourceDocumentId)
      ..write(obj.presetId)
      ..write(obj.fileSizeBytes)
      ..write(obj.width)
      ..write(obj.height)
      ..write(obj.pageCount)
      ..writeString(obj.failureMessage);
  }
}

class PrivacySettingsModelAdapter extends TypeAdapter<PrivacySettingsModel> {
  @override
  final int typeId = 3;

  @override
  PrivacySettingsModel read(BinaryReader reader) {
    return PrivacySettingsModel(
      firstRunPrivacySeen: reader.readBool(),
      appLockEnabled: reader.readBool(),
      lockTimeoutSeconds: reader.readInt(),
      lastUnlockedAt: reader.read() as DateTime?,
      sensitiveMaskingEnabled: reader.readBool(),
      secureStorageVersion: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PrivacySettingsModel obj) {
    writer
      ..writeBool(obj.firstRunPrivacySeen)
      ..writeBool(obj.appLockEnabled)
      ..writeInt(obj.lockTimeoutSeconds)
      ..write(obj.lastUnlockedAt)
      ..writeBool(obj.sensitiveMaskingEnabled)
      ..writeInt(obj.secureStorageVersion);
  }
}

class AppLockCredentialModelAdapter
    extends TypeAdapter<AppLockCredentialModel> {
  @override
  final int typeId = 4;

  @override
  AppLockCredentialModel read(BinaryReader reader) {
    return AppLockCredentialModel(
      credentialId: reader.readString(),
      pinVerifier: reader.readString(),
      createdAt: reader.read() as DateTime,
      updatedAt: reader.read() as DateTime,
      failedAttemptCount: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, AppLockCredentialModel obj) {
    writer
      ..writeString(obj.credentialId)
      ..writeString(obj.pinVerifier)
      ..write(obj.createdAt)
      ..write(obj.updatedAt)
      ..writeInt(obj.failedAttemptCount);
  }
}

Object? _tryRead(BinaryReader reader) {
  try {
    return reader.read();
  } catch (_) {
    return null;
  }
}
