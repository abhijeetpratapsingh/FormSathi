import '../../domain/entities/user_info.dart';
import '../../domain/repositories/my_info_repository.dart';
import '../datasources/my_info_local_data_source.dart';
import '../models/user_info_model.dart';

class MyInfoRepositoryImpl implements MyInfoRepository {
  MyInfoRepositoryImpl(this._localDataSource);

  final MyInfoLocalDataSource _localDataSource;

  @override
  Future<void> clearUserInfo() => _localDataSource.clearUserInfo();

  @override
  Future<UserInfo> getUserInfo() async {
    return _localDataSource.getUserInfo()?.toEntity() ?? const UserInfo();
  }

  @override
  Future<void> saveUserInfo(UserInfo userInfo) {
    return _localDataSource.saveUserInfo(UserInfoModel.fromEntity(userInfo));
  }
}
