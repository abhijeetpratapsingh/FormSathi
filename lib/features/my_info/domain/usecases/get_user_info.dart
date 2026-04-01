import '../entities/user_info.dart';
import '../repositories/my_info_repository.dart';

class GetUserInfo {
  const GetUserInfo(this._repository);

  final MyInfoRepository _repository;

  Future<UserInfo> call() => _repository.getUserInfo();
}
