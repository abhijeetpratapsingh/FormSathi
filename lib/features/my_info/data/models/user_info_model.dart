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
    profilePhotoPath: entity.profilePhotoPath,
    customSections: entity.customSections,
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
    profilePhotoPath: profilePhotoPath,
    customSections: customSections,
  );

  List<Map<String, Object?>> customSectionsToJson() {
    return customSections
        .map(
          (section) => <String, Object?>{
            'id': section.id,
            'title': section.title,
            'fields': section.fields
                .map(
                  (field) => <String, String>{
                    'label': field.label,
                    'value': field.value,
                    'fieldType': field.fieldType,
                    'isRequired': field.isRequired.toString(),
                  },
                )
                .toList(growable: false),
          },
        )
        .toList(growable: false);
  }

  static List<CustomInfoSection> customSectionsFromJson(Object? value) {
    if (value is! List) {
      return const <CustomInfoSection>[];
    }

    return value
        .whereType<Map>()
        .map((section) {
          final fieldsValue = section['fields'];
          final fields = fieldsValue is List
              ? fieldsValue
                    .whereType<Map>()
                    .map((field) {
                      return CustomInfoField(
                        label: (field['label'] as String?)?.trim() ?? '',
                        value: (field['value'] as String?)?.trim() ?? '',
                        fieldType:
                            (field['fieldType'] as String?)?.trim() ?? 'Text',
                        isRequired: field['isRequired'] == 'true',
                      );
                    })
                    .where((field) => field.label.isNotEmpty)
                    .toList(growable: false)
              : const <CustomInfoField>[];

          return CustomInfoSection(
            id: (section['id'] as String?)?.trim() ?? '',
            title: (section['title'] as String?)?.trim() ?? 'Custom Section',
            fields: fields,
          );
        })
        .where((section) => section.id.isNotEmpty)
        .toList(growable: false);
  }
}
