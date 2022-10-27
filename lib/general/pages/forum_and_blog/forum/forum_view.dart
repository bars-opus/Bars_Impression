import 'package:bars/utilities/exports.dart';

class ForumView extends StatefulWidget {
  final String currentUserId;
  final Forum forum;
  // final AccountHolder author;
  final String feed;

  ForumView(
      {required this.currentUserId,
      required this.feed,
      required this.forum,
  });

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

  _dynamicLink() async {
    final dynamicLinkParams = await DynamicLinkParameters(
      socialMetaTagParameters: await SocialMetaTagParameters(
        imageUrl: Uri.parse(
            'https://firebasestorage.googleapis.com/v0/b/bars-5e3e5.appspot.com/o/IMG_8574.PNG?alt=media&token=ccb4e3b1-b5dc-470f-abd0-63edb5ed549f'),
        title: 'Forum',
        description: widget.forum.title,
      ),
      link: Uri.parse('https://www.barsopus.com/forum_${widget.forum.id}'),
      uriPrefix: 'https://barsopus.com/barsImpression',
      androidParameters:
          AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
      iosParameters: IOSParameters(
        bundleId: 'com.bars-Opus.barsImpression',
        appStoreId: '1610868894',
      ),
    );
    if (Platform.isIOS) {
      var link =
          await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
      Share.share(link.toString());
    } else {
      var link =
          await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
      Share.share(link.shortUrl.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return FocusedMenuHolder(
      blurBackgroundColor:
          ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white10,
      openWithTap: false,
      onPressed: () {},
      menuWidth: width,
      menuItemExtent: 60,
      menuOffset: 10,
      menuItems: [
        FocusedMenuItem(
          title: Container(
            width: width - 40,
            child: Center(
              child: Text(
                widget.forum.authorId == widget.currentUserId
                    ? 'Edit forum'
                    : "View profile ",
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
                      builder: (_) => 
                      
                      // widget.author.userName!.isEmpty
                      //     ? UserNotFound(
                      //         userName: 'User',
                      //       )
                      //     : 
                          ProfileScreen(
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
            onPressed: () => _dynamicLink()),
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
          // author: widget.author,
         
          // onPressedThougthScreen: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ThoughtsScreen(
          //             feed: widget.feed,
          //             forum: widget.forum,
          //             author: widget.author,
          //             thoughtCount: _thoughtCount,
          //             currentUserId: widget.currentUserId))),
          forum: widget.forum, feed: widget.feed,
          thoughtCount: _thoughtCount
          // NumberFormat.compact().format(_thoughtCount),
        ),
      ),
    );
  }
}
