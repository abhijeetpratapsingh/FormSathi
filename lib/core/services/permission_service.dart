import 'package:permission_handler/permission_handler.dart';

import '../errors/app_exception.dart';

class PermissionService {
  Future<void> ensureCameraPermission() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      throw AppException('Camera permission is required to capture images.');
    }
  }
}
