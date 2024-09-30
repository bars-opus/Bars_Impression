import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EventDashboardScreen extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final PaletteGenerator? palette;

  EventDashboardScreen({
    required this.event,
    required this.currentUserId,
    required this.palette,
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
  int _expectedPeople = 0;
  int _refundRequestedCount = 0;
  int _refundProcessedCount = 0;
  bool _isLoading = false;
  bool _eventHasEnded = false;
  int _affiliateRequestedCount = 0;
  int _affiliateInviteCount = 0;
  EventPayoutModel? fundPayout;
  bool _fundsDistibuted = false;
  bool _isEventSuccessful = false;
  double totalSales = 0;

  @override
  void initState() {
    super.initState();
    _setUpEventInvites('Accepted');
    _setUpEventInvites('Rejected');
    _setUpEventInvites('');
    _setUpEventInvites('Sent');
    _setUpEventExpectedAttendees(true);
    _setUpEventExpectedAttendees(false);
    _setRefundCount('pending');
    _setRefundCount('processed');
    _validateEvent();
    _setExpectedPeople();
    sumFunction();
    _countDown();
    if (widget.event.fundsDistributed) _getFundsPayout();
    // if (widget.event.isAffiliateEnabled)
    _setUpAffiliateCount();
  }

  void _validateEvent() {
    setState(() {
      EventSuccessValidator validator = EventSuccessValidator(
        expectedAttendees: _expectedAttendees,
        validatedAttendees: _validatedAttendees,
      );
      _isEventSuccessful = validator.validateEvent();
    });
  }

  _setUpAffiliateCount() async {
    await _setAffiliateCount('Invited');
    await _setAffiliateCount('Requested');
  }

  _getFundsPayout() async {
    EventPayoutModel? newFundPayout = await DatabaseService.getUserPayoutWithId(
        widget.currentUserId, widget.event.id);
    if (mounted)
      setState(() {
        fundPayout = newFundPayout;
      });
  }

  void _countDown() async {
    if (EventHasStarted.hasEventEnded(widget.event.clossingDay.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  void sumFunction() async {
    double totalSum = await getTotalSum();
    if (mounted)
      setState(() {
        totalSales = totalSum;
      });
  }

  Future<double> getTotalSum() async {
    // Check if the event ID is empty or just whitespace
    if (widget.event.id.isEmpty || widget.event.id.trim() == '') {
      return 0;
    }
    // Fetch the query snapshot from Firestore
    QuerySnapshot querySnapshot = await newEventTicketOrderRef
        .doc(widget.event.id)
        .collection('ticketOrders')
        .where('refundRequestStatus', isEqualTo: '')
        .get();

    // Map the documents to TicketOrderModel instances
    List<TicketOrderModel> ticketOrders =
        querySnapshot.docs.map((doc) => TicketOrderModel.fromDoc(doc)).toList();

    // Print each ticket order's total if needed for debugging
    ticketOrders.forEach((ticketOrder) {
      print('Ticket order total: ${ticketOrder.total}');
    });

    // Calculate the total sum of all non-empty total fields
    double totalSum = ticketOrders.fold(0, (sum, item) {
      // Check if the total field is not null or zero before adding
      if (item.total > 0) {
        return sum + item.total;
      }
      return sum;
    });

    return totalSum;
  }

  _setExpectedPeople() async {
    DatabaseService.numExpectedPeople(
      widget.event.id,
    ).listen((inviteCount) {
      if (mounted) {
        setState(() {
          _expectedPeople = inviteCount;
        });
      }
    });
  }

  _setUpEventInvites(String answer) async {
    answer.startsWith('Sent')
        ? DatabaseService.numAllEventInvites(widget.event.id, answer)
            .listen((inviteCount) {
            if (mounted) {
              setState(() {
                _invitationsSent = inviteCount;
              });
            }
          })
        : DatabaseService.numAllAnsweredEventInvites(widget.event.id, answer)
            .listen((inviteCount) {
            if (mounted) {
              setState(() {
                answer.startsWith('Accepted')
                    ? _invitationsAccepted = inviteCount
                    : answer.startsWith('Rejected')
                        ? _invitationsRejected = inviteCount
                        : answer.startsWith('')
                            ? _invitationsAnunswered = inviteCount
                            : answer.startsWith('Sent')
                                ? _invitationsSent = inviteCount
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

  _setAffiliateCount(String marketingType) async {
    DatabaseService.numAffiliates(widget.event.id, marketingType)
        .listen((inviteCount) {
      if (mounted) {
        setState(() {
          marketingType == 'Invited'
              ? _affiliateInviteCount = inviteCount
              : _affiliateRequestedCount = inviteCount;
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

  _buttons(
    String buttonText1,
    VoidCallback onPressed1,
    String buttonText2,
    VoidCallback onPressed2,
  ) {
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Color(0xFF1a1a1a));
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      decoration: BoxDecoration(
          color: _paletteDark, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomModelSheetIconActionWidget(
            minor: true,
            dontPop: true,
            buttoncolor: _paletteDark,
            textcolor: Colors.white,
            icon: Icons.dashboard_outlined,
            onPressed: onPressed1,
            text: buttonText1,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey,
          ),
          BottomModelSheetIconActionWidget(
            minor: true,
            dontPop: true,
            buttoncolor: _paletteDark,
            textcolor: Colors.white,
            icon: MdiIcons.thoughtBubbleOutline,
            onPressed: onPressed2,
            text: buttonText2,
          ),
        ],
      ),
    );
  }

  _buttons2(
    String buttonText1,
    VoidCallback onPressed1,
    String buttonText2,
    VoidCallback onPressed2,
    String buttonText3,
    VoidCallback onPressed3,
  ) {
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Color(0xFF1a1a1a));
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      decoration: BoxDecoration(
          color: _paletteDark, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomModelSheetIconActionWidget(
            dontPop: true,
            mini: true,
            buttoncolor: _paletteDark,
            textcolor: Colors.white,
            icon: Icons.send_outlined,
            onPressed: onPressed1,
            text: buttonText1,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey,
          ),
          BottomModelSheetIconActionWidget(
            mini: true,
            dontPop: true,
            buttoncolor: _paletteDark,
            textcolor: Colors.white,
            icon: Icons.share_outlined,
            onPressed: onPressed2,
            text: buttonText2,
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey,
          ),
          BottomModelSheetIconActionWidget(
            dontPop: true,
            mini: true,
            buttoncolor: _paletteDark,
            textcolor: Colors.white,
            icon: FontAwesomeIcons.idBadge,
            onPressed: onPressed3,
            text: buttonText3,
          ),
        ],
      ),
    );
  }

  _tableText(int count, String title, Widget page) {
    return GestureDetector(
      onTap: () => _navigateToPage(context, page),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
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

  _invitationTable() {
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Colors.blue);
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
              thickness: .3,
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
                    _invitationsSent,
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
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Colors.blue);

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
                _tableText(
                    _refundRequestedCount,
                    '\nRefund\nrequested',
                    EventRefunds(
                      eventId: widget.event.id,
                      status: 'pending',
                    )),
                _tableText(
                    _refundProcessedCount,
                    '\nRefund\nprocessed',
                    EventRefunds(
                      eventId: widget.event.id,
                      status: 'processed',
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

  _affiliateTable() {
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Colors.blue);
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
            'Affiliate table',
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
                  _affiliateRequestedCount,
                  '\nAffiliate\nrequests',
                  UserAffilate(
                    currentUserId: widget.currentUserId,
                    eventId: widget.event.id,
                    marketingType: 'Requested',
                    isUser: false,
                    fromActivity: false,
                  ),
                ),
                _tableText(
                  _affiliateInviteCount,
                  '\nAffiliate\ninvites',
                  UserAffilate(
                    currentUserId: widget.currentUserId,
                    eventId: widget.event.id,
                    marketingType: 'Invited',
                    isUser: false,
                    fromActivity: false,
                  ),
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

  void _showBottomInvitationMessage() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SendInviteMessage(
            currentUserId: widget.currentUserId,
            event: widget.event,
            palette: widget.palette,
          );
        });
  }

  _salesSummary() {
    var _comission = totalSales * 0.10;
    var _expetedAmount =
        totalSales - widget.event.totalAffiliateAmount - _comission;
    return Container(
      width: ResponsiveHelper.responsiveHeight(context, 600),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              if (fundPayout != null)
                Icon(
                  Icons.check_circle_outline_outlined,
                  size: 50,
                  color: Colors.green,
                ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Total sales',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              const SizedBox(height: 30),
              PayoutDataWidget(
                label: 'No. of tickets purchased',
                value:
                    NumberFormat.compact().format(_expectedPeople).toString(),
              ),
              Divider(
                thickness: .3,
              ),
              PayoutDataWidget(
                label: 'Total ticket sales',
                value: totalSales.toString(),
              ),
              Divider(
                thickness: .3,
              ),
              PayoutDataWidget(
                label: 'Affiliate amount',
                value: widget.event.totalAffiliateAmount.toString(),
              ),
              Divider(
                thickness: .3,
              ),
              PayoutDataWidget(
                label: 'Commission',
                value: _comission.toString(),
              ),
              Divider(
                thickness: .3,
              ),
              PayoutDataWidget(
                label: fundPayout != null
                    ? 'Payout\namount'
                    : 'Expected\npayout amount',
                value: _expetedAmount.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _currentSaleReport() {
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");
    return Column(
      children: [
        _isLoading
            ? Center(
                child: CircularProgress(
                  isMini: true,
                  indicatorColor: Colors.blue,
                ),
              )
            : GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        surfaceTintColor: Colors.transparent,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        title: TicketPurchasingIcon(
                          title: '',
                        ),
                        content: _salesSummary(),
                      );
                    },
                  );
                },
                child: RichText(
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            '${currencyPartition.isEmpty ? '' : currencyPartition.length > 1 ? currencyPartition[1] : ''}\n',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: totalSales.toString(),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 50.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '\nTotal sales',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }

  void _showBottomSheetRefund(bool isRefund, bool fromNoAffiliate) {
    var _provider = Provider.of<UserData>(context, listen: false);
    // bool _showFunds = !widget.event.isFree &&
    //     !widget.event.isCashPayment &&
    //     widget.event.ticketSite.isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: isRefund
                  ? RefundDoc(
                      refundOnPressed: () {},
                      isRefunding: false,
                    )
                  : AffiliateDoc(
                      isAffiliated: _eventHasEnded
                          ? false
                          : fromNoAffiliate
                              ? false
                              : true,
                      isOganiser: true,
                      affiliateOnPressed: () {
                        Navigator.pop(context);
                        _provider.setAffiliateComission(5);
                        _showBottomSheetCreateAffiliate();
                      },
                    ));
        });
      },
    );
  }

  void _showBottomSheetEvidence() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: EventEvidenceDoc(
                refundOnPressed: () {},
                // isRefunding: false,
              ));
        });
      },
    );
  }

  void _showBottomSheetPricing() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700), padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: PricingDoc(
                  // refundOnPressed: () {},
                  // isRefunding: false,
                  ));
        });
      },
    );
  }

  void _showBottomSheetFreeAffiliateDoc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 450),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\nAffiliates',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text:
                              '\n\nAffiliate marketing is a type of performance-based marketing where a business rewards one or more affiliates for each visitor or customer brought about by the affiliate\'s own marketing efforts.\n\nThis is only available for events that offer paid tickets through Bars Impression(not support for payment through other website or cash-payment) and not free events.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showBottomSheetRefund(false, true);
                    },
                    child: Center(
                      child: Text(
                        '\nLearn more.',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14)),
                      ),
                    ),
                  )
                ],
              ));
        });
      },
    );
  }

  void _showBottomSheetInvites() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: inviteDoc(
                affiliateOnPressed: () {
                  Navigator.pop(context);
                  _showBottomInvitationMessage();
                },
                showInviteButton: _eventHasEnded ? false : true,
              ));
        });
      },
    );
  }

  void _showBottomSheetCreateAffiliate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(30)),
              child: CreateAffiliate(
                event: widget.event,
                currentUserId: widget.currentUserId,
                paletteColor: widget.palette!,
              ));
        });
      },
    );
  }

  // Method to create event
  _submitRequest() async {
    if (!_isLoading) {
      if (mounted)
        setState(() {
          _isLoading = true;
        });

      try {
        bool existingOrder = await DatabaseService.isPayoutAvailable(
          userId: widget.event.authorId,
          eventId: widget.event.id,
        );
        if (!existingOrder) {
          await _createPayoutRequst();
          _showBottomSheetPayoutSuccessful();
          _fundsDistibuted = true;
        } else {
          _showBottomSheetErrorMessage('Payout already requested');
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } catch (e) {
        if (mounted)
          setState(() {
            _isLoading = false;
          });
        _showBottomSheetErrorMessage(
            'Please check your internet connection and try again.');
      }
    }
  }

  Future<EventPayoutModel> _createPayoutRequst() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    String commonId = Uuid().v4();
    EventPayoutModel payout = EventPayoutModel(
      id: commonId,
      eventId: widget.event.id,
      status: 'pending',
      timestamp: Timestamp.fromDate(DateTime.now()),
      eventAuthorId: widget.event.authorId,
      idempotencyKey: '',
      subaccountId: widget.event.subaccountId,
      transferRecepientId: widget.event.transferRecepientId,
      eventTitle: widget.event.title,
      clossingDay: widget.event.clossingDay,
      total: 0,
      totalAffiliateAmount: widget.event.totalAffiliateAmount,
    );

    await DatabaseService.requestPayout(widget.event, payout, _provider.user!);
    return payout;
  }

  void _showBottomSheetPayoutSuccessful() {
    var _comission = totalSales * 0.10;
    var _expetedAmount =
        totalSales - widget.event.totalAffiliateAmount - _comission;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return PayoutSuccessWidget(
            amount: _expetedAmount.toInt(),
          );
        });
      },
    );
  }

  void _showBottomSheetErrorMessage(String error) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: "Request failed",
          subTitle: error,
        );
      },
    );
  }

  void _showBottomSheetConfirmRefund() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: 'Request payout',
          onPressed: () async {
            Navigator.pop(context);
            _submitRequest();
          },
          title: 'Are you sure you want to request for a payout?',
          subTitle:
              'Please be informed that payout request can only be made once.',
        );
      },
    );
  }

  void _showBottomSheetRequestPayouts(bool isRequesting) {
    bool _noResources = !widget.event.isFree &&
        !widget.event.isCashPayment &&
        widget.event.ticketSite.isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(
                context, isRequesting ? 700 : 400),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  if (isRequesting)
                    Align(
                      alignment: Alignment.centerRight,
                      child: MiniCircularProgressButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBottomSheetConfirmRefund();
                        },
                        text: "Continue",
                        color: Colors.blue,
                      ),
                    ),
                  PayoutDoc(
                      isCashPayment: widget.event.isCashPayment,
                      isRequesting: isRequesting,
                      isFreeEvent:
                          !_noResources ? widget.event.isFree : _noResources,
                      eventTitle: widget.event.title,
                      eventClossinDay: widget.event.clossingDay),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomSheetNoSalesPayouts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 400),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: widget.event.isFree ||
                      widget.event.isCashPayment ||
                      widget.event.ticketSite.isNotEmpty
                  ? PayoutDoc(
                      isRequesting: false,
                      isFreeEvent: widget.event.ticketSite.isNotEmpty
                          ? true
                          : widget.event.isFree,
                      eventTitle: widget.event.title,
                      eventClossinDay: widget.event.clossingDay,
                      isCashPayment: widget.event.isCashPayment,
                    )
                  : ListView(
                      children: [
                        TicketPurchasingIcon(
                          title: '',
                        ),
                        // const SizedBox(height: 40),

                        totalSales == 0
                            ? RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '\nNo Sales',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                    TextSpan(
                                      text:
                                          '\n\nUnfortunately, no ticket sales have been recorded for this event. As a result, there are no ticket sales payouts available at this time. The total sales amount remains at 0.00.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              )
                            : !_isEventSuccessful
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      _showBottomSheetEvidence();
                                    },
                                    child: RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '\nNo enough evidence',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                          TextSpan(
                                            text:
                                                '\n\nIt seems that this event has not met the required attendance threshold. To ensure the integrity of ticket sales, a minimum of 10% of the expected attendees must have validated their tickets at the event.',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          TextSpan(
                                            text: '\n\nLearn more.',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: ResponsiveHelper
                                                  .responsiveFontSize(
                                                      context, 12.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                        const SizedBox(height: 60),
                      ],
                    ),
            ),
          );
        });
      },
    );
  }

  void _showBottomSheetValidatorDoc() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 700),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: ValidatorDoc(),
          );
        });
      },
    );
  }

  _fundsAlreadyPaidOut() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5.0),
                  topLeft: Radius.circular(5.0),
                ),
                color: Colors.green[600],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(10, 10),
                    blurRadius: 10.0,
                    spreadRadius: 4.0,
                  )
                ]),
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: ResponsiveHelper.responsiveFontSize(context, 40.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Funds distributed  ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: fundPayout == null
                ? 0.0
                : ResponsiveHelper.responsiveHeight(context, 450),
            width: double.infinity,
            curve: Curves.linearToEaseOut,
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(10, 10),
                blurRadius: 10.0,
                spreadRadius: 4.0,
              )
            ]),
            child: fundPayout != null
                ? SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        PayoutWidget(
                          payout: fundPayout!,
                          currentUserId: widget.currentUserId,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    surfaceTintColor: Colors.transparent,
                                    backgroundColor:
                                        Theme.of(context).primaryColorLight,
                                    title: TicketPurchasingIcon(
                                      title: '',
                                    ),
                                    content: _salesSummary(),
                                  );
                                },
                              );
                            },
                            child: ShakeTransition(
                              axis: Axis.vertical,
                              curve: Curves.linearToEaseOut,
                              duration: const Duration(seconds: 3),
                              child: Text(
                                'more.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showBottomSheetAnalysisConsideration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              Container(
                height: ResponsiveHelper.responsiveHeight(context, 300),
                // padding: const EdgeInsets.only(top: 50.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: AnimatedCircle(
                      // animateShape: true,
                      size: 50,
                      stroke: 3,
                      animateSize: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'To derive at this analysis, the following event information was considered. Event title, event theme, event date, event location, event dresscode ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]),
              ),
            ],
          );
        });
      },
    );
  }

  void _showBottomSheetMarketingAnalysis() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 700),
            // padding: const EdgeInsets.only(top: 50.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.all(20.0),
            child: ListView(children: [
              TicketPurchasingIcon(
                title: '',
              ),
              const SizedBox(height: 10),
              Center(
                child: AnimatedCircle(
                  // animateShape: true,
                  size: 50,
                  stroke: 3,
                  animateSize: true,
                ),
              ),
              const SizedBox(height: 40),
              MarkdownBody(
                data: widget.event.aiMarketingAdvice,
                styleSheet: MarkdownStyleSheet(
                  h1: Theme.of(context).textTheme.titleLarge,
                  h2: Theme.of(context).textTheme.titleMedium,
                  p: Theme.of(context).textTheme.bodyMedium,
                  listBullet: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () {
                  _showBottomSheetAnalysisConsideration();
                },
                child: Text(
                  'This information is an analysis I made of the event, based on the event details provided by the event organizer. This analysis was not directly written by the organizer, but is intended to help potential attendees understand the concept of the event more.',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.blue,
                  ),
                ),
              ),
            ]),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Color(0xFF1a1a1a));
    bool isGhanaian = _provider.userLocationPreference!.country == 'Ghana' ||
        _provider.userLocationPreference!.currency == 'Ghana Cedi | GHS';
    bool _showFunds = !widget.event.isFree &&
        !widget.event.isCashPayment &&
        widget.event.ticketSite.isEmpty;

    // bool _noResources = !widget.event.isFree ||
    //     !widget.event.isCashPayment && widget.event.ticketSite.isNotEmpty;

    return Scaffold(
      backgroundColor: _paletteDark,
      appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          surfaceTintColor: Colors.transparent,
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
              if (widget.event.fundsDistributed) _fundsAlreadyPaidOut(),
              _container(
                Column(
                  children: [
                    if (!widget.event.isPrivate)
                      GestureDetector(
                        onTap: () {
                          _showBottomSheetMarketingAnalysis();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AnimatedCircle(
                              animateShape: true,
                              size: 25,
                              stroke: 3,
                            ),
                          ),
                        ),
                      ),
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
                          title: '\nValidated\nTicketd',
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
                          title: '\nunValidated\nTickets',
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
                      height: 50,
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
                    if (_showFunds)
                      if (_expectedPeople > 1) _currentSaleReport(),
                    _buttons(
                        _showFunds ? 'Request Payout' : 'Payout',
                        widget.event.fundsDistributed || _fundsDistibuted
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      surfaceTintColor: Colors.transparent,
                                      backgroundColor:
                                          Theme.of(context).primaryColorLight,
                                      title: TicketPurchasingIcon(
                                        title: '',
                                      ),
                                      content: _salesSummary(),
                                    );
                                  },
                                );
                              }
                            :
                            // _noResources
                            //     ? () {
                            //         _showBottomSheetRequestPayouts(false);
                            //       }
                            //     :
                            _showFunds &&
                                    _isEventSuccessful
                                    // _expectedPeople > 1
                                    &&
                                    _eventHasEnded
                                ? () {
                                    _showBottomSheetRequestPayouts(true);
                                  }
                                : !_eventHasEnded
                                    ? () {
                                        _showBottomSheetRequestPayouts(false);
                                      }
                                    : totalSales == 0
                                        ? () {
                                            _showBottomSheetNoSalesPayouts();
                                          }
                                        : !_isEventSuccessful
                                            ? () {
                                                _showBottomSheetNoSalesPayouts();
                                              }
                                            : () {
                                                _showBottomSheetRequestPayouts(
                                                    false);
                                              },
                        'Create affiliate', () {
                      widget.event.isFree ||
                              widget.event.isCashPayment ||
                              widget.event.ticketSite.isNotEmpty
                          ? _showBottomSheetFreeAffiliateDoc()
                          : _eventHasEnded
                              ? _showBottomSheetRefund(false, false)
                              : _showBottomSheetRefund(false, false);
                    }),
                    const SizedBox(
                      height: 5,
                    ),
                    _buttons2(
                        'Send',
                        () {
                          _navigateToPage(
                              context,
                              SendToChats(
                                currentUserId: widget.currentUserId,
                                sendContentType: 'Event',
                                sendContentId: widget.event.id,
                                sendImageUrl: widget.event.imageUrl,
                                sendTitle: widget.event.title,
                              ));
                        },
                        'Share',
                        () {
                          Share.share(widget.event.dynamicLink);
                        },
                        'Invite',
                        () {
                          _showBottomSheetInvites();
                        }),
                    const SizedBox(
                      height: 5,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                              'Tickets\ngenerated\n',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "   ${NumberFormat.compact().format(_expectedPeople)} people attending",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              height: 1),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _invitationTable(),
                    if (!widget.event.isFree &&
                        !widget.event.isCashPayment &&
                        widget.event.ticketSite.isEmpty)
                      _refundTable(),
                    if (!widget.event.isFree &&
                        !widget.event.isCashPayment &&
                        widget.event.ticketSite.isEmpty)
                      _affiliateTable(),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 50),
                      child: Divider(
                        color: Colors.grey,
                        thickness: .3,
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
                    ),
                    if (widget.event.improvemenSuggestion.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              5.0,
                            ),
                            color: Colors.blue,
                          ),
                          child: ListTile(
                            leading: Icon(
                              Icons.info_outline,
                              color: Colors.white,
                            ),
                            title: Text(
                              widget.event.improvemenSuggestion,
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12.0),
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
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
              const SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: () {},
                child: Center(
                  child: Text(
                    'Docs.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _showBottomSheetValidatorDoc();
                },
                child: Center(
                  child: Text(
                    '\nTicket validation.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              if (isGhanaian)
                GestureDetector(
                  onTap: () {
                    _showBottomSheetRefund(true, false);
                  },
                  child: Center(
                    child: Text(
                      '\nTicket refund.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              if (isGhanaian)
                GestureDetector(
                  onTap: () {
                    _showBottomSheetEvidence();
                  },
                  child: Center(
                    child: Text(
                      '\nEvent evidence.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              if (isGhanaian)
                GestureDetector(
                  onTap: () {
                    _showBottomSheetPricing();
                  },
                  child: Center(
                    child: Text(
                      '\nPricing.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              const SizedBox(
                height: 50,
              ),
              Divider(
                color: Colors.white,
                thickness: .3,
              ),
              const SizedBox(
                height: 25,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _navigateToPage(
                        context,
                        CompainAnIssue(
                          parentContentId: widget.event.id,
                          authorId: widget.currentUserId,
                          complainContentId: widget.event.id,
                          complainType: 'Event',
                          parentContentAuthorId: widget.event.authorId,
                        ));
                  },
                  child: Text(
                    '\nComplain an issue.',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
