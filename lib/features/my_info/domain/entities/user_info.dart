import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  const UserInfo({
    this.fullName = '',
    this.fatherName = '',
    this.motherName = '',
    this.dob,
    this.gender = '',
    this.phone = '',
    this.email = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.pinCode = '',
    this.aadhaar = '',
    this.pan = '',
    this.schoolCollege = '',
    this.qualification = '',
    this.category = '',
    this.nationality = '',
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

  bool get isEmpty =>
      props.every((element) => element == null || element == '');

  UserInfo copyWith({
    String? fullName,
    String? fatherName,
    String? motherName,
    DateTime? dob,
    bool clearDob = false,
    String? gender,
    String? phone,
    String? email,
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? aadhaar,
    String? pan,
    String? schoolCollege,
    String? qualification,
    String? category,
    String? nationality,
  }) {
    return UserInfo(
      fullName: fullName ?? this.fullName,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      dob: clearDob ? null : (dob ?? this.dob),
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      aadhaar: aadhaar ?? this.aadhaar,
      pan: pan ?? this.pan,
      schoolCollege: schoolCollege ?? this.schoolCollege,
      qualification: qualification ?? this.qualification,
      category: category ?? this.category,
      nationality: nationality ?? this.nationality,
    );
  }

  @override
  List<Object?> get props => [
    fullName,
    fatherName,
    motherName,
    dob,
    gender,
    phone,
    email,
    address,
    city,
    state,
    pinCode,
    aadhaar,
    pan,
    schoolCollege,
    qualification,
    category,
    nationality,
  ];
}
