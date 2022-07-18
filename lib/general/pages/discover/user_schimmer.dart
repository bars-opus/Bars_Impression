import 'package:bars/utilities/exports.dart';

class UserSchimmer extends StatefulWidget {
  static final id = 'User_schimmer';

  @override
  _UserSchimmerState createState() => _UserSchimmerState();
}

class _UserSchimmerState extends State<UserSchimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      body: ListView(children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
              UserSchimmerSkeleton(),
            ]),
      ]),
    );
  }
}
