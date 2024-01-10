import 'package:bars/utilities/exports.dart';

class EventBottomModalSheetActions extends StatelessWidget {
  final Event event;
  final String currentUserId;
  final bool eventHasEnded;

  EventBottomModalSheetActions(
      {required this.event,
      required this.currentUserId,
      required this.eventHasEnded});

  //launch map to show event location
  _launchMap() {
    return MapsLauncher.launchQuery(event.venue);
  }

//display calendar
  void _showBottomSheetCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventSheduleCalendar(
          event: event, currentUserId: currentUserId,
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
          event: event,
          isSponsor: isSponsor,
          showTagsOnImage: false,
        );
      },
    );
  }

// Ticket options purchase entry
  void _showBottomSheetAttendOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          final width = MediaQuery.of(context).size.width;
          List<TicketModel> tickets = event.ticket;
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
                  currentUserId: currentUserId,
                  groupTickets: event.ticket,
                  event: event,
                  inviteReply: '',
                ),
              ],
            ),
          );
        });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isAuthor = currentUserId == event.authorId ? true : false;
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
              trailing: eventHasEnded
                  ? null
                  : GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _isAuthor
                            ? _navigateToPage(
                                context,
                                EditEventScreen(
                                  currentUserId: currentUserId,
                                  event: event,
                                ),
                              )
                            : _showBottomSheetAttendOptions(context);
                      },
                      child: Icon(
                        currentUserId == event.authorId
                            ? Icons.edit_outlined
                            : Icons.payment_outlined,
                        color: Colors.blue,
                        size: ResponsiveHelper.responsiveHeight(context, 30.0),
                      ),
                    ),
              leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(event.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                event.title.toUpperCase(),
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
                      Share.share(event.dynamicLink);
                    },
                    text: 'Invite people',
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.send_outlined,
                  onPressed: () {
                    _navigateToPage(
                      context,
                      SendToChats(
                        currentUserId: currentUserId,
                        sendContentType: 'Event',
                        sendContentId: event.id,
                        sendImageUrl: event.imageUrl,
                        sendTitle: event.title,
                      ),
                    );
                  },
                  text: 'Send',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.share_outlined,
                  onPressed: () async {
                    Share.share(event.dynamicLink);
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
                            currentUserId: currentUserId,
                            userId: event.authorId,
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
                      contentId: event.id,
                      parentContentId: event.id,
                      repotedAuthorId: event.authorId,
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
