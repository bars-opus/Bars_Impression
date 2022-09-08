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
        const SizedBox(
          height: 20,
        ),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
        EventSchimmerSkeleton(),
      ],
    );
  }
}
