class EventHasStarted {
  // Method to check if the event has started
  static bool hasEventStarted(DateTime startDate) {
    return startDate.isBefore(DateTime.now());
  }

  // Method to check if the event has ended
  static bool hasEventEnded(DateTime closingDate) {
    return closingDate.isBefore(DateTime.now());
  }
}
