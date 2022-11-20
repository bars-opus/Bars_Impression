import 'package:bars/utilities/exports.dart';

class EventAttendeesAll extends StatefulWidget {
  static final id = 'EventAttendeesAll';
  final Event event;
  final String answer;

  final bool showAppBar;
  final bool dontShowAnswerWidget;
  final PaletteGenerator palette;

  EventAttendeesAll({
    required this.event,
    required this.palette,
    required this.showAppBar,
    required this.dontShowAnswerWidget,
    required this.answer,
  });

  @override
  _EventAttendeesAllState createState() => _EventAttendeesAllState();
}

class _EventAttendeesAllState extends State<EventAttendeesAll>
    with AutomaticKeepAliveClientMixin {
  List<EventInvite> _inviteList = [];
  final _inviteSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  bool _isLoading = true;
  bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    widget.event.isPrivate ? _setUpInviteAllPrivate() : _setUpInviteAllPublic();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.event.isPrivate ? _loadMoreAllPrivate() : _loadMoreAllPublic();
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

  _setUpInviteAllPrivate() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
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
        _isLoading = false;
      });
    }
    return users;
  }

  _setUpInviteAllPublic() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
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
        _isLoading = false;
      });
    }
    return users;
  }

  _loadMoreAllPrivate() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
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

  _loadMoreAllPublic() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
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

  _buildUserTile(EventInvite invite) {
    return widget.event.authorId ==
                Provider.of<UserData>(context).currentUserId &&
            widget.event.isPrivate
        ? EventAttendeeRequestAnswereWidget(
            invite: invite,
            palette: widget.palette,
            activityEvent: null,
          )
        : _buildAttendees(invite);
  }

  _buildAttendees(EventInvite invite) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8.0),
          child: ListTile(
            leading: invite.anttendeeprofileImageUrl.isEmpty
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
                    backgroundImage: CachedNetworkImageProvider(
                        invite.anttendeeprofileImageUrl),
                  ),
            title: Align(
              alignment: Alignment.topLeft,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Text(invite.anttendeeName,
                        style: TextStyle(
                          fontSize: width > 800 ? 18 : 14.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ],
              ),
            ),
            subtitle: Text(invite.anttendeeprofileHandle,
                style: TextStyle(
                  fontSize: width > 800 ? 14 : 12,
                  color: Colors.blue,
                )),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          currentUserId:
                              Provider.of<UserData>(context).currentUserId!,
                          userId: invite.anttendeeId,
                          user: null,
                        ))),
          ),
        ),
      ),
    );
  }

  _buildEventBuilder() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                EventInvite invite = _inviteList[index];
                return widget.dontShowAnswerWidget
                    ? _buildAttendees(invite)
                    : _buildUserTile(invite);
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
          widget.showAppBar
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
                    widget.dontShowAnswerWidget
                        ? 'Expected Attendees'
                        : 'Event Attendees ${widget.answer}',
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
                    'Attendee requests',
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
                    _isLoading
                        ? Expanded(
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            ),
                          )
                        : _inviteList.length == 0
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
