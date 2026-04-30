import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/privacy_settings.dart';
import '../../domain/entities/wipe_result.dart';
import '../../domain/usecases/app_lock_usecases.dart';
import '../../domain/usecases/privacy_usecases.dart';

class PrivacyState extends Equatable {
  const PrivacyState({
    this.settings = const PrivacySettings(),
    this.isLoading = false,
    this.isWiping = false,
    this.wipeResult,
    this.errorMessage = '',
  });

  final PrivacySettings settings;
  final bool isLoading;
  final bool isWiping;
  final WipeResult? wipeResult;
  final String errorMessage;

  PrivacyState copyWith({
    PrivacySettings? settings,
    bool? isLoading,
    bool? isWiping,
    WipeResult? wipeResult,
    bool clearWipeResult = false,
    String? errorMessage,
  }) {
    return PrivacyState(
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      isWiping: isWiping ?? this.isWiping,
      wipeResult: clearWipeResult ? null : (wipeResult ?? this.wipeResult),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    settings,
    isLoading,
    isWiping,
    wipeResult,
    errorMessage,
  ];
}

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit({
    required GetPrivacySettingsUseCase getPrivacySettingsUseCase,
    required MarkPrivacyIntroSeenUseCase markPrivacyIntroSeenUseCase,
    required SavePrivacySettingsUseCase savePrivacySettingsUseCase,
    required WipeLocalDataUseCase wipeLocalDataUseCase,
  }) : _getPrivacySettingsUseCase = getPrivacySettingsUseCase,
       _markPrivacyIntroSeenUseCase = markPrivacyIntroSeenUseCase,
       _savePrivacySettingsUseCase = savePrivacySettingsUseCase,
       _wipeLocalDataUseCase = wipeLocalDataUseCase,
       super(const PrivacyState());

  final GetPrivacySettingsUseCase _getPrivacySettingsUseCase;
  final MarkPrivacyIntroSeenUseCase _markPrivacyIntroSeenUseCase;
  final SavePrivacySettingsUseCase _savePrivacySettingsUseCase;
  final WipeLocalDataUseCase _wipeLocalDataUseCase;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
    try {
      final settings = await _getPrivacySettingsUseCase();
      emit(state.copyWith(settings: settings, isLoading: false));
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: AppException.userSafeMessage(error),
        ),
      );
    }
  }

  Future<void> markIntroSeen() async {
    await _markPrivacyIntroSeenUseCase();
    await load();
  }

  Future<void> setMaskingEnabled(bool enabled) async {
    final updated = state.settings.copyWith(sensitiveMaskingEnabled: enabled);
    await _savePrivacySettingsUseCase(updated);
    emit(state.copyWith(settings: updated));
  }

  Future<void> wipeLocalData() async {
    emit(
      state.copyWith(isWiping: true, clearWipeResult: true, errorMessage: ''),
    );
    try {
      final result = await _wipeLocalDataUseCase();
      emit(
        state.copyWith(
          isWiping: false,
          wipeResult: result,
          settings: const PrivacySettings(),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isWiping: false,
          errorMessage: AppException.userSafeMessage(error),
        ),
      );
    }
  }
}
