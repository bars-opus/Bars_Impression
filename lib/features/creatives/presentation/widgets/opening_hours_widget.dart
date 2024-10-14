import 'package:bars/utilities/exports.dart';

class OpeninHoursWidget extends StatelessWidget {
  final Map<String, DateTimeRange> openingHours;

  OpeninHoursWidget({required this.openingHours});

  @override
  Widget build(BuildContext context) {
    _payoutWidget(String label, DateTimeRange range) {
      final now = DateTime.now();
      final currentDayName = _getDayName(now.weekday);

      final startTime = MyDateFormat.toTime(range.start);
      final endTime = MyDateFormat.toTime(range.end);
      final duration = range.end.difference(range.start);
      final formattedDuration = _formatDuration(duration);

      // final value = (label == currentDayName) ? 'Open' : formattedDuration;

      String value;
      if (label == currentDayName) {
        if (now.isAfter(range.start) && now.isBefore(range.end)) {
          value = 'Open';
        } else {
          value = 'Closed';
        }
      } else {
        value = formattedDuration;
      }

      return Column(
        children: [
          PayoutDataWidget(
            label: label,
            value2: value,
            value: '$startTime - $endTime',
            text2Ccolor: Colors.black,
          ),
          Divider(
            thickness: .4,
          )
        ],
      );
    }

    List<String> dayOrder = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    var sortedOpeningHours = Map.fromEntries(
      openingHours.entries.toList()
        ..sort((a, b) =>
            dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key))),
    );

    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 380),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sortedOpeningHours.length,
        itemBuilder: (context, index) {
          String day = sortedOpeningHours.keys.elementAt(index);
          DateTimeRange hours = sortedOpeningHours[day]!;
          return _payoutWidget(day, hours);
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return '${hours} hours ${minutes} mimutes';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

// class OpeninHoursWidget extends StatelessWidget {
//   final Map<String, DateTimeRange> openingHours;

//   OpeninHoursWidget({required this.openingHours});

//   String _formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//     return '${hours}hours ${minutes}minutes';
//   }

//   @override
//   Widget build(BuildContext context) {
//     _payoutWidget(String label, DateTimeRange range) {
//       final startTime = MyDateFormat.toTime(range.start);
//       final endTime = MyDateFormat.toTime(range.end);
//       final duration = range.end.difference(range.start);
//       final formattedDuration = _formatDuration(duration);

      // return PayoutDataWidget(
      //   label: label,
      //   value2: formattedDuration,
      //   value: '$startTime - $endTime',
      //   text2Ccolor: Colors.black,
      // );
//     }

//     List<String> dayOrder = [
//       'Monday',
//       'Tuesday',
//       'Wednesday',
//       'Thursday',
//       'Friday',
//       'Saturday',
//       'Sunday'
//     ];

//     var sortedOpeningHours = Map.fromEntries(
//       openingHours.entries.toList()
//         ..sort((a, b) =>
//             dayOrder.indexOf(a.key).compareTo(dayOrder.indexOf(b.key))),
//     );

//     return Container(
//       height: ResponsiveHelper.responsiveFontSize(context, 380),
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: ListView.builder(
//         physics: const NeverScrollableScrollPhysics(),
//         itemCount: sortedOpeningHours.length,
//         itemBuilder: (context, index) {
//           String day = sortedOpeningHours.keys.elementAt(index);
//           DateTimeRange hours = sortedOpeningHours[day]!;
//           return _payoutWidget(day, hours);
//         },
//       ),
//     );
//   }
// }

// extension on DateTimeRange {
//   String duration() {
//     final duration = end.difference(start);
//     return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
//   }
// }

