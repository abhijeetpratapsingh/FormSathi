import '../entities/user_info.dart';

abstract class MyInfoRepository {
  Future<UserInfo> getUserInfo();
  Future<void> saveUserInfo(UserInfo userInfo);
  Future<void> clearUserInfo();
}
