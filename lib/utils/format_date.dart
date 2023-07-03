import 'package:intl/intl.dart';

/// helper function to format `DateTime` objects
String formatDate(DateTime date) {
  final dateFormat = DateFormat.yMd().add_jm();

  return dateFormat.format(date);
}

/// helper function to format `DateTime` objects into string
/// specifically for `DateTime`s that are within 7 days of
/// `DateTime.now()`
String formatDateSameWeek(DateTime date) {
  DateFormat dateFormat;

  dateFormat = date.day == DateTime.now().day
      ? DateFormat('hh:mm a')
      : DateFormat('EEEE, hh:mm a');

  return dateFormat.format(date);
}

/// helper function to format `DateTime` objects into strings
String formatDateMessage(DateTime date) {
  final dateFormat = DateFormat('EEE. MMM. d ' 'yy' ' hh:mm a');

  return dateFormat.format(date);
}

/// helper function to determine if a given
/// timestamp is within a week of `DateTime.now()`
bool isSameWeek(DateTime timestamp) {
  return DateTime.now().difference(timestamp).inDays < 7;
}
