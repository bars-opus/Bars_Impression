import 'package:bars/utilities/exports.dart';

class OpeninHoursWidget extends StatelessWidget {
  final Map<String, DateTimeRange> openingHours;

  OpeninHoursWidget({required this.openingHours});

  @override
  Widget build(BuildContext context) {
    _payoutWidget(String label, DateTimeRange range) {
      final startTime = MyDateFormat.toTime(range.start);
      final endTime = MyDateFormat.toTime(range.end);

      return PayoutDataWidget(
        label: label,
        value: '$startTime - $endTime',
        text2Ccolor: Colors.black,
      );
    }

    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: openingHours.length,
        itemBuilder: (context, index) {
          String day = openingHours.keys.elementAt(index);
          DateTimeRange hours = openingHours[day]!;
          return _payoutWidget(day, hours);
        },
      ),
    );
  }
}
