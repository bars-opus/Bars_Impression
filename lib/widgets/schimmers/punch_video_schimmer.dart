import 'package:bars/utilities/exports.dart';

class PunchVideoSchimmer extends StatefulWidget {
  static final id = 'PunchVideo_schimmer';

  @override
  _PunchVideoSchimmerState createState() => _PunchVideoSchimmerState();
}

class _PunchVideoSchimmerState extends State<PunchVideoSchimmer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
            PunchVideoSchimmerSkeleton(),
          ],
        ),
      ],
    );
  }
}
