import 'package:bars/utilities/exports.dart';

class EventAttendeesInvitedScreeen extends StatefulWidget {
  static final id = 'EventAttendeesInvitedScreeen';
  final Event event;
  final String answer;
  final bool letShowAppBar;
  final PaletteGenerator palette;

  EventAttendeesInvitedScreeen({
    required this.event,
    required this.palette,
    required this.letShowAppBar,
    required this.answer,
  });

  @override
  _EventAttendeesInvitedScreeenState createState() =>
      _EventAttendeesInvitedScreeenState();
}

class _EventAttendeesInvitedScreeenState
    extends State<EventAttendeesInvitedScreeen>
    with AutomaticKeepAliveClientMixin {
  List<InviteModel> _inviteList = [];
  final _inviteSnapshot = <DocumentSnapshot>[];
  int limit = 10;
  bool _hasNext = true;
  bool _isLoading = true;

  bool _isFectchingUser = false;
  bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    if (widget.event.id.isNotEmpty)
      widget.answer.startsWith('All') ? _setUpInvitedAll() : _setUpInvite();
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
    QuerySnapshot inviteSnapShot = await sentEventIviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('answer', isEqualTo: widget.answer)
        .limit(limit)
        .get();
    List<InviteModel> users =
        inviteSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
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

  _setUpInvitedAll() async {
    QuerySnapshot inviteSnapShot = await sentEventIviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        // .where('invited', isEqualTo: true)
        .limit(limit)
        .get();
    List<InviteModel> users =
        inviteSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
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

  _loadMoreInvite() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await sentEventIviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('answer', isEqualTo: widget.answer)
        .limit(limit)
        .startAfterDocument(_inviteSnapshot.last)
        .get();
    List<InviteModel> moreusers =
        inviteSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
    if (_inviteSnapshot.length < limit) _hasNext = false;
    List<InviteModel> allusers = _inviteList..addAll(moreusers);
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
    QuerySnapshot inviteSnapShot = await sentEventIviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        // .where('invited', isEqualTo: true)
        .limit(limit)
        .startAfterDocument(_inviteSnapshot.last)
        .get();
    List<InviteModel> moreusers =
        inviteSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
    if (_inviteSnapshot.length < limit) _hasNext = false;
    List<InviteModel> allusers = _inviteList..addAll(moreusers);
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

  _buildUserTile(InviteModel invite) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
            future: DatabaseService.getUserWithId(invite.inviteeId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              AccountHolderAuthor user = snapshot.data;
              return ListTile(
                leading: user.profileImageUrl!.isEmpty
                    ? Icon(
                        Icons.account_circle,
                        size: 40.0,
                        color: Colors.grey,
                      )
                    : CircleAvatar(
                        radius: 18.0,
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            CachedNetworkImageProvider(user.profileImageUrl!),
                      ),
                title: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(children: [
                      TextSpan(
                        text: user.userName,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      TextSpan(
                          text: "\n${user.profileHandle}",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            color: Colors.blue,
                          )),
                    ])),
                subtitle: Divider(
                  color: Colors.grey,
                ),
              );
            }));
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
                InviteModel invite = _inviteList[index];
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
    return Material(
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
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
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
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
        ],
        body: Container(
          color: widget.palette.darkMutedColor == null
              ? Color(0xFF1a1a1a)
              : widget.palette.darkMutedColor!.color,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: SafeArea(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
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
        ),
      ),
    );
  }
}
