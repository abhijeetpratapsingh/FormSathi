import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toDisplayDate() => DateFormat('dd MMM yyyy').format(this);
  String toDateInput() => DateFormat('yyyy-MM-dd').format(this);
  String toDateTimeLabel() => DateFormat('dd MMM yyyy, hh:mm a').format(this);
}
