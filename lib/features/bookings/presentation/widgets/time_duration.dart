// time_utils.dart
class TimeDuration {
  /// Calculates the duration between two DateTime objects.
  /// Returns a Map containing the number of days, hours, and minutes.
  static Map<String, int> calculateDuration(
      DateTime startTime, DateTime endTime) {
    // Calculate the duration between the two times
    Duration duration = endTime.difference(startTime);

    // Extract days, hours, and minutes from the duration
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);

    return {
      'days': days,
      'hours': hours,
      'minutes': minutes,
    };
  }
}
