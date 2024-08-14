import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  static final id = 'NotificationPage';
  final String currentUserId;
  NotificationPage({
    required this.currentUserId,
  });

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    with AutomaticKeepAliveClientMixin {
  List<Activity> _activities = [];
  List<Activity> _filteredActivities = [];
  DocumentSnapshot? _lastActivityDocument;
  DocumentSnapshot? _lastFiletedActivityDocument;
  int limit = 10;
  bool _hasNext = true;
  String _isSortedBy = '';
  bool _isLoading = true;
  late ScrollController _hideButtonController;

  @override
  void initState() {
    super.initState();
    _setupActivities();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _isSortedBy.isEmpty
            ? _loadMoreActivities()
            : _loadMoreFilteredActivities(_isSortedBy);
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  // The _setupActivities() function is designed to fetch the activities
  // of a certain user from Firestore and store them in a list,
  // which is then assigned to _activities. It also sets _hasNext to
  // true if the number of activities is 10 (the limit you specified in the query),
  // and retrieves the last document from the snapshot to paginate further results.
  // Overall, this is a common practice for paginating Firestore data and it's efficient for this purpose.
//  if _lastActivityDocument is not null, the query starts after it. This is how you fetch
//  the next set of activities. Also, I've changed _activities = activities to _activities += activities
//  to append new activities to the existing list instead of replacing it.
// You can call _setupActivities() again when the user scrolls to the end of the list or clicks a
// "Load More" button, for example. If there are more activities to load, _lastActivityDocument will
// not be null and the query will fetch the next set of activities. If there are no more activities,
// _lastActivityDocument will be null and the query will fetch the first set of activities again.

  _setupActivities() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await activitiesRef
          .doc(widget.currentUserId)
          .collection('userActivities')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<Activity> ticketOrder =
          ticketOrderSnapShot.docs.map((doc) => Activity.fromDoc(doc)).toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastActivityDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _activities = ticketOrder;
          _isLoading = false;
        });
      }
      if (ticketOrderSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return ticketOrder;
    } catch (e) {
      print('Error fetching initial invites: $e');
      return [];
    }
  }

  _loadMoreActivities() async {
    try {
      Query activitiesQuery = activitiesRef
          .doc(widget.currentUserId)
          .collection('userActivities')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastActivityDocument!)
          .limit(5);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<Activity> morePosts =
          postFeedSnapShot.docs.map((doc) => Activity.fromDoc(doc)).toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastActivityDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _activities.addAll(morePosts);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      _hasNext = false;
      return _hasNext;
    }
  }

  void _loadMoreFilteredActivities(String type) async {
    try {
      Query query = activitiesRef
          .doc(widget.currentUserId)
          .collection('userActivities')
          .where('type', isEqualTo: _isSortedBy)
          .limit(10);

      if (_lastFiletedActivityDocument != null) {
        query = query.startAfterDocument(_lastFiletedActivityDocument!);
      }
      QuerySnapshot userFeedSnapShot = await query.get();
      if (userFeedSnapShot.docs.isNotEmpty) {
        List<Activity> moreActivities =
            userFeedSnapShot.docs.map((doc) => Activity.fromDoc(doc)).toList();
        if (mounted) {
          setState(() {
            _filteredActivities.addAll(moreActivities);
            _hasNext = userFeedSnapShot.docs.length == 10;
            _lastFiletedActivityDocument = userFeedSnapShot.docs.last;
          });
        }
      } else {
        _hasNext = false;
      }
    } catch (e) {}
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

  void _showBottomSheetClearActivity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Clear all',
          onPressed: () async {
            Navigator.pop(context);
            try {
              // Call recursive function to delete documents in chunks
              await deleteActivityDocsInBatches();
              _activities.clear();
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing notifications ');
            }
          },
          title: 'Are you sure you want to clear your notifications?',
          subTitle: 'Please make sure you don\'t miss any appointment',
        );
      },
    );
  }

  Future<void> deleteActivityDocsInBatches() async {
    // get the first batch of documents to be deleted
    var snapshot = await activitiesRef
        .doc(widget.currentUserId)
        .collection('userActivities')
        .limit(500)
        .get();

    // if there's no document left, return
    if (snapshot.docs.isEmpty) {
      return;
    }
    // prepare a new batch
    var batch = FirebaseFirestore.instance.batch();
    // loop over the documents in the snapshot and delete them
    snapshot.docs.forEach((doc) {
      batch.delete(doc.reference);
    });

    // commit the deletions
    await batch.commit();
    return deleteActivityDocsInBatches();
  }

  bool _isSorting = false;

  _sort(NotificationActivityType type) {
    if (_isSorting) return;

    _isSorting = true;

    setState(() {
      _isSortedBy = type.toString().split('.').last.toString();
      _lastFiletedActivityDocument = null; // reset the pagination
      _filteredActivities.clear(); // clear the list
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadMoreFilteredActivities(_isSortedBy);
      _isSorting = false;
    });

    Navigator.pop(context);
  }

  _sortByWidget(
    VoidCallback onPressed,
    IconData icon,
    String title,
  ) {
    // var _blueStyle = TextStyle(
    //     fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
    //     color: Colors.black);
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: NotificationSortButton(
              icon: icon,
              onPressed: onPressed,
              title: title,
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: .2,
          )
        ],
      ),
    );
  }

  void _showBottomSheetSortNotifications(BuildContext context) {
    // final width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 600.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
                child: ListView(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  TicketPurchasingIcon(
                    title: 'Sort:',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Divider(
                    color: Colors.grey,
                    thickness: .2,
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.advice);
                    },
                    Icons.comment_outlined,
                    'Advices',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.affiliate);
                    },
                    Icons.attach_money,
                    'Affiliates',
                  ),
                  // _sortByWidget(
                  //   () async {
                  //     HapticFeedback.mediumImpact();
                  //     await Future.delayed(Duration(milliseconds: 300));
                  //     _sort(NotificationActivityType.bookingMade);
                  //   },
                  //   Icons.calendar_month_outlined,
                  //   'Bookings made',
                  // ),
                  // _sortByWidget(
                  //   () async {
                  //     HapticFeedback.mediumImpact();
                  //     await Future.delayed(Duration(milliseconds: 300));
                  //     _sort(NotificationActivityType.bookingReceived);
                  //   },
                  //   Icons.calendar_month_outlined,
                  //   'Bookings received',
                  // ),
                  // _sortByWidget(
                  //   () async {
                  //     HapticFeedback.mediumImpact();
                  //     await Future.delayed(Duration(milliseconds: 300));
                  //     _sort(NotificationActivityType.donation);
                  //   },
                  //   MdiIcons.giftOutline,
                  //   'Donations',
                  // ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.eventDeleted);
                    },
                    Icons.event_busy_outlined,
                    'Events deleted',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.newEventInNearYou);
                    },
                    Icons.event_available_outlined,
                    'Events nearby',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.eventUpdate);
                    },
                    Icons.event_note,
                    'Events update',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.ask);
                    },
                    Icons.question_mark_rounded,
                    'Events questions',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.follow);
                    },
                    Icons.account_circle_outlined,
                    'Followers',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.inviteRecieved);
                    },
                    FontAwesomeIcons.idBadge,
                    'Invites received',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.refundRequested);
                    },
                    Icons.request_quote_outlined,
                    'Refund requests',
                  ),
                  _sortByWidget(
                    () async {
                      HapticFeedback.mediumImpact();
                      await Future.delayed(Duration(milliseconds: 300));
                      _sort(NotificationActivityType.ticketPurchased);
                    },
                    Icons.payment,
                    'Tickets purchased',
                  ),
                ])));
      },
    );
  }

  _buildActivityBuilder(
    List<Activity> _activitiesList,
  ) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                Activity activity = _activitiesList[index];
                return ActivityWidget(
                  activity: activity,
                  currentUserId: widget.currentUserId,
                );
              },
              childCount: _activitiesList.length,
            ),
          ),
        ],
      ),
    );
  }

  _sortByText() {
    String title = '';
    switch (_isSortedBy) {
      case 'ask':
        title = 'Event questions';
        break;
      case 'advice':
        title = 'Advices';
        break;
      case 'newEventInNearYou':
        title = 'Events nearby';
        break;
      case 'inviteRecieved':
        title = 'Invites received';
        break;
      case 'eventUpdate':
        title = 'event updates';
        break;
      case 'ticketPurchased':
        title = 'Tickets purchased';
        break;
      case 'refundRequested':
        title = 'Refund requests';
        break;
      case 'follow':
        title = 'Followers';
        break;
      default:
        break;
    }

    return Text(
      'Sorted By: $title',
      style: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
          fontWeight: FontWeight.normal),
    );
  }

  Future<void> refreshData() async {
    await _setupActivities();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    ;
    super.build(context);
    final width = MediaQuery.of(context).size.width;
    String _activityCount = _isSortedBy.isNotEmpty
        ? NumberFormat.compact().format(_filteredActivities.length)
        : NumberFormat.compact().format(_provider.activityCount);
    return Material(
      color: Theme.of(context).primaryColorLight,
      child: Scrollbar(
        controller: _hideButtonController,
        child: NestedScrollView(
          controller: _hideButtonController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                iconTheme: IconThemeData(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                pinned: false,
                centerTitle: false,
                backgroundColor: Theme.of(context).primaryColorLight,
                title: Text(
                  'Activities ',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      _showBottomSheetClearActivity(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0, right: 20),
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ];
          },
          body: RefreshIndicator(
            color: Colors.blue,
            onRefresh: refreshData,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: GestureDetector(
                    onTap: () {
                      _showBottomSheetClearActivity(context);
                    },
                    child: Text(
                      _activityCount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      _showBottomSheetSortNotifications(context);
                    },
                    icon: Icon(
                      Icons.sort,
                      size: ResponsiveHelper.responsiveHeight(context, 25.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  height: _isSortedBy.isEmpty ? 0.0 : 60,
                  width: width.toDouble(),
                  color: Colors.blue,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              _setupActivities();
                              if (mounted) {
                                setState(() {
                                  _isSortedBy = '';
                                  _lastFiletedActivityDocument = null;
                                  _hasNext = false;
                                  _filteredActivities.clear();
                                });
                              }
                            },
                            icon: Icon(
                              size: ResponsiveHelper.responsiveHeight(
                                  context, 25.0),
                              Icons.clear,
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          _sortByText(),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                !_isLoading
                    ? _activities.length == 0
                        ? Expanded(
                            child: Center(
                            child: NoContents(
                              icon: (Icons.notifications_none_outlined),
                              title: 'No activities,',
                              subTitle:
                                  'You can be the first person to ask a question or tell others how you feel about this upcoming event, ',
                            ),
                          ))
                        : _isSortedBy.isNotEmpty
                            ? Expanded(
                                child: _buildActivityBuilder(
                                _filteredActivities,
                              ))
                            : Expanded(
                                child: _buildActivityBuilder(
                                _activities,
                              ))
                    : Expanded(
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                              8,
                              (index) => EventAndUserScimmerSkeleton(
                                    from: '',
                                  )),
                        ),
                      ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
