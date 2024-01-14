import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class EventsAttendingTicketScreen extends StatefulWidget {
  final TicketOrderModel ticketOrder;
  final TicketPurchasedModel ticket;
  final Event event;
  final String currentUserId;
  final String justPurchased;
  final PaletteGenerator palette;

  const EventsAttendingTicketScreen({
    required this.ticketOrder,
    required this.event,
    required this.currentUserId,
    required this.justPurchased,
    required this.palette,
    required this.ticket,
  });

  @override
  State<EventsAttendingTicketScreen> createState() =>
      _EventsAttendingTicketScreenState();
}

class _EventsAttendingTicketScreenState
    extends State<EventsAttendingTicketScreen> {
  bool _isLoading = false;

  int _index = 0;

  int _expectedAttendees = 0;
  bool _eventHasEnded = false;

  bool _seeAllSchedules = false;

  @override
  void initState() {
    super.initState();
    // _generatePalette();
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
          },
          title: "Request failed",
          subTitle: 'Please check your internet connection and try again.',
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

// This function generates the ticket display widget.
// It includes elements such as the event date, generated message, and check-in number.
// The date is displayed in a large font, and the generated message and check-in instructions are presented in smaller fonts.
// The ShakeTransition widget wraps the date, which makes the date shake for 2 seconds, providing a special visual effect.

  _ticketdisplay() {
    // Color _palleteColor = widget.palette == null
    //     ? Colors.grey
    //     : widget.palette.vibrantColor == null
    //         ? Colors.grey
    //         : widget.palette.vibrantColor!.color;

    // final width = MediaQuery.of(context).size.width;
    // var _textStyle2 = Theme.of(context).textTheme.bodyMedium;
    // var _textStyle = TextStyle(
    //   fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
    //   color: Colors.grey,
    // );

    // List<TicketModel> tickets = widget.ticketOrder.tickets;
    // return new Material(
    //   color: Colors.transparent,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //     child: Container(
    //       width: width,
    //       decoration: BoxDecoration(
    //           color: Theme.of(context).primaryColorLight,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black26,
    //               offset: Offset(10, 10),
    //               blurRadius: 10.0,
    //               spreadRadius: 4.0,
    //             )
    //           ]),
    //       child: Column(
    //         children: [
    //           if (!widget.ticketOrder.validated)
    //             const SizedBox(
    //               height: 70,
    //             ),
    //           if (widget.ticketOrder.validated)
    //             Padding(
    //               padding:
    //                   const EdgeInsets.only(right: 30.0, top: 40, bottom: 30),
    //               child: Align(
    //                 alignment: Alignment.centerRight,
    //                 child: Icon(
    //                   Icons.check_circle,
    //                   color: Colors.blue,
    //                   size: 20.0,
    //                 ),
    //               ),
    //             ),
    //           if (widget.ticketOrder.isInvited)
    //             Icon(
    //               FontAwesomeIcons.idBadge,
    //               color: Theme.of(context).secondaryHeaderColor,
    //               size: 30.0,
    //             ),
    //           if (widget.ticketOrder.isInvited)
    //             const SizedBox(
    //               height: 10,
    //             ),
    //           if (widget.ticketOrder.isInvited)
    //             Text(
    //               'CORDIALLY\nINVITED',
    //               style: Theme.of(context).textTheme.bodySmall,
    //               textAlign: TextAlign.center,
    //             ),
    //           if (widget.ticketOrder.isInvited)
    //             const SizedBox(
    //               height: 30,
    //             ),
    //           ShakeTransition(
    //             duration: const Duration(seconds: 2),
    //             child: Padding(
    //                 padding: const EdgeInsets.symmetric(
    //                     vertical: 10.0, horizontal: 10),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(15.0),
    //                   child: QrImageView(
    //                     version: QrVersions.auto,
    //                     foregroundColor: widget.ticketOrder.validated
    //                         ? _palleteColor
    //                         : Colors.grey,
    //                     backgroundColor: Colors.transparent,
    //                     data: widget.ticketOrder.entranceId,
    //                     size: width / 2,
    //                   ),
    //                 )),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(
    //               top: 30.0,
    //             ),
    //             child: Text(
    //               widget.ticketOrder.orderNumber.substring(0, 4),
    //               style: TextStyle(
    //                   fontSize:
    //                       ResponsiveHelper.responsiveFontSize(context, 30.0),
    //                   color: Colors.grey),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 70.0, bottom: 30),
    //             child: Divider(
    //               color: Colors.grey,
    //             ),
    //           ),
    //           Container(
    //             width: width,
    //             child: Padding(
    //               padding: const EdgeInsets.only(left: 12.0, right: 12),
    //               child: RichText(
    //                 textScaleFactor: MediaQuery.of(context).textScaleFactor,
    //                 text: TextSpan(
    //                   children: [
    //                     TextSpan(
    //                         text: 'Check-in number:   ', style: _textStyle),
    //                     TextSpan(
    //                       text: widget.ticketOrder.entranceId,
    //                       style: _textStyle2,
    //                     ),
    //                     TextSpan(
    //                         text: '\nInvited:                     ',
    //                         style: _textStyle),
    //                     TextSpan(
    //                       text: widget.ticketOrder.isInvited.toString(),
    //                       style: _textStyle2,
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 30.0, bottom: 30),
    //             child: Divider(
    //               color: Colors.grey,
    //             ),
    //           ),
    //           ...tickets
    //               .map((ticket) => Container(
    //                     width: width,
    //                     child: Padding(
    //                       padding: const EdgeInsets.only(
    //                         left: 12.0,
    //                         right: 12,
    //                       ),
    //                       child: RichText(
    //                         textScaleFactor:
    //                             MediaQuery.of(context).textScaleFactor,
    //                         text: TextSpan(
    //                           children: [
    //                             TextSpan(
    //                               text: 'Sales Receipt',
    //                               style: Theme.of(context).textTheme.bodyLarge,
    //                             ),
    //                             TextSpan(
    //                               text: '\n\nOrder number:        ',
    //                               style: _textStyle,
    //                             ),
    //                             TextSpan(
    //                               text: widget.ticketOrder.orderNumber
    //                                   .substring(0, 4),
    //                               style: _textStyle2,
    //                             ),
    //                             if (ticket.type.isNotEmpty)
    //                               TextSpan(
    //                                 text: '\nTicket type:             ',
    //                                 style: _textStyle,
    //                               ),
    //                             if (ticket.type.isNotEmpty)
    //                               TextSpan(
    //                                 text: ticket.type,
    //                                 style: _textStyle2,
    //                               ),
    //                             if (ticket.group.isNotEmpty)
    //                               TextSpan(
    //                                 text: '\nTicket group:           ',
    //                                 style: _textStyle,
    //                               ),
    //                             if (ticket.group.isNotEmpty)
    //                               TextSpan(
    //                                 text: ticket.group,
    //                                 style: _textStyle2,
    //                               ),
    //                             if (ticket.accessLevel.isNotEmpty)
    //                               TextSpan(
    //                                 text: '\nAccess level:           ',
    //                                 style: _textStyle,
    //                               ),
    //                             if (ticket.accessLevel.isNotEmpty)
    //                               TextSpan(
    //                                 text: ticket.accessLevel + 'ppp',
    //                                 style: _textStyle2,
    //                               ),
    //                             TextSpan(
    //                               text: '\nPurchased time:     ',
    //                               style: _textStyle,
    //                             ),
    //                             TextSpan(
    //                               text: MyDateFormat.toTime(
    //                                   widget.ticketOrder.timestamp!.toDate()),
    //                               style: _textStyle2,
    //                             ),
    //                             TextSpan(
    //                               text: '\nPurchased date:     ',
    //                               style: _textStyle,
    //                             ),
    //                             TextSpan(
    //                               text: MyDateFormat.toDate(
    //                                   widget.ticketOrder.timestamp!.toDate()),
    //                               style: _textStyle2,
    //                             ),
    //                             TextSpan(
    //                               text: '\nTotal:                       ',
    //                               style: _textStyle,
    //                             ),
    //                             TextSpan(
    //                               text: ticket.price.toString(),
    //                               style: _textStyle2,
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ))
    //               .toList(),
    //           Padding(
    //             padding: const EdgeInsets.only(top: 30.0, bottom: 30),
    //             child: Divider(
    //               color: Colors.grey,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 12.0, right: 12),
    //             child: Text(
    //               'Your check-in number, also known as your attendee number, is ${widget.ticketOrder.orderNumber}. This number will be validated at the entrance of this event before you can enter. Once this ticket has been validated, the color of the barcode on the ticket will change, and a blue verified badge is placed at the top right corner of the ticket.  Enjoy attending this event and have a great time!',
    //               style: TextStyle(
    //                 color: Theme.of(context).secondaryHeaderColor,
    //                 fontSize:
    //                     ResponsiveHelper.responsiveFontSize(context, 12.0),
    //               ),
    //               textAlign: TextAlign.center,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 50,
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
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
                padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
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

// If the user has just purchased a ticket (justPurchased.startsWith('New')),
// the _ticketSummaryInfo widget is displayed. If the user has already purchased a
// ticket (justPurchased.startsWith('Already')), a message is displayed stating that they've already purchased a ticket.
// The _ticketSummaryInfo() is a method that returns a widget displaying the summary
//information when a user purchases a ticket. It contains:
// Congratulations message: It displays a congratulations message with a shaking celebration icon.
// User-specific message: If the user data is available, it displays a personalized message
//thanking the user for purchasing the ticket and welcoming them as an attendee to the event.
// Attendee experience info: This section displays information about the attendee's experience,
// calendar and schedules, and the event room.
// Visual styling: Like the previous widget, it is styled using a BoxDecoration with a light primary color background and a box shadow.

  // _ticketSummaryInfo() {
  //   final width = MediaQuery.of(context).size.width;
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   return new Material(
  //     color: Colors.transparent,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //       child: Container(
  //         width: width,
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColorLight,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26,
  //                 offset: Offset(10, 10),
  //                 blurRadius: 10.0,
  //                 spreadRadius: 4.0,
  //               )
  //             ]),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             children: [
  //               const SizedBox(
  //                 height: 50,
  //               ),
  //               ShakeTransition(
  //                 duration: const Duration(seconds: 2),
  //                 child: Icon(
  //                   Icons.celebration_outlined,
  //                   size: 50,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               Text(
  //                 'Congratulations',
  //                 style: TextStyle(
  //                   fontSize:
  //                       ResponsiveHelper.responsiveFontSize(context, 30.0),
  //                   color: Theme.of(context).secondaryHeaderColor,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               Divider(
  //                 color: Colors.grey,
  //               ),
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               if (_provider.user != null)
  //                 RichText(
  //                   textScaleFactor: MediaQuery.of(context).textScaleFactor,
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: 'Dear  ${_provider.user!.userName} \n',
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             'Thank you for purchasing the tickets to attend ${widget.event.title}. We are delighted to officially welcome you as an attendee to this event. Enjoy and have a fantastic time!',
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               const SizedBox(
  //                 height: 40,
  //               ),
  //               RichText(
  //                 textScaleFactor: MediaQuery.of(context).textScaleFactor,
  //                 text: TextSpan(
  //                   children: [
  //                     TextSpan(
  //                       text: 'Your Attendee\nExperience',
  //                       style: TextStyle(
  //                         fontSize: ResponsiveHelper.responsiveFontSize(
  //                             context, 20.0),
  //                         fontWeight: FontWeight.bold,
  //                         color: Theme.of(context).secondaryHeaderColor,
  //                       ),
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           '\nWe prioritize providing an exceptional attendee experience that will enhance your participation in this event. We are thrilled to support you throughout your attendance. As an attendee, you have access to a comprehensive set of resources to assist you in attending and networking with other participants',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                     TextSpan(
  //                       text: '\n\nCalendar and schdeules.',
  //                       style: Theme.of(context).textTheme.bodyLarge,
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           '\nYou can find this feature as the fourth icon named "Tickets" on the navigation bar of your home screen when you first launch the app. It allows you to stay organized by keeping track of the dates of your events. This page also conveniently displays your tickets for upcoming events, ensuring easy access',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                     TextSpan(
  //                       text: '\n\nEvent Room',
  //                       style: Theme.of(context).textTheme.bodyLarge,
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           '\nAn event room fosters networking and interaction among attendees of a specific event. You can find this feature as the fifth icon named "Chats" on the navigation bar of your home screen when you first launch the app. The event room is located on the second tab of the chat page, labeled "Rooms". It creates a dedicated group for all event attendees to chat and connect with each other.',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                     TextSpan(
  //                       text: '\n\nReminders',
  //                       style: Theme.of(context).textTheme.bodyLarge,
  //                     ),
  //                     TextSpan(
  //                       text:
  //                           '\nSeven days prior to the event, we will send you daily reminders to ensure that you don\'t forget about your upcoming event.',
  //                       style: Theme.of(context).textTheme.bodyMedium,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 50,
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Method to create event
  _submitRequeste() async {
    if (!_isLoading) {
      _isLoading = true;
      try {
        RefundModel refund = await _createRefund();

        _isLoading = false;
        // if (mounted) {
        //   _navigateToPage(
        //       context,
        //       EventEnlargedScreen(
        //         justCreated: true,
        //         currentUserId: _provider.currentUserId!,
        //         event: event,
        //         type: event.type,
        //         palette: _paletteGenerator,
        //       ));

        mySnackBar(context, 'Your refund request was successful.');
        // }
      } catch (e) {
        // _handleError(e, false);
        _isLoading = false;
        _showBottomSheetErrorMessage();
      }
    }
  }

  Future<RefundModel> _createRefund() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    // Calculate the total cost of the order

    String commonId = Uuid().v4();

    RefundModel refund = RefundModel(
      id: commonId,
      eventId: widget.event.id,
      timestamp: Timestamp.fromDate(DateTime.now()),
      userRequestId: _provider.user!.userId!,
      approvedTimestamp: Timestamp.fromDate(DateTime.now()),
      reason: '',
      city: _provider.userLocationPreference!.city!,
      status: 'pending',
      transactionId: widget.ticketOrder.transactionId,
    );

    await DatabaseService.requestRefund(widget.event, refund, _provider.user!);

    return refund;
  }

  void _showBottomSheetConfirmRefund(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: widget.event.isFree || widget.ticketOrder.tickets.isEmpty
              ? 'Cancel attendance'
              : 'Refund request confirmation',
          onPressed: () async {
            Navigator.pop(context);
            _submitRequeste();
          },
          title: widget.event.isFree || widget.ticketOrder.tickets.isEmpty
              ? 'Are you sure you cancel attendance?'
              : 'Are you sure you want to request for a refund?',
          subTitle:
              'Please be informed that your ticket for this event would be revoked and you would lose access to this event\'s room.',
        );
      },
    );
  }

  // void _showBottomSheetRefund() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return Container(
  //           height: ResponsiveHelper.responsiveFontSize(context, 650),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: ListView(
  //               children: [
  //                 // const SizedBox(
  //                 //   height: 30,
  //                 // ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     TicketPurchasingIcon(
  //                       title: '',
  //                     ),
  //                     MiniCircularProgressButton(
  //                         color: Colors.blue,
  //                         text: 'Continue',
  //                         onPressed: () async {
  //                           Navigator.pop(context);
  //                           _showBottomRefundForm();
  //                           // if (mounted) {
  //                           //   setState(() {
  //                           //     _checkingTicketAvailability = true;
  //                           //   });
  //                           // }
  //                           // await _attendMethod();
  //                           // if (mounted) {
  //                           //   setState(() {
  //                           //     _checkingTicketAvailability = false;
  //                           //   });
  //                           // }
  //                         })
  //                   ],
  //                 ),
  //                 const SizedBox(height: 40),
  //                 // RichText(
  //                 //   textScaleFactor: MediaQuery.of(context).textScaleFactor,
  //                 //   text: TextSpan(
  //                 //     children: [
  //                 //       TextSpan(
  //                 //         text: 'Refund',
  //                 //         style: Theme.of(context).textTheme.titleMedium,
  //                 //       ),
  //                 //       TextSpan(
  //                 //         text: "\n\n${widget.event.termsAndConditions}",
  //                 //         style: Theme.of(context).textTheme.bodyMedium,
  //                 //       ),
  //                 //     ],
  //                 //   ),
  //                 // ),
  //                 RichText(
  //                   textScaleFactor: MediaQuery.of(context).textScaleFactor,
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: 'Refund',
  //                         style: Theme.of(context).textTheme.titleLarge,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n\nThank you for using Bars Impression to purchase tickets for events. We aim to provide a seamless ticketing experience for our users. In the event that you need to request a refund for a purchased ticket, please review our refund policy outlined below.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text: "\n\nRefund Amount.",
  //                         style: Theme.of(context).textTheme.bodyLarge,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\nPlease note that we offer a partial refund policy.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n - We will refund 70 percent of the ticket purchase price.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n - The remaining 30 percent will be retained as a non-refundable fee to cover administrative and processing costs associated with ticket sales and refunds.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text: "\n\nRefund Timeframe.",
  //                         style: Theme.of(context).textTheme.bodyLarge,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n - The time it takes to process a refund may vary depending on your original payment method and financial institution.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n - Please allow 24hrs for the refund to be processed and reflected in your account",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text: "\n\nNon-Refundable Circumstances.",
  //                         style: Theme.of(context).textTheme.bodyLarge,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\nRefunds will not be provided under the following circumstances:",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text: "\n - The event has already taken place.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n - The refund request is made after the specified deadline.",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                       TextSpan(
  //                         text: "\n\nChanges to the Refund Policy.",
  //                         style: Theme.of(context).textTheme.bodyLarge,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\nBars Impression reserves the right to modify or update the refund policy at any time. Any changes will be effective immediately upon posting the revised policy within the app",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 60),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }
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

  // This button leads to the ProfileScreen of the event's organizer.

  // _refundButton() {
  //   return EventBottomButton(
  //     buttonColor: Colors.red,
  //     buttonText: widget.event.isFree ? 'Cancel attendance' : 'Request refund',
  //     onPressed: () {
  //       widget.event.isFree || widget.ticketOrder.tickets.isEmpty
  //           ? _showBottomRefundForm()
  //           : _showBottomSheetRefund();
  //     },
  //   );
  // }

  //  This button leads to either the event's location on a map or the event's virtual venue,
  //  depending on whether the event is virtual or not.

  _locationButton() {
    return EventBottomButton(
      buttonText: widget.event.isVirtual ? 'Host link' : 'Event location',
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
    );
  }

// If the ticketOrder indicates the user is invited to the event,
//  a button is displayed that leads to the EventInvitePage.

  _invitationButton() {
    return Stack(
      alignment: FractionalOffset.center,
      children: [
        EventBottomButton(
          buttonText: 'Invitation',
          onPressed: () async {
            if (_isLoading) return;
            _isLoading = true;
            // try {
            InviteModel? invite = await DatabaseService.getEventIviteWithId(
                widget.currentUserId, widget.ticketOrder.eventId);

            TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
                widget.event.id, widget.currentUserId);

            if (invite != null) {
              _navigateToPage(
                  context,
                  EventInviteScreen(
                    currentUserId: widget.currentUserId,
                    event: widget.event,
                    invite: invite,
                    palette: widget.palette,
                    ticketOrder: _ticket!,
                  ));
            } else {
              _showBottomSheetErrorMessage();
            }
            // } catch (e) {
            //   _showBottomSheetErrorMessage();
            // } finally {
            _isLoading = false;
            // }
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
    );
  }

  // This button leads to the EventRoomPage which displays the event room details.

  _eventRoomButton() {
    return Stack(
      alignment: FractionalOffset.center,
      children: [
        EventBottomButton(
          buttonText: _isLoading ? '' : 'Event room',
          onPressed: () async {
            if (_isLoading) return;
            _isLoading = true;
            try {
              EventRoom? room = await DatabaseService.getEventRoomWithId(
                  widget.ticketOrder.eventId);

              TicketIdModel? ticketId = await DatabaseService.getTicketIdWithId(
                  widget.event.id, widget.currentUserId);

              if (room != null) {
                _navigateToPage(
                    context,
                    EventRoomScreen(
                      currentUserId: widget.currentUserId,
                      room: room,
                      palette: widget.palette,
                      ticketId: ticketId!,
                    ));
              } else {
                _showBottomSheetErrorMessage();
              }
            } catch (e) {
              _showBottomSheetErrorMessage();
            } finally {
              _isLoading = false;
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

  // _alreadyPurchasedTicket() {
  //   return Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
  //       child: Text(
  //         'You have already purchased a ticket for this event. Please note that only one ticket per event is allowed',
  //         style: TextStyle(
  //           color: Colors.white,
  //           fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
  //         ),
  //       ));
  // }

  _ticket() {
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");

    return ListView(
      children: [
        const SizedBox(
          height: 40,
        ),

        // widget.justPurchased.startsWith('New')
        //     ? _ticketSummaryInfo()
        //     : widget.justPurchased.startsWith('Already')
        //         ? _alreadyPurchasedTicket()
        //         : SizedBox.shrink(),

        const SizedBox(
          height: 40,
        ),

        TicketEnlargedWidget(
          // event: widget.event,
          palette: widget.palette,
          ticketOrder: widget.ticketOrder,
          hasEnded: _eventHasEnded,
          currency: widget.event.isFree || widget.event.rate.isEmpty
              ? ''
              : currencyPartition.length > 0
                  ? currencyPartition[1].trim()
                  : '',
          event: widget.event, ticket: widget.ticket,
          currentUserId: widget.currentUserId,
        ),
        // _ticketdisplay(),
        const SizedBox(
          height: 10,
        ),
        _eventInfoDisplay(),
        const SizedBox(
          height: 30,
        ),
        if (widget.ticketOrder.isInvited) _invitationButton(),
        _locationButton(),
        _eventRoomButton(),
        _organizerButton(),
        // const SizedBox(
        //   height: 10,
        // ),

        if (widget.currentUserId != widget.event.authorId)
          // if (!_eventHasEnded) _refundButton(),
          const SizedBox(
            height: 100,
          ),
        IconButton(
          icon: Icon(Icons.close),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }

  _programLineup() {
    List<Schedule> shedules = widget.event.schedule;
    List<Schedule> scheduleOptions = [];
    for (Schedule shedules in shedules) {
      Schedule sheduleOption = shedules;
      scheduleOptions.add(sheduleOption);
    }
    scheduleOptions
        .sort((a, b) => a.startTime.toDate().compareTo(b.startTime.toDate()));
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: ResponsiveHelper.responsiveHeight(context, 120)),
          child: _seeAllSchedules
              ? ScheduleGroup(
                  ticketEventDate: null,
                  from: '',
                  schedules: scheduleOptions,
                  isEditing: false,
                  eventOrganiserId: widget.event.authorId,
                  currentUserId: widget.currentUserId,
                )
              : ScheduleGroup(
                  ticketEventDate: widget.ticket.eventTicketDate,
                  from: '',
                  schedules: scheduleOptions,
                  isEditing: false,
                  eventOrganiserId: widget.event.authorId,
                  currentUserId: widget.currentUserId,
                ),

          // ListView.builder(
          //   itemCount: scheduleOptions.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     Schedule schedule = scheduleOptions[index];

          //     return ScheduleWidget(schedule: schedule);
          //   },
          // ),
        ),
        Positioned(
          top: 200,
          child: Container(
            width: ResponsiveHelper.responsiveFontSize(context, 320),
            height: 50,
            child: ShakeTransition(
              duration: const Duration(seconds: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Program\nLineup',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      //  24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (scheduleOptions.length > 1)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _seeAllSchedules = !_seeAllSchedules;
                        });
                      },
                      child: Text(
                        !_seeAllSchedules
                            ? 'See all'
                            : 'See for only this ticket',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          //  24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    // ListView(
    //   // physics: NeverScrollableScrollPhysics(),
    //   children: [
    //     const SizedBox(
    //       height: 80,
    //     ),
    //     Text(
    //       'Program\nLineup',
    //       style: TextStyle(
    //         fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
    //         //  24.0,
    //         fontWeight: FontWeight.bold,
    //         color: Colors.white,
    //       ),
    //     ),
    //     const SizedBox(
    //       height: 10,
    //     ),
    //     Container(
    //       height: 700,
    //       width: 500,
    //       child: ListView.builder(
    //         itemCount: scheduleOptions.length,
    //         itemBuilder: (BuildContext context, int index) {
    //           Schedule schedule = scheduleOptions[index];

    //           return ScheduleWidget(schedule: schedule);
    //         },
    //       ),
    //     ),
    //     // _eventInfoDisplay(),
    //     // const SizedBox(
    //     //   height: 30,
    //     // ),
    //     // if (widget.ticketOrder.isInvited) _invitationButton(),
    //     // _locationButton(),
    //     // _eventRoomButton(),
    //     // _organizerButton(),
    //     // const SizedBox(
    //     //   height: 10,
    //     // ),
    //     // if (!_eventHasEnded) _refundButton(),
    //     // const SizedBox(
    //     //   height: 100,
    //     // ),
    //     IconButton(
    //       icon: Icon(Icons.close),
    //       iconSize: 30.0,
    //       color: Colors.white,
    //       onPressed: () => Navigator.pop(context),
    //     ),
    //     const SizedBox(
    //       height: 100,
    //     ),
    //   ],
    // );
  }

  _indicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _index == index ? 2 : 5,
      width: _index == index ? 20 : 50,
      decoration: BoxDecoration(
          color: Colors.transparent,
          // shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        centerTitle: false,
        title: Text(
          widget.ticket.type,
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
            Positioned(
              top: 120,
              child: Row(
                children: [
                  _indicator(1),
                  const SizedBox(
                    width: 5,
                  ),
                  _indicator(0),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: PageView(
                //  controller: _pageController,
                onPageChanged: (int index) {
                  // HapticFeedback.lightImpact();
                  setState(() {
                    _index = index;
                  });
                },
                children: [
                  _ticket(),
                  _programLineup(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
