class CalculateWeekOfMonth {
  int calculateWeekOfMonth(DateTime date) {
    // Determine the first day of the month
    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);

    // Find the weekday of the first day of the month
    int weekday = firstDayOfMonth.weekday;

    // Calculate the offset of the first day from the start of the week
    int offset = (weekday + 6) % 7;

    // Calculate the week number
    int week = ((date.day + offset - 1) / 7).ceil();

    return week;
  }
}
