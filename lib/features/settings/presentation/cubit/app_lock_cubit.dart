import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/usecases/app_lock_usecases.dart';

enum AppLockStatus { disabled, locked, unlocked, setupInProgress }

class AppLockState extends Equatable {
  const AppLockState({
    this.status = AppLockStatus.disabled,
    this.isBusy = false,
    this.errorMessage = '',
  });

  final AppLockStatus status;
  final bool isBusy;
  final String errorMessage;

  AppLockState copyWith({
    AppLockStatus? status,
    bool? isBusy,
    String? errorMessage,
  }) {
    return AppLockState(
      status: status ?? this.status,
      isBusy: isBusy ?? this.isBusy,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, isBusy, errorMessage];
}

class AppLockCubit extends Cubit<AppLockState> {
  AppLockCubit({
    required EnableAppLockUseCase enableAppLockUseCase,
    required VerifyAppLockUseCase verifyAppLockUseCase,
    required DisableAppLockUseCase disableAppLockUseCase,
    required ShouldLockUseCase shouldLockUseCase,
  }) : _enableAppLockUseCase = enableAppLockUseCase,
       _verifyAppLockUseCase = verifyAppLockUseCase,
       _disableAppLockUseCase = disableAppLockUseCase,
       _shouldLockUseCase = shouldLockUseCase,
       super(const AppLockState());

  final EnableAppLockUseCase _enableAppLockUseCase;
  final VerifyAppLockUseCase _verifyAppLockUseCase;
  final DisableAppLockUseCase _disableAppLockUseCase;
  final ShouldLockUseCase _shouldLockUseCase;

  Future<void> refreshLockStatus() async {
    final shouldLock = await _shouldLockUseCase(DateTime.now());
    emit(
      state.copyWith(
        status: shouldLock ? AppLockStatus.locked : AppLockStatus.unlocked,
      ),
    );
  }

  Future<void> enable(String pin, String confirmation) async {
    if (pin.isEmpty || pin != confirmation) {
      emit(state.copyWith(errorMessage: 'PINs do not match.'));
      return;
    }
    emit(state.copyWith(isBusy: true, errorMessage: ''));
    try {
      await _enableAppLockUseCase(pin);
      emit(state.copyWith(isBusy: false, status: AppLockStatus.unlocked));
    } catch (error) {
      emit(
        state.copyWith(
          isBusy: false,
          errorMessage: AppException.userSafeMessage(error),
        ),
      );
    }
  }

  Future<void> unlock(String pin) async {
    emit(state.copyWith(isBusy: true, errorMessage: ''));
    final verified = await _verifyAppLockUseCase(pin);
    emit(
      state.copyWith(
        isBusy: false,
        status: verified ? AppLockStatus.unlocked : AppLockStatus.locked,
        errorMessage: verified ? '' : 'Incorrect PIN. Try again.',
      ),
    );
  }

  Future<void> disable() async {
    await _disableAppLockUseCase();
    emit(state.copyWith(status: AppLockStatus.disabled, errorMessage: ''));
  }
}
