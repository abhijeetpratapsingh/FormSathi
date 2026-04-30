import '../../domain/entities/user_info.dart';

class UserInfoModel {
  UserInfoModel({
    required this.fullName,
    required this.fatherName,
    required this.motherName,
    required this.dob,
    required this.gender,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.aadhaar,
    required this.pan,
    required this.schoolCollege,
    required this.qualification,
    required this.category,
    required this.nationality,
  });

  final String fullName;
  final String fatherName;
  final String motherName;
  final DateTime? dob;
  final String gender;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String pinCode;
  final String aadhaar;
  final String pan;
  final String schoolCollege;
  final String qualification;
  final String category;
  final String nationality;

  factory UserInfoModel.fromEntity(UserInfo entity) => UserInfoModel(
    fullName: entity.fullName,
    fatherName: entity.fatherName,
    motherName: entity.motherName,
    dob: entity.dob,
    gender: entity.gender,
    phone: entity.phone,
    email: entity.email,
    address: entity.address,
    city: entity.city,
    state: entity.state,
    pinCode: entity.pinCode,
    aadhaar: entity.aadhaar,
    pan: entity.pan,
    schoolCollege: entity.schoolCollege,
    qualification: entity.qualification,
    category: entity.category,
    nationality: entity.nationality,
  );

  UserInfo toEntity() => UserInfo(
    fullName: fullName,
    fatherName: fatherName,
    motherName: motherName,
    dob: dob,
    gender: gender,
    phone: phone,
    email: email,
    address: address,
    city: city,
    state: state,
    pinCode: pinCode,
    aadhaar: aadhaar,
    pan: pan,
    schoolCollege: schoolCollege,
    qualification: qualification,
    category: category,
    nationality: nationality,
  );
}
