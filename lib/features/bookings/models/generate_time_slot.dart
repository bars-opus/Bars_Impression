import 'package:bars/features/bookings/models/appointment_slot_model.dart';
import 'package:flutter/material.dart';

List<TimeOfDay> generateTimeSlotsForAppointment(AppointmentSlotModel slot,
    DateTime selectedDate, Map<String, DateTimeRange> openingHours) {
  String dayOfWeek = _getDayOfWeek(selectedDate);
  if (!openingHours.containsKey(dayOfWeek)) {
    return []; // Return an empty list if the shop is closed on the selected day
  }

  DateTimeRange openingRange = openingHours[dayOfWeek]!;
  Duration duration = _parseDuration(slot.duruation);

  return generateTimeSlots(
    TimeOfDay.fromDateTime(openingRange.start),
    TimeOfDay.fromDateTime(openingRange.end),
    duration,
  );
}

List<TimeOfDay> generateTimeSlots(
    TimeOfDay openingTime, TimeOfDay closingTime, Duration duration) {
  List<TimeOfDay> slots = [];
  TimeOfDay currentTime = openingTime;

  while (currentTime.hour < closingTime.hour ||
      (currentTime.hour == closingTime.hour &&
          currentTime.minute < closingTime.minute)) {
    slots.add(currentTime);

    // Calculate the next time
    int totalMinutes =
        currentTime.hour * 60 + currentTime.minute + duration.inMinutes;
    int nextHour = totalMinutes ~/ 60;
    int nextMinute = totalMinutes % 60;

    TimeOfDay nextTime = TimeOfDay(hour: nextHour, minute: nextMinute);

    // Break the loop if next time exceeds closing time
    if (nextTime.hour > closingTime.hour ||
        (nextTime.hour == closingTime.hour &&
            nextTime.minute >= closingTime.minute)) {
      break;
    }

    currentTime = nextTime;
  }

  return slots;
}

// List<TimeOfDay> generateTimeSlots(TimeOfDay openingTime, TimeOfDay closingTime, Duration duration) {
//   List<TimeOfDay> slots = [];
//   TimeOfDay currentTime = openingTime;

//   while (currentTime.hour < closingTime.hour ||
//       (currentTime.hour == closingTime.hour && currentTime.minute < closingTime.minute)) {
//     final nextTime = TimeOfDay(
//       hour: (currentTime.hour + duration.inHours) % 24,
//       minute: (currentTime.minute + duration.inMinutes) % 60,
//     );
//     if (nextTime.hour < closingTime.hour ||
//         (nextTime.hour == closingTime.hour && nextTime.minute <= closingTime.minute)) {
//       slots.add(currentTime);
//     }
//     currentTime = nextTime;
//   }

//   return slots;
// }

String _getDayOfWeek(DateTime date) {
  return [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ][date.weekday % 7];
}

Duration _parseDuration(String duration) {
  final parts = duration.split(' ');
  int hours = 0;
  int minutes = 0;

  for (var i = 0; i < parts.length; i += 2) {
    final value = int.parse(parts[i]);
    final unit = parts[i + 1];
    if (unit.contains('hour')) {
      hours = value;
    } else if (unit.contains('minute')) {
      minutes = value;
    }
  }

  return Duration(hours: hours, minutes: minutes);
}
