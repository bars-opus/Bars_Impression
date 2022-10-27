import 'package:bars/utilities/exports.dart';

class EventCompletedWidget extends StatelessWidget {
  final String date;
  final String time;
  final String type;
  final String title;
  final String previousEvent;
  final Function onPressed;
  EventCompletedWidget(
      {required this.time,
      required this.type,
      required this.previousEvent,
      required this.date,
      required this.title,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(date)).split(" ");
    final List<String> timePartition =
        MyDateFormat.toTime(DateTime.parse(time)).split(" ");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShakeTransition(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: datePartition[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (datePartition.length > 1)
                        TextSpan(
                          text: "\n${datePartition[1].toUpperCase()} ",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (datePartition.length > 2)
                        TextSpan(
                          text: "\n${datePartition[2].toUpperCase()} ",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 50,
                  width: 1,
                  color: Colors.white,
                ),
              ),
              ShakeTransition(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: timePartition[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (timePartition.length > 1)
                        TextSpan(
                          text: "\n${timePartition[1].toUpperCase()} ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      if (timePartition.length > 2)
                        TextSpan(
                          text: "\n${timePartition[2].toUpperCase()} ",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          ShakeTransition(
            child: new Material(
              color: Colors.transparent,
              child: Text(
                "Completed",
                style: TextStyle(
                  fontSize: 34,
                  color: Colors.white,
                  letterSpacing: 6,
                  // fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ShakeTransition(
            child: new Material(
              color: Colors.transparent,
              child: Text(
                title +
                    ' which was dated on ' +
                    MyDateFormat.toDate(DateTime.parse(date)) +
                    ' has been completed successfuly, you can watch the previous event below and if interested cantact the publisher for the next event. ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          previousEvent.isNotEmpty
              ? ShakeTransition(
                  child: Container(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.blue,
                        side: BorderSide(width: 1.0, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Previous Event',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      onPressed: () => onPressed,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              type.startsWith('Fe')
                  ? 'Festival'
                  : type.startsWith('Al')
                      ? 'Album Launch'
                      : type.startsWith('Aw')
                          ? 'Award'
                          : type.startsWith('O')
                              ? 'Others'
                              : type.startsWith('T')
                                  ? 'Tour'
                                  : '',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Bessita',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
