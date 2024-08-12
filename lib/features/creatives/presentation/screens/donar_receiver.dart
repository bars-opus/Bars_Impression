import 'package:bars/utilities/exports.dart';

class DonarReceiver extends StatefulWidget {
  static final id = 'DonarReceiver';
  final String userId;
  final bool isDonar;
  DonarReceiver({
    required this.userId,
    required this.isDonar,
  });

  @override
  _DonarReceiverState createState() => _DonarReceiverState();
}

class _DonarReceiverState extends State<DonarReceiver>
    with AutomaticKeepAliveClientMixin {
  List<DonationModel> _donationList = [];
  int limit = 20;
  bool _hasNext = true;
  bool _isLoading = true;
  late ScrollController _hideButtonController;
  DocumentSnapshot? _lastInviteDocument;

  @override
  void initState() {
    super.initState();
    widget.isDonar ? _setReceiver() : _setUpDoner();
    _hideButtonController = ScrollController();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        widget.isDonar ? _loadMoreReceiver() : _loadMoreDoners();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpDoner() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await newDonationToCreativesRef
          .doc(widget.userId)
          .collection('donations')
          // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<DonationModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => DonationModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _donationList = ticketOrder;
          _isLoading = false;
          print('Donar');
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

  _loadMoreDoners() async {
    try {
      Query activitiesQuery = newDonationToCreativesRef
          .doc(widget.userId)
          .collection('donations')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<DonationModel> morePosts = postFeedSnapShot.docs
          .map((doc) => DonationModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _donationList.addAll(morePosts);
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

  _setReceiver() async {
    try {
      QuerySnapshot ticketOrderSnapShot = await newUserDonationsRef
          .doc(widget.userId)
          .collection('donations')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<DonationModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => DonationModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _donationList = ticketOrder;
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

  _loadMoreReceiver() async {
    try {
      Query activitiesQuery = newUserDonationsRef
          .doc(widget.userId)
          .collection('donations')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<DonationModel> morePosts = postFeedSnapShot.docs
          .map((doc) => DonationModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _donationList.addAll(morePosts);
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

  _buildDonationBuilder(
    List<DonationModel> _donationList,
  ) {
    return Scrollbar(
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                DonationModel donations = _donationList[index];

                return DonationWidget(
                  donation: donations,
                  currentUserId: widget.userId,
                  isDonor: widget.isDonar,
                );
              },
              childCount: _donationList.length,
            ),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NestedScrollView(
      controller: _hideButtonController,
      headerSliverBuilder: (context, innerBoxScrolled) => [],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _isLoading
              ? Expanded(
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                        8,
                        (index) => EventAndUserScimmerSkeleton(
                              from: 'Donations',
                            )),
                  ),
                )
              : _donationList.isEmpty
                  ? Expanded(
                      child: Center(
                      child: NoContents(
                        icon: ( MdiIcons.giftOutline),
                        title: widget.isDonar
                            ? 'No donations made,'
                            : 'No donations received,',
                        subTitle: widget.isDonar
                            ? 'All the donations you have made to support other creatives would appear here.'
                            : 'All the donations other creatives have made to support you would appear here.',
                      ),
                    ))
                  : Expanded(
                      child: _buildDonationBuilder(
                      _donationList,
                    )),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
