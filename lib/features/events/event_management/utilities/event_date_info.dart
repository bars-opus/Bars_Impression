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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          border: TableBorder.all(
            color: Colors.blue,
            width: 0.5,
          ),
          children: [
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'Start date:   ',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  "${MyDateFormat.toDate(startDate)}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ]),
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'End date:',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  '${MyDateFormat.toDate(endDate)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ]),
            if (duration != 0)
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Event Duration:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: '$duration days',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 16),
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
            TableRow(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: Text(
                  'Countdown',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                child: CountdownTimer(
                  split: 'Single',
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Theme.of(context).secondaryHeaderColor,
                  clossingDay: endDate,
                  startDate: startDate,
                  eventHasEnded: false,
                  eventHasStarted: false,
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
