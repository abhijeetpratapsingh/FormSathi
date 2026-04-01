import 'package:go_router/go_router.dart';

import '../features/documents/presentation/cubit/documents_cubit.dart';
import '../features/documents/presentation/pages/documents_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/pages/splash_page.dart';
import '../features/my_info/presentation/cubit/my_info_cubit.dart';
import '../features/my_info/presentation/pages/my_info_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/tools/presentation/pages/tools_feature_page.dart';
import 'di.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/my-info',
        builder: (context, state) => MyInfoPage(
          cubit: MyInfoCubit(
            getUserInfoUseCase: sl(),
            saveUserInfoUseCase: sl(),
          ),
        ),
      ),
      GoRoute(
        path: '/documents',
        builder: (context, state) => DocumentsPage(
          cubit: DocumentsCubit(
            getDocumentsUseCase: sl(),
            saveDocumentUseCase: sl(),
            updateDocumentUseCase: sl(),
            deleteDocumentUseCase: sl(),
            localFileService: sl(),
          ),
        ),
      ),
      GoRoute(
        path: '/tools',
        builder: (context, state) => const ToolsFeaturePage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
