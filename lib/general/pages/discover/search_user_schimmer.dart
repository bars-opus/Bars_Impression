import 'package:bars/utilities/exports.dart';

class SearchUserSchimmer extends StatefulWidget {
  static final id = 'User_schimmer';

  @override
  _SearchUserSchimmerState createState() => _SearchUserSchimmerState();
}

class _SearchUserSchimmerState extends State<SearchUserSchimmer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: ListView(children: <Widget>[
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
              SearchUserSchimmerSkeleton(),
            ]),
      ]),
    );
  }
}
