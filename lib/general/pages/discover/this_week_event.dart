import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

class ThisWeekEvent extends StatefulWidget {
  final Event event;
  final List<Event> currentEventList;
  final List<DocumentSnapshot> currentEventSnapShot;
  final int sortNumberOfDays;

  const ThisWeekEvent(
      {super.key,
      required this.event,
      required this.currentEventList,
      required this.currentEventSnapShot,
      required this.sortNumberOfDays});

  @override
  State<ThisWeekEvent> createState() => _ThisWeekEventState();
}

class _ThisWeekEventState extends State<ThisWeekEvent> {
  bool _checkingTicketAvailability = false;

  bool _eventHasStarted = false;
  bool _eventHasEnded = false;

  @override
  void initState() {
    super.initState();
    _countDown();
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetTermsAndConditions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TicketPurchasingIcon(
                        title: '',
                      ),
                      _checkingTicketAvailability
                          ? SizedBox(
                              height: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              width: ResponsiveHelper.responsiveHeight(
                                  context, 10.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ),
                            )
                          : MiniCircularProgressButton(
                              color: Colors.blue,
                              text: 'Continue',
                              onPressed: () async {
                                if (mounted) {
                                  setState(() {
                                    _checkingTicketAvailability = true;
                                  });
                                }
                                await _attendMethod();
                                if (mounted) {
                                  setState(() {
                                    _checkingTicketAvailability = false;
                                  });
                                }
                              })
                    ],
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Terms and Conditions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "\n\n${widget.event.termsAndConditions}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _attendMethod() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    Provider.of<UserData>(context, listen: false).ticketList.clear();

    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _checkingTicketAvailability = true;
      });
    }

    TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
        widget.event.id, _provider.currentUserId!);

    if (_ticket != null) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.event.imageUrl),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      _navigateToPage(
        context,
        PurchasedAttendingTicketScreen(
          ticketOrder: _ticket,
          event: widget.event,
          currentUserId: _provider.currentUserId!,
          justPurchased: 'Already',
          palette: _paletteGenerator,
        ),
      );
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _checkingTicketAvailability = false;
        });
        _showBottomSheetAttendOptions(context, widget.event);
      }
    }
  }

  // Ticket options purchase entry
  void _showBottomSheetAttendOptions(BuildContext context, Event currentEvent) {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          List<TicketModel> tickets = currentEvent.ticket;
          Map<String, List<TicketModel>> ticketsByGroup = {};
          for (TicketModel ticket in tickets) {
            if (!ticketsByGroup.containsKey(ticket.group)) {
              ticketsByGroup[ticket.group] = [];
            }
            ticketsByGroup[ticket.group]!.add(ticket);
          }
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TicketPurchasingIcon(
                    // icon: Icons.close,
                    title: 'Ticket packages.',
                  ),
                ),
                TicketGroup(
                  currentUserId: _provider.currentUserId!,
                  groupTickets: currentEvent.ticket,
                  event: currentEvent,
                  inviteReply: '',
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    String startDate = MyDateFormat.toDate(widget.event.startDate.toDate());
    String _startDate = startDate.substring(0, startDate.length - 5);
    List<TicketModel> tickets = widget.event.ticket;
    double _fristTickePrice = tickets.isNotEmpty ? tickets[0].price : 0.0;
    final List<String> currencyPartition =
        widget.event.rate.trim().replaceAll('\n', ' ').split("|");
    return GestureDetector(
      onTap: () {
        int eventIndex =
            widget.currentEventList.indexWhere((p) => p.id == widget.event.id);

        _navigateToPage(
            context,
            EventPages(
              types: 'All',
              event: widget.event,
              currentUserId: _provider.currentUserId!,
              eventList: widget.currentEventList,
              eventSnapshot: widget.currentEventSnapShot,
              liveCity: '',
              liveCountry: '',
              isFrom: '',
              // seeMoreFrom: seeMoreFrom,
              sortNumberOfDays: 7,

              eventIndex: eventIndex,
            ));
      },
      child: Stack(
        // alignment: FractionalOffset.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 0.5),
            child: Container(
              height: ResponsiveHelper.responsiveHeight(
                context,
                600,
              ),
              width: ResponsiveHelper.responsiveWidth(
                context,
                200,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ResponsiveHelper.responsiveHeight(
                      context,
                      200,
                    ),
                    width: ResponsiveHelper.responsiveWidth(
                      context,
                      200,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image:
                            CachedNetworkImageProvider(widget.event.imageUrl),
                        fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.event.title.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).secondaryHeaderColor,
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 20.0),
                            fontWeight: FontWeight.w400,
                          ),
                          // maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.event.theme,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                                context, 14.0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${widget.event.city} ${widget.event.country}",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.event.isFree
                              ? 'Free'
                              : currencyPartition.length > 0 ||
                                      widget.event.rate.isNotEmpty
                                  ? "${currencyPartition[1]}${_fristTickePrice.toString()}"
                                  : _fristTickePrice.toString(),
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14.0),
                            // fontSize: 18,
                            color: _eventHasEnded ? Colors.grey : Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        if (_eventHasStarted)
                          Text(
                            _eventHasEnded ? 'Completed' : 'Ongoing',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12.0),
                              color: _eventHasEnded ? Colors.red : Colors.blue,
                              // fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!_eventHasEnded)
            if (widget.event.authorId != _provider.currentUserId)
              Positioned(
                bottom: 20,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      width: ResponsiveHelper.responsiveHeight(
                        context,
                        100,
                      ),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(
                            width: 0.5,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: _checkingTicketAvailability
                              ? SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Attend',
                                  style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 14.0),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  )),
                        ),
                        onPressed: widget.event.termsAndConditions.isNotEmpty
                            ? () {
                                _showBottomSheetTermsAndConditions();
                              }
                            : () async {
                                _attendMethod();
                              },

                        //  () async {
                        //   HapticFeedback.lightImpact();
                        //   if (mounted) {
                        //     setState(() {
                        //       _checkingTicketAvailability = true;
                        //     });
                        //   }

                        //   TicketOrderModel? _ticket =
                        //       await DatabaseService.getTicketWithId(
                        //           widget.event.id, _provider.currentUserId!);

                        //   if (_ticket != null) {
                        //     PaletteGenerator _paletteGenerator =
                        //         await PaletteGenerator.fromImageProvider(
                        //       CachedNetworkImageProvider(widget.event.imageUrl),
                        //       size: Size(1110, 150),
                        //       maximumColorCount: 20,
                        //     );

                        //     _navigateToPage(
                        //       context,
                        //       EventsAttendingTicketScreen(
                        //         ticketOrder: _ticket,
                        //         event: widget.event,
                        //         currentUserId: _provider.currentUserId!,
                        //         justPurchased: 'Already',
                        //         palette: _paletteGenerator,
                        //       ),
                        //     );
                        //     if (mounted) {
                        //       setState(() {
                        //         _checkingTicketAvailability = false;
                        //       });
                        //     }
                        //   } else {
                        //     if (mounted) {
                        //       setState(() {
                        //         _checkingTicketAvailability = false;
                        //       });
                        //       _showBottomSheetAttendOptions(
                        //           context, widget.event);
                        //     }
                        //   }
                        // },

                        //  () {
                        //   HapticFeedback.mediumImpact();
                        //   _showBottomSheetAttendOptions(context, event);
                        // },
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
