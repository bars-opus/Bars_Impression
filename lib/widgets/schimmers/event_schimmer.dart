import 'package:bars/utilities/exports.dart';

class EventSchimmer extends StatefulWidget {
  static final id = 'Event_schimmer';

  @override
  _EventSchimmerState createState() => _EventSchimmerState();
}

class _EventSchimmerState extends State<EventSchimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
            EventSchimmerSkeleton(),
          ],
        ),
      ],
    );
  }
}
