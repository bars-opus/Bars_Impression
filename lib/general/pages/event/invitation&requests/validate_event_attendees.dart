import 'package:bars/utilities/exports.dart';

class ValidateEventAttendees extends StatefulWidget {
  static final id = 'ValidateEventAttendees';
  final Event event;
  final String from;
  final PaletteGenerator palette;

  ValidateEventAttendees({
    required this.event,
    required this.palette,
    required this.from,
  });

  @override
  _ValidateEventAttendeesState createState() => _ValidateEventAttendeesState();
}

class _ValidateEventAttendeesState extends State<ValidateEventAttendees>
    with AutomaticKeepAliveClientMixin {
  List<EventInvite> _inviteList = [];
  Future<QuerySnapshot>? _invite;
  String query = "";
  final _controller = new TextEditingController();
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

    _setAttendesNotValidate();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        // widget.from.startsWith('Received') ? _loadMoreAll() :
        _loadAttendeesNotValidated();
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

  _setAttendesNotValidate() async {
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('attendeeStatus', isEqualTo: widget.from)
        .where('validated', isEqualTo: false)
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

  _loadAttendeesNotValidated() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot inviteSnapShot = await eventInviteRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .where('attendeeStatus', isEqualTo: widget.from)
        .where('validated', isEqualTo: false)
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

  _buildEventTile(EventInvite invite) {
    return EventAttendeeValidateWidget(
      invite: invite,
      palette: widget.palette,
      activityEvent: null,
      event: widget.event,
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
                return _buildEventTile(invite);
              },
              childCount: _inviteList.length,
            ),
          )
        ]),
      ),
    );
  }

  _clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
    setState(() {
      _invite = null;
    });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveScaffold(
        child: ResponsiveScaffold(
      child: Scaffold(
          backgroundColor: widget.palette.darkMutedColor == null
              ? Color(0xFF1a1a1a)
              : widget.palette.darkMutedColor!.color,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: widget.palette.darkMutedColor == null
                ? Color(0xFF1a1a1a)
                : widget.palette.darkMutedColor!.color,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Material(
                color: Colors.grey,
                elevation: 1.0,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                child: TextField(
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                  ),
                  cursorColor: Colors.blue,
                  controller: _controller,
                  onChanged: (input) {
                    setState(() {
                      _invite = DatabaseService.searchAttendeeNumber(
                          widget.event.id, input.toUpperCase());
                    });
                  },

                  // },
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    border: InputBorder.none,
                    hintText: 'Enter Attendee number',
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.0,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
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
                        _invite = DatabaseService.searchAttendeeNumber(
                            widget.event.id, input.toUpperCase());
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
                  child: _invite == null
                      ? _buildEventBuilder()
                      //  Center(
                      //     child: NoContents(
                      //         title: "Searh for users. ",
                      //         subTitle:
                      //             'Enter username, \ndon\'t enter a user\'s nickname.',
                      //         icon: Icons.search))
                      : FutureBuilder<QuerySnapshot>(
                          future: _invite,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              );
                            }
                            if (snapshot.data!.docs.length == 0) {
                              return Center(
                                child: RichText(
                                    text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No invitation found. ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck attendee number  and try again.'),
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
                                            EventInvite? invite =
                                                EventInvite.fromDoc(
                                                    snapshot.data!.docs[index]);
                                            return _buildEventTile(invite);
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

    // ResponsiveScaffold(
    //   child: NestedScrollView(
    //     controller: _hideButtonController,
    //     headerSliverBuilder: (context, innerBoxScrolled) => [
    //       SliverAppBar(
    //         elevation: 0.0,
    //         automaticallyImplyLeading: true,
    //         floating: true,
    //         snap: true,
    //         pinned: true,
    //         iconTheme: new IconThemeData(
    //           color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
    //         ),
    //         backgroundColor: widget.palette.darkMutedColor == null
    //             ? Color(0xFF1a1a1a)
    //             : widget.palette.darkMutedColor!.color,
    //         title: Text(
    //           'Validate Attendees',
    //           style: TextStyle(
    //               color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold),
    //         ),
    //         centerTitle: true,
    //       )
    //     ],
    //     body: MediaQuery.removePadding(
    //       context: context,
    //       removeTop: true,
    //       child: Container(
    //         color: widget.palette.darkMutedColor == null
    //             ? Color(0xFF1a1a1a)
    //             : widget.palette.darkMutedColor!.color,
    //         child: SafeArea(
    //           child: MediaQuery(
    //             data: MediaQuery.of(context).copyWith(
    //                 textScaleFactor:
    //                     MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 _inviteList.length == 0
    //                     ? SizedBox.shrink()
    //                     : Expanded(child: _buildEventBuilder())
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
