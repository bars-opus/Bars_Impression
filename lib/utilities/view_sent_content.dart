import 'package:bars/utilities/exports.dart';

class ViewSentContent extends StatefulWidget {
  final String contentId;
  final String contentType;

  ViewSentContent({required this.contentType, required this.contentId});
  @override
  _ViewSentContentState createState() => _ViewSentContentState();
}

class _ViewSentContentState extends State<ViewSentContent> {
  int _thoughtCount = 0;
  final bool showExplore = true;
  @override
  void initState() {
    super.initState();
    widget.contentType.startsWith('Forum') ? _setUpThoughts() : () {};
  }

  _setUpThoughts() async {
    DatabaseService.numThoughts(widget.contentId).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: widget.contentType.startsWith('Mood Punched')
          ? FutureBuilder(
              future: DatabaseService.getPostWithId(widget.contentId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return PostSchimmerSkeleton();
                }
                Post _post = snapshot.data;
                return FutureBuilder(
                    future: DatabaseService.getUserWithId(_post.authorId),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return PostSchimmerSkeleton();
                      }
                      AccountHolder _author = snapshot.data;
                      return AllPostEnlarged(
                          currentUserId:
                              Provider.of<UserData>(context, listen: false)
                                  .currentUserId!,
                          post: _post,
                          feed: 'All',
                          author: _author);
                    });
              })
          : widget.contentType.startsWith('Forum')
              ? FutureBuilder(
                  future: DatabaseService.getForumWithId(widget.contentId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        width: width,
                        height: height,
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFf2f2f2),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.blue,
                        )),
                      );
                    }
                    Forum _forum = snapshot.data;
                    return FutureBuilder(
                        future: DatabaseService.getUserWithId(_forum.authorId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              width: width,
                              height: height,
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFF1a1a1a)
                                  : Color(0xFFf2f2f2),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blue,
                              )),
                            );
                          }
                          AccountHolder _author = snapshot.data;
                          return ThoughtsScreen(
                              feed: '',
                              forum: _forum,
                              author: _author,
                              thoughtCount: _thoughtCount,
                              currentUserId:
                                  Provider.of<UserData>(context, listen: false)
                                      .currentUserId!);
                        });
                  })
              : widget.contentType.startsWith('Event')
                  ? FutureBuilder(
                      future: DatabaseService.getEventWithId(widget.contentId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: width,
                            height: height,
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Color(0xFFf2f2f2),
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.blue,
                            )),
                          );
                        }
                        Event _event = snapshot.data;
                        return AllEvenEnlarged(
                          exploreLocation: 'No',
                          feed: 1,
                          askCount: 0,
                          currentUserId:
                              Provider.of<UserData>(context, listen: false)
                                  .currentUserId!,
                          event: _event,
                          user: Provider.of<UserData>(context, listen: false)
                              .user!,
                        );
                      })
                  : widget.contentType.startsWith('User')
                      ? ProfileScreen(
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          userId: widget.contentId,
                        )
                      : const SizedBox.shrink(),
    );
  }
}
