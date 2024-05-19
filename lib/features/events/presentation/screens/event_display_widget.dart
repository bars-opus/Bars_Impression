import 'dart:ui';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class EventDisplayWidget extends StatefulWidget {
  final String currentUserId;
  final Event event;
  List<Event> eventList;
  List<DocumentSnapshot> eventSnapshot;
  final int pageIndex;
  final bool eventPagesOnly;

  final String liveCity;
  final String liveCountry;
  final int sortNumberOfDays;
  final String isFrom;

  EventDisplayWidget({
    required this.currentUserId,
    required this.event,
    required this.eventList,
    required this.eventSnapshot,
    required this.pageIndex,
    required this.eventPagesOnly,
    required this.liveCity,
    required this.liveCountry,
    // required this.seeMoreFrom,
    required this.sortNumberOfDays,
    required this.isFrom,
    //  required this.fromThisWeekOrFree,
  });

  @override
  State<EventDisplayWidget> createState() => _EventDisplayWidgetState();
}

class _EventDisplayWidgetState extends State<EventDisplayWidget> {
  bool _eventHasStarted = false;
  bool _eventHasEnded = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _countDown();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).ticketList.clear();
    });
  }

  void _countDown() async {
    if (EventHasStarted.hasEventStarted(widget.event.startDate.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasStarted = true;
        });
      }
    }

    if (EventHasStarted.hasEventEnded(widget.event.clossingDay.toDate())) {
      if (mounted) {
        setState(() {
          _eventHasEnded = true;
        });
      }
    }
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 4,
    double sigmaY = 4,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthor = widget.currentUserId == widget.event.authorId;
    List<TicketModel> tickets = widget.event.ticket;
    double _fristTickePrice = tickets.isNotEmpty ? tickets[0].price : 0.0;
    String startDate = MyDateFormat.toDate(widget.event.startDate.toDate());
    String _startDate = startDate.substring(0, startDate.length - 5);
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");

    void _showBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EventBottomModalSheetActions(
            event: widget.event,
            currentUserId: widget.currentUserId,
            eventHasEnded: _eventHasEnded,
          );
        },
      );
    }

    return FocusedMenuAction(
      onPressedReport: () {
        isAuthor
            ? _navigateToPage(
                context,
                EditEventScreen(
                  currentUserId: widget.currentUserId,
                  event: widget.event,
                  isCompleted: _eventHasEnded,
                ),
              )
            : _navigateToPage(
                context,
                ReportContentPage(
                  contentId: widget.event.id,
                  parentContentId: widget.event.id,
                  repotedAuthorId: widget.event.authorId,
                  contentType: 'event',
                ));
      },
      onPressedSend: () {
        _navigateToPage(
          context,
          SendToChats(
            currentUserId: widget.currentUserId,
            sendContentType: 'Event',
            sendContentId: widget.event.id,
            sendImageUrl: widget.event.imageUrl,
            sendTitle: widget.event.title,
          ),
        );
      },
      onPressedShare: () async {
        Share.share(widget.event.dynamicLink);
      },
      isAuthor: isAuthor,
      child: GestureDetector(
        onTap: _isNavigating
            ? () {}
            : () async {
                _isNavigating = true;

                int eventIndex =
                    widget.eventList.indexWhere((p) => p.id == widget.event.id);
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => widget.eventPagesOnly
                            ? EventPages(
                                types: 'All',
                                event: widget.event,
                                currentUserId: widget.currentUserId,
                                eventList: widget.eventList,
                                eventSnapshot: widget.eventSnapshot,
                                eventIndex: eventIndex,
                                liveCity: widget.liveCity,
                                liveCountry: widget.liveCountry,
                                sortNumberOfDays: widget.sortNumberOfDays,
                                isFrom: widget.isFrom,
                              )
                            : EventPageView(
                                event: widget.event,
                                currentUserId: widget.currentUserId,
                                eventList: widget.eventList,
                                eventSnapshot: widget.eventSnapshot,
                                eventIndex: eventIndex,
                                pageIndex: widget.pageIndex,
                                key: ValueKey('EventPageView1'),
                                liveCity: widget.liveCity,
                                liveCountry: widget.liveCountry,
                                sortNumberOfDays: widget.sortNumberOfDays,
                                isFrom: widget.isFrom,
                              )));
                _isNavigating = false;
              },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        image:
                            CachedNetworkImageProvider(widget.event.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: widget.event.report.isNotEmpty
                        ? Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.7),
                            ),
                            child: ShakeTransition(
                              child: Icon(
                                MdiIcons.eyeOff,
                                color: Colors.white,
                                size: ResponsiveHelper.responsiveHeight(
                                    context, 20.0),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  SizedBox(
                    width: ResponsiveHelper.responsiveWidth(context, 10.0),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title.toUpperCase(),
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.event.theme,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (!_eventHasEnded)
                          Text(
                            _startDate,
                            style: Theme.of(context).textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          widget.event.venue,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.event.city} ${widget.event.country}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Divider(
                          color: Theme.of(context).primaryColor, thickness: .3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: ResponsiveHelper.responsiveWidth(context, 80.0),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        _showBottomSheet(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.more_vert_rounded,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 20),
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          Text(
                            widget.event.isFree
                                ? 'Free'
                                : currencyPartition.length > 0
                                    ? " ${currencyPartition[1]}\n${_fristTickePrice.toString()}"
                                    : _fristTickePrice.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              color: _eventHasEnded ? Colors.grey : Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.end,
                          ),
                          // _eventHasStarted
                          //     ? Text(
                          //         "Ongoing...",
                          //         style: TextStyle(
                          //           fontSize:
                          //               ResponsiveHelper.responsiveFontSize(
                          //                   context, 12.0),
                          //           color: Colors.blue,
                          //           // fontWeight: FontWeight.bold,
                          //         ),
                          //         textAlign: TextAlign.end,
                          //       )
                          //     : _eventHasEnded
                          //         ?

                          // _eventHasStarted
                          //     ? Text(
                          //         _eventHasEnded ? 'Completed' : 'Ongoing',
                          //         style: TextStyle(
                          //           fontSize:
                          //               ResponsiveHelper.responsiveFontSize(
                          //                   context, 12.0),
                          //           color: _eventHasEnded
                          //               ? Colors.red
                          //               : Colors.blue,
                          //           fontWeight: FontWeight.bold,
                          //         ),
                          //         textAlign: TextAlign.end,
                          //       )
                          //     :

                          CountdownTimer(
                            split: 'Single',
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14.0),
                            color: Theme.of(context).secondaryHeaderColor,
                            clossingDay: DateTime.now(),
                            startDate: widget.event.startDate.toDate(),
                            eventHasEnded: _eventHasEnded,
                            eventHasStarted: _eventHasStarted,
                          ),
                          if (widget.event.isPrivate)
                            Text(
                              "private.",
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12.0),
                                color: Colors.blue,
                                // fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
