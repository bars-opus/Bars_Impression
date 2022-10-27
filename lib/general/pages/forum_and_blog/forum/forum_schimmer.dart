import 'package:bars/utilities/exports.dart';

class ForumSchimmer extends StatefulWidget {
  static final id = 'Forum_schimmer';

  @override
  _ForumSchimmerState createState() => _ForumSchimmerState();
}

class _ForumSchimmerState extends State<ForumSchimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      body: ListView(children: <Widget>[
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
        ForumSchimmerSkeleton(),
      ]),
    );
  }
}
