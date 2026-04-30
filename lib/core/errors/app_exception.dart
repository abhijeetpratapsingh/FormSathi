class AppException implements Exception {
  AppException(this.message);

  final String message;

  static String userSafeMessage(Object error) {
    if (error is AppException) return error.message;
    final raw = error.toString();
    if (raw.trim().isEmpty) {
      return 'Something went wrong. Please try again.';
    }
    if (raw.contains('FileSystemException')) {
      return 'The selected file is not available. Please choose it again.';
    }
    if (raw.contains('PlatformException')) {
      return 'The action could not be completed on this device. Please try again.';
    }
    if (raw.contains('Permission')) {
      return 'Permission is required to complete this action.';
    }
    return 'Something went wrong. Please try again.';
  }

  @override
  String toString() => message;
}
