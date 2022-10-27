import 'package:bars/utilities/exports.dart';

class AllPostEnlarged extends StatefulWidget {
  final String currentUserId;
  final Post post;
  // final AccountHolder author;
  final String feed;
  AllPostEnlarged(
      {required this.currentUserId,
      required this.feed,
      required this.post,
    });

  @override
  _AllPostEnlargedState createState() => _AllPostEnlargedState();
}

class _AllPostEnlargedState extends State<AllPostEnlarged> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          body: GestureDetector(
            onLongPress: () => () {},
            child: PunchExpandedWidget(
              feed: widget.feed,
              // author: widget.author,
              post: widget.post,
              currentUserId: widget.currentUserId,
            ),
          )),
    );
  }
}
