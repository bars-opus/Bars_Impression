import 'package:bars/utilities/exports.dart';

class TicketEnlargedWidget extends StatelessWidget {
  final TicketOrderModel ticketOrder;
  final TicketPurchasedModel ticket;

  // final Event event;
  final PaletteGenerator palette;
  final bool onInvite;
  final bool hasEnded;
  final String currency;
  final Event event;

  final String currentUserId;

  const TicketEnlargedWidget({
    super.key,
    required this.ticketOrder,
    required this.currency,
    required this.palette,
    this.onInvite = false,
    required this.hasEnded,
    required this.event,
    required this.ticket,
    required this.currentUserId,
  });

  // display event dates and schedules on calendar
  void _showBottomSheetCalendar(BuildContext context, Color palletColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                Icon(
                  Icons.horizontal_rule,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: ResponsiveHelper.responsiveHeight(context, 30.0),
                ),
                const SizedBox(
                  height: 30,
                ),
                TableCalendar(
                  pageAnimationCurve: Curves.easeInOut,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  calendarFormat: CalendarFormat.month,
                  availableGestures: AvailableGestures.horizontalSwipe,
                  rowHeight: ResponsiveHelper.responsiveHeight(context, 45.0),
                  daysOfWeekHeight:
                      ResponsiveHelper.responsiveHeight(context, 30),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: palletColor, // Choose a color for the focused day
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    holidayTextStyle: TextStyle(color: Colors.red),
                    outsideDaysVisible: true,
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 20),
                    ),
                    // formatButtonDecoration: BoxDecoration(
                    //   color: Colors.blue,
                    //   borderRadius: BorderRadius.circular(20.0),
                    // ),
                    formatButtonVisible: false,
                    formatButtonTextStyle: TextStyle(color: Colors.white),
                    formatButtonShowsNext: false,
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                  ),
                  firstDay: ticket.eventTicketDate.toDate(),
                  focusedDay: ticket.eventTicketDate.toDate(),
                  lastDay: ticket.eventTicketDate.toDate(),
                  selectedDayPredicate: (DateTime day) {
                    // Use a comparison here to determine if the day is the selected day
                    return isSameDay(day, ticket.eventTicketDate.toDate());
                  },
                ),
                Text(
                  'The event for this ticket would take place on ${MyDateFormat.toDate(ticket.eventTicketDate.toDate()).toString()}.  If you have purchased multiple tickets for this event, each ticket date might vary, so please take notice',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Color _palleteColor = palette == null
        ? Colors.grey
        : palette.vibrantColor == null
            ? Colors.grey
            : palette.vibrantColor!.color;

    final width = MediaQuery.of(context).size.width;

    bool _isRefunded = ticketOrder.refundRequestStatus == 'processed';
    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Theme.of(context).secondaryHeaderColor,
      decoration:
          _isRefunded ? TextDecoration.lineThrough : TextDecoration.none,
    );

    // var _textStyle2 = Theme.of(context).textTheme.bodyMedium;
    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

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
            children: [
              if (hasEnded)
                Text(
                  '\n\nCompleted',
                  style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      //  14.0,

                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              if (!ticket.validated)
                const SizedBox(
                  height: 70,
                ),
              if (ticket.validated)
                Padding(
                  padding:
                      const EdgeInsets.only(right: 30.0, top: 40, bottom: 30),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 20.0,
                    ),
                  ),
                ),
              if (ticketOrder.isInvited)
                Icon(
                  FontAwesomeIcons.idBadge,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: onInvite ? 0 : 30.0,
                ),
              if (ticketOrder.isInvited || onInvite)
                const SizedBox(
                  height: 10,
                ),
              if (ticketOrder.isInvited)
                Text(
                  onInvite ? 'YOUR TICKET' : 'CORDIALLY\nINVITED',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              if (ticketOrder.isInvited)
                const SizedBox(
                  height: 30,
                ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10),
                  child: ShakeTransition(
                    duration: const Duration(seconds: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: QrImageView(
                        version: QrVersions.auto,
                        foregroundColor:
                            ticket.validated ? _palleteColor : Colors.grey,
                        backgroundColor: Colors.transparent,
                        data: ticket.entranceId,
                        size: ResponsiveHelper.responsiveFontSize(
                            context, _isRefunded ? 40 : 200),
                      ),
                    ),
                  )),
              if (ticket.entranceId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                  ),
                  child: Text(
                    ticket.entranceId.substring(0, 4),
                    style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 30.0),
                        color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 70.0, bottom: 30),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Container(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: GestureDetector(
                    onTap: () {
                      _showBottomSheetCalendar(context, _palleteColor);
                    },
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Check-in number:   ', style: _textStyle),
                          if (ticket.entranceId.isNotEmpty)
                            TextSpan(
                              text: ticket.entranceId.substring(0, 4),
                              style: _textStyle2,
                            ),
                          TextSpan(
                              text: '\nInvited:                     ',
                              style: _textStyle),
                          TextSpan(
                            text: ticketOrder.isInvited.toString(),
                            style: _textStyle2,
                          ),
                          TextSpan(
                              text: '\nTicket event date:   ',
                              style: _textStyle),
                          TextSpan(
                            text: MyDateFormat.toDate(
                                    ticket.eventTicketDate.toDate())
                                .toString()
                                .substring(
                                    0,
                                    ticket.eventTicketDate
                                            .toDate()
                                            .toString()
                                            .length -
                                        2),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Container(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    right: 12,
                  ),
                  child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sales Receipt',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: '\n\nOrder number:      ',
                          style: _textStyle,
                        ),
                        if (ticketOrder.orderId.isNotEmpty)
                          TextSpan(
                            text: ticketOrder.orderId.substring(0, 4),
                            style: _textStyle2,
                          ),
                        if (ticket.type.isNotEmpty)
                          TextSpan(
                            text: '\nTicket type:           ',
                            style: _textStyle,
                          ),
                        if (ticket.type.isNotEmpty)
                          TextSpan(
                            text: ticket.type,
                            style: _textStyle2,
                          ),
                        if (ticket.group.isNotEmpty)
                          TextSpan(
                            text: '\nTicket group:         ',
                            style: _textStyle,
                          ),
                        if (ticket.group.isNotEmpty)
                          TextSpan(
                            text: ticket.group,
                            style: _textStyle2,
                          ),
                        if (ticket.accessLevel.isNotEmpty)
                          TextSpan(
                            text: '\nAccess level:         ',
                            style: _textStyle,
                          ),
                        if (ticket.accessLevel.isNotEmpty)
                          TextSpan(
                            text: ticket.accessLevel,
                            style: _textStyle2,
                          ),
                        TextSpan(
                          text: '\nPurchased time:    ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: MyDateFormat.toTime(
                              ticketOrder.timestamp!.toDate()),
                          style: _textStyle2,
                        ),
                        TextSpan(
                          text: '\nPurchased date:    ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: MyDateFormat.toDate(
                              ticketOrder.timestamp!.toDate()),
                          style: _textStyle2,
                        ),
                        TextSpan(
                          text: '\nTotal:                     ',
                          style: _textStyle,
                        ),
                        TextSpan(
                          text: "$currency ${ticket.price.toString()}",
                          style: _textStyle2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 30),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12),
                child: ticketOrder.userOrderId == event.authorId
                    ? GestureDetector(
                        onTap: () {
                          _navigateToPage(
                              context,
                              EventDashboardScreen(
                                // askCount: 0,
                                currentUserId: event.authorId,
                                event: event,
                                palette: palette,
                              ));
                        },
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              if (ticket.entranceId.isNotEmpty)
                                TextSpan(
                                  text:
                                      'Your check-in number, also known as your attendee number, is ${ticket.entranceId.substring(0, 4)}. This number is generated for you automatically. As the event organizer, your ticket is free and already validated.\n\nTo validate attendees, use the ticket scanner on your ',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 12.0),
                                  ),
                                ),
                              TextSpan(
                                text: 'event dashboard.\n\n',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                ),
                              ),
                              TextSpan(
                                text:
                                    'Validated tickets will have their barcode color match your current ticket barcode color, and attendees will receive a blue verified badge at the right corner of their tickets. Best wishes for your event!',
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Text(
                        ticket.entranceId.isNotEmpty
                            ? ''
                            : 'Your check-in number, also known as your attendee number, is ${ticket.entranceId.substring(0, 4)}. This number will be validated at the entrance of this event before you can enter. Once this ticket has been validated, the color of the barcode on the ticket will change, and a blue verified badge is placed at the top right corner of the ticket.  Enjoy attending this event and have a great time!',
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 12.0),
                        ),
                        textAlign: TextAlign.start,
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
}
