import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class EventDashboardScreen extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final PaletteGenerator? palette;
  // final int askCount;

  EventDashboardScreen({
    required this.event,
    required this.currentUserId,
    required this.palette,
    // required this.askCount,
  });

  @override
  _EventDashboardScreenState createState() => _EventDashboardScreenState();
}

class _EventDashboardScreenState extends State<EventDashboardScreen> {
  int _invitationsSent = 0;
  int _invitationsAccepted = 0;
  int _invitationsAnunswered = 0;
  int _invitationsRejected = 0;
  int _expectedAttendees = 0;
  int _validatedAttendees = 0;

  int _refundRequestedCount = 0;

  int _refundProcessedCount = 0;

  final _messageController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  double totalSales = 0;

  @override
  void initState() {
    super.initState();
    _setUpEventInvites('Accepted');
    _setUpEventInvites('Rejected');
    _setUpEventInvites('');
    _setUpEventExpectedAttendees(true);
    _setUpEventExpectedAttendees(false);
    _setRefundCount('pending');
    _setRefundCount('processed');

    someFunction();
    _messageController.addListener(_onAskTextChanged);
  }

  void someFunction() async {
    double totalSum = await getTotalSum();
    setState(() {
      totalSales = totalSum;
    });
  }

  Future<double> getTotalSum() async {
    if (widget.event.id.isEmpty || widget.event.id.trim() == '') {
      return 0;
    }
    QuerySnapshot querySnapshot = await newEventTicketOrderRef
        .doc(widget.event.id)
        .collection('eventInvite')
        .get();

    List<TicketOrderModel> ticketOrders =
        querySnapshot.docs.map((doc) => TicketOrderModel.fromDoc(doc)).toList();

    ticketOrders.forEach((ticketOrder) {
      print('Ticket order total: ${ticketOrder.total}');
    });

    double totalSum = ticketOrders.fold(0, (sum, item) => sum + item.total);

    return totalSum;
  }

  void _onAskTextChanged() {
    if (_messageController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  _setUpEventInvites(String answer) async {
    DatabaseService.numAllEventInvites(widget.event.id, answer)
        .listen((inviteCount) {
      if (mounted) {
        setState(() {
          answer.startsWith('Accepted')
              ? _invitationsAccepted = inviteCount
              : answer.startsWith('Rejected')
                  ? _invitationsRejected = inviteCount
                  : answer.startsWith('')
                      ? _invitationsAnunswered = inviteCount
                      : _invitationsSent = inviteCount;
        });
      }
    });
  }

  _setRefundCount(String status) async {
    DatabaseService.numRefunds(widget.event.id, status).listen((inviteCount) {
      if (mounted) {
        setState(() {
          status == 'pending'
              ? _refundRequestedCount = inviteCount
              : _refundProcessedCount = inviteCount;
        });
      }
    });
  }

  _setUpEventExpectedAttendees(bool validated) async {
    DatabaseService.numExpectedAttendees(widget.event.id, validated)
        .listen((inviteCount) {
      if (mounted) {
        setState(() {
          validated
              ? _validatedAttendees = inviteCount
              : _expectedAttendees = inviteCount;
        });
      }
    });
  }

  _container(Widget child) {
    final width = MediaQuery.of(context).size.width;

    return Container(
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5.0),
              topLeft: Radius.circular(5.0),
              bottomLeft: Radius.circular(5.0),
              bottomRight: Radius.circular(5.0),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(10, 10),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              )
            ]),
        child: child);
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _inviteButton(double width, String buttonText, VoidCallback onPressed) {
    Color _paletteDark = widget.palette == null
        ? Colors.blue
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    return Container(
      width: ResponsiveHelper.responsiveWidth(context, width),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _paletteDark,
          elevation: 0.0,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveHeight(context, 8.0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  _tableText(int count, String title, Widget page) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, page),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: TextSpan(
            children: [
              TextSpan(
                text: NumberFormat.compact().format(count),
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                  color: count < 1 ? Colors.grey : Colors.blue,
                ),
              ),
              TextSpan(
                text: title,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  color: count < 1 ? Colors.grey : Colors.blue,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _refundTableText(
    int count,
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      child: RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(
          children: [
            TextSpan(
              text: NumberFormat.compact().format(count),
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                color: Colors.grey,
              ),
            ),
            TextSpan(
              text: title,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                color: Colors.grey,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  _invitationTable() {
    Color _paletteDark = widget.palette == null
        ? Colors.blue
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    var _tableTitleStyle = TextStyle(
        color: _paletteDark,
        fontWeight: FontWeight.bold,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        height: 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 30),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          Text(
            'Invitation table',
            style: _tableTitleStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Table(
            border: TableBorder.all(
              color: Colors.grey,
            ),
            children: [
              TableRow(children: [
                _tableText(
                    _invitationsAccepted +
                        _invitationsAnunswered +
                        _invitationsRejected,
                    '\nInvitations\nsent',
                    EventAttendeesInvitedScreeen(
                      letShowAppBar: true,
                      event: widget.event,
                      palette: widget.palette!,
                      answer: 'All',
                    )),
                _tableText(
                    _invitationsAnunswered,
                    '\nInvitations\nunanswered\n(pending)',
                    EventAttendeesInvitedScreeen(
                      letShowAppBar: true,
                      event: widget.event,
                      palette: widget.palette!,
                      answer: '',
                    )),
              ]),
              TableRow(children: [
                _tableText(
                    _invitationsAccepted,
                    '\nInvitations\naccepted',
                    EventAttendeesInvitedScreeen(
                      letShowAppBar: true,
                      palette: widget.palette!,
                      event: widget.event,
                      answer: 'Accepted',
                    )),
                _tableText(
                    _invitationsRejected,
                    '\nInvitations\nrejected',
                    EventAttendeesInvitedScreeen(
                      letShowAppBar: true,
                      palette: widget.palette!,
                      event: widget.event,
                      answer: 'Rejected',
                    )),
              ]),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  _refundTable() {
    Color _paletteDark = widget.palette == null
        ? Colors.blue
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    var _tableTitleStyle = TextStyle(
        color: _paletteDark,
        fontWeight: FontWeight.bold,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        height: 1);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Refund table',
            style: _tableTitleStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Table(
            border: TableBorder.all(
              color: Colors.grey,
            ),
            children: [
              TableRow(children: [
                _refundTableText(
                  _refundRequestedCount,
                  '\nRefund\nrequested',
                ),
                _refundTableText(
                  _refundProcessedCount,
                  '\nRefund\nprocessed',
                ),
              ]),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  _ticketFiled(
    String labelText,
    String hintText,
    TextEditingController controler,
    final Function onValidateText,
  ) {
    var style = Theme.of(context).textTheme.titleSmall;
    var labelStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 18.0),
        color: Colors.blue);
    var hintStyle = TextStyle(
        fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
        color: Colors.grey);
    return TextFormField(
      controller: controler,
      keyboardType: TextInputType.multiline,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
      style: style,
      maxLines: null,
      autofocus: true,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: labelStyle,
        hintStyle: hintStyle,
      ),
      validator: (string) => onValidateText(string),
    );
  }

  void _showBottomInvitationMessage() {
    Color _paletteDark = widget.palette == null
        ? Color(0xFF1a1a1a)
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return ValueListenableBuilder(
                valueListenable: _isTypingNotifier,
                builder: (BuildContext context, bool isTyping, Widget? child) {
                  return Container(
                    height: _size.height.toDouble() / 1.3,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: BorderRadius.circular(30)),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Padding(
                        padding: EdgeInsets.all(10),
                        child: ListView(children: [
                          _messageController.text.length > 0
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: MiniCircularProgressButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _navigateToPage(
                                          context,
                                          InviteSearchScreen(
                                            event: widget.event,
                                            currentUserId: widget.currentUserId,
                                            inviteMessage:
                                                _messageController.text.trim(),
                                            paletteColor: _paletteDark,
                                          ));
                                    },
                                    text: "Continue",
                                    color: Colors.blue,
                                  ),
                                )
                              : ListTile(
                                  leading: _messageController.text.length > 0
                                      ? SizedBox.shrink()
                                      : IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
                                        ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      _navigateToPage(
                                          context,
                                          InviteSearchScreen(
                                            event: widget.event,
                                            paletteColor: _paletteDark,
                                            currentUserId: widget.currentUserId,
                                            inviteMessage:
                                                _messageController.text.trim(),
                                          ));
                                    },
                                    child: Text(
                                      'Skip',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 40),
                          _ticketFiled(
                            'Invitation message',
                            'A special invitation message to your guests',
                            _messageController,
                            () {},
                          ),
                          const SizedBox(height: 20),
                        ]),
                      ),
                    ),
                  );
                });
          });
        });
  }

  _currentSaleReport() {
    return Column(
      children: [
        RichText(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'USD\n',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              TextSpan(
                  text: totalSales.toString(),
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 50.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              TextSpan(
                  text: '\nTotal sales',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.black,
                  )),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Color _paletteDark = widget.palette == null
        ? Color(0xFF1a1a1a)
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    return Scaffold(
      backgroundColor: _paletteDark,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: _paletteDark),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ShakeTransition(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: EditProfileInfo(
                  color: Colors.white,
                  iconColor: _paletteDark,
                  editTitle: 'Event \nDashboard',
                  info:
                      'The event dashboard offers various tools to assist you in managing your event and attendees effectively.',
                  icon: Icons.event_available,
                ),
              ),
              _container(
                Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    Text(
                      'CHECK-IN\nVALIDATOR',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 16.0),
                        color: _paletteDark,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UserStatistics(
                          countColor: Colors.black,
                          titleColor: Colors.black,
                          count: NumberFormat.compact()
                              .format(_validatedAttendees),
                          onPressed: () {
                            _navigateToPage(
                              context,
                              EventExpectedAttendeesScreen(
                                event: widget.event,
                                letShowAppBar: true,
                                palette: widget.palette!,
                                peopleAttending: false,
                                validated: true,
                              ),
                            );
                          },
                          title: '\nValidated\nAttendees',
                          subTitle: '',
                        ),
                        Container(height: 100, width: 1, color: _paletteDark),
                        UserStatistics(
                          countColor: Colors.black,
                          titleColor: Colors.black,
                          count:
                              NumberFormat.compact().format(_expectedAttendees),
                          onPressed: () {
                            _navigateToPage(
                              context,
                              EventExpectedAttendeesScreen(
                                event: widget.event,
                                letShowAppBar: true,
                                palette: widget.palette!,
                                peopleAttending: false,
                                validated: false,
                              ),
                            );
                          },
                          title: '\nExpected\nAttendees',
                          subTitle: '',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    IconButton(
                      icon: Icon(Icons.qr_code_scanner),
                      iconSize:
                          ResponsiveHelper.responsiveHeight(context, 50.0),
                      color: Colors.blue,
                      onPressed: () {
                        _navigateToPage(
                            context,
                            TicketScannerValidatorScreen(
                              event: widget.event,
                              palette: widget.palette!,
                              from: widget.event.isPrivate ? 'Accepted' : '',
                            ));
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _navigateToPage(
                            context,
                            TicketScannerValidatorScreen(
                              event: widget.event,
                              palette: widget.palette!,
                              from: widget.event.isPrivate ? 'Accepted' : '',
                            ));
                      },
                      child: Text(
                        'Tap to\nscan tickets',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        textScaleFactor: MediaQuery.of(context)
                            .textScaleFactor
                            .clamp(0.5, 1.5),
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    'The validator feature assists in verifying attendees at the entrance of the event. Each attendee is assigned a unique Check-in number (attendee\'s number). By scanning the barcode on each attendee\'s invitation, you can validate their attendance. Once a ticket has been validated, the color of the barcode on the ticket changes, and a blue verified badge is placed at the top right corner of the ticket. This ensures precise tracking of the attendees allowed to enter your event.',
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                  color: Colors.black,
                                )),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _container(
                Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    _currentSaleReport(),
                    const SizedBox(
                      height: 50,
                    ),
                    _inviteButton(300, 'Send Invite', () {
                      _showBottomInvitationMessage();
                    }),
                    const SizedBox(height: 5),
                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _inviteButton(150, 'Send to chat', () {
                              _navigateToPage(
                                  context,
                                  SendToChats(
                                    currentUserId: widget.currentUserId,
                                    sendContentType: 'Event',
                                    sendContentId: widget.event.id,
                                    sendImageUrl: widget.event.imageUrl,
                                    sendTitle: widget.event.title,
                                  ));
                            }),
                            const SizedBox(width: 2),
                            _inviteButton(150, 'Share event', () async {
                              Share.share(widget.event.dynamicLink);
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: GestureDetector(
                        onTap: () {
                          _navigateToPage(
                            context,
                            EventExpectedAttendeesScreen(
                              event: widget.event,
                              letShowAppBar: true,
                              palette: widget.palette!,
                              peopleAttending: true,
                              validated: false,
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                NumberFormat.compact().format(
                                    _expectedAttendees + _validatedAttendees),
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 40.0),
                                    height: 1),
                              ),
                            ),
                            Text(
                              'People\nattending',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _invitationTable(),
                    _refundTable(),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        widget.event.type,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.black,
                          fontFamily: 'Bessita',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Text(
                        widget.event.category,
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Center(
                  child: IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 30.0,
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
