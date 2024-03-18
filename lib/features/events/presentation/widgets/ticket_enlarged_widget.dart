import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class TicketEnlargedWidget extends StatefulWidget {
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

  @override
  State<TicketEnlargedWidget> createState() => _TicketEnlargedWidgetState();
}

class _TicketEnlargedWidgetState extends State<TicketEnlargedWidget> {
  bool _isValidated = false;
  bool _isScanning = false;
  bool init = true;
  Timer? _delayTimer;
  StreamSubscription<DocumentSnapshot>? _ticketSubscription;

  @override
  void initState() {
    super.initState();
    _isValidated = widget.ticket.validated;
    // stopInit();
  }

  @override
  void dispose() {
    _ticketSubscription?.cancel();
    _delayTimer?.cancel();
    super.dispose();
  }

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
                  firstDay: widget.ticket.eventTicketDate.toDate(),
                  focusedDay: widget.ticket.eventTicketDate.toDate(),
                  lastDay: widget.ticket.eventTicketDate.toDate(),
                  selectedDayPredicate: (DateTime day) {
                    // Use a comparison here to determine if the day is the selected day
                    return isSameDay(
                        day, widget.ticket.eventTicketDate.toDate());
                  },
                ),
                Text(
                  'The event for this ticket would take place on ${MyDateFormat.toDate(widget.ticket.eventTicketDate.toDate()).toString()}.  If you have purchased multiple tickets for this event, each ticket date might vary, so please take notice',
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
    // Color _palleteColor = widget.palette == null
    //     ? Colors.blue
    //     : widget.palette.vibrantColor == null
    //         ? Colors.blue
    //         : widget.palette.vibrantColor!.color;

    Color _palleteColor =
        Utils.getPaletteVibrantColor(widget.palette, Colors.blue);
    final width = MediaQuery.of(context).size.width;

    String entranceIdSubstring =
        Utils.safeSubstring(widget.ticket.entranceId, 0, 4);

    String orderIdSubstring =
        Utils.safeSubstring(widget.ticketOrder.orderNumber, 0, 4);

    bool _isRefunded = widget.ticketOrder.refundRequestStatus == 'processed';
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
              if (_isScanning)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LinearProgress(),
                ),
              if (widget.hasEnded)
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
              if (!_isValidated)
                const SizedBox(
                  height: 70,
                ),
              if (_isValidated)
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
              if (widget.ticketOrder.isInvited)
                Icon(
                  FontAwesomeIcons.idBadge,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: widget.onInvite ? 0 : 30.0,
                ),
              if (widget.ticketOrder.isInvited || widget.onInvite)
                const SizedBox(
                  height: 10,
                ),
              if (widget.ticketOrder.isInvited)
                Text(
                  widget.onInvite ? 'YOUR TICKET' : 'CORDIALLY\nINVITED',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              if (widget.ticketOrder.isInvited)
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
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: _isValidated ? _palleteColor : Colors.grey,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: _isValidated ? _palleteColor : Colors.grey,
                        ),

                        backgroundColor: Colors.transparent,
                        data:
                            '${widget.ticketOrder.userOrderId} | ${widget.ticket.entranceId}',
                        // ticket.entranceId,
                        size: ResponsiveHelper.responsiveFontSize(
                            context, _isRefunded ? 40 : 200),
                      ),
                    ),
                  )),
              if (widget.ticket.entranceId.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                  ),
                  child: Text(
                    entranceIdSubstring,
                    // widget.ticket.entranceId.substring(0, 4),
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
                  child: Column(
                    children: [
                      if (widget.ticket.entranceId.isNotEmpty)
                        SalesReceiptWidget(
                          width: 110,
                          isRefunded: _isRefunded,
                          lable: 'Check-in number',
                          value: entranceIdSubstring,
                          // widget.ticket.entranceId.substring(0, 4),
                        ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Invited',
                        value: widget.ticketOrder.isInvited.toString(),
                      ),
                      GestureDetector(
                        onTap: () {
                          _showBottomSheetCalendar(context, _palleteColor);
                        },
                        child: SalesReceiptWidget(
                            width: 110,
                            color: Colors.blue,
                            isRefunded: _isRefunded,
                            lable: 'Ticket event date',
                            value: MyDateFormat.toDate(
                                    widget.ticket.eventTicketDate.toDate())
                                .toString()),
                      ),
                    ],
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Receipt',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Order number',
                        value: orderIdSubstring,

                        //  widget.ticketOrder.orderNumber.substring(0, 4),
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Ticket type',
                        value: widget.ticket.type,
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Ticket group',
                        value: widget.ticket.group,
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Access level',
                        value: widget.ticket.accessLevel,
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Purchased time:',
                        value: MyDateFormat.toTime(
                            widget.ticketOrder.timestamp!.toDate()),
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Purchased date:',
                        value: MyDateFormat.toDate(
                            widget.ticketOrder.timestamp!.toDate()),
                      ),
                      SalesReceiptWidget(
                        width: 110,
                        isRefunded: _isRefunded,
                        lable: 'Total',
                        value: widget.event.isFree
                            ? 'Free'
                            : '${widget.currency} ${widget.ticket.price.toString()}',
                      ),
                    ],
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
                child: widget.ticketOrder.userOrderId == widget.event.authorId
                    ? GestureDetector(
                        onTap: () {
                          _navigateToPage(
                              context,
                              EventDashboardScreen(
                                // askCount: 0,
                                currentUserId: widget.event.authorId,
                                event: widget.event,
                                palette: widget.palette,
                              ));
                        },
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(
                            children: [
                              if (widget.ticket.entranceId.isNotEmpty)
                                TextSpan(
                                  text:
                                      'Your check-in number, also known as your attendee number, is $orderIdSubstring. This number is generated for you automatically. As the event organizer, your ticket is free and already validated.\n\nTo validate attendees, use the ticket scanner on your ',
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
                        widget.ticket.entranceId.isNotEmpty
                            ? ''
                            : 'Your check-in number, also known as your attendee number, is $orderIdSubstring. This number will be validated at the entrance of this event before you can enter. Once this ticket has been validated, the color of the barcode on the ticket will change, and a blue verified badge is placed at the top right corner of the ticket.  Enjoy attending this event and have a great time!',
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
