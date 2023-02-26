import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class ImportContentSearchUser extends StatefulWidget {
  static final id = 'ImportContentSearchUser';
  final String currentUserId;
  final Forum forum;

  ImportContentSearchUser({
    required this.currentUserId,
    required this.forum,
  });

  @override
  _ImportContentSearchUserState createState() =>
      _ImportContentSearchUserState();
}

class _ImportContentSearchUserState extends State<ImportContentSearchUser>
    with AutomaticKeepAliveClientMixin {
  Future<QuerySnapshot>? _users;
  String query = "";
  final _controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  _showSelectImageDialog(AccountHolder user) {
    return Platform.isIOS
        ? _iosBottomSheet(user)
        : _androidDialog(context, user);
  }

  _iosBottomSheet(AccountHolder user) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to import this user?',
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
                  _sendContent(user);
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

  _androidDialog(BuildContext parentContext, AccountHolder user) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to import this user?',
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
                    _sendContent(user);
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

  _sendContent(AccountHolder user) {
    DatabaseService.thoughtOnForum(
      currentUserId: widget.currentUserId,
      forum: widget.forum,
      thought: "User imported",
      reportConfirmed: '',
      user: Provider.of<UserData>(context, listen: false).user!,
      isThoughtLiked: false,
      mediaType: user.id!,
      mediaUrl: user.profileImageUrl!,
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

  _buildUserTile(AccountHolder user) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: user.profileImageUrl!.isEmpty
              ? Icon(
                  Icons.account_circle,
                  size: 60.0,
                  color: Colors.grey,
                )
              : CircleAvatar(
                  radius: 25.0,
                  backgroundColor: ConfigBloc().darkModeOn
                      ? Color(0xFF1a1a1a)
                      : Color(0xFFf2f2f2),
                  backgroundImage:
                      CachedNetworkImageProvider(user.profileImageUrl!),
                ),
          title: Align(
            alignment: Alignment.topLeft,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(user.userName!,
                      style: TextStyle(
                        fontSize: width > 800 ? 18 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      )),
                ),
                user.verified!.isEmpty
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 3,
                        right: 0,
                        child: Icon(
                          MdiIcons.checkboxMarkedCircle,
                          size: 11,
                          color: Colors.blue,
                        ),
                      ),
              ],
            ),
          ),
          subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(user.profileHandle!,
                        style: TextStyle(
                          fontSize: width > 800 ? 14 : 12,
                          color: Colors.blue,
                        )),
                    Text(user.company!,
                        style: TextStyle(
                          fontSize: width > 800 ? 14 : 12,
                          color: Colors.blueGrey,
                        )),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Divider(
                  color: ConfigBloc().darkModeOn
                      ? Colors.grey[850]
                      : Colors.grey[350],
                )
              ]),
          onTap: () {
            _showSelectImageDialog(user);
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => SendEventInviation(
            //               user: user,
            //               currentUserId:
            //                   Provider.of<UserData>(context).currentUserId!,
            //               event: widget.event,
            //               palette: widget.palette,
            //             )));
          },
        ));
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _users = null;
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
                      _users = DatabaseService.searchUsers(input.toUpperCase());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter username',
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
                        _users =
                            DatabaseService.searchUsers(input.toUpperCase());
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
                  child: _users == null
                      ? Center(
                          child: NoContents(
                              title: "Search for users.",
                              subTitle:
                                  'Enter username, \ndon\'t enter a user\'s stage name or nickname.',
                              icon: Icons.search))
                      : FutureBuilder<QuerySnapshot>(
                          future: _users,
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
                                        text: "No users found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck username and try again.'),
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
                                            AccountHolder? user =
                                                AccountHolder.fromDoc(
                                                    snapshot.data!.docs[index]);
                                            return _buildUserTile(user);
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
