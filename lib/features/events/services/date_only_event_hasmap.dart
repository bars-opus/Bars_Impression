import 'dart:collection';
import 'package:bars/features/events/event_management/models/event_model.dart';


class DateOnly {
  final DateTime dateTime;
  DateOnly(this.dateTime);

  @override
  bool operator ==(Object other) {
    if (other is DateOnly) {
      return dateTime.year == other.dateTime.year &&
          dateTime.month == other.dateTime.month &&
          dateTime.day == other.dateTime.day;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => dateTime.hashCode;
}

LinkedHashMap<DateOnly, List<Event>> _events = LinkedHashMap<DateOnly, List<Event>>(
  equals: (a, b) => a == b,
  hashCode: (date) => date.hashCode,
);
