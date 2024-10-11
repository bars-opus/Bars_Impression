import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityWidget extends StatefulWidget {
  final Activity activity;
  final String currentUserId;

  const ActivityWidget(
      {super.key, required this.activity, required this.currentUserId});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  bool _isLoading = false;
  bool _isFollowRequestRejected = false;
  bool _isFollowRequestAccepted = false;

  _submit(Activity activity) async {
    try {
      await activitiesRef
          .doc(widget.currentUserId)
          .collection('userActivities')
          .doc(activity.id)
          .update({
        'seen': true,
      });

      activity.seen = true;
    } catch (e) {
      _showBottomSheetErrorMessage(
          'Request failed', 'Check your internet connection and try again.');
    }
  }

  void _showBottomSheetErrorMessage(
    String errorTitle,
    String body,
  ) {
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
          title: errorTitle,
          subTitle: body,
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _activityProfile(
    Activity activity,
  ) {
    return GestureDetector(
      onTap: activity.type == NotificationActivityType.refundRequested
          ? () {}
          : () async {
              widget.activity.seen!
                  ? const SizedBox.shrink()
                  : await _submit(
                      widget.activity,
                    );
              _navigateToPage(
                  context,
                  ProfileScreen(
                    currentUserId: widget.currentUserId,
                    userId: activity.authorId!,
                    user: null, accountType: '',
                  ));
            },
      child: activity.authorProfileImageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: ResponsiveHelper.responsiveHeight(context, 50.0),
              color: Colors.grey,
            )
          : CircleAvatar(
              radius: ResponsiveHelper.responsiveHeight(context, 20.0),
              backgroundColor: Theme.of(context).primaryColorLight,
              backgroundImage: CachedNetworkImageProvider(
                  activity.authorProfileImageUrl, errorListener: (_) {
                return;
              }),
            ),
    );
  }

  void _showBottomDeletedEvent(
      BuildContext context, TicketOrderModel ticketOrder) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SizedBox.shrink();
          //  EventDeletedMessageWidget(
          //   currentUserId: widget.currentUserId,
          //   ticketOrder: ticketOrder,
          // );
        });
  }

  _getEvent(TicketOrderModel ticketOrder) async {
    Event? _event = await DatabaseService.getUserEventWithId(
        ticketOrder.eventId, ticketOrder.eventAuthorId);

    if (_event != null && _event.imageUrl.isNotEmpty) {
      PaletteGenerator _paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(_event.imageUrl, errorListener: (_) {
          return;
        }),
        size: Size(1110, 150),
        maximumColorCount: 20,
      );

      // _navigateToPage(
      //     context,
      //     PurchasedAttendingTicketScreen(
      //       ticketOrder: ticketOrder,
      //       event: _event,
      //       currentUserId: widget.currentUserId,
      //       justPurchased: '',
      //       palette: _paletteGenerator,
      //     ));
    }
  }

  Future<void> _getActivityTicketOrder(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return _showBottomSheetErrorMessage(
          'Ticket not found.', 'This ticket might have been deleted');
    }

    TicketOrderModel? ticketOrder =
        await DatabaseService.getUserTicketOrderWithId(
            postId, widget.currentUserId);
    if (ticketOrder != null) {
      ticketOrder.isDeleted
          ? _showBottomDeletedEvent(context, ticketOrder)
          : _getEvent(ticketOrder);
    } else {
      _showBottomSheetErrorMessage('Failed to fetch ticket order.',
          'Check your internet connection and try again.');
    }
  }

  Future<void> _getActivityParentContent(Activity activity) async {
    switch (activity.type) {
      case NotificationActivityType.comment:
      case NotificationActivityType.like:
        await _getActivityPost(activity);
        break;
      case NotificationActivityType.ask:
        await _getActivityEvent(activity);
        break;
      case NotificationActivityType.newEventInNearYou:
        await _getActivityEvent(activity);
        break;
      case NotificationActivityType.eventUpdate:
        await _getActivityTicketOrder(activity);
        break;

      case NotificationActivityType.refundRequested:
        await _getActivityEvent(activity);
        break;

      case NotificationActivityType.inviteRecieved:
        await _getActivityInviteReceived(activity);
        break;
      case NotificationActivityType.ticketPurchased:
        await _getActivityEvent(activity);
        break;
      case NotificationActivityType.advice:
        await _getActivityAdvice(activity);
        break;

      case NotificationActivityType.eventDeleted:
        await _getActivityTicketOrder(activity);
        break;

      case NotificationActivityType.follow:
        await _getActivityFollower(activity);
        break;

      case NotificationActivityType.affiliate:
        await _getAffiliate(activity);
        break;

      case NotificationActivityType.bookingReceived:
        await _getBooking(activity, false);
        break;

      case NotificationActivityType.bookingMade:
        await _getBooking(activity, true);
        break;

      case NotificationActivityType.donation:
        await _getActivityFollower(activity);
        break;

      case NotificationActivityType.tag:
        await _getTage(activity);
        break;

      case NotificationActivityType.tagConfirmed:
        await _getActivityFollower(activity);
        break;

      default:
        break;
    }
  }

  void _showBottomSheetPrivateEventMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CantFetchPrivateEvent(
          body:
              'To maintain this event\'s privacy, the event\'s contents can only be accessed through the ticket or via your profile if you are the organizer.',
        );
      },
    );
  }

  Future<void> _getActivityInviteReceived(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return _showBottomSheetErrorMessage(
          'Invite not found.', 'This invite might have been deleted');
    }

    InviteModel? _invite =
        await DatabaseService.getEventIviteWithId(widget.currentUserId, postId);
    if (_invite != null) {
      Event? _event = await DatabaseService.getUserEventWithId(
          _invite.eventId, _invite.inviterId);

      TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
          _invite.eventId, widget.currentUserId);

      if (_event != null) {
        PaletteGenerator _paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(_event.imageUrl, errorListener: (_) {
            return;
          }),
          size: Size(1110, 150),
          maximumColorCount: 20,
        );

        // _navigateToPage(
        //   context,
        //   EventInviteScreen(
        //     currentUserId: widget.currentUserId,
        //     event: _event,
        //     invite: _invite,
        //     palette: _paletteGenerator,
        //     ticketOrder: _ticket,
        //   ),
        // );
      } else {
        _showBottomSheetErrorMessage('Event not found.',
            'This event might have been deleted or cancelled');
        // _showBottomSheetErrorMessage('Failed to fetch event.',
        //     'Check your internet connection and try again.');
      }
    } else {
      _showBottomSheetErrorMessage('Invitation not found.', '');
      // _showBottomSheetErrorMessage('Failed to fetch event.',
      //     'Check your internet connection and try again.');
    }
  }

  Future<void> _getActivityPost(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return;
    }
  }

  Future<void> _getActivityEvent(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return _showBottomSheetErrorMessage('Event not found.',
          'This event might have been deleted or cancelled');
    }

    Event? event = await DatabaseService.getUserEventWithId(
        postId, activity.helperFielId!);
    if (event != null) {
      // event.isPrivate
      //     ? _showBottomSheetPrivateEventMessage()
      //     : _navigateToPage(
      //         context,
      //         EventEnlargedScreen(
      //           currentUserId: widget.currentUserId,
      //           event: event,
      //           type: event.type,
      //           showPrivateEvent: true,
      //         ),
      //       );
    } else {
      _showBottomSheetErrorMessage('Event not found.',
          'This event might have been deleted or cancelled');
      // _getActivityTicketOrder(activity);
    }
  }

  Future<void> _getActivityAdvice(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      return _showBottomSheetErrorMessage(
          'User not found.', 'This user might have deleted this account');
    }

    // AccountHolderAuthor? user = await DatabaseService.getUserWithId(authorId);
    _navigateToPage(
      context,
      UserAdviceScreen(
        updateBlockStatus: () {
          setState(() {});
        },
        // user: user!,
        currentUserId: widget.currentUserId,
        userId: activity.authorId!,
        userName: activity.authorName, disableAdvice: false, hideAdvice: false,
      ),
    );
  }

  Future<void> _getActivityFollower(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      // handle null authorId appropriately
      return _showBottomSheetErrorMessage(
          'User not found.', 'This user might have deleted this account');
    }

    _navigateToPage(
      context,
      ProfileScreen(
        currentUserId: widget.currentUserId,
        userId: authorId,
        user: null, accountType: '',
      ),
    );
  }

  Future<void> _getAffiliate(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      // handle null authorId appropriately
      return;
    }

    AffiliateModel? affiliate = await DatabaseService.getUserAffiliate(
        widget.currentUserId, activity.postId!);

    if (affiliate == null)
      return _showBottomSheetErrorMessage(
          'Affiliate not found.', 'This affiliate might have been deleted');

    // _navigateToPage(
    //   context,
    //   AffiliatePage(
    //     currentUserId: widget.currentUserId,
    //     isUser: true,
    //     affiliate: affiliate,
    //     fromActivity: true,
    //   ),
    // );
  }

  Future<void> _getTage(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      // handle null authorId appropriately
      return;
    }

    TaggedNotificationModel? tag = await DatabaseService.getUserTag(
        widget.currentUserId, activity.postId!);

    if (tag == null)
      return _showBottomSheetErrorMessage(
          'Tag not found.', 'This tag might have been deleted');

    _navigateToPage(
      context,
      TagPage(
        currentUserId: widget.currentUserId,
        currentTag: tag,
      ),
    );
  }

  Future<void> _getBooking(Activity activity, bool bookingMade) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      // handle null authorId appropriately
      return;
    }

    BookingModel? booking = bookingMade
        ? await DatabaseService.getBookingMade(
            widget.currentUserId, activity.postId!)
        : await DatabaseService.getUserBooking(
            widget.currentUserId, activity.postId!);
    if (booking == null)
      return _showBottomSheetErrorMessage(
          'Booking not found.', 'This booking might have been deleted');

    _navigateToPage(
      context,
      BookingPage(
        currentUserId: widget.currentUserId,
        // isUser: true,
        booking: booking,
        fromActivity: true,
      ),
    );
  }

  _onTapPost() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    widget.activity.seen!
        ? const SizedBox.shrink()
        : await _submit(
            widget.activity,
          );

    await _getActivityParentContent(
      widget.activity,
    );
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _activityContent(Activity activity) {
    bool _isSeen = activity.seen!;

    String text = '';
    Color color = Colors.grey;

    switch (activity.type) {
      case NotificationActivityType.comment:
        text = "vibed:";
        color = Colors.blueGrey;
        break;
      case NotificationActivityType.ticketPurchased:
        text = "";
        color = Colors.blueGrey;
        break;
      case NotificationActivityType.like:
        text = "liked your punch";
        color = Colors.pink;
        break;
      case NotificationActivityType.ask:
        text = "Asked:";
        color = activity.comment != null ? Colors.blueGrey : Colors.pink;
        break;
      case NotificationActivityType.advice:
        text = "Adviced you:";
        color = activity.comment != null ? Colors.blueGrey : Colors.pink;
        break;
      case NotificationActivityType.follow:
        text = "";
        color = Colors.blue;
        break;
      default:
        text = '';
        color = Colors.grey;
    }

    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: color,
            ),
          ),
          TextSpan(
            text: activity.comment != null ? '${activity.comment}' : '',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              fontWeight: _isSeen ? FontWeight.normal : FontWeight.bold,
              color: _isSeen ? Colors.grey : Colors.blue,
            ),
          ),
        ],
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  _iconContiner(Activity activity) {
    bool _isSeen = activity.seen ?? false;

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 50.0),
      width: ResponsiveHelper.responsiveHeight(context, 50.0),
      decoration: BoxDecoration(
          color: _isSeen ? Colors.grey : Colors.blue, shape: BoxShape.circle),
      child: Padding(
        padding: EdgeInsets.all(
          ResponsiveHelper.responsiveHeight(context, 8.0),
        ),
        child: Icon(
          activity.type == NotificationActivityType.inviteRecieved
              ? Icons.mail_outline_rounded
              : activity.type == NotificationActivityType.donation
                  ? Icons.payment
                  : activity.type == NotificationActivityType.tag
                      ? Icons.link
                      : Icons.event_outlined,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }

  Widget _buildTitle(Activity activity, bool isSeen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  activity.authorName,
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    fontWeight: isSeen ? FontWeight.normal : FontWeight.bold,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildVerificationIcon(activity),
            ],
          ),
        ),
        _activityContent(activity),
      ],
    );
  }

  Widget _buildVerificationIcon(Activity activity) {
    return !activity.authorVerification
        ? const SizedBox.shrink()
        : Icon(
            MdiIcons.checkboxMarkedCircle,
            size: ResponsiveHelper.responsiveHeight(context, 11.0),
            color: Colors.blue,
          );
  }

  Widget _buildSubtitle(Activity activity) {
    String timeAgo = activity.timestamp != null
        ? timeago.format(activity.timestamp!.toDate())
        : '';

    return Text(
      timeAgo,
      style: TextStyle(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 10.0),
          color: Colors.grey),
    );
  }

  Widget _followRequestRespond(Activity activity) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Container(
      width: ResponsiveHelper.responsiveHeight(context, 100),
      height: ResponsiveHelper.responsiveHeight(context, 70),
      child: _isLoading
          ? SizedBox(
              height: ResponsiveHelper.responsiveHeight(context, 10.0),
              width: ResponsiveHelper.responsiveHeight(context, 10.0),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.blue,
              ),
            )
          : _isFollowRequestRejected || _isFollowRequestAccepted
              ? Text(
                  _isFollowRequestAccepted ? 'Accepted' : 'Rejected',
                  style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12),
                      color:
                          _isFollowRequestAccepted ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await DatabaseService.acceptFollowRequest(
                          currentUserId: widget.currentUserId,
                          requesterUserId: activity.authorId!,
                          activityId: activity.id!,
                          currentUser: _provider.user!,
                        );

                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _isFollowRequestAccepted = true;
                          });
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.4),
                          ),
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            'Accept',
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12),
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        await DatabaseService.rejectFollowRequest(
                          currentUserId: widget.currentUserId,
                          userId: activity.authorId!,
                          activityId: activity.id!,
                        );

                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _isFollowRequestRejected = true;
                          });
                        }
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color:
                                Theme.of(context).primaryColor.withOpacity(.4),
                          ),
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Text(
                            ' Reject',
                            style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12),
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
    );
  }

  Widget _buildTrailing(Activity activity, bool isSeen) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return _isLoading
        ? SizedBox(
            height: ResponsiveHelper.responsiveHeight(context, 10.0),
            width: ResponsiveHelper.responsiveHeight(context, 10.0),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Colors.blue,
            ),
          )
        : activity.type == NotificationActivityType.follow
            // &&
            //         _provider.user!.isShop!
            ? _followRequestRespond(activity)
            : activity.type == NotificationActivityType.follow ||
                    activity.postImageUrl!.isEmpty
                ? SizedBox.shrink()
                : Container(
                    width: ResponsiveHelper.responsiveHeight(context, 90),
                    height: ResponsiveHelper.responsiveHeight(context, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildUnseenIndicator(activity, isSeen),
                        _buildLikeButton(activity, isSeen),
                        // if(activity.postImageUrl != null)

                        CachedNetworkImage(
                          imageUrl: activity.postImageUrl ?? '',
                          height:
                              ResponsiveHelper.responsiveHeight(context, 40.0),
                          width:
                              ResponsiveHelper.responsiveHeight(context, 40.0),
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  );
  }

  Widget _buildUnseenIndicator(Activity activity, bool isSeen) {
    if (activity.type == NotificationActivityType.like || isSeen) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CircleAvatar(
        backgroundColor: Colors.red,
        radius: ResponsiveHelper.responsiveHeight(context, 3.0),
      ),
    );
  }

  Widget _buildLikeButton(Activity activity, bool isSeen) {
    if (activity.type != NotificationActivityType.like || isSeen) {
      return const SizedBox.shrink();
    }
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 12.0),
      child: CircularButton(
        color: Colors.pink,
        icon: Icons.favorite,
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isSeen = widget.activity.seen ?? false;
    return Column(
      children: [
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 5.0),
        ),
        Container(
            decoration: BoxDecoration(
                color: _isSeen
                    ? Colors.transparent
                    : Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: _isSeen
                        ? Colors.transparent
                        : Theme.of(context).primaryColor,
                    offset: Offset(4.0, 4.0),
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  ),
                ]),
            child: GestureDetector(
              onTap: () {
                _onTapPost();
                // if (mounted) {
                //   setState(() {
                //     _isLoading = true;
                //   });
                // }
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ResponsiveHelper.responsiveHeight(
                      context,
                      8,
                    ),
                    horizontal: ResponsiveHelper.responsiveHeight(
                      context,
                      8,
                    )),
                child: Row(
                  children: [
                    widget.activity.type ==
                                NotificationActivityType.newEventInNearYou ||
                            widget.activity.type ==
                                NotificationActivityType.inviteRecieved ||
                            widget.activity.type ==
                                NotificationActivityType.eventDeleted ||
                            widget.activity.type ==
                                NotificationActivityType.donation ||
                            widget.activity.type ==
                                NotificationActivityType.eventUpdate ||
                            widget.activity.type == NotificationActivityType.tag
                        ? _iconContiner(widget.activity)
                        : _activityProfile(widget.activity),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(widget.activity, _isSeen),
                          _buildSubtitle(widget.activity),
                        ],
                      ),
                    ),
                    _buildTrailing(widget.activity, _isSeen),
                  ],
                ),
              ),
            )),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 3.0),
        ),
      ],
    );
  }
}
