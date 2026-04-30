import 'package:hive/hive.dart';

import '../models/user_info_model.dart';

class MyInfoLocalDataSource {
  MyInfoLocalDataSource(this._box);

  final Box<UserInfoModel> _box;
  static const _key = 'user_info';

  UserInfoModel? getUserInfo() => _box.get(_key);

  Future<void> saveUserInfo(UserInfoModel model) => _box.put(_key, model);

  Future<void> clearUserInfo() => _box.delete(_key);
}
