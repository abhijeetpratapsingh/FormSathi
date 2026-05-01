import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formsathi/features/documents/domain/entities/saved_document.dart';
import 'package:formsathi/features/documents/domain/repositories/documents_repository.dart';
import 'package:formsathi/features/documents/domain/usecases/get_documents_usecase.dart';
import 'package:formsathi/features/home/presentation/pages/home_page.dart';
import 'package:formsathi/features/home/presentation/cubit/home_cubit.dart';
import 'package:formsathi/features/my_info/domain/entities/user_info.dart';
import 'package:formsathi/features/my_info/domain/repositories/my_info_repository.dart';
import 'package:formsathi/features/my_info/domain/usecases/get_user_info.dart';
import 'package:formsathi/features/tools/domain/entities/processed_file.dart';
import 'package:formsathi/features/tools/domain/repositories/tools_repository.dart';
import 'package:formsathi/features/tools/domain/usecases/load_recent_processed_files_usecase.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('home shows primary Info and Docs actions', (tester) async {
    final homeCubit = HomeCubit(
      getUserInfoUseCase: GetUserInfo(_FakeMyInfoRepository()),
      getDocumentsUseCase: GetDocumentsUseCase(_FakeDocumentsRepository()),
      loadRecentProcessedFilesUseCase: LoadRecentProcessedFilesUseCase(
        _FakeToolsRepository(),
      ),
    )..load();

    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) =>
              BlocProvider.value(value: homeCubit, child: const HomePage()),
        ),
        GoRoute(
          path: '/my-info',
          builder: (context, state) => const Scaffold(body: Text('Info page')),
        ),
        GoRoute(
          path: '/documents',
          builder: (context, state) => const Scaffold(body: Text('Docs page')),
        ),
        GoRoute(
          path: '/tools',
          builder: (context, state) => const Scaffold(body: Text('Tools page')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Open Info'), findsWidgets);
    expect(find.text('Open Docs'), findsWidgets);
    expect(find.text('Need a quick edit instead? Open Tools'), findsOneWidget);
    expect(find.text('Saved essentials'), findsOneWidget);

    await tester.tap(find.text('Open Info').first);
    await tester.pumpAndSettle();
    expect(find.text('Info page'), findsOneWidget);

    router.go('/home');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Need a quick edit instead? Open Tools'));
    await tester.pumpAndSettle();
    expect(find.text('Tools page'), findsOneWidget);
  });
}

class _FakeMyInfoRepository implements MyInfoRepository {
  @override
  Future<void> clearUserInfo() async {}

  @override
  Future<UserInfo> getUserInfo() async => const UserInfo();

  @override
  Future<void> saveUserInfo(UserInfo userInfo) async {}
}

class _FakeDocumentsRepository implements DocumentsRepository {
  @override
  Future<void> clearDocuments() async {}

  @override
  Future<void> deleteDocument(String id) async {}

  @override
  Future<List<SavedDocument>> getDocuments() async => const [];

  @override
  Future<void> migrateCategoryOnlyDocuments() async {}

  @override
  Future<void> saveDocument(SavedDocument document) async {}

  @override
  Future<void> updateDocument(SavedDocument document) async {}
}

class _FakeToolsRepository implements ToolsRepository {
  @override
  Future<void> clearProcessedFiles() async {}

  @override
  Future<void> deleteProcessedFile(String id) async {}

  @override
  Future<List<ProcessedFile>> getProcessedFiles() async => const [];

  @override
  Future<void> saveProcessedFile(ProcessedFile file) async {}
}
