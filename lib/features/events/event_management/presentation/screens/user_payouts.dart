import 'package:bars/utilities/exports.dart';

class UserPayouts extends StatefulWidget {
  static final id = 'UserPayouts';
  final String currentUserId;
  UserPayouts({
    required this.currentUserId,
  });

  @override
  _UserPayoutsState createState() => _UserPayoutsState();
}

class _UserPayoutsState extends State<UserPayouts>
    with AutomaticKeepAliveClientMixin {
  List<EventPayoutModel> _payoutList = [];
  DocumentSnapshot? _lastInviteDocument;
  DocumentSnapshot? _lastFiletedActivityDocument;
  int limit = 5;
  bool _hasNext = true;
  String _isSortedBy = '';
  bool _isLoading = true;
  bool _isDeleting = false;
  final now = DateTime.now();
  late ScrollController _hideButtonController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _setUpInvites();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        _loadMoreInvites();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpInvites() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await userPayoutRequestRef
          .doc(widget.currentUserId)
          .collection('payoutRequests')
          // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<EventPayoutModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => EventPayoutModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _payoutList = ticketOrder;
          _isLoading = false;
        });
      }
      if (ticketOrderSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return ticketOrder;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = userPayoutRequestRef
          .doc(widget.currentUserId)
          .collection('payoutRequests')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<EventPayoutModel> morePosts = postFeedSnapShot.docs
          .map((doc) => EventPayoutModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _payoutList.addAll(morePosts);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      // Handle the error
      print('Error fetching more user activities: $e');
      _hasNext = false;
      return _hasNext;
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
              setState(() {
                _isDeleting = true;
              });
              // Call recursive function to delete documents in chunks
              await deleteActivityDocsInBatches();
              _payoutList.clear();
              setState(() {
                _isDeleting = false;
              });
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing notifications ');
            }
          },
          title: 'Are you sure you want to clear your ticket payouts.',
          subTitle: '',
        );
      },
    );
  }

  Future<void> deleteActivityDocsInBatches() async {
    // get the first batch of documents to be deleted
    var snapshot = await userPayoutRequestRef
        .doc(widget.currentUserId)
        .collection('payoutRequests')
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
    _payoutList.clear();

    // Navigator.pop(context);
    // call the function recursively to delete the next batch
    return deleteActivityDocsInBatches();
  }

  _buildActivityBuilder(
    List<EventPayoutModel> _payoutList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                EventPayoutModel payout = _payoutList[index];

                return PayoutWidget(
                  currentUserId: widget.currentUserId,
                  payout: payout,
                );
              },
              childCount: _payoutList.length,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshData() async {
    await _setUpInvites();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Material(
      color: Theme.of(context).primaryColorLight,
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
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
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    'Ticket sales payout',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  actions: [
                    _isDeleting
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                                height: ResponsiveHelper.responsiveFontSize(
                                    context, 20.0),
                                width: ResponsiveHelper.responsiveFontSize(
                                    context, 20.0),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                  strokeWidth:
                                      ResponsiveHelper.responsiveFontSize(
                                          context, 2.0),
                                )),
                          )
                        : GestureDetector(
                            onTap: () {
                              _showBottomSheetClearActivity(context);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, right: 20),
                              child: Text(
                                'Clear all',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14),
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
                  _isLoading
                      ? Expanded(
                          child: ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                                8,
                                (index) => EventAndUserScimmerSkeleton(
                                      from: 'Event',
                                    )),
                          ),
                        )
                      : _payoutList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (MdiIcons.transfer),
                                title: 'No payouts,',
                                subTitle:
                                    'All your ticket sales payouts would appear here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityBuilder(
                              _payoutList,
                            )),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
