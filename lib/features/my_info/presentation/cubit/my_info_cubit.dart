import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user_info.dart';
import '../../domain/usecases/get_user_info.dart';
import '../../domain/usecases/save_user_info.dart';
import 'my_info_state.dart';

class MyInfoCubit extends Cubit<MyInfoState> {
  MyInfoCubit({
    required GetUserInfo getUserInfoUseCase,
    required SaveUserInfo saveUserInfoUseCase,
  }) : _getUserInfoUseCase = getUserInfoUseCase,
       _saveUserInfoUseCase = saveUserInfoUseCase,
       super(const MyInfoState());

  final GetUserInfo _getUserInfoUseCase;
  final SaveUserInfo _saveUserInfoUseCase;

  Future<void> loadUserInfo() async {
    emit(state.copyWith(status: MyInfoStatus.loading, clearFeedback: true));
    try {
      final userInfo = await _getUserInfoUseCase();
      emit(
        state.copyWith(
          status: MyInfoStatus.ready,
          userInfo: userInfo,
          clearFeedback: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MyInfoStatus.failure,
          feedbackMessage: 'Unable to load your saved details.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    }
  }

  Future<void> saveUserInfo(
    UserInfo userInfo, {
    bool showFeedback = true,
  }) async {
    emit(state.copyWith(status: MyInfoStatus.saving, clearFeedback: true));
    try {
      await _saveUserInfoUseCase(userInfo);
      emit(
        state.copyWith(
          status: MyInfoStatus.ready,
          userInfo: userInfo,
          feedbackMessage: showFeedback
              ? 'Your details have been saved offline.'
              : null,
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MyInfoStatus.failure,
          feedbackMessage: showFeedback
              ? 'Could not save your details. Please try again.'
              : null,
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    }
  }

  void toggleAadhaarVisibility() {
    emit(state.copyWith(isAadhaarObscured: !state.isAadhaarObscured));
  }

  void togglePanVisibility() {
    emit(state.copyWith(isPanObscured: !state.isPanObscured));
  }

  Future<void> copyField({required String label, required String value}) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      emit(
        state.copyWith(
          feedbackMessage: '$label is empty.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: trimmed));
      emit(
        state.copyWith(
          feedbackMessage: '$label copied to clipboard.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          feedbackMessage: 'Could not copy $label.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    }
  }

  Future<void> copyAllInfo(UserInfo userInfo) async {
    final text = _buildCopyText(userInfo);
    if (text.trim().isEmpty) {
      emit(
        state.copyWith(
          feedbackMessage: 'Nothing to copy yet. Add your details first.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: text));
      emit(
        state.copyWith(
          feedbackMessage: 'All details copied to clipboard.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          feedbackMessage: 'Could not copy all details.',
          feedbackVersion: state.feedbackVersion + 1,
        ),
      );
    }
  }

  String _buildCopyText(UserInfo userInfo) {
    final buffer = StringBuffer();
    void addLine(String label, String value) {
      if (value.trim().isEmpty) return;
      buffer.writeln('$label: ${value.trim()}');
    }

    addLine('Full Name', userInfo.fullName);
    addLine("Father's Name", userInfo.fatherName);
    addLine("Mother's Name", userInfo.motherName);
    if (userInfo.dob != null) {
      addLine('DOB', _formatDate(userInfo.dob!));
    }
    addLine('Gender', userInfo.gender);
    addLine('Phone', userInfo.phone);
    addLine('Email', userInfo.email);
    addLine('Address', userInfo.address);
    addLine('City', userInfo.city);
    addLine('State', userInfo.state);
    addLine('Pin Code', userInfo.pinCode);
    addLine('Aadhaar', userInfo.aadhaar);
    addLine('PAN', userInfo.pan);
    addLine('School/College', userInfo.schoolCollege);
    addLine('Qualification', userInfo.qualification);
    addLine('Category', userInfo.category);
    addLine('Nationality', userInfo.nationality);
    for (final section in userInfo.customSections) {
      for (final field in section.fields) {
        addLine('${section.title} - ${field.label}', field.value);
      }
    }

    return buffer.toString().trim();
  }

  String _formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day-$month-${dateTime.year}';
  }
}
