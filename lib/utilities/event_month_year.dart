class EventMonthYear {
  static String toMonthYear(DateTime date) {
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    final month = monthNames[date.month - 1];
    final year = date.year.toString();
    return '$month$year';
  }
}
