import 'package:bars/utilities/exports.dart';

class BookedAndBookings extends StatefulWidget {
  static final id = 'BookedAndBookings';
  final String userId;
  final bool isBooked;
  BookedAndBookings({
    required this.userId,
    required this.isBooked,
  });

  @override
  _BookedAndBookingsState createState() => _BookedAndBookingsState();
}

class _BookedAndBookingsState extends State<BookedAndBookings>
    with AutomaticKeepAliveClientMixin {
  List<BookingModel> _bookingList = [];
  int limit = 20;
  bool _hasNext = true;
  bool _isLoading = true;
  late ScrollController _hideButtonController;
  DocumentSnapshot? _lastInviteDocument;

  @override
  void initState() {
    super.initState();
    widget.isBooked ? _setReceiver() : _setUpDoner();
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(true);
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        Provider.of<UserData>(context, listen: false).setShowEventTab(false);
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  _setUpDoner() async {
    // try {
    QuerySnapshot ticketOrderSnapShot = await newBookingsSentRef
        .doc(widget.userId)
        .collection('bookings')
        .orderBy('timestamp', descending: true)
        // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
        // .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    List<BookingModel> ticketOrder = ticketOrderSnapShot.docs
        .map((doc) => BookingModel.fromDoc(doc))
        .toList();
    if (ticketOrderSnapShot.docs.isNotEmpty) {
      _lastInviteDocument = ticketOrderSnapShot.docs.last;
    }
    if (mounted) {
      setState(() {
        _bookingList = ticketOrder;
        _isLoading = false;
        print('Donar');
      });
    }

    if (ticketOrderSnapShot.docs.length < 10) {
      _hasNext = false; // No more documents to load
    }

    return ticketOrder;
    // } catch (e) {
    //   print('Error fetching initial invites: $e');
    //   // Handle the error appropriately.
    //   return [];
    // }
  }

  _loadMoreDoners() async {
    try {
      Query activitiesQuery = newBookingsReceivedRef
          .doc(widget.userId)
          .collection('bookings')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<BookingModel> morePosts = postFeedSnapShot.docs
          .map((doc) => BookingModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _bookingList.addAll(morePosts);
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
      QuerySnapshot ticketOrderSnapShot = await newBookingsReceivedRef
          .doc(widget.userId)
          .collection('bookings')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<BookingModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => BookingModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _bookingList = ticketOrder;
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
      Query activitiesQuery = newBookingsSentRef
          .doc(widget.userId)
          .collection('bookings')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastInviteDocument!)
          .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<BookingModel> morePosts = postFeedSnapShot.docs
          .map((doc) => BookingModel.fromDoc(doc))
          .toList();
      if (postFeedSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = postFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _bookingList.addAll(morePosts);
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
    List<BookingModel> _bookingList,
  ) {
    return Scrollbar(
      controller: _hideButtonController,
      child: CustomScrollView(
        controller: _hideButtonController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                BookingModel booking = _bookingList[index];
                return BookingWidget(
                  currentUserId: widget.userId,
                  booking: booking,
                );
              },
              childCount: _bookingList.length,
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
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
                              from: 'Donations',
                            )),
                  ),
                )
              : _bookingList.isEmpty
                  ? Expanded(
                      child: Center(
                      child: NoContents(
                        icon: (Icons.calendar_month_outlined),
                        title: widget.isBooked
                            ? 'No bookings received,'
                            : 'No bookings made,',
                        subTitle: widget.isBooked
                            ? 'All the bookings you have made to support other creatives would appear here.'
                            : 'All the bookings other creatives have made to support you would appear here.',
                      ),
                    ))
                  : Expanded(
                      child: _buildDonationBuilder(
                      _bookingList,
                    )),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
