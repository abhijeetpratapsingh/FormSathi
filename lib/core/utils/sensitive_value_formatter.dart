class SensitiveValueFormatter {
  const SensitiveValueFormatter._();

  static String maskLast4(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) return '';
    if (normalized.length <= 4) return normalized;
    final last4 = normalized.substring(normalized.length - 4);
    return '•••• $last4';
  }
}
