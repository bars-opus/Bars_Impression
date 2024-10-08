import 'package:bars/utilities/exports.dart';

class EventRefunds extends StatefulWidget {
  static final id = 'EventRefunds';
  final String eventId;
  final String status;

  EventRefunds({
    required this.eventId,
    required this.status,
  });

  @override
  _EventRefundsState createState() => _EventRefundsState();
}

class _EventRefundsState extends State<EventRefunds>
    with AutomaticKeepAliveClientMixin {
  List<RefundModel> _refundList = [];
  DocumentSnapshot? _lastInviteDocument;
  DocumentSnapshot? _lastFiletedActivityDocument;
  int limit = 5;
  bool _hasNext = true;
  String _isSortedBy = '';
  bool _isLoading = true;
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
      QuerySnapshot ticketOrderSnapShot = await eventRefundRequestsRef
          .doc(widget.eventId)
          .collection('refundRequests')
          .where('status', isEqualTo: widget.status)
          .limit(10)
          .get();
      List<RefundModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => RefundModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _refundList = ticketOrder;
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
      Query activitiesQuery = eventRefundRequestsRef
          .doc(widget.eventId)
          .collection('refundRequests')
          .where('status', isEqualTo: widget.status)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);
      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();
      List<RefundModel> morePosts =
          postFeedSnapShot.docs.map((doc) => RefundModel.fromDoc(doc)).toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _refundList.addAll(morePosts);
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
              // Call recursive function to delete documents in chunks
              await deleteActivityDocsInBatches();
              _refundList.clear();
            } catch (e) {
              _showBottomSheetErrorMessage('Error clearing notifications ');
            }
          },
          title: 'Are you sure you want to clear refund data?',
          subTitle: '',
        );
      },
    );
  }

  Future<void> deleteActivityDocsInBatches() async {
    // get the first batch of documents to be deleted
    var snapshot = await eventRefundRequestsRef
        .doc(widget.eventId)
        .collection('refundRequests')
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
    _refundList.clear();

    // call the function recursively to delete the next batch
    return deleteActivityDocsInBatches();
  }

  _buildActivityBuilder(
    List<RefundModel> _refundList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        // controller: _hideButtonController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                RefundModel refund = _refundList[index];

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SalesReceiptWidget(
                        isRefunded: false,
                        lable: 'Status',
                        value: refund.status,
                      ),
                      SalesReceiptWidget(
                        isRefunded: false,
                        lable: 'Amount',
                        value: refund.amount.toString(),
                      ),
                      SalesReceiptWidget(
                        isRefunded: false,
                        lable: 'Request \ndate',
                        value: MyDateFormat.toDate(
                            refund.approvedTimestamp.toDate()),
                      ),
                      SalesReceiptWidget(
                        isRefunded: false,
                        lable: 'Request\nReason',
                        value: refund.reason,
                      ),
                    ],
                  ),
                );
              },
              childCount: _refundList.length,
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
                  backgroundColor: Theme.of(context).primaryColorLight,
                  title: Text(
                    'Ticket refunds',
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
                      : _refundList.isEmpty
                          ? Expanded(
                              child: Center(
                              child: NoContents(
                                icon: (Icons.payment_outlined),
                                title: 'No refunds,',
                                subTitle:
                                    'All your refund requests would be displayed here.',
                              ),
                            ))
                          : Expanded(
                              child: _buildActivityBuilder(
                              _refundList,
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
