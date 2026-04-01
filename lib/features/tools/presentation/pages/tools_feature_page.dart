import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/services/image_processing_service.dart';
import '../../../../core/services/local_file_service.dart';
import '../../../../core/services/pdf_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../domain/repositories/tools_repository.dart';
import '../../domain/usecases/compress_image_usecase.dart';
import '../../domain/usecases/create_pdf_usecase.dart';
import '../../domain/usecases/delete_processed_file_usecase.dart';
import '../../domain/usecases/load_recent_processed_files_usecase.dart';
import '../../domain/usecases/resize_image_usecase.dart';
import '../cubit/compress_image_cubit.dart';
import '../cubit/image_to_pdf_cubit.dart';
import '../cubit/resize_image_cubit.dart';
import '../cubit/tools_cubit.dart';
import 'tools_home_page.dart';

class ToolsFeaturePage extends StatelessWidget {
  const ToolsFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.I;
    return MultiBlocProvider(
      providers: [
        BlocProvider<ToolsCubit>(
          create: (_) => ToolsCubit(
            LoadRecentProcessedFilesUseCase(getIt<ToolsRepository>()),
            DeleteProcessedFileUseCase(
              repository: getIt<ToolsRepository>(),
              localFileService: getIt<LocalFileService>(),
            ),
          )..loadRecentFiles(),
        ),
        BlocProvider<ResizeImageCubit>(
          create: (_) => ResizeImageCubit(
            resizeImageUseCase: ResizeImageUseCase(
              processingService: getIt<ImageProcessingService>(),
              localFileService: getIt<LocalFileService>(),
              repository: getIt<ToolsRepository>(),
            ),
            localFileService: getIt<LocalFileService>(),
            permissionService: getIt<PermissionService>(),
          ),
        ),
        BlocProvider<CompressImageCubit>(
          create: (_) => CompressImageCubit(
            compressImageUseCase: CompressImageUseCase(
              processingService: getIt<ImageProcessingService>(),
              localFileService: getIt<LocalFileService>(),
              repository: getIt<ToolsRepository>(),
            ),
            localFileService: getIt<LocalFileService>(),
            permissionService: getIt<PermissionService>(),
          ),
        ),
        BlocProvider<ImageToPdfCubit>(
          create: (_) => ImageToPdfCubit(
            createPdfUseCase: CreatePdfUseCase(
              pdfService: getIt<PdfService>(),
              localFileService: getIt<LocalFileService>(),
              repository: getIt<ToolsRepository>(),
            ),
            localFileService: getIt<LocalFileService>(),
            permissionService: getIt<PermissionService>(),
            pdfService: getIt<PdfService>(),
          ),
        ),
      ],
      child: const ToolsHomePage(),
    );
  }
}
