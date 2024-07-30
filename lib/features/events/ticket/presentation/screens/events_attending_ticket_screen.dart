import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

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
    return MapsLauncher.launchQuery(widget.event.address);
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
                  thickness: .3,
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

  //  This button leads to either the event's location on a map or the event's virtual venue,
  //  depending on whether the event is virtual or not.
  _locationButton() {
    return EventBottomButton(
      buttonText: widget.event.isVirtual ? 'Host link' : 'Event location',
      onPressed: () {
        // widget.event.isVirtual
        //     ? _navigateToPage(
        //         context,
        //         MyWebView(
        //           title: '',
        //           url: widget.event.virtualVenue,
        //         ))
        // :
        _launchMap();
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
            _isLoading = false;
          },
        ),
        _isLoading
            ? SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blue,
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
                  color: Colors.blue,
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

  _ticket() {
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");

    return ListView(
      children: [
        const SizedBox(
          height: 40,
        ),
        const SizedBox(
          height: 40,
        ),
        TicketEnlargedWidget(
          palette: widget.palette,
          ticketOrder: widget.ticketOrder,
          hasEnded: _eventHasEnded,
          currency: widget.event.isFree || widget.event.rate.isEmpty
              ? ''
              : currencyPartition.length > 0
                  ? currencyPartition[1].trim()
                  : '',
          event: widget.event,
          ticket: widget.ticket,
          currentUserId: widget.currentUserId,
        ),
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
        if (widget.currentUserId != widget.event.authorId)
          const SizedBox(
            height: 100,
          ),
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
                    parentContentId: widget.ticketOrder.eventId,
                    authorId: widget.currentUserId,
                    complainContentId: widget.ticketOrder.orderId,
                    complainType: 'TicketOrder',
                    parentContentAuthorId: widget.ticketOrder.eventAuthorId,
                  ));
            },
            child: Text(
              '\nComplain an issue.',
              style: TextStyle(
                color: Colors.blue,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
              textAlign: TextAlign.start,
            ),
          ),
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
              ? ShakeTransition(
                  curve: Curves.linearToEaseOut,
                  offset: -100,
                  duration: const Duration(seconds: 1),
                  child: ScheduleGroup(
                    ticketEventDate: null,
                    from: '',
                    schedules: scheduleOptions,
                    isEditing: false,
                    eventOrganiserId: widget.event.authorId,
                    currentUserId: widget.currentUserId,
                  ),
                )
              : ScheduleGroup(
                  ticketEventDate: widget.ticket.eventTicketDate,
                  from: '',
                  schedules: scheduleOptions,
                  isEditing: false,
                  eventOrganiserId: widget.event.authorId,
                  currentUserId: widget.currentUserId,
                ),
        ),
        Positioned(
          top: 200,
          child: Container(
            width: ResponsiveHelper.responsiveFontSize(context, 320),
            height: ResponsiveHelper.responsiveFontSize(context, 50),
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
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
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
  }

  _indicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: _index == index ? 2 : 5,
      width: _index == index ? 20 : 50,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(width: 2, color: Colors.white)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        surfaceTintColor: Colors.transparent,
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
                onPageChanged: (int index) {
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
