import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class ImportContentSearchForum extends StatefulWidget {
  static final id = 'ImportContentSearchForum';
  final String currentUserId;
  final Forum forum;

  ImportContentSearchForum({
    required this.currentUserId,
    required this.forum,
  });

  @override
  _ImportContentSearchForumState createState() =>
      _ImportContentSearchForumState();
}

class _ImportContentSearchForumState extends State<ImportContentSearchForum>
    with AutomaticKeepAliveClientMixin {
  Future<QuerySnapshot>? _forum;
  String query = "";
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _showSelectImageDialog(Forum forum) {
    return Platform.isIOS
        ? _iosBottomSheet(forum)
        : _androidDialog(context, forum);
  }

  _iosBottomSheet(
    Forum forum,
  ) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to import this forum?',
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
                  _sendContent(forum);
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

  _androidDialog(BuildContext parentContext, Forum forum) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to import this forum?',
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
                    _sendContent(forum);
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

  _sendContent(Forum forum) {
    DatabaseService.thoughtOnForum(
      currentUserId: widget.currentUserId,
      forum: widget.forum,
      thought: "Forum imported",
      reportConfirmed: '',
      user: Provider.of<UserData>(context, listen: false).user!,
      isThoughtLiked: false,
      mediaType: forum.id,
      mediaUrl: '',
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
      _forum = null;
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
                      _forum = DatabaseService.searchForum(input.toUpperCase());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter forum title',
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
                        _forum =
                            DatabaseService.searchForum(input.toUpperCase());
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
                  child: _forum == null
                      ? Center(
                          child: NoContents(
                              title: "Search for forums. ",
                              subTitle: 'Enter forum title.',
                              icon: Icons.event))
                      : FutureBuilder<QuerySnapshot>(
                          future: _forum,
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
                                        text: "No forums found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text: '\nCheck title and try again.'),
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
                                            Forum? _forum = Forum.fromDoc(
                                                snapshot.data!.docs[index]);
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(_forum.title,
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue,
                                                      )),
                                                  subtitle:
                                                      Text(_forum.subTitle,
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                          )),
                                                  onTap: () {
                                                    _showSelectImageDialog(
                                                        _forum);
                                                  },
                                                ),
                                                Divider(
                                                  color: Colors.grey,
                                                )
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
