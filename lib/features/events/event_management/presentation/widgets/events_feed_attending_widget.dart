import 'package:bars/utilities/exports.dart';

class EventsFeedAttendingWidget extends StatefulWidget {
  final TicketOrderModel ticketOrder;
  final String currentUserId;
  final bool disableMoreVert;
  final List<TicketOrderModel> ticketList;

  const EventsFeedAttendingWidget({
    required this.ticketOrder,
    required this.currentUserId,
    required this.ticketList,
    this.disableMoreVert = false,
  });

  @override
  State<EventsFeedAttendingWidget> createState() =>
      _EventsFeedAttendingWidgetState();
}

class _EventsFeedAttendingWidgetState extends State<EventsFeedAttendingWidget> {
  bool _isLoading = false;

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetErrorMessage(String title) {
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
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _launchMap(Event event) {
    return MapsLauncher.launchQuery(event.address);
  }

  void _showBottomSheetClearActivity() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: 'Delete tickets',
          onPressed: () async {
            Navigator.pop(context);

            try {
              String orderId = widget.ticketOrder.orderId;

              widget.ticketList
                  .removeWhere((ticket) => ticket.orderId == orderId);
              await DatabaseService.deleteTicket(
                  ticketOrder: widget.ticketOrder);
              setState(() {});
            } catch (e) {
              _showBottomSheetErrorMessage('Failed to delete ticket');
            }
            mySnackBar(context, "Ticket deleted successfully");
          },
          title: 'Are you sure you want to delete this ticket? ',
          subTitle:
              'Deleting this ticket will result in the loss of access to this event and it\'s room. Deleted tickets would be refunded."',
        );
      },
    );
  }

  void _showBottomSheetMore(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 370.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    widget.ticketOrder.eventTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  height: ResponsiveHelper.responsiveHeight(context, 250.0),
                  // color: Colors.red,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 2),
                      child: MyBottomModelSheetAction(actions: [
                        const SizedBox(
                          height: 40,
                        ),
                        Stack(
                          alignment: FractionalOffset.center,
                          children: [
                            BottomModelSheetListTileActionWidget(
                              colorCode:
                                  widget.ticketOrder.isDeleted ? 'Grey' : '',
                              icon: Icons.event_available_outlined,
                              onPressed: widget.ticketOrder.isDeleted
                                  ? () {
                                      _showBottomDeletedEvent(context);
                                    }
                                  : () async {
                                      _isLoading = true;
                                      try {
                                        Event? event = await DatabaseService
                                            .getUserEventWithId(
                                                widget.ticketOrder.eventId,
                                                widget
                                                    .ticketOrder.eventAuthorId);

                                        if (event != null) {
                                          _navigateToPage(EventEnlargedScreen(
                                            currentUserId: widget.currentUserId,
                                            event: event,
                                            type: event.type, showPrivateEvent: true,
                                          ));
                                        } else {
                                          _showBottomSheetErrorMessage(
                                              'Failed to fetch event.');
                                        }
                                      } catch (e) {
                                        _showBottomSheetErrorMessage(
                                            'Failed to fetch event');
                                      } finally {
                                        _isLoading = false;
                                      }
                                    },
                              text: 'View event',
                            ),
                            _isLoading
                                ? Positioned(
                                    right: 30,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                        Stack(
                          alignment: FractionalOffset.center,
                          children: [
                            BottomModelSheetListTileActionWidget(
                              colorCode:
                                  widget.ticketOrder.isDeleted ? 'Grey' : '',
                              icon: Icons.location_on_outlined,
                              onPressed: widget.ticketOrder.isDeleted
                                  ? () {
                                      _showBottomDeletedEvent(context);
                                    }
                                  : () async {
                                      _isLoading = true;
                                      try {
                                        Event? event = await DatabaseService
                                            .getUserEventWithId(
                                                widget.ticketOrder.eventId,
                                                widget
                                                    .ticketOrder.eventAuthorId);
                                        if (event != null) {
                                          _launchMap(event);
                                        } else {
                                          _showBottomSheetErrorMessage(
                                              'Failed to launch map.');
                                        }
                                      } catch (e) {
                                        _showBottomSheetErrorMessage(
                                            'Failed to launch map');
                                      } finally {
                                        _isLoading = false;
                                      }
                                    },
                              text: 'Acces location',
                            ),
                            _isLoading
                                ? Positioned(
                                    right: 30,
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink()
                          ],
                        ),
                        BottomModelSheetListTileActionWidget(
                          colorCode: '',
                          icon: Icons.delete_outlined,
                          onPressed: () {
                            _showBottomSheetClearActivity();
                          },
                          text: 'Delete ticket',
                        ),
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: () {
                      _navigateToPage(CompainAnIssue(
                        parentContentId: widget.ticketOrder.eventId,
                        authorId: widget.currentUserId,
                        complainContentId: widget.ticketOrder.orderId,
                        complainType: 'TicketOrder',
                        parentContentAuthorId: widget.ticketOrder.eventAuthorId,
                      ));
                    },
                    child: Text(
                      'Complain an issue.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showBottomDeletedEvent(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return EventDeletedMessageWidget(
            currentUserId: widget.currentUserId,
            ticketOrder: widget.ticketOrder,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> datePartition = widget.ticketOrder.eventTimestamp == null
        ? MyDateFormat.toDate(DateTime.now()).split(" ")
        : MyDateFormat.toDate(widget.ticketOrder.eventTimestamp!.toDate())
            .split(" ");

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          trailing: _isLoading
              ? SizedBox(
                  height: ResponsiveHelper.responsiveHeight(context, 20),
                  width: ResponsiveHelper.responsiveHeight(context, 20),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.blue,
                  ),
                )
              : Container(
                  width: ResponsiveHelper.responsiveWidth(context, 70),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.ticketOrder.isDeleted)
                        //     ?
                        Icon(
                          Icons.remove_outlined,
                          color: Colors.grey,
                          size: 20.0,
                        ),
                      // : SizedBox.shrink(),
                      if (!widget.disableMoreVert)
                        IconButton(
                            onPressed: () {
                              _showBottomSheetMore(context);
                            },
                            icon: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                    ],
                  ),
                ),
          onTap: widget.ticketOrder.isDeleted
              ? () {
                  _showBottomDeletedEvent(context);
                }
              : () async {
                  // print(widget.ticketOrder.eventAuthorId );
                  if (_isLoading) return;
                  _isLoading = true;
                  try {
                    Event? event = await DatabaseService.getUserEventWithId(
                        widget.ticketOrder.eventId,
                        widget.ticketOrder.eventAuthorId);

                    if (event != null) {
                      PaletteGenerator _paletteGenerator =
                          await PaletteGenerator.fromImageProvider(
                        CachedNetworkImageProvider(event.imageUrl),
                        size: Size(1110, 150),
                        maximumColorCount: 20,
                      );

                      _navigateToPage(
                        PurchasedAttendingTicketScreen(
                          ticketOrder: widget.ticketOrder,
                          event: event,
                          currentUserId: widget.currentUserId,
                          justPurchased: '',
                          palette: _paletteGenerator,
                        ),
                      );
                    } else {
                      _showBottomSheetErrorMessage('Failed to fetch event.');
                    }
                  } catch (e) {
                    _showBottomSheetErrorMessage('Failed to fetch event');
                  } finally {
                    _isLoading = false;
                  }
                },
          leading: CountdownTimer(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 11.0),
            split: 'Multiple',
            color: Theme.of(context).secondaryHeaderColor,
            clossingDay: DateTime.now(),
            startDate: widget.ticketOrder.eventTimestamp!.toDate(),
            eventHasEnded: false,
            eventHasStarted: false,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                widget.ticketOrder.eventTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "${datePartition[2]} ${datePartition[1]} ${datePartition[0]}",
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
