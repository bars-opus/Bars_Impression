import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class ImportContentSearchPost extends StatefulWidget {
  static final id = 'ImportContentSearchPost';
  final String currentUserId;
  final Forum forum;

  ImportContentSearchPost({
    required this.currentUserId,
    required this.forum,
  });

  @override
  _ImportContentSearchPostState createState() =>
      _ImportContentSearchPostState();
}

class _ImportContentSearchPostState extends State<ImportContentSearchPost>
    with AutomaticKeepAliveClientMixin {
  Future<QuerySnapshot>? _post;
  String query = "";
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _showSelectImageDialog(Post post) {
    return Platform.isIOS
        ? _iosBottomSheet(post)
        : _androidDialog(context, post);
  }

  _iosBottomSheet(
    Post post,
  ) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to import this mood punched?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Import',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _sendContent(post);
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog(BuildContext parentContext, Post post) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to import this mood punched?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Import',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _sendContent(post);
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _sendContent(Post post) {
    DatabaseService.thoughtOnForum(
      currentUserId: widget.currentUserId,
      forum: widget.forum,
      thought: "Mood Punched imported",
      reportConfirmed: '',
      user: Provider.of<UserData>(context, listen: false).user!,
      isThoughtLiked: false,
      mediaType: post.id!,
      mediaUrl: post.imageUrl,
      imported: true,
    );
    Navigator.pop(context);
    final double width = MediaQuery.of(context).size.width;
    Flushbar(
      margin: EdgeInsets.all(8),
      boxShadows: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      titleText: Text(
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Imported succesfully.",
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 20 : 12,
        ),
      ),
      icon: Icon(
        MdiIcons.checkCircleOutline,
        size: 30.0,
        color: Colors.blue,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _post = null;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveScaffold(
        child: ResponsiveScaffold(
      child: Scaffold(
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
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFFf2f2f2)
                    : Color(0xFF1a1a1a),
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: TextField(
                  autofocus: true,
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  controller: _controller,
                  onChanged: (input) {
                    setState(() {
                      _post = DatabaseService.searchPost(input.toUpperCase());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter punchline',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.0,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 15.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.black
                            : Colors.white,
                      ),
                      onPressed: _clearSearch,
                    ),
                  ),
                  onSubmitted: (input) {
                    if (input.isNotEmpty) {
                      setState(() {
                        _post = DatabaseService.searchPost(input.toUpperCase());
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: Container(
                  // ignore: unnecessary_null_comparison
                  child: _post == null
                      ? Center(
                          child: NoContents(
                              title: "Search for mood punched. ",
                              subTitle: 'Enter punchline.',
                              icon: Icons.event))
                      : FutureBuilder<QuerySnapshot>(
                          future: _post,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  height: 250,
                                  width: 250,
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                      Colors.grey,
                                    ),
                                    strokeWidth: 1,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No moods punched found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck punchline and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                )),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Scrollbar(
                                child: CustomScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    slivers: [
                                      SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                            Post? _post = Post.fromDoc(
                                                snapshot.data!.docs[index]);
                                            return Column(
                                              children: [
                                                ListTile(
                                                  leading: Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                    child: CachedNetworkImage(
                                                      imageUrl: _post.imageUrl,
                                                      height: 40.0,
                                                      width: 40.0,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  title: Text(_post.punch,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                  subtitle: Text(_post.artist,
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                        color: ConfigBloc()
                                                                .darkModeOn
                                                            ? Colors.white
                                                            : Colors.black,
                                                      )),
                                                  onTap: () {
                                                    _showSelectImageDialog(
                                                        _post);
                                                  },
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                ),
                                              ],
                                            );
                                          },
                                          childCount:
                                              snapshot.data!.docs.length,
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          })),
            ),
          )),
    ));
  }
}
