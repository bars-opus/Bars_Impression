import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class ProfileForumView extends StatefulWidget {
  final String currentUserId;
  final Forum forum;
  final AccountHolder author;
  final String feed;

  ProfileForumView(
      {required this.currentUserId,
      required this.feed,
      required this.forum,
      required this.author});

  @override
  _ProfileForumViewState createState() => _ProfileForumViewState();
}

class _ProfileForumViewState extends State<ProfileForumView> {
  int _thoughtCount = 0;
  @override
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
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
      menuWidth: width,
      menuOffset: 10,
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          title: Text(
            'Your thought on this topic',
            overflow: TextOverflow.ellipsis,
            textScaleFactor: MediaQuery.of(context).textScaleFactor,
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThoughtsScreen(
                        feed: 'Profile',
                        forum: widget.forum,
                        author: widget.author,
                        thoughtCount: _thoughtCount,
                        currentUserId: widget.currentUserId,
                      ))),
        ),
        widget.forum.authorId == widget.currentUserId
            ? FocusedMenuItem(
                title: Text(
                  'Edit forum',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditForum(
                      forum: widget.forum,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                ),
              )
            : FocusedMenuItem(
                title: Text(
                  "Go to ${widget.author.userName}'s profile",
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ProfileScreen(
                              currentUserId: widget.currentUserId,
                              userId: widget.forum.authorId,
                            ))),
              ),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: ForumViewWidget(
          currentUserId: widget.currentUserId,
          author: widget.author,
          forum: widget.forum,
          titleHero: 'titleProfile' + widget.forum.id.toString(),
          subtitleHero: 'subTitleProfile' + widget.forum.id.toString(),
          thougthCount: NumberFormat.compact().format(_thoughtCount),
          onPressedThougthScreen: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThoughtsScreen(
                        feed: widget.feed,
                        forum: widget.forum,
                        author: widget.author,
                        thoughtCount: _thoughtCount,
                        currentUserId: widget.currentUserId,
                      ))),
        ),
      ),
    );
  }
}
