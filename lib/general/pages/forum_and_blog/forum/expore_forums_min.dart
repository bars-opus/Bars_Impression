import 'package:bars/widgets/general_widget/explore_forum_min_widget.dart';

import 'package:bars/utilities/exports.dart';

class ExploreForumMin extends StatefulWidget {
  final String currentUserId;
  final Forum forum;
  final String feed;

  ExploreForumMin(
      {required this.currentUserId, required this.forum, @required required this.feed, });

  @override
  _ExploreForumMinState createState() => _ExploreForumMinState();
}

class _ExploreForumMinState extends State<ExploreForumMin> {
  int _thoughtCount = 0;

  void initState() {
    super.initState();
    _setUpThoughts();
  }

  _setUpThoughts() async {
    DatabaseService.numThoughts(widget.forum.id).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExploreForumsMinWidget(
      currentUserId: widget.currentUserId,
      forum: widget.forum,
      feed: widget.feed,
      thougthCount: _thoughtCount,
    );
  }
}
