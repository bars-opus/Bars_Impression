import 'package:intl/intl.dart';

class MyDateFormat {
  static String toDate(DateTime dateTime) {
    final date = DateFormat.yMMMMEEEEd().format(dateTime);
    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat('hh:mm a').format(dateTime);
    return '$time';
  }
}
