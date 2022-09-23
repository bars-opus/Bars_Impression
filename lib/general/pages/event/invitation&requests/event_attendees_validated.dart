import 'package:bars/utilities/exports.dart';

class EventAttendeesValidated extends StatefulWidget {
  static final id = 'EventAttendeesValidated';
  final Event event;
  final String from;
  final PaletteGenerator palette;

  EventAttendeesValidated({
    required this.event,
    required this.palette,
    required this.from,
  });

  @override
  _EventAttendeesValidatedState createState() =>
      _EventAttendeesValidatedState();
}

class _EventAttendeesValidatedState extends State<EventAttendeesValidated>
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
    // widget.from.startsWith('Received') ? _setUpInviteAll() :
    _setAttendeesValidate();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        // widget.from.startsWith('Received') ? _loadMoreAll() :
        _loadAttendeesValidated();
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

  _setAttendeesValidate() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('attendeeStatus', isEqualTo: widget.from)
        .where('validated', isEqualTo: true)
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

  _loadAttendeesValidated() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('attendeeStatus', isEqualTo: widget.from)
        .where('validated', isEqualTo: true)
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

  _buildEventBuilder() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Scrollbar(
        child: CustomScrollView(slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                EventInvite invite = _inviteList[index];
                return EventAttendeeValidateWidget(
                  invite: invite,
                  palette: widget.palette,
                  activityEvent: null,
                  event: widget.event,
                );
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
          SliverAppBar(
                  elevation: 0.0,
                  automaticallyImplyLeading: true,
                  floating: true,
                  snap: true,
                  pinned: true,
                  iconTheme: new IconThemeData(
                    color:
                        ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                  ),
                  backgroundColor: widget.palette.darkMutedColor == null
                      ? Color(0xFF1a1a1a)
                      : widget.palette.darkMutedColor!.color,
                  title: Text(
                    'Validated Attendees',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.black
                            : Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                )
             
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
                        ? SizedBox.shrink()
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
