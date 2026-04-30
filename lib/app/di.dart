import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/services/app_directories_service.dart';
import '../core/services/hive_adapters.dart';
import '../core/services/export_orchestration_service.dart';
import '../core/services/image_processing_service.dart';
import '../core/services/local_file_service.dart';
import '../core/services/pdf_service.dart';
import '../core/services/permission_service.dart';
import '../features/documents/data/datasources/documents_local_data_source.dart';
import '../features/documents/data/models/saved_document_model.dart';
import '../features/documents/data/repositories/documents_repository_impl.dart';
import '../features/documents/domain/repositories/documents_repository.dart';
import '../features/documents/domain/usecases/delete_document_usecase.dart';
import '../features/documents/domain/usecases/get_documents_usecase.dart';
import '../features/documents/domain/usecases/save_document_usecase.dart';
import '../features/documents/domain/usecases/update_document_usecase.dart';
import '../features/my_info/data/datasources/my_info_local_data_source.dart';
import '../features/my_info/data/models/user_info_model.dart';
import '../features/my_info/data/repositories/my_info_repository_impl.dart';
import '../features/my_info/domain/repositories/my_info_repository.dart';
import '../features/my_info/domain/usecases/get_user_info.dart';
import '../features/my_info/domain/usecases/save_user_info.dart';
import '../features/settings/data/datasources/privacy_local_data_source.dart';
import '../features/settings/data/models/app_lock_credential_model.dart';
import '../features/settings/data/models/privacy_settings_model.dart';
import '../features/settings/data/repositories/settings_repository_impl.dart';
import '../features/settings/domain/repositories/settings_repository.dart';
import '../features/settings/domain/usecases/app_lock_usecases.dart';
import '../features/settings/domain/usecases/privacy_usecases.dart';
import '../features/tools/data/datasources/tools_local_data_source.dart';
import '../features/tools/data/models/processed_file_model.dart';
import '../features/tools/data/repositories/tools_repository_impl.dart';
import '../features/tools/domain/repositories/tools_repository.dart';
import '../features/tools/domain/usecases/delete_processed_file_usecase.dart';
import '../features/tools/domain/usecases/export_saved_document_usecase.dart';
import '../features/tools/domain/usecases/load_recent_processed_files_usecase.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  _registerAdapters();
  await _openBoxes();

  final directoriesService = AppDirectoriesService();
  await directoriesService.init();

  sl
    ..registerSingleton<AppDirectoriesService>(directoriesService)
    ..registerLazySingleton<LocalFileService>(() => LocalFileService(sl()))
    ..registerLazySingleton(PermissionService.new)
    ..registerLazySingleton(ImageProcessingService.new)
    ..registerLazySingleton(PdfService.new)
    ..registerLazySingleton(
      () => ExportOrchestrationService(
        imageProcessingService: sl(),
        pdfService: sl(),
        localFileService: sl(),
      ),
    )
    ..registerLazySingleton<MyInfoLocalDataSource>(
      () => MyInfoLocalDataSource(sl()),
    )
    ..registerLazySingleton<DocumentsLocalDataSource>(
      () => DocumentsLocalDataSource(sl()),
    )
    ..registerLazySingleton<ToolsLocalDataSource>(
      () => ToolsLocalDataSource(sl()),
    )
    ..registerLazySingleton<PrivacyLocalDataSource>(
      () => PrivacyLocalDataSource(settingsBox: sl(), credentialBox: sl()),
    )
    ..registerLazySingleton<MyInfoRepository>(() => MyInfoRepositoryImpl(sl()))
    ..registerLazySingleton<DocumentsRepository>(
      () => DocumentsRepositoryImpl(sl()),
    )
    ..registerLazySingleton<ToolsRepository>(() => ToolsRepositoryImpl(sl()))
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(
        localDataSource: sl(),
        myInfoRepository: sl(),
        documentsRepository: sl(),
        toolsRepository: sl(),
        localFileService: sl(),
      ),
    )
    ..registerLazySingleton(() => GetUserInfo(sl()))
    ..registerLazySingleton(() => SaveUserInfo(sl()))
    ..registerLazySingleton(() => GetDocumentsUseCase(sl()))
    ..registerLazySingleton(() => SaveDocumentUseCase(sl()))
    ..registerLazySingleton(() => UpdateDocumentUseCase(sl()))
    ..registerLazySingleton(() => DeleteDocumentUseCase(sl()))
    ..registerLazySingleton(() => LoadRecentProcessedFilesUseCase(sl()))
    ..registerLazySingleton(
      () => ExportSavedDocumentUseCase(
        exportService: sl(),
        toolsRepository: sl(),
      ),
    )
    ..registerLazySingleton(() => GetPrivacySettingsUseCase(sl()))
    ..registerLazySingleton(() => EnableAppLockUseCase(sl()))
    ..registerLazySingleton(() => VerifyAppLockUseCase(sl()))
    ..registerLazySingleton(() => DisableAppLockUseCase(sl()))
    ..registerLazySingleton(() => ShouldLockUseCase(sl()))
    ..registerLazySingleton(() => MarkPrivacyIntroSeenUseCase(sl()))
    ..registerLazySingleton(() => SavePrivacySettingsUseCase(sl()))
    ..registerLazySingleton(() => WipeLocalDataUseCase(sl()))
    ..registerLazySingleton(
      () =>
          DeleteProcessedFileUseCase(repository: sl(), localFileService: sl()),
    )
    ..registerLazySingleton<Box<UserInfoModel>>(
      () => Hive.box<UserInfoModel>(_BoxNames.userInfo),
    )
    ..registerLazySingleton<Box<SavedDocumentModel>>(
      () => Hive.box<SavedDocumentModel>(_BoxNames.documents),
    )
    ..registerLazySingleton<Box<ProcessedFileModel>>(
      () => Hive.box<ProcessedFileModel>(_BoxNames.processedFiles),
    )
    ..registerLazySingleton<Box<PrivacySettingsModel>>(
      () => Hive.box<PrivacySettingsModel>(_BoxNames.privacySettings),
    )
    ..registerLazySingleton<Box<AppLockCredentialModel>>(
      () => Hive.box<AppLockCredentialModel>(_BoxNames.appLockCredential),
    );

  await _runStartupMigrations();
}

void _registerAdapters() {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserInfoModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(SavedDocumentModelAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(ProcessedFileModelAdapter());
  }
  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(PrivacySettingsModelAdapter());
  }
  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(AppLockCredentialModelAdapter());
  }
}

Future<void> _openBoxes() async {
  await Hive.openBox<UserInfoModel>(_BoxNames.userInfo);
  await Hive.openBox<SavedDocumentModel>(_BoxNames.documents);
  await Hive.openBox<ProcessedFileModel>(_BoxNames.processedFiles);
  await Hive.openBox<PrivacySettingsModel>(_BoxNames.privacySettings);
  await Hive.openBox<AppLockCredentialModel>(_BoxNames.appLockCredential);
}

Future<void> _runStartupMigrations() async {
  await sl<DocumentsRepository>().migrateCategoryOnlyDocuments();
}

class _BoxNames {
  const _BoxNames._();

  static const userInfo = 'user_info_box';
  static const documents = 'documents_box';
  static const processedFiles = 'processed_files_box';
  static const privacySettings = 'privacy_settings_box';
  static const appLockCredential = 'app_lock_credential_box';
}
