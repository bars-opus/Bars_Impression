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
      _showBottomSheetErrorMessage('Request failed');
    }
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
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
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  void _showBottomSheetErrorDeletedEvent(String errorTitle) {
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
          subTitle:
              'The event you are trying to access might have either been deleted or is not available.',
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
                    user: null,
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
              backgroundImage:
                  CachedNetworkImageProvider(activity.authorProfileImageUrl),
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
          return EventDeletedMessageWidget(
            currentUserId: widget.currentUserId,
            ticketOrder: ticketOrder,
          );
        });
  }

  Future<void> _getActivityTicketOrder(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return;
    }

    TicketOrderModel? ticketOrder =
        await DatabaseService.getUserTicketOrderWithId(
            postId, widget.currentUserId);
    if (ticketOrder != null) {
      _showBottomDeletedEvent(context, ticketOrder);
    } else {
      _showBottomSheetErrorMessage('Failed to fetch ticket order.');
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
        await _getActivityEvent(activity);
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
      default:
        break;
    }
  }

  Future<void> _getActivityInviteReceived(Activity activity) async {
    var postId = activity.postId;
    if (postId == null) {
      return;
    }

    InviteModel? _invite =
        await DatabaseService.getEventIviteWithId(widget.currentUserId, postId);
    if (_invite != null) {
      Event? _event = await DatabaseService.getEventWithId(_invite.eventId);

      TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
          _invite.eventId, widget.currentUserId);

      if (_event != null) {
        PaletteGenerator _paletteGenerator =
            await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(_event.imageUrl),
          size: Size(1110, 150),
          maximumColorCount: 20,
        );

        _navigateToPage(
          context,
          EventInviteScreen(
            currentUserId: widget.currentUserId,
            event: _event,
            invite: _invite,
            palette: _paletteGenerator,
            ticketOrder: _ticket,
          ),
        );
      } else {
        _showBottomSheetErrorMessage('Failed to fetch event.');
      }
    } else {
      _showBottomSheetErrorMessage('Failed to fetch event.');
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
      return;
    }

    Event? event = await DatabaseService.getEventWithId(postId);
    if (event != null) {
      _navigateToPage(
        context,
        EventEnlargedScreen(
          currentUserId: widget.currentUserId,
          event: event,
          type: event.type,
        ),
      );
    } else {
      _showBottomSheetErrorDeletedEvent('Event not found');
    }
  }

  Future<void> _getActivityAdvice(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      return;
    }

    AccountHolderAuthor? user = await DatabaseService.getUserWithId(authorId);
    _navigateToPage(
      context,
      UserAdviceScreen(
          updateBlockStatus: () {
            setState(() {});
          },
          user: user!,
          currentUserId: widget.currentUserId,
          userId: activity.authorId!,
          userName: activity.authorName),
    );
  }

  Future<void> _getActivityFollower(Activity activity) async {
    var authorId = activity.authorId;
    if (authorId == null) {
      // handle null authorId appropriately
      return;
    }

    _navigateToPage(
      context,
      ProfileScreen(
        currentUserId: widget.currentUserId,
        userId: authorId,
        user: null,
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
        text = "follows you:";
        color = Colors.blue;
        break;
      default:
        text = '';
        color = Colors.grey;
    }

    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
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
            text: activity.comment != null ? ' ${activity.comment}' : '',
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

    return Text(timeAgo,
        style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 10.0),
            color: Colors.grey));
  }

  Widget _buildTrailing(Activity activity, bool isSeen) {
    return _isLoading
        ? SizedBox(
            height: ResponsiveHelper.responsiveHeight(context, 10.0),
            width: ResponsiveHelper.responsiveHeight(context, 10.0),
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
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
                    CachedNetworkImage(
                      imageUrl: activity.postImageUrl ?? '',
                      height: ResponsiveHelper.responsiveHeight(context, 40.0),
                      width: ResponsiveHelper.responsiveHeight(context, 40.0),
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
        icon: Icon(Icons.favorite,
            size: ResponsiveHelper.responsiveHeight(context, 15.0),
            color: Colors.white),
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
                                NotificationActivityType.eventUpdate
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
