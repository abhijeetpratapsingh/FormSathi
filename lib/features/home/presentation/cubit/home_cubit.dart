import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../documents/domain/usecases/get_documents_usecase.dart';
import '../../../my_info/domain/usecases/get_user_info.dart';
import '../../../tools/domain/usecases/load_recent_processed_files_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required GetUserInfo getUserInfoUseCase,
    required GetDocumentsUseCase getDocumentsUseCase,
    required LoadRecentProcessedFilesUseCase loadRecentProcessedFilesUseCase,
  }) : _getUserInfoUseCase = getUserInfoUseCase,
       _getDocumentsUseCase = getDocumentsUseCase,
       _loadRecentProcessedFilesUseCase = loadRecentProcessedFilesUseCase,
       super(const HomeState());

  final GetUserInfo _getUserInfoUseCase;
  final GetDocumentsUseCase _getDocumentsUseCase;
  final LoadRecentProcessedFilesUseCase _loadRecentProcessedFilesUseCase;

  Future<void> load() async {
    emit(state.copyWith(status: HomeStatus.loading, clearErrorMessage: true));

    try {
      final userInfo = await _getUserInfoUseCase();
      final documents = await _getDocumentsUseCase();
      final recentFiles = await _loadRecentProcessedFilesUseCase();

      emit(
        state.copyWith(
          status: HomeStatus.ready,
          userInfo: userInfo,
          documents: documents,
          recentFiles: recentFiles,
          clearErrorMessage: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Some home summaries could not be loaded.',
        ),
      );
    }
  }
}
