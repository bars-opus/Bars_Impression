import 'package:bars/utilities/exports.dart';

class ActivityReactedContent extends StatefulWidget {
  final String authorId;
  final String parentContentId;
  final String contentId;
  final String forumAuthorId;
  final String contentType;

  ActivityReactedContent(
      {required this.contentType,
      required this.contentId,
      required this.authorId,
      required this.parentContentId,
      required this.forumAuthorId});
  @override
  _ActivityReactedContentState createState() => _ActivityReactedContentState();
}

class _ActivityReactedContentState extends State<ActivityReactedContent> {
  int _thoughtCount = 0;
  final bool showExplore = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.contentType.startsWith('Forum') ? _setUpThoughts() : _nothing();
  }

  _nothing() {}
  _setUpThoughts() async {
    DatabaseService.numThoughts(widget.contentId).listen((thoughtCount) {
      if (mounted) {
        setState(() {
          _thoughtCount = thoughtCount;
        });
      }
    });
  }

  _userTile(AccountHolder user) {
    return SearchUserTile(
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        verified: user.verified,
        company: user.company!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        // score: user.score!,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        userId: user.id!,
                        user: user,
                      )));
        });
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        title: Text(
          '',
          style: TextStyle(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
          child:
              //  widget.contentType.startsWith('Thought')
              //     ?
              FutureBuilder(
                  future: DatabaseService.getThoughtWithId(
                      widget.parentContentId, widget.contentId),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: width,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    Thought _thought = snapshot.data;

                    return FutureBuilder(
                        future: DatabaseService.getUserWithId(widget.authorId),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: width,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          AccountHolder _user = snapshot.data;
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            width: width,
                            child: ListView(
                              children: [
                                Container(
                                  color: Colors.blue[100],
                                  child: Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: _thought
                                                .authorProfileImageUrl.isEmpty
                                            ? AssetImage(
                                                'assets/images/user_placeholder2.png',
                                              ) as ImageProvider
                                            : CachedNetworkImageProvider(
                                                _thought.authorProfileImageUrl),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            _thought.authorName,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(_thought.authorProfileHanlde,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.blueGrey,
                                              )),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2.0),
                                            child: Container(
                                              color: Colors.blue,
                                              height: 1.0,
                                              width: 50.0,
                                            ),
                                          ),
                                          Text(
                                            _thought.content,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 10.0),
                                        ],
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'Liked by: ',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                _userTile(_user),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                _isLoading
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Shimmer.fromColors(
                                          period: Duration(milliseconds: 1000),
                                          baseColor: Colors.grey,
                                          highlightColor: Colors.blue,
                                          child: RichText(
                                              text: TextSpan(
                                            children: [
                                              TextSpan(
                                                  text:
                                                      'Fetching please Wait... '),
                                            ],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue),
                                          )),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(
                                    width: width,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        elevation: 0.0,
                                        foregroundColor: Colors.blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2),
                                        child: Text(
                                          'View forum',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        String currentUserId =
                                            Provider.of<UserData>(context,
                                                    listen: false)
                                                .currentUserId!;
                                        Forum forum =
                                            await DatabaseService.getUserForum(
                                          widget.forumAuthorId,
                                          widget.parentContentId,
                                        );

                                        DatabaseService.numThoughts(forum.id)
                                            .listen((thoughtCount) {
                                          if (mounted) {
                                            setState(() {
                                              _thoughtCount = thoughtCount;
                                            });
                                          }
                                        });

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ThoughtsScreen(
                                              feed: '',
                                              forum: forum,
                                              // author: user,
                                              thoughtCount: _thoughtCount,
                                              currentUserId: currentUserId,
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  })),
    );
    //
  }
}
