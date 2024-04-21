import 'package:bars/utilities/exports.dart';

class EventExpectedAttendeesScreen extends StatefulWidget {
  static final id = 'EventExpectedAttendeesScreen';
  final Event event;
  final bool validated;
  final bool peopleAttending;
  final bool letShowAppBar;

  final PaletteGenerator palette;
  bool fromDashboard;

  EventExpectedAttendeesScreen({
    required this.event,
    required this.palette,
    required this.letShowAppBar,
    required this.validated,
    required this.peopleAttending,
    this.fromDashboard = true,
  });

  @override
  _EventExpectedAttendeesScreenState createState() =>
      _EventExpectedAttendeesScreenState();
}

class _EventExpectedAttendeesScreenState
    extends State<EventExpectedAttendeesScreen>
    with AutomaticKeepAliveClientMixin {
  List<TicketOrderModel> _inviteList = [];
  final _inviteSnapshot = <DocumentSnapshot>[];
  // int limit = 10;
  bool _hasNext = true;
  bool _isLoading = true;

  bool _isFectchingUser = false;
  bool _showInfo = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    if (widget.event.id.isNotEmpty)
      widget.peopleAttending
          ? _setUpPeopleAttending()
          : _setUpPeopleValidated();
    __setShowInfo();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        // widget.answer.startsWith('All') ? _loadMoreAll() : _loadMoreInvite();
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

  _setUpPeopleValidated() async {
    try {
      QuerySnapshot inviteSnapShot = await newEventTicketOrderRef
          .doc(widget.event.id)
          .collection('ticketOrders')
          .where('refundRequestStatus', isEqualTo: '')
          .get();

      // Filter users based on validation status within the 'tickets' array
      var filteredUsers = inviteSnapShot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> tickets = data['tickets'] ?? [];
        bool hasValidatedTicket =
            tickets.any((ticket) => ticket['validated'] == widget.validated);
        return hasValidatedTicket ? TicketOrderModel.fromDoc(doc) : null;
      }).where((user) =>
          user != null); // Filter out nulls if no validated ticket found

      // Cast away the nulls to get a non-nullable list
      List<TicketOrderModel> users = List<TicketOrderModel>.from(filteredUsers);

      

      _inviteSnapshot.addAll(inviteSnapShot.docs);
      if (mounted) {
        print(users.length.toString());
        setState(() {
          _hasNext = false;
          _inviteList = users;
          _isLoading = false;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _isLoading = false;
      });
    }
    return _inviteList;
  }
  // _setUpPeopleValidated() async {
  //   QuerySnapshot inviteSnapShot = await newEventTicketOrderRef
  //       .doc(widget.event.id)
  //       .collection('eventInvite')
  //       .where('validated', isEqualTo: widget.validated)
  //       // .limit(limit)
  //       .get();
  //   List<TicketOrderModel> users = inviteSnapShot.docs
  //       .map((doc) => TicketOrderModel.fromDoc(doc))
  //       .toList();
  //   _inviteSnapshot.addAll((inviteSnapShot.docs));
  //   if (mounted) {
  //     print(users.length.toString());
  //     setState(() {
  //       _hasNext = false;
  //       _inviteList = users;
  //       _isLoading = false;
  //     });
  //   }
  //   return users;
  // }

  _setUpPeopleAttending() async {
    QuerySnapshot inviteSnapShot = await newEventTicketOrderRef
        .doc(widget.event.id)
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
        // .limit(limit)
        .get();
    List<TicketOrderModel> users = inviteSnapShot.docs
        .map((doc) => TicketOrderModel.fromDoc(doc))
        .toList();
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _buildUserTile(TicketOrderModel attendee) {
    var _provider = Provider.of<UserData>(context, listen: false);

    String ordernumberSubstring = Utils.safeSubstring(attendee.orderId, 0, 4);




    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: FutureBuilder(
            future: DatabaseService.getUserWithId(attendee.userOrderId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              AccountHolderAuthor user = snapshot.data;
              return ListTile(
                onTap: () {
                  _navigateToPage(
                      context,
                      ProfileScreen(
                        currentUserId: _provider.currentUserId!,
                        userId: attendee.userOrderId,
                        user: null,
                      ));
                },
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
                            color: Colors.grey,
                          )),
                      if (widget.fromDashboard)
                        TextSpan(
                            text: "\nOrder number:    ",
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: Colors.grey,
                            )),
                      if (widget.fromDashboard)
                        TextSpan(
                            text: ordernumberSubstring,
                            // "${attendee.orderId.substring(0, 4)}",
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: Colors.blue,
                            )),
                      // if (widget.fromDashboard)
                      //   TextSpan(
                      //       text: "\nEntracne id:         ",
                      //       style: TextStyle(
                      //         fontSize: ResponsiveHelper.responsiveFontSize(
                      //             context, 12.0),
                      //         color: Colors.grey,
                      //       )),
                      // if (widget.fromDashboard)
                      //   if (attendee.orderId.isNotEmpty)
                      //     TextSpan(
                      //         text: attendee.orderId.
                      //         // "${attendee.orderId.substring(0, 4)}",
                      //         style: TextStyle(
                      //           fontSize: ResponsiveHelper.responsiveFontSize(
                      //               context, 12.0),
                      //           color: Colors.blue,
                      //         )),
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
                TicketOrderModel attendee = _inviteList[index];
                return _buildUserTile(attendee);
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
                    'Attendees ',
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
