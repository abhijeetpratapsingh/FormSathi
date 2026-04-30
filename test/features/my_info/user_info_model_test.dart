import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/core/services/hive_adapters.dart';
import 'package:formsathi/core/services/hive_type_ids.dart';
import 'package:formsathi/features/my_info/data/models/user_info_model.dart';
import 'package:formsathi/features/my_info/domain/entities/user_info.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory temp;

  setUp(() async {
    temp = await Directory.systemTemp.createTemp('formsathi_hive_info');
    Hive.init(temp.path);
    if (!Hive.isAdapterRegistered(HiveTypeIds.userInfo)) {
      Hive.registerAdapter(UserInfoModelAdapter());
    }
  });

  tearDown(() async {
    await Hive.close();
    await temp.delete(recursive: true);
  });

  test(
    'round-trips custom info sections in the existing user info record',
    () async {
      final box = await Hive.openBox<UserInfoModel>('user_info');
      await box.put(
        'user_info',
        UserInfoModel.fromEntity(
          const UserInfo(
            fullName: 'Aarav Kumar',
            profilePhotoPath: '/tmp/profile.jpg',
            customSections: [
              CustomInfoSection(
                id: 'section-1',
                title: 'Exam Details',
                fields: [
                  CustomInfoField(label: 'Registration Number', value: 'EX-42'),
                ],
              ),
            ],
          ),
        ),
      );

      await box.close();
      final reopened = await Hive.openBox<UserInfoModel>('user_info');
      final model = reopened.get('user_info')!;

      expect(model.fullName, 'Aarav Kumar');
      expect(model.profilePhotoPath, '/tmp/profile.jpg');
      expect(model.customSections.single.title, 'Exam Details');
      expect(
        model.customSections.single.fields.single.label,
        'Registration Number',
      );
      expect(model.customSections.single.fields.single.value, 'EX-42');
    },
  );
}
