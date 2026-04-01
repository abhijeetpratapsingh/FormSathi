import 'package:equatable/equatable.dart';

import '../../domain/entities/user_info.dart';

enum MyInfoStatus { initial, loading, ready, saving, failure }

class MyInfoState extends Equatable {
  const MyInfoState({
    this.status = MyInfoStatus.initial,
    this.userInfo = const UserInfo(),
    this.isAadhaarObscured = true,
    this.isPanObscured = true,
    this.feedbackMessage,
    this.feedbackVersion = 0,
  });

  final MyInfoStatus status;
  final UserInfo userInfo;
  final bool isAadhaarObscured;
  final bool isPanObscured;
  final String? feedbackMessage;
  final int feedbackVersion;

  bool get isLoading => status == MyInfoStatus.loading;
  bool get isSaving => status == MyInfoStatus.saving;
  bool get isBusy => isLoading || isSaving || status == MyInfoStatus.initial;
  bool get hasUserInfo => !userInfo.isEmpty;

  MyInfoState copyWith({
    MyInfoStatus? status,
    UserInfo? userInfo,
    bool? isAadhaarObscured,
    bool? isPanObscured,
    String? feedbackMessage,
    bool clearFeedback = false,
    int? feedbackVersion,
  }) {
    return MyInfoState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      isAadhaarObscured: isAadhaarObscured ?? this.isAadhaarObscured,
      isPanObscured: isPanObscured ?? this.isPanObscured,
      feedbackMessage: clearFeedback ? null : (feedbackMessage ?? this.feedbackMessage),
      feedbackVersion: feedbackVersion ?? this.feedbackVersion,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userInfo,
        isAadhaarObscured,
        isPanObscured,
        feedbackMessage,
        feedbackVersion,
      ];
}
