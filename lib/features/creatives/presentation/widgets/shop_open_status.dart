import 'package:bars/utilities/exports.dart';

class ShopOpenStatus extends StatefulWidget {
  final UserStoreModel shop;

  const ShopOpenStatus({Key? key, required this.shop}) : super(key: key);

  @override
  State<ShopOpenStatus> createState() => _ShopOpenStatusState();
}

class _ShopOpenStatusState extends State<ShopOpenStatus> {
  @override
  Widget build(BuildContext context) {
    String currentDay = _getDayOfWeek(DateTime.now());
    DateTime now = DateTime.now();

    if (widget.shop.openingHours.containsKey(currentDay)) {
      DateTimeRange hours = widget.shop.openingHours[currentDay]!;

      DateTime todayStart = DateTime(
          now.year, now.month, now.day, hours.start.hour, hours.start.minute);
      DateTime todayEnd = DateTime(
          now.year, now.month, now.day, hours.end.hour, hours.end.minute);

      Duration timeLeft = todayEnd.difference(now);
      Duration timeUntilOpen = todayStart.difference(now);

      final startTime = MyDateFormat.toTime(hours.start);
      final endTime = MyDateFormat.toTime(hours.end);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 14),
              children: [
                TextSpan(
                  text: '$startTime - ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: '$endTime',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: now.isAfter(todayStart) && now.isBefore(todayEnd)
                      ? '\n${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m left to close'
                      : '\n${timeUntilOpen.inHours}h ${timeUntilOpen.inMinutes.remainder(60)}m until open',
                  style: TextStyle(
                    color: Colors.blue,
                    // fontWeight: FontWeight.bold,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                  ),

                  //  Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            now.isAfter(todayStart) && now.isBefore(todayEnd)
                ? 'Open'
                : 'Closed',
            style: TextStyle(
              color: now.isAfter(todayStart) && now.isBefore(todayEnd)
                  ? Colors.blue
                  : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
            ),
          ),
        ],
      );
    }

    return Text('Closed', style: TextStyle(color: Colors.red));
  }

  String _getDayOfWeek(DateTime date) {
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][date.weekday - 1];
  }
}

// class ShopOpenStatus extends StatelessWidget {
//   final UserStoreModel shop;

//   const ShopOpenStatus({Key? key, required this.shop}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String currentDay = _getDayOfWeek(DateTime.now());
//     DateTime now = DateTime.now();

//     if (shop.openingHours.containsKey(currentDay)) {
//       DateTimeRange hours = shop.openingHours[currentDay]!;

//       DateTime todayStart = DateTime(
//           now.year, now.month, now.day, hours.start.hour, hours.start.minute);
//       DateTime todayEnd = DateTime(
//           now.year, now.month, now.day, hours.end.hour, hours.end.minute);

//       if (now.isAfter(todayStart) && now.isBefore(todayEnd)) {
//         // Calculate time left to close
//         Duration timeLeft = todayEnd.difference(now);
//         return Row(
//           children: [
//             Text('Open', style: TextStyle(color: Colors.green)),
//             SizedBox(width: 8),
//             Text(
//               '${timeLeft.inHours}h ${timeLeft.inMinutes.remainder(60)}m left to close',
//               style: TextStyle(color: Colors.black),
//             ),
//           ],
//         );
//       } else if (now.isBefore(todayStart)) {
//         // Calculate time until open
//         Duration timeUntilOpen = todayStart.difference(now);
//         return Row(
//           children: [
//             Text('Closed', style: TextStyle(color: Colors.red)),
//             SizedBox(width: 8),
//             Text(
//               '${timeUntilOpen.inHours}h ${timeUntilOpen.inMinutes.remainder(60)}m until open',
//               style: TextStyle(color: Colors.black),
//             ),
//           ],
//         );
//       }
//     }

//     return Text('Closed', style: TextStyle(color: Colors.red));
//   }

//   String _getDayOfWeek(DateTime date) {
//     return [
//       'Sunday',
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday'
//     ][date.weekday - 1];
//   }
// }
