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
    this.profilePhotoPath = '',
    this.customSections = const <CustomInfoSection>[],
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
  final String profilePhotoPath;
  final List<CustomInfoSection> customSections;

  bool get isEmpty => props.every((element) {
    if (element is List<CustomInfoSection>) {
      return element.isEmpty;
    }
    return element == null || element == '';
  });

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
    String? profilePhotoPath,
    List<CustomInfoSection>? customSections,
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
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      customSections: customSections ?? this.customSections,
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
    profilePhotoPath,
    customSections,
  ];
}

class CustomInfoSection extends Equatable {
  const CustomInfoSection({
    required this.id,
    required this.title,
    this.fields = const <CustomInfoField>[],
  });

  final String id;
  final String title;
  final List<CustomInfoField> fields;

  CustomInfoSection copyWith({
    String? id,
    String? title,
    List<CustomInfoField>? fields,
  }) {
    return CustomInfoSection(
      id: id ?? this.id,
      title: title ?? this.title,
      fields: fields ?? this.fields,
    );
  }

  @override
  List<Object?> get props => [id, title, fields];
}

class CustomInfoField extends Equatable {
  const CustomInfoField({
    required this.label,
    required this.value,
    this.fieldType = 'Text',
    this.isRequired = false,
  });

  final String label;
  final String value;
  final String fieldType;
  final bool isRequired;

  CustomInfoField copyWith({
    String? label,
    String? value,
    String? fieldType,
    bool? isRequired,
  }) {
    return CustomInfoField(
      label: label ?? this.label,
      value: value ?? this.value,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  @override
  List<Object?> get props => [label, value, fieldType, isRequired];
}
