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
          title: Container(
            width: width - 40,
            child: Center(
              child: Text(
                widget.forum.authorId == widget.currentUserId
                    ? 'Edit forum'
                    : "Go to ${widget.author.userName}\' profile ",
                overflow: TextOverflow.ellipsis,
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
              ),
            ),
          ),
          onPressed: () => widget.forum.authorId == widget.currentUserId
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditForum(
                      forum: widget.forum,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId: widget.currentUserId,
                            userId: widget.forum.authorId,
                          ))),
        ),
        FocusedMenuItem(
            title: Container(
              width: width - 40,
              child: Center(
                child: Text(
                  'Send ',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SendToChats(
                            sendContentId: widget.forum.id,
                            currentUserId: widget.currentUserId,
                            userId: '',
                            sendContentType: 'Forum',
                            event: null,
                            post: null,
                            forum: widget.forum,
                            user: null,
                          )));
            }),
        FocusedMenuItem(
            title: Container(
              width: width - 40,
              child: Center(
                child: Text(
                  'Share ',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
              ),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => SendToChats(
                            currentUserId: widget.currentUserId,
                            userId: '',
                            sendContentType: 'Forum',
                            event: null,
                            post: null,
                            forum: widget.forum,
                            user: null,
                            sendContentId: widget.forum.id,
                          )));
            }),
        FocusedMenuItem(
            title: Container(
              width: width - 40,
              child: Center(
                child: Text(
                  'Report',
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                ),
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
              width: width - 40,
              child: Center(
                child: Center(
                  child: Text(
                    'Suggestion Box',
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  ),
                ),
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
