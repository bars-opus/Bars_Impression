import 'package:bars/utilities/exports.dart';

class EventBottomModalSheetActions extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final bool eventHasEnded;

  EventBottomModalSheetActions(
      {required this.event,
      required this.currentUserId,
      required this.eventHasEnded});

  @override
  State<EventBottomModalSheetActions> createState() =>
      _EventBottomModalSheetActionsState();
}

class _EventBottomModalSheetActionsState
    extends State<EventBottomModalSheetActions> {
  bool _checkingTicketAvailability = false;

  //launch map to show event location
  _launchMap() {
    return MapsLauncher.launchQuery(widget.event.address);
  }

//display calendar
  void _showBottomSheetCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return widget.event.schedule.isEmpty
            ? NoScheduleCalendar(
                askMoreOnpressed: () {},
                showAskMore: false,
              )
            : EventSheduleCalendar(
                event: widget.event,
                currentUserId: widget.currentUserId,
                duration: 0,
              );
      },
    );
  }

// To display the people tagged in a post as performers, crew, sponsors or partners
  void _showBottomSheetTaggedPeople(BuildContext context, bool isSponsor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventTaggedPeople(
          event: widget.event,
          isSponsor: isSponsor,
          showTagsOnImage: false,
        );
      },
    );
  }

// Ticket options purchase entry
  void _showBottomSheetAttendOptions(BuildContext context) {
    Provider.of<UserData>(context, listen: false).ticketList.clear();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          List<TicketModel> tickets = widget.event.ticket;
          Map<String, List<TicketModel>> ticketsByGroup = {};
          for (TicketModel ticket in tickets) {
            if (!ticketsByGroup.containsKey(ticket.group)) {
              ticketsByGroup[ticket.group] = [];
            }
            ticketsByGroup[ticket.group]!.add(ticket);
          }
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            width: width,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TicketPurchasingIcon(
                    title: 'Ticket packages.',
                  ),
                ),
                TicketGroup(
                  currentUserId: widget.currentUserId,
                  groupTickets: widget.event.ticket,
                  event: widget.event,
                  inviteReply: '',
                ),
              ],
            ),
          );
        });
  }

  _attendMethod(BuildContext context) async {
    HapticFeedback.lightImpact();
    if (mounted) {
      setState(() {
        _checkingTicketAvailability = true;
      });
    }

    TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
        widget.event.id, widget.currentUserId);

    if (_ticket != null) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(widget.event.imageUrl),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );
      Navigator.pop(context);

      _navigateToPage(
        context,
        PurchasedAttendingTicketScreen(
          ticketOrder: _ticket,
          event: widget.event,
          currentUserId: widget.currentUserId,
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
        Navigator.pop(context);
        _showBottomSheetAttendOptions(context);
      }
    }
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetPrivateEventMessage(BuildContext context, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CantFetchPrivateEvent(
          body: body,
        );
      },
    );
  }

  void _showBottomSheetExternalLink() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 550),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: widget.event.ticketSite,
              contentType: 'Event ticket',
              icon: Icons.link,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuthor =
        widget.currentUserId == widget.event.authorId ? true : false;
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 650.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Icon(
              Icons.horizontal_rule,
              size: ResponsiveHelper.responsiveHeight(context, 30.0),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              trailing: widget.eventHasEnded
                  ? null
                  : !widget.event.isPrivate && !_isAuthor
                      ? GestureDetector(
                          onTap: _isAuthor
                              ? () {
                                  _navigateToPage(
                                    context,
                                    EditEventScreen(
                                      currentUserId: widget.currentUserId,
                                      event: widget.event, isCompleted: widget.eventHasEnded,
                                    ),
                                  );
                                }
                              : widget.event.ticketSite.isNotEmpty
                                  ? () {
                                      Navigator.pop(context);
                                      _showBottomSheetExternalLink();
                                    }
                                  : () {
                                      _attendMethod(context);
                                    },
                          child: _checkingTicketAvailability
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                )
                              : Icon(
                                  widget.currentUserId == widget.event.authorId
                                      ? Icons.edit_outlined
                                      : Icons.payment_outlined,
                                  color: Colors.blue,
                                  size: ResponsiveHelper.responsiveHeight(
                                      context, 30.0),
                                ),
                        )
                      : null,
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                widget.event.title.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            !_isAuthor
                ? SizedBox.shrink()
                : BottomModelSheetListTileActionWidget(
                    colorCode: 'Blue',
                    icon: Icons.mail_outline,
                    onPressed: () {
                      Share.share(widget.event.dynamicLink);
                    },
                    text: 'Invite people',
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.send_outlined,
                  onPressed: () {
                    !widget.event.isPrivate
                        ? _navigateToPage(
                            context,
                            SendToChats(
                              currentUserId: widget.currentUserId,
                              sendContentType: 'Event',
                              sendContentId: widget.event.id,
                              sendImageUrl: widget.event.imageUrl,
                              sendTitle: widget.event.title,
                            ),
                          )
                        : widget.event.isPrivate && _isAuthor
                            ? _navigateToPage(
                                context,
                                SendToChats(
                                  currentUserId: widget.currentUserId,
                                  sendContentType: 'Event',
                                  sendContentId: widget.event.id,
                                  sendImageUrl: widget.event.imageUrl,
                                  sendTitle: widget.event.title,
                                ),
                              )
                            : _showBottomSheetPrivateEventMessage(context,
                                'To maintain this event\'s privacy, the event can only be shared by the organizer.');
                  },
                  text: 'Send',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.share_outlined,
                  onPressed: () async {
                    !widget.event.isPrivate
                        ? Share.share(widget.event.dynamicLink)
                        : widget.event.isPrivate && _isAuthor
                            ? Share.share(widget.event.dynamicLink)
                            : _showBottomSheetPrivateEventMessage(context,
                                'To maintain this event\'s privacy, the event can only be shared by the organizer.');
                  },
                  text: 'Share',
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.people_outline,
                  onPressed: () {
                    _showBottomSheetTaggedPeople(context, false);
                  },
                  text: 'People',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.handshake_outlined,
                  onPressed: () {
                    _showBottomSheetTaggedPeople(context, true);
                  },
                  text: 'Sponsors',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.calendar_month_outlined,
                  onPressed: () {
                    _showBottomSheetCalendar(
                      context,
                    );
                  },
                  text: 'Schedules',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.location_on_outlined,
                  onPressed: () {
                    _launchMap();
                  },
                  text: 'Location',
                ),
              ],
            ),
            _isAuthor
                ? SizedBox.shrink()
                : BottomModelSheetListTileActionWidget(
                    colorCode: '',
                    icon: Icons.person_outline_outlined,
                    onPressed: () {
                      _navigateToPage(
                          context,
                          ProfileScreen(
                            user: null,
                            currentUserId: widget.currentUserId,
                            userId: widget.event.authorId,
                          ));
                    },
                    text: 'Show organizer',
                  ),
            const SizedBox(
              height: 20,
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: 'Red',
              icon: Icons.flag_outlined,
              onPressed: () {
                _navigateToPage(
                    context,
                    ReportContentPage(
                      contentId: widget.event.id,
                      parentContentId: widget.event.id,
                      repotedAuthorId: widget.event.authorId,
                      contentType: 'event',
                    ));
              },
              text: 'Report',
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: '',
              icon: Icons.feedback_outlined,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => SuggestionBox()));
              },
              text: 'Suggestion',
            ),
          ],
        ),
      ),
    );
  }
}
