import 'package:bars/utilities/exports.dart';

class EventDateInfo extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final int duration;

  const EventDateInfo(
      {super.key,
      required this.startDate,
      required this.endDate,
      required this.duration});

  @override
  Widget build(BuildContext context) {
    var blueTextStyle = TextStyle(
        color: Colors.blue,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14));
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            children: [
              TextSpan(
                text: "\nStart date:  ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: " ${MyDateFormat.toDate(startDate)}",
                style: blueTextStyle,
              ),
              TextSpan(
                text: "\nEnd date:    ",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              TextSpan(
                text: " ${MyDateFormat.toDate(endDate)}",
                style: blueTextStyle,
              ),
              if (duration != 0)
                TextSpan(
                  text: "\n\nEvent Duration:  ",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (duration != 0)
                TextSpan(
                  text: " $duration days",
                  style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14)),
                ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              "Countdown:        ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CountdownTimer(
              split: 'Single',
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              color: Theme.of(context).secondaryHeaderColor,
              clossingDay: endDate,
              startDate: startDate,
              eventHasEnded: false,
              eventHasStarted: false,
            ),
          ],
        ),
      ],
    );
  }
}
