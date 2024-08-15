import 'package:bars/utilities/exports.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

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
        CachedNetworkImageProvider(widget.event.imageUrl, errorListener: (_) {
          return;
        }),
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

  // void _showBottomSheetExternalLink() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: ResponsiveHelper.responsiveHeight(context, 550),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: WebDisclaimer(
  //             link: widget.event.ticketSite,
  //             contentType: 'Event ticket',
  //             icon: Icons.link,
  //           ));
  //     },
  //   );
  // }

  void _showBottomSheetContactOrganizer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.horizontal_rule,
                color: Theme.of(context).secondaryHeaderColor,
                size: ResponsiveHelper.responsiveHeight(context, 30.0),
              ),
              Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DisclaimerWidget(
                        title: 'Call Organizer',
                        subTitle:
                            'These are the contacts provided by this event\'s organizers. While we make efforts to gather the contact information, we cannot guarantee that these are the exact and correct contacts. Therefore, we advise you to conduct additional research and verify these contact details  independently.',
                        icon: Icons.call,
                      ),
                      const SizedBox(height: 40),
                      EventOrganizerContactWidget(
                        portfolios: widget.event.contacts,
                        edit: false,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBottomEditLocation(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 400,
          buttonText: 'set up city',
          onPressed: () async {
            Navigator.pop(context);
            _navigateToPage(
                context,
                EditProfileSelectLocation(
                  user: _userLocation!,
                  notFromEditProfile: true,
                ));
          },
          title: 'Set up your city',
          subTitle:
              'To proceed with purchasing a ticket, we kindly ask you to provide your country information. This allows us to handle ticket processing appropriately, as the process may vary depending on different countries. Please note that specifying your city is sufficient, and there is no need to provide your precise location or community details.',
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

  void _showBottomSheetAnalysisConsideration() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              Container(
                height: ResponsiveHelper.responsiveHeight(context, 300),
                // padding: const EdgeInsets.only(top: 50.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: AnimatedCircle(
                      // animateShape: true,
                      size: 50,
                      stroke: 3,
                      animateSize: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    'To derive at this analysis, the following event information was considered. Event title, event theme, event date, event, location, event dresscode ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ]),
              ),
            ],
          );
        });
      },
    );
  }

  _showBottomSheetBrandInsight(BuildContext context) {
    bool _isAuthor = widget.currentUserId == widget.event.authorId;

    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
              height: ResponsiveHelper.responsiveHeight(context, 700),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(20.0),
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(children: [
                    TicketPurchasingIcon(
                      title: '',
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: AnimatedCircle(
                        // animateShape: true,
                        size: 50,
                        stroke: 3,
                        animateSize: true,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // if (!widget.event.isPrivate)
                    MarkdownBody(
                      data: _isAuthor
                          ? widget.event.aiMarketingAdvice
                          : widget.event.aiAnalysis,
                      styleSheet: MarkdownStyleSheet(
                        h1: Theme.of(context).textTheme.titleLarge,
                        h2: Theme.of(context).textTheme.titleMedium,
                        p: Theme.of(context).textTheme.bodyMedium,
                        listBullet: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (widget.event.isPrivate && _isAuthor)
                      Text(
                        'No marketing insight for private event',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    // if (!widget.event.isPrivate && !_isAuthor)
                    GestureDetector(
                      onTap: () {
                        _showBottomSheetAnalysisConsideration();
                      },
                      child: Text(
                        'This information is an analysis I made of the event, based on the event details provided by the event organizer. This analysis was not directly written by the organizer, but is intended to help potential attendees understand the concept of the event more.',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ])));
        });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    bool _isAuthor =
        widget.currentUserId == widget.event.authorId ? true : false;

    var _usercountry = _provider.userLocationPreference!.country;

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, _isAuthor ? 600 : 550),
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
                                      event: widget.event,
                                      isCompleted: widget.eventHasEnded,
                                    ),
                                  );
                                }
                              : _usercountry!.isEmpty
                                  ? () {
                                      widget.event.isFree
                                          ? _attendMethod(context)
                                          : _showBottomEditLocation(context);
                                    }
                                  : () {
                                      widget.event.ticketSite.isNotEmpty
                                          ? _showBottomSheetExternalLink()
                                          : _showBottomSheetAttendOptions(
                                              context);
                                    },
                          child: _checkingTicketAvailability
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.blue,
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
                    image: CachedNetworkImageProvider(widget.event.imageUrl,
                        errorListener: (_) {
                      return;
                    }),
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
                ? const SizedBox.shrink()
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
            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.location_on_outlined,
                  onPressed: () {
                    _launchMap();
                  },
                  text: 'Location',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.circle_outlined,
                  onPressed: () {
                    _showBottomSheetBrandInsight(context);
                  },
                  text: 'Analysis & guide',
                ),
              ],
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.call_outlined,
                  onPressed: () {
                    _showBottomSheetContactOrganizer(context);
                  },
                  text: 'Call organizer',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.handshake_outlined,
                  onPressed: () {
                    _navigateToPage(
                        context,
                        ProfileScreen(
                          user: null,
                          currentUserId: widget.currentUserId,
                          userId: widget.event.authorId,
                        ));
                  },
                  text: 'See publisher',
                ),
              ],
            ),
            // BottomModelSheetListTileActionWidget(
            //   colorCode: '',
            //   icon: Icons.call_outlined,
            //   onPressed: () {
            //     _showBottomSheetContactOrganizer(context);
            //   },
            //   text: 'Call organizer',
            // ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  textcolor: Colors.red,
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
                BottomModelSheetIconActionWidget(
                  icon: Icons.feedback_outlined,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SuggestionBox()));
                  },
                  text: 'Suggestion',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
