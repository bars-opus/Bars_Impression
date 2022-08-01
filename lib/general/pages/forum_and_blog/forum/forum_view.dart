import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class ForumView extends StatefulWidget {
  final String currentUserId;
  final Forum forum;
  final AccountHolder author;
  final String feed;

  // final List<Forum> forumList;

  ForumView(
      {required this.currentUserId,
      // required this.forumList,
      required this.feed,
      required this.forum,
      required this.author});

  @override
  _ForumViewState createState() => _ForumViewState();
}

class _ForumViewState extends State<ForumView> {
  int _thoughtCount = 0;
  final bool showExplore = true;
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
                        forum: widget.forum,
                        feed: widget.feed,
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
                  "Go to ${widget.author.userName}\' profile ",
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
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Report',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ReportContentPage(
                          parentContentId: widget.forum.id,
                          repotedAuthorId: widget.forum.authorId,
                          contentType: 'forum',
                          contentId: widget.forum.id,
                        )))),
        FocusedMenuItem(
            title: Container(
              width: width / 2,
              child: Text(
                'Suggestion Box',
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => SuggestionBox()))),
      ],
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
        child: ForumViewWidget(
          currentUserId: widget.currentUserId,
          author: widget.author,
          titleHero: 'title' + widget.forum.id.toString(),
          subtitleHero: 'subTitle' + widget.forum.id.toString(),
          thougthCount: NumberFormat.compact().format(_thoughtCount),
          onPressedThougthScreen: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThoughtsScreen(
                      feed: widget.feed,
                      forum: widget.forum,
                      author: widget.author,
                      thoughtCount: _thoughtCount,
                      currentUserId: widget.currentUserId))),
          forum: widget.forum,
        ),
      ),
    );
  }
}
