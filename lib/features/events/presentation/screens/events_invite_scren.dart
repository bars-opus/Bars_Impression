import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// This code segment is the build method of a widget that displays an event invitation to the user.
class EventInviteScreen extends StatefulWidget {
  final InviteModel invite;
  final Event event;
  final String currentUserId;
  final PaletteGenerator palette;
  final TicketOrderModel? ticketOrder;

  const EventInviteScreen({
    required this.invite,
    required this.event,
    required this.currentUserId,
    required this.palette,
    required this.ticketOrder,
  });

  @override
  State<EventInviteScreen> createState() => _EventInviteScreenState();
}

class _EventInviteScreenState extends State<EventInviteScreen> {
  bool _isLoading = false;
  bool _isLoadingSubmit = false;
  int _expectedAttendees = 0;
  bool _eventHasEnded = false;

  @override
  void initState() {
    super.initState();
    _setUpEventExpectedAttendees();
    _countDown();
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

  // This method sets up a stream that listens to the total count of expected attendees for an event.
  // It updates the _expectedAttendees state variable with the invite count whenever it changes.
  _setUpEventExpectedAttendees() async {
    DatabaseService.numTotalExpectedAttendees(
      widget.event.id,
    ).listen((inviteCount) {
      if (mounted) {
        setState(() {
          _expectedAttendees = inviteCount;
        });
      }
    });
  }

// This method shows a bottom sheet with an error message.
// It uses the showModalBottomSheet function to display a DisplayErrorHandler widget, which shows
// the message "Request failed" along with a button for dismissing the bottom sheet.
  void _showBottomSheetErrorMessage(Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          subTitle: result,
        );
      },
    );
  }

  // This method navigates to a new page. It takes the BuildContext and the Widget for the new page as parameters
  // and uses the Navigator.push function to navigate to the new page.
  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

// This method launches a map with the event's venue.
// It uses the MapsLauncher.launchQuery function to do this.
  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.venue);
  }

  // This asynchronous method sends an invitation. It first checks if the _isLoadingSubmit state variable is true.
  // If not, it sets _isLoadingSubmit to true and then attempts to send the event invite
  //  using the DatabaseService.answerEventInvite method. This method is retried up to 3 times in case of failures.
  //  If the invitation is accepted, it also creates a ticket order and navigates to the EventsAttendingTicket page.
  //  If the invitation sending fails, it shows the bottom sheet error message. After all operations are done,
  _sendInvite(bool isAccepted, String purchaseReferenceId) async {
    var _user = Provider.of<UserData>(context, listen: false).user;
    String commonId = Uuid().v4();

    if (_isLoadingSubmit) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingSubmit = true;
      });
    }

    Future<T> retry<T>(Future<T> Function() function, {int retries = 3}) async {
      Duration delay =
          const Duration(milliseconds: 100); // Start with a short delay
      for (int i = 0; i < retries; i++) {
        try {
          return await function();
        } catch (e) {
          if (i == retries - 1) {
            // Don't delay after the last attempt
            rethrow;
          }
          await Future.delayed(delay);
          delay *= 2; // Double the delay for the next attempt
        }
      }
      throw Exception('Failed after $retries attempts');
    }

    WriteBatch batch = FirebaseFirestore.instance.batch();
    Future<void> sendInvites() => DatabaseService.answerEventInviteBatch(
          batch: batch,
          event: widget.event,
          answer: isAccepted ? 'Accepted' : 'Rejected',
          currentUser: _user!,
        );

    try {
      await retry(() => sendInvites(), retries: 3);
      if (isAccepted) {
        try {
          TicketOrderModel order = await retry(
              () =>
                  _createTicketOrder(batch, commonId, [], purchaseReferenceId),
              retries: 3);

          PaletteGenerator _paletteGenerator =
              await PaletteGenerator.fromImageProvider(
            CachedNetworkImageProvider(widget.event.imageUrl),
            size: Size(1110, 150),
            maximumColorCount: 20,
          );

          _navigateToPage(
            context,
            PurchasedAttendingTicketScreen(
              ticketOrder: order,
              event: widget.event,
              currentUserId: widget.currentUserId,
              justPurchased: 'New',
              palette: _paletteGenerator,
            ),
          );

          mySnackBar(context, "Invite accepted successfully");
        } catch (e) {
          print('Error in if (isAccepted) block: $e');
        }
      } else {
        Navigator.pop(context);
        mySnackBar(context, "Invite rejected ");
      }
      await batch.commit();
    } catch (e) {
      _showBottomSheetErrorMessage(e);
    } finally {
      _endLoading();
    }
  }

// This asynchronous method creates a ticket order.
// It first calculates the total cost of the order, then creates a TicketOrder object with the necessary details,
//  and finally uses the DatabaseService.purchaseTicket and DatabaseService.addUserTicketIdRef methods to save the ticket order in the database.
  Future<TicketOrderModel> _createTicketOrder(
      WriteBatch batch,
      String commonId,
      List<TicketPurchasedModel> _finalTicket,
      String purchaseReferenceId) async {
    // Calculate the total cost of the order
    var _user = Provider.of<UserData>(context, listen: false).user;

    double total = _finalTicket.fold(0, (acc, ticket) => acc + ticket.price);

    TicketOrderModel order = TicketOrderModel(
      orderId: commonId,
      tickets: _finalTicket,
      total: total,
      // entranceId: '',
      eventId: widget.event.id,
      eventImageUrl: widget.event.imageUrl,
      eventTimestamp: widget.event.timestamp,
      isInvited: true,
      timestamp: Timestamp.now(),
      orderNumber: commonId,
      // validated: false,
      userOrderId: widget.currentUserId,
      eventTitle: widget.event.title,
      purchaseReferenceId: purchaseReferenceId, refundRequestStatus: '',
      //  refundRequestStatus: '',
    );

    widget.event.ticketOrder.add(order);
    DatabaseService.purchaseTicketBatch(
      ticketOrder: order,
      batch: batch,
      user: _user!,
      eventAuthorId: widget.event.authorId,
      purchaseReferenceId: purchaseReferenceId,
    );

    return order;
  }

// This method sets _isLoadingSubmit to false.
// This indicates that the loading process is finished.
  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

// This function generates the ticket display widget.
// It includes elements such as the event date, generated message, and check-in number.
// The date is displayed in a large font, and the generated message and check-in instructions are presented in smaller fonts.
// The ShakeTransition widget wraps the date, which makes the date shake for 2 seconds, providing a special visual effect.
  _ticketdisplay() {
    Color _palleteColor = widget.palette == null
        ? Colors.grey
        : widget.palette.vibrantColor == null
            ? Colors.grey
            : widget.palette.vibrantColor!.color;

    final width = MediaQuery.of(context).size.width;
    final List<String> datePartition = widget.event.startDate == null
        ? MyDateFormat.toDate(DateTime.now()).split(" ")
        : MyDateFormat.toDate(widget.event.startDate.toDate()).split(" ");
    var _dateAndTimeSmallStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      fontWeight: FontWeight.bold,
      color: _palleteColor,
    );
    var _dateAndTimeLargeStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 150.0),
      color: _palleteColor,
      fontWeight: FontWeight.bold,
    );
    return new Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 70,
                ),
                Icon(
                  FontAwesomeIcons.idBadge,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: ResponsiveHelper.responsiveFontSize(context, 30.0),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'CORDIALLY\nINVITED',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 70,
                ),
                Text(
                  widget.invite.generatedMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                ShakeTransition(
                  duration: const Duration(seconds: 2),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: datePartition[0].toUpperCase(),
                            style: _dateAndTimeSmallStyle),
                        if (datePartition.length > 1)
                          TextSpan(
                              text: "\n${datePartition[1].toUpperCase()}\n",
                              style: _dateAndTimeSmallStyle),
                        if (datePartition.length > 2)
                          TextSpan(
                              text: "${datePartition[2].toUpperCase()} ",
                              style: _dateAndTimeLargeStyle),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  widget.invite.inviterMessage,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 120.0, bottom: 30),
                  child: Divider(color: Colors.grey),
                ),
                widget.invite.answer.isNotEmpty
                    ? _alreadyAnswered(widget.invite.answer)
                    : Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 12),
                        child: Text(
                          '"You have been invited to attend this event. Accepting this invitation is optional. Some invitations may include a pass that allows you to obtain a ticket for the event without making a purchase, while others may not include a pass. \n\nIf an invitation includes a pass or if the event associated with the invitation is free, you will be presented with Accept and Reject buttons to respond to the invitation. If not, the tickets for the event associated with the invitation will be displayed for you to purchase."',
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This function generates a widget that displays information about the event.
  //  It includes the event details, a divider line, and a section that shows the number of people attending the event.
  //  It also provides a link to see the attendees' list.
  //  When the user taps on this link, a PaletteGenerator is used to generate a color palette from the event's image,
  //  and then it navigates to the EventExpectedAttendees page.

  _eventInfoDisplay() {
    final width = MediaQuery.of(context).size.width;
    return new Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          width: width,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventOnTicketWidget(
                event: widget.event,
                // finalPurchasintgTicket: null,
                currentUserId: widget.currentUserId,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  PaletteGenerator _paletteGenerator =
                      await PaletteGenerator.fromImageProvider(
                    CachedNetworkImageProvider(widget.event.imageUrl),
                    size: Size(1110, 150),
                    maximumColorCount: 20,
                  );
                  _navigateToPage(
                    context,
                    EventExpectedAttendeesScreen(
                      event: widget.event,
                      letShowAppBar: true,
                      palette: widget.palette,
                      peopleAttending: true,
                      validated: false,
                      fromDashboard: false,
                    ),
                  );
                },
                child: Container(
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'The number of people attending:   ',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: Colors.grey,
                            ),
                          ),
                          TextSpan(
                            text: NumberFormat.compact()
                                .format(_expectedAttendees),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          TextSpan(
                            text: "\nSee people attending",
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

// This function shows a bottom sheet asking the user to confirm their decision to accept or reject the invitation.
// It uses the ConfirmationPrompt widget to display the confirmation prompt.

  void _showBottomSheetAcceptReject(BuildContext context, bool isAccepted) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: isAccepted ? 'Accept' : 'Reject',
          onPressed: () async {
            Navigator.pop(context);
            _sendInvite(isAccepted, '');
          },
          title: isAccepted
              ? 'Are you sure you want to accept this invitation?'
              : 'Are you sure you want to reject this invitation?',
          subTitle: 'Please make sure you don\'t miss any appointment',
        );
      },
    );
  }

// This function generates an 'Accept' or 'Reject' button based on the passed parameters.
// The button includes an icon which varies depending on whether the button is 'Accept' or 'Reject'.
// It uses the ElevatedButton widget to create the button.

  _acceptRejectButton(
    String buttonText,
    VoidCallback onPressed,
    bool fullLength,
  ) {
    return Center(
      child: Container(
        width: ResponsiveHelper.responsiveWidth(context, 150.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColorLight,
            elevation: 0.0,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                ),
                textAlign: TextAlign.center,
              ),
              Icon(
                buttonText.startsWith('Accept') ? Icons.check : Icons.close,
                size: ResponsiveHelper.responsiveHeight(context, 20.0),
                color:
                    buttonText.startsWith('Accept') ? Colors.blue : Colors.red,
              )
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

// This function generates a widget that tells the user they have already responded to the invitation.
// It displays a message such as "You have accepted this event invitation" or "You have rejected this event invitation".
  _alreadyAnswered(String answer) {
    return Center(
      child: Text(
        "You have ${answer.toLowerCase()} this event invitaion",
        style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
      ),
    );
  }

  // full-screen image for the event, with a Hero widget
  //to create an animation when transitioning between pages.
  _backgroundEventImage() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.event.imageUrl),
            fit: BoxFit.cover,
          )),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
          Colors.black.withOpacity(.5),
          Colors.black.withOpacity(.4),
        ])),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(
          'Invitation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
          ),
        ),
      ),
      body: Material(
        child: Stack(
          alignment: FractionalOffset.center,
          children: [
            _backgroundEventImage(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  _ticketdisplay(),
                  if (widget.ticketOrder != null)
                    const SizedBox(
                      height: 10,
                    ),
                  if (widget.ticketOrder != null)
                    Column(
                      children: [
                        if (widget.ticketOrder!.refundRequestStatus ==
                            'pending')
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5.0, left: 20, right: 20, top: 50),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColorLight,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(10, 10),
                                      blurRadius: 10.0,
                                      spreadRadius: 4.0,
                                    )
                                  ]),
                              // width: width,
                              child: RichText(
                                textScaleFactor:
                                    MediaQuery.of(context).textScaleFactor,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Refund requested  ',
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14.0),
                                        color: Colors.red,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "\nYou have requested a refund for this ticket order. Your refund request is being processed. You should receive your funds within 24 hours.",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        PurchaseTicketSummaryWidget(
                          finalPurchasingTicketList:
                              widget.ticketOrder!.tickets,
                          currentUserId: widget.currentUserId,
                          event: widget.event,
                          justPurchased: '',
                          palette: widget.palette,
                          ticketOrder: widget.ticketOrder!,
                        ),
                      ],
                    ),
                  // TicketEnlargedWidget(
                  //   onInvite: true,
                  //   // event: widget.event,
                  //   palette: widget.palette,
                  //   ticketOrder: widget.ticketOrder!,
                  //   hasEnded: _eventHasEnded,
                  //   currency: currencyPartition.length > 0
                  //       ? currencyPartition[1]
                  //       : '',
                  //   event: widget.event,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  _eventInfoDisplay(),
                  const SizedBox(
                    height: 10,
                  ),
                  EventBottomButton(
                    buttonText:
                        widget.event.isVirtual ? 'Host link' : 'Event location',
                    onPressed: () {
                      widget.event.isVirtual
                          ? _navigateToPage(
                              context,
                              MyWebView(
                                title: '',
                                url: widget.event.virtualVenue,
                              ))
                          : _launchMap();
                    },
                  ),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 5.0),
                  ),
                  Stack(
                    alignment: FractionalOffset.center,
                    children: [
                      EventBottomButton(
                        buttonText: _isLoading ? '' : 'Event room',
                        onPressed: () async {
                          PaletteGenerator _paletteGenerator =
                              await PaletteGenerator.fromImageProvider(
                            CachedNetworkImageProvider(widget.event.imageUrl),
                            size: Size(1110, 150),
                            maximumColorCount: 20,
                          );
                          if (_isLoading) return;
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            EventRoom? room =
                                await DatabaseService.getEventRoomWithId(
                                    widget.invite.eventId.isEmpty
                                        ? widget.event.id
                                        : widget.invite.eventId);

                            TicketIdModel? ticketId =
                                await DatabaseService.getTicketIdWithId(
                                    widget.event.id, widget.currentUserId);
                            if (room != null) {
                              _navigateToPage(
                                  context,
                                  EventRoomScreen(
                                    currentUserId: widget.currentUserId,
                                    room: room,
                                    palette: _paletteGenerator,
                                    ticketId: ticketId!,
                                  ));
                            } else {
                              mySnackBar(context, 'Could not fetch room');
                            }
                          } catch (e) {
                            _showBottomSheetErrorMessage(e);
                          } finally {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                      ),
                      _isLoading
                          ? SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : SizedBox.shrink()
                    ],
                  ),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 5.0),
                  ),
                  EventBottomButton(
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
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  widget.invite.isTicketPass
                      ? widget.invite.answer.isNotEmpty
                          ? SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Center(
                                child: Text(
                                  "Answer invitation\n",
                                  style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14.0),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                      : widget.invite.answer.isNotEmpty
                          ? SizedBox.shrink()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                "Ticket Options",
                                style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 16.0),
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                  widget.invite.answer.isNotEmpty
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            widget.invite.isTicketPass
                                ? 'This invite includes a pass that allows you to obtain a free ticket for the event without making a purchase. You may accept or reject the invite. '
                                : widget.event.isFree
                                    ? 'This event is free, tap to generate a free ticket. Wishing you the best experience and create amazing memories.\n'
                                    : 'These are the available tickets for the event. You can choose a ticket from the options provided and proceed with the purchase.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                  widget.invite.isTicketPass
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: _isLoadingSubmit
                              ? CircularProgress(isMini: true)
                              : widget.invite.answer.isNotEmpty
                                  ? SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _acceptRejectButton('Accept', () {
                                          _showBottomSheetAcceptReject(
                                            context,
                                            true,
                                          );
                                        }, false),
                                        _acceptRejectButton('Reject', () {
                                          _showBottomSheetAcceptReject(
                                            context,
                                            false,
                                          );
                                        }, false),
                                      ],
                                    ),
                        )
                      : SizedBox.shrink(),

                  widget.invite.isTicketPass
                      ? SizedBox.shrink()
                      : widget.invite.answer.isNotEmpty
                          ? SizedBox.shrink()
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TicketGroup(
                                    onInvite: true,
                                    currentUserId: widget.currentUserId,
                                    event: widget.event,
                                    groupTickets: widget.event.ticket,
                                    inviteReply: 'Accepted',
                                  ),
                                ),
                              ],
                            ),
                  const SizedBox(
                    height: 100,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    iconSize: ResponsiveHelper.responsiveHeight(context, 30.0),
                    color: Colors.white,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Center(
                    child: CountdownTimer(
                      split: 'Single',
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.white,
                      clossingDay: DateTime.now(),
                      startDate: widget.event.startDate.toDate(),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.event.type,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                        color: Colors.white,
                        fontFamily: 'Bessita',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
