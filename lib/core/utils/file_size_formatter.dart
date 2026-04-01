import 'dart:math' as math;

class FileSizeFormatter {
  const FileSizeFormatter._();

  static String format(int bytes) {
    if (bytes <= 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB'];
    final digitGroups = (math.log(bytes) / math.log(1024)).floor();
    final size = bytes / math.pow(1024, digitGroups);
    final text = size >= 100 ? size.toStringAsFixed(0) : size.toStringAsFixed(1);
    return '$text ${units[digitGroups]}';
  }
}
