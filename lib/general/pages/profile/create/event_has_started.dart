class EventHasStarted {
  // Method to check if the event has started
  static bool hasEventStarted(DateTime startDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    DateTime startDateAtMidnight =
        DateTime(startDate.year, startDate.month, startDate.day);

    // The event has started if the start date is today or before today
    return !startDateAtMidnight.isAfter(today);
  }

  // Method to check if the event has ended
  static bool hasEventEnded(DateTime closingDate) {
    // Get the current date with time stripped (set to midnight)
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Convert closingDate to a date with time stripped (set to midnight)
    DateTime closingDateAtMidnight =
        DateTime(closingDate.year, closingDate.month, closingDate.day);

    // Check if the closingDate is before today
    return closingDateAtMidnight.isBefore(today);
  }
  // static bool hasEventEnded(DateTime closingDate) {
  //   return closingDate.isBefore(DateTime.now());
  // }
}
