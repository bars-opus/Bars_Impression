import 'package:bars/utilities/exports.dart';

class FollowUserSchimmer extends StatefulWidget {
  static final id = 'User_schimmer';

  @override
  _FollowUserSchimmerState createState() => _FollowUserSchimmerState();
}

class _FollowUserSchimmerState extends State<FollowUserSchimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
              FollowerUserSchimmerSkeleton(),
            ]),
      ]),
    );
  }
}
