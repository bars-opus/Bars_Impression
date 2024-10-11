class DurationUtils {
  static Duration parseDuration(String durationString) {
    final parts = durationString.split(' ');
    int hours = 0;
    int minutes = 0;

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].contains('hour')) {
        hours = int.parse(parts[i - 1]);
      } else if (parts[i].contains('minute')) {
        minutes = int.parse(parts[i - 1]);
      }
    }

    return Duration(hours: hours, minutes: minutes);
  }
}
