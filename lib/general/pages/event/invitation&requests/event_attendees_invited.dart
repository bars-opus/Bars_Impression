import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EventAttendeesInvited extends StatefulWidget {
  static final id = 'EventAttendeesInvited';
  final Event event;
  final String answer;
  final bool letShowAppBar;

  final PaletteGenerator palette;

  EventAttendeesInvited({
    required this.event,
    required this.palette,
    required this.letShowAppBar,
    required this.answer,
  });

  @override
  _EventAttendeesInvitedState createState() => _EventAttendeesInvitedState();
}

class _EventAttendeesInvitedState extends State<EventAttendeesInvited>
    with AutomaticKeepAliveClientMixin {
  List<EventInvite> _inviteList = [];
  final _inviteSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    widget.answer.startsWith('All') ? _setUpInvited() : _setUpInvite();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.answer.startsWith('All') ? _loadMoreAll() : _loadMoreInvite();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  __setShowInfo() {
    if (_showInfo) {
      Timer(Duration(seconds: 7), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  _setUpInvite() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('invited', isEqualTo: true)
        .where('attendeeStatus', isEqualTo: widget.answer)
        .limit(limit)
        .get();
    List<EventInvite> users =
        inviteSnapShot.docs.map((doc) => EventInvite.fromDoc(doc)).toList();
    _inviteSnapshot.addAll((inviteSnapShot.docs));
    if (mounted) {
      print(users.length.toString());
      setState(() {
        _hasNext = false;
        _inviteList = users;
      });
    }
    return users;
  }

  _setUpInvited() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('invited', isEqualTo: true)
        .limit(limit)
        .get();
    List<EventInvite> users =
        inviteSnapShot.docs.map((doc) => EventInvite.fromDoc(doc)).toList();
    _inviteSnapshot.addAll((inviteSnapShot.docs));
    if (mounted) {
      print(users.length.toString());
      setState(() {
        _hasNext = false;
        _inviteList = users;
      });
    }
    return users;
  }

  _loadMoreInvite() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('invited', isEqualTo: true)
        .where('attendeeStatus', isEqualTo: widget.answer)
        .limit(limit)
        .startAfterDocument(_inviteSnapshot.last)
        .get();
    List<EventInvite> moreusers =
        inviteSnapShot.docs.map((doc) => EventInvite.fromDoc(doc)).toList();
    if (_inviteSnapshot.length < limit) _hasNext = false;
    List<EventInvite> allusers = _inviteList..addAll(moreusers);
    _inviteSnapshot.addAll((inviteSnapShot.docs));
    if (mounted) {
      setState(() {
        _inviteList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _loadMoreAll() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('invited', isEqualTo: true)
        .limit(limit)
        .startAfterDocument(_inviteSnapshot.last)
        .get();
    List<EventInvite> moreusers =
        inviteSnapShot.docs.map((doc) => EventInvite.fromDoc(doc)).toList();
    if (_inviteSnapshot.length < limit) _hasNext = false;
    List<EventInvite> allusers = _inviteList..addAll(moreusers);
    _inviteSnapshot.addAll((inviteSnapShot.docs));
    if (mounted) {
      setState(() {
        _inviteList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _showSelectImageDialog(EventInvite invite) {
    return Platform.isIOS
        ? _iosBottomSheet(invite)
        : _androidDialog(context, invite);
  }

  _iosBottomSheet(EventInvite invite) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to cancel this invitation?',
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'Cancel Invitation',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  DatabaseService.cancelInvite(
                    eventInvite: invite,
                  );
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

  _androidDialog(BuildContext parentContext, EventInvite invite) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to cancel this invitation?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel Invitation',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    DatabaseService.cancelInvite(
                      eventInvite: invite,
                    );
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

  _buildUserTile(EventInvite invite) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(10, 10),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              )
            ]),
        child: GestureDetector(
            onTap: () {},
            child: Material(
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(),
                      height: 60,
                      child: ListTile(
                        leading: invite.anttendeeprofileImageUrl.isEmpty
                            ? Icon(
                                Icons.account_circle,
                                size: 60.0,
                                color: Colors.white,
                              )
                            : CircleAvatar(
                                radius: 25.0,
                                backgroundColor: ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Color(0xFFf2f2f2),
                                backgroundImage: CachedNetworkImageProvider(
                                    invite.anttendeeprofileImageUrl),
                              ),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: RichText(
                            textScaleFactor:
                                MediaQuery.of(context).textScaleFactor,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: invite.anttendeeName.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: '\n${invite.anttendeeprofileHandle},',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProfileScreen(
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUserId!,
                                      userId: invite.anttendeeId,
                                    ))),
                      ),
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: invite.invited!
                                  ? 'Invite message'
                                  : 'Request reason:',
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.palette.darkMutedColor == null
                                    ? Color(0xFF1a1a1a)
                                    : widget.palette.darkMutedColor!.color,
                              ),
                            ),
                            TextSpan(
                              text: '\n${invite.message}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        invite.attendeeStatus.isEmpty
                            ? 'Unanswered'
                            : invite.attendeeStatus,
                        style: TextStyle(
                          color: invite.attendeeStatus.startsWith('Reject')
                              ? Colors.red
                              : invite.attendeeStatus.startsWith('Accept')
                                  ? Colors.blue
                                  : Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width / 1.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  // Colors.grey,
                                  Color(0xFFf2f2f2),
                              elevation: 0.0,
                              onPrimary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 2),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              _showSelectImageDialog(invite);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ))),
      ),
    );
  }

  _buildEventBuilder() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        controller: _hideButtonController,
        child: CustomScrollView(controller: _hideButtonController, slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                EventInvite invite = _inviteList[index];
                return _buildUserTile(invite);
              },
              childCount: _inviteList.length,
            ),
          )
        ]),
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveScaffold(
      child: NestedScrollView(
        controller: _hideButtonController,
        headerSliverBuilder: (context, innerBoxScrolled) => [
          widget.letShowAppBar
              ? SliverAppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  floating: true,
                  snap: true,
                  pinned: true,
                  iconTheme: new IconThemeData(
                    color: Colors.white,
                  ),
                  backgroundColor: widget.palette.darkMutedColor == null
                      ? Color(0xFF1a1a1a)
                      : widget.palette.darkMutedColor!.color,
                  title: Text(
                    'Invites ${widget.answer}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                )
              : SliverAppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: false,
                  floating: false,
                  snap: false,
                  pinned: false,
                  iconTheme: new IconThemeData(
                    color: Colors.transparent,
                  ),
                  backgroundColor: widget.palette.darkMutedColor == null
                      ? Color(0xFF1a1a1a)
                      : widget.palette.darkMutedColor!.color,
                  title: Text(
                    'Invitation responds',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.black
                            : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
        ],
        body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Container(
            color: widget.palette.darkMutedColor == null
                ? Color(0xFF1a1a1a)
                : widget.palette.darkMutedColor!.color,
            child: SafeArea(
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    textScaleFactor:
                        MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _inviteList.length == 0
                        ? const SizedBox.shrink()
                        : Expanded(child: _buildEventBuilder())
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
