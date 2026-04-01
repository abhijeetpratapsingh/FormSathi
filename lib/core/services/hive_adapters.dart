import 'package:hive/hive.dart';

import '../../features/documents/data/models/saved_document_model.dart';
import '../../features/my_info/data/models/user_info_model.dart';
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
    return SavedDocumentModel(
      id: reader.readString(),
      title: reader.readString(),
      categoryName: reader.readString(),
      localPath: reader.readString(),
      createdAt: reader.read() as DateTime,
      updatedAt: reader.read() as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SavedDocumentModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.title)
      ..writeString(obj.categoryName)
      ..writeString(obj.localPath)
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
    );
  }

  @override
  void write(BinaryWriter writer, ProcessedFileModel obj) {
    writer
      ..writeString(obj.id)
      ..writeString(obj.typeName)
      ..writeString(obj.localPath)
      ..write(obj.createdAt)
      ..writeMap(obj.metadata);
  }
}
