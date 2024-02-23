import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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

  int _expectedPeople = 0;

  int _refundRequestedCount = 0;

  int _refundProcessedCount = 0;
  bool _isLoading = false;

  // final _messageController = TextEditingController();
  // ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
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
    _setExpectedPeople();

    someFunction();
    // _messageController.addListener(_onAskTextChanged);
  }

  void someFunction() async {
    double totalSum = await getTotalSum();
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
        .collection('eventInvite')
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
      if (item.total != null && item.total > 0) {
        return sum + item.total;
      }
      return sum;
    });

    return totalSum;
  }

  // void _onAskTextChanged() {
  //   if (_messageController.text.isNotEmpty) {
  //     _isTypingNotifier.value = true;
  //   } else {
  //     _isTypingNotifier.value = false;
  //   }
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _messageController.dispose();
  // }

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
          return SendInviteMessage(
            currentUserId: widget.currentUserId,
            event: widget.event,
          );
          // return StatefulBuilder(
          //     builder: (BuildContext context, StateSetter setState) {
          //   return
          // });
        });
  }

  _currentSaleReport() {
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");
    return Column(
      children: [
        if (!widget.event.isFree)
          RichText(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
            text: TextSpan(
              children: [
                TextSpan(
                    text:
                        '${currencyPartition.isEmpty ? '' : currencyPartition.length > 0 ? currencyPartition[1] : ''}\n',
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

  void _showBottomSheetRefund() {
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
              child: RefundDoc(
                refundOnPressed: () {},
                isRefunding: false,
              ));
        });
      },
    );
  }
  // This button leads to the ProfileScreen of the event's organizer.

  _organizerButton() {
    return EventBottomButton(
      buttonText: 'View organizer',
      onPressed: () {
        _navigateToPage(
            context,
            ProfileScreen(
              user: null,
              currentUserId: widget.currentUserId,
              userId: widget.event.authorId,
            ));
      },
    );
  }

  Future<void> _sendMail(String email, BuildContext context) async {
    String url = 'mailto:$email';
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not launch mail');
    }
  }

  // Method to create event
  _submitRequest() async {
    if (!_isLoading) {
      _isLoading = true;
      try {
        await _createPayoutRequst();

        _isLoading = false;

        mySnackBar(context, 'Payout requested succesfully.');
        // }
      } catch (e) {
        // _handleError(e, false);
        _isLoading = false;
        _showBottomSheetErrorMessage();
      }
    }
  }

  Future<EventPayoutModel> _createPayoutRequst() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    // Calculate the total cost of the order

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
    );

    await DatabaseService.requestPayout(widget.event, payout, _provider.user!);

    return payout;
  }

  void _showBottomSheetErrorMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
            _submitRequest();
          },
          title: "Request failed",
          subTitle: 'Please check your internet connection and try again.',
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
          buttonText: 'Refund request confirmation',
          onPressed: () async {
            Navigator.pop(context);
            //  _submitRequeste();
          },
          title: 'Are you sure you want to request for a payout?',
          subTitle: 'Please be informed that request can only be made once.',
        );
      },
    );
  }

  void _showBottomSheetRequestPayouts() {
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  // const SizedBox(height: 40),
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
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Request\nTicket Payouts',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text:
                              '\n\nCongratulations on successfully completing ${widget.event!.title}. We are delighted to see that you have reached this significant milestone. Completing such an event is a commendable achievement, and we appreciate your dedication.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              '\n\nWe understand that you are ready to receive the payouts for your ticket sales. It is important for you to have a clear understanding of how the payout system functions. While most payouts are instant, occasional network issues and other factors may contribute to slight delays in the payout. Typically, payouts are processed within 3 days after your request. Please note that Bars Impression applies a 10% commission on the payment amount to cover maintenance and other operational costs associated with managing the event process.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              '\n\nKindly ensure that you have completed your event and are fully prepared to receive your funds before submitting a payout request. Please remember that payout requests can only be made once. The funds will be transferred to the bank account linked to the event at the time of its creation.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _sendMail('support@barsopus.com', context);
                    },
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\n\nIf you have any further questions or need assistance, please don\'t hesitate to reach out to our ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: 'support team.',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomSheetDoc() {
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 40),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Ticket Validation:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        TextSpan(
                          text:
                              "\n\nThe scanning system (validator) on your event dashboard utilizes a QR code scanner to validate attendees' tickets. Upon successful validation, the QR code on the ticket changes color, and a blue verified checkmark is displayed in the top-right corner of the attendees' tickets. The ticket validation process typically takes only milliseconds, although the duration may vary depending on network conditions and the strength of connectivity. Once a ticket is scanned, the QR code scanner resets itself to scan another ticket. However, please avoid keeping the scanner on a ticket for an extended period after scanning, as it may result in a \"Ticket already validated\" error.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n\nDifferent errors that may occur during ticket scanning include:",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextSpan(
                          text: "\n\n1.	Ticket not found:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nThis indicates that the scanned ticket is either unavailable or forged.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n2.	Ticket has already been validated:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nThis means that the ticket is authentic and has already been validated for the attendee.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n3.	Ticket not valid for today: ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nThis error occurs when the scanned ticket's date does not match the current date. It typically happens for events that span multiple days and offer different tickets for each day. For example, if an event is taking place over two days, a ticket purchased for the first day (20th) would not be validated by the scanner on the 22nd. The ticket's date must match the current day for successful validation.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n4.	Invalid QR code data or invalid QR code format: ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nThis error indicates that the scanned ticket is forged or contains invalid QR code data.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n\nDetecting forged tickets:",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        TextSpan(
                          text:
                              "\nWhen scanning a ticket, a blue linear loading indicator should appear on the ticket, indicating that it is being scanned. If this loading indicator does not appear, it suggests that the ticket is forged or a screenshot. We encourage you to only scan tickets presented by attendees within the app while it is open and to avoid scanning screenshots of tickets. Valid tickets will provide a gentle haptic feedback on your phone, while non-valid tickets will generate a more pronounced vibration impact. \n\nAdditional Information:",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n1.	Scanning Instructions:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nPosition your phone's camera in such a way that the QR code on the ticket is entirely visible within the scanning frame. Ensure good lighting conditions for optimal scanning accuracy.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n2.	Error Handling:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nIf you encounter any errors during the scanning process, please follow these steps:",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n•	For a \"Ticket not found\" error,\nkindly verify that the ticket is valid and try scanning again. If the issue persists, contact our support team for assistance.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n•	If you receive an \"Invalid QR code data or invalid QR code format\" error,\nit is possible that the ticket has been tampered with. Please ensure you are scanning a genuine ticket and not a forged version.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\•	In the case of a \"Ticket not valid for today\" error, confirm that the ticket corresponds to the current event date. If you believe there is an error, please consult our event staff for further guidance.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n3.	Scanner Performance Tips:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\n•	Ensure good lighting conditions during scanning to enhance QR code readability.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n•	Avoid covering the QR code on your ticket, as it may affect scanning accuracy.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n•	Keep your device's camera lens clean for optimum scanning results.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n4.	Offline Mode:",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nOur scanning system requires an internet connection to validate tickets. Please ensure you have a stable network connection or access to mobile data for seamless ticket validation.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: "\n\n5.	App Permissions: ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text:
                              "\nFor the scanning system to function correctly, the app requires access to your device's camera. Please grant the necessary camera permissions when prompted to ensure smooth ticket scanning.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n\nWe hope this documentation provides comprehensive guidance on using the scanning system effectively and accurately validating attendees' tickets.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    final width = MediaQuery.of(context).size.width;
    Color _paletteDark = widget.palette == null
        ? Color(0xFF1a1a1a)
        : widget.palette!.darkMutedColor == null
            ? Color(0xFF1a1a1a)
            : widget.palette!.darkMutedColor!.color;
    bool isGhanaian = _provider.userLocationPreference!.country == 'Ghana' ||
        _provider.userLocationPreference!.currency == 'Ghana Cedi | GHS';
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
                    _inviteButton(300, 'Request payout', () {
                      _showBottomSheetRequestPayouts();
                    }),
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
                          // _expectedPeople

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
                    if (!widget.event.isFree) _refundTable(),
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
              const SizedBox(
                height: 100,
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
                  _showBottomSheetDoc();
                },
                child: Center(
                  child: Text(
                    '\nTicket Validation.',
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
                    _showBottomSheetRefund();
                  },
                  child: Center(
                    child: Text(
                      '\nRefund.',
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
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
