import '../entities/user_info.dart';
import '../repositories/my_info_repository.dart';

class SaveUserInfo {
  const SaveUserInfo(this._repository);

  final MyInfoRepository _repository;

  Future<void> call(UserInfo userInfo) => _repository.saveUserInfo(userInfo);
}
