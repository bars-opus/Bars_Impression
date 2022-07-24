import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:bars/utilities/exports.dart';

class ExploreEvent extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  final int askCount;
  final AccountHolder author;
  final Event event;
  final int feed;
  final String exploreLocation;

  ExploreEvent(
      {required this.currentUserId,
      required this.askCount,
      required this.author,
      required this.feed,
      required this.exploreLocation,
      required this.event,
      required this.user});
  @override
  _ExploreEventState createState() => _ExploreEventState();
}

class _ExploreEventState extends State<ExploreEvent> {
  final _pageController = PageController();
  final _eventSnapshot = <DocumentSnapshot>[];
  List<Event> _eventsList = [];
  bool _showInfo = true;
  double page = 0.0;
  int limit = 2;
  bool _hasNext = true;
  bool _isFetchingEvent = false;
  String _city = '';
  String _country = '';
  late double userLatitude;
  late double userLongitude;

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    _setShowInfo();
    widget.exploreLocation.endsWith('Live') ? _getCurrentLocation() : () {};
    widget.exploreLocation.endsWith('City')
        ? _setUpCityFeed()
        : widget.exploreLocation.endsWith('Country')
            ? _setUpCountryFeed()
            : widget.exploreLocation.endsWith('Live')
                ? _setUpLiveFeed()
                : widget.exploreLocation.endsWith('Virtual')
                    ? _setUpVirtualFeed()
                    : _setUpFeed();

    super.initState();
  }

  _setShowInfo() {
    if (_showInfo) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  void _listenScroll() {
    setState(() {
      page = _pageController.page!;
    });
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
  }

  _setUpFeed() async {
    widget.feed == 1
        ? _setupFeedEvent()
        : widget.feed == 2
            ? _setupAllEvent()
            : widget.feed == 3
                ? _setupAllCategoryEvent()
                : widget.feed == 4
                    ? _setupProfileEvent()
                    : () {};
  }

  _loadMore() {
    widget.feed == 1
        ? _loadMoreEvents()
        : widget.feed == 2
            ? _loadMoreAllEvents()
            : widget.feed == 3
                ? _loadMoreAllCategoryEvent()
                : widget.feed == 3
                    ? _loadMoreProfileEvents()
                    : () {};
  }

  _setUpCityFeed() async {
    widget.feed == 2
        ? _setupAllCityEvent()
        : widget.feed == 3
            ? _setupCategoryCityEvent()
            : () {};
  }

  _loadMoreCity() {
    widget.feed == 2
        ? _loadMoreAllCityEvents()
        : widget.feed == 3
            ? _loadMoreCategoryCityEvent()
            : () {};
  }

  _setUpCountryFeed() async {
    widget.feed == 2
        ? _setupAllCountryEvent()
        : widget.feed == 3
            ? _setupCategoryCountryEvent()
            : () {};
  }

  _loadMoreCountry() {
    widget.feed == 2
        ? _loadMoreAllCountryEvents()
        : widget.feed == 3
            ? _loadMoreCategoryCountryEvent()
            : () {};
  }

  _setUpLiveFeed() async {
    widget.feed == 2
        ? _setupAllLiveEvent()
        : widget.feed == 3
            ? _setupCategoryLiveEvent()
            : () {};
  }

  _loadMoreLive() {
    widget.feed == 2
        ? _loadMoreAllLiveEvents()
        : widget.feed == 3
            ? _loadMoreCategoryLiveEvent()
            : () {};
  }

  _setUpVirtualFeed() async {
    widget.feed == 2
        ? _setupAllVirtualEvent()
        : widget.feed == 3
            ? _setupCategoryVirtualEvent()
            : () {};
  }

  _loadMoreVirtual() {
    widget.feed == 2
        ? _loadMoreAllVirtualEvents()
        : widget.feed == 3
            ? _loadMoreCategoryVirtualEvent()
            : () {};
  }

  _getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = geoposition.latitude;
      userLongitude = geoposition.longitude;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(userLatitude, userLongitude);
    setState(() {
      _city = (placemarks[0].locality == null ? '' : placemarks[0].locality)!;
      _country = (placemarks[0].country == null ? '' : placemarks[0].country)!;
    });
  }

  _setupFeedEvent() async {
    QuerySnapshot eventFeedSnapShot = await eventFeedsRef
        .doc(
          widget.currentUserId,
        )
        .collection('userEventFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }

    return events;
  }

  _loadMoreEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await eventFeedsRef
        .doc(widget.currentUserId)
        .collection('userEventFeed')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }

    return events;
  }

  _loadMoreAllEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllCategoryEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreAllCategoryEvent() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllCityEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.user.city)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }

    return events;
  }

  _loadMoreAllCityEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.user.city)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupCategoryCityEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.user.city)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreCategoryCityEvent() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: widget.user.city)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllCountryEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreAllCountryEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupCategoryCountryEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreCategoryCountryEvent() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('country', isEqualTo: widget.user.country)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllLiveEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreAllLiveEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupCategoryLiveEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreCategoryLiveEvent() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .where('type', isEqualTo: widget.event.type)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupAllVirtualEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreAllVirtualEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupCategoryVirtualEvent() async {
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
        .where('type', isEqualTo: 'Festival')
        .limit(limit)
        .get();
    List<Event> events =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }
    return events;
  }

  _loadMoreCategoryVirtualEvent() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot eventFeedSnapShot = await allEventsRef
        .where('isVirtual', isEqualTo: true)
        .where('type', isEqualTo: 'Festival')
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((eventFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  _setupProfileEvent() async {
    QuerySnapshot userEventsSnapshot = await eventsRef
        .doc(widget.currentUserId)
        .collection('userEvents')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    List<Event> events =
        userEventsSnapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
    _eventSnapshot.addAll((userEventsSnapshot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _eventsList = events;
      });
    }

    return events;
  }

  _loadMoreProfileEvents() async {
    if (_isFetchingEvent) return;
    _isFetchingEvent = true;
    _hasNext = true;
    QuerySnapshot userEventsSnapshot = await eventsRef
        .doc(widget.currentUserId)
        .collection('userEvents')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .startAfterDocument(_eventSnapshot.last)
        .get();
    List<Event> moreevents =
        userEventsSnapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
    if (_eventSnapshot.length < limit) _hasNext = false;
    List<Event> allevents = _eventsList..addAll(moreevents);
    _eventSnapshot.addAll((userEventsSnapshot.docs));
    if (mounted) {
      setState(() {
        _eventsList = allevents;
      });
    }
    _hasNext = false;
    _isFetchingEvent = false;
    return _hasNext;
  }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 5,
    double sigmaY = 5,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );

  final backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF444a55),
        Color(0xFFf2f2f2),
      ]);

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFF1a1a1a)
                    : Color(0xFFeff0f2),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.event.imageUrl,
                  ),
                  fit: BoxFit.cover,
                )),
            child: Container(
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(begin: Alignment.bottomRight, colors: [
                Colors.black.withOpacity(.5),
                Colors.black.withOpacity(.5),
              ])),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                decoration: BoxDecoration(
                    color: widget.event.report.isNotEmpty
                        ? Colors.black.withOpacity(.9)
                        : Colors.black.withOpacity(0.3)),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Hero(
                          tag: 'close' + widget.event.id.toString(),
                          child: Material(
                              color: Colors.transparent, child: ExploreClose()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: widget.exploreLocation.endsWith('City')
                                    ? Text(
                                        widget.feed == 2
                                            ? "Explore\nAll Events\nIn ${widget.user.city}"
                                            : widget.feed == 3
                                                ? "Explore\n${widget.event.type == 'Others' ? widget.event.type : widget.event.type + 's'}\nIn ${widget.user.city}"
                                                : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.end,
                                      )
                                    : widget.exploreLocation.endsWith('Country')
                                        ? Text(
                                            widget.feed == 2
                                                ? "Explore\nAll Events\nIn ${widget.user.country}"
                                                : widget.feed == 3
                                                    ? "Explore\n${widget.event.type == 'Others' ? widget.event.type : widget.event.type + 's'}\nIn ${widget.user.country}"
                                                    : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.end,
                                          )
                                        : widget.exploreLocation
                                                .endsWith('Live')
                                            ? Text(
                                                widget.feed == 2
                                                    ? "Explore\nAll Events\nIn ${_city}"
                                                    : widget.feed == 3
                                                        ? "Explore\n${widget.event.type == 'Others' ? widget.event.type : widget.event.type + 's'}\nIn ${_city}"
                                                        : '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                                textAlign: TextAlign.end,
                                              )
                                            : widget.exploreLocation
                                                    .endsWith('Virtual')
                                                ? Text(
                                                    widget.feed == 2
                                                        ? "Explore\nAll Virtual\nEvents"
                                                        : widget.feed == 3
                                                            ? "Explore\nVirtual\n${widget.event.type == 'Others' ? widget.event.type : widget.event.type + 's'}"
                                                            : '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                  )
                                                : Text(
                                                    widget.feed == 1
                                                        ? "Explore\nEvents"
                                                        : widget.feed == 2
                                                            ? "Explore\nAll Events"
                                                            : widget.feed == 3
                                                                ? "Explore\n${widget.event.type == 'Others' ? widget.event.type : widget.event.type + 's'}\n"
                                                                : widget.feed ==
                                                                        4
                                                                    ? "Explore\nProfile Events"
                                                                    : '',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                    textAlign: TextAlign.end,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800),
                      height: _showInfo ? 40 : 0.0,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: Swipinfo(
                          color: _showInfo ? Colors.white : Colors.transparent,
                          text: 'Swipe',
                        ),
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  _eventsList.length > 0
                      ? Expanded(
                          child: PageView.builder(
                              controller: _pageController,
                              itemCount: _eventsList.length,
                              onPageChanged: (i) {
                                if (i == _eventsList.length - 1) {
                                  widget.exploreLocation.endsWith('City')
                                      ? _loadMoreCity()
                                      : widget.exploreLocation
                                              .endsWith('Country')
                                          ? _loadMoreCountry()
                                          : widget.exploreLocation
                                                  .endsWith('Live')
                                              ? _loadMoreLive()
                                              : widget.exploreLocation
                                                      .endsWith('Virtual')
                                                  ? _loadMoreVirtual()
                                                  : _loadMore();
                                }
                              },
                              itemBuilder: (context, index) {
                                final event = _eventsList[index];
                                final percent =
                                    (page - index).abs().clamp(0.0, 1.0);
                                final factor = _pageController
                                            .position.userScrollDirection ==
                                        ScrollDirection.forward
                                    ? 1.0
                                    : -1.0;
                                final opacity = percent.clamp(0.0, 0.7);

                                return Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateY(
                                        vector.radians(45 * factor * percent)),
                                  child: Opacity(
                                    opacity: (1 - opacity),
                                    child: ExploreEventEnlarged(
                                      event: event,
                                      user: widget.user,
                                      exploreLocation: widget.exploreLocation,
                                      feed: widget.feed,
                                      author: widget.author,
                                      currentUserId:
                                          Provider.of<UserData>(context)
                                              .currentUserId!,
                                      askCount: 0,
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Expanded(child: ExploreEventsSchimmerSkeleton()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreEventEnlarged extends StatefulWidget {
  final String currentUserId;
  final Event event;
  final AccountHolder author;
  final AccountHolder user;
  final int askCount;
  final int feed;
  final String exploreLocation;

  ExploreEventEnlarged(
      {required this.currentUserId,
      required this.user,
      required this.askCount,
      required this.feed,
      required this.exploreLocation,
      required this.event,
      required this.author});

  @override
  _ExploreEventEnlargedState createState() => _ExploreEventEnlargedState();
}

class _ExploreEventEnlargedState extends State<ExploreEventEnlarged> {
  late DateTime _date;
  late DateTime _toDaysDate;
  int _different = 0;
  void initState() {
    super.initState();

    _countDown();
  }

  _countDown() async {
    DateTime date = DateTime.parse(widget.event.date);
    final toDayDate = DateTime.now();
    var different = date.difference(toDayDate).inDays;

    setState(() {
      _date = date;
      _different = different;
      _toDaysDate = toDayDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> datePartition =
        MyDateFormat.toDate(DateTime.parse(widget.event.date)).split(" ");
    final List<String> timePartition =
        MyDateFormat.toTime(DateTime.parse(widget.event.time)).split(" ");
    final List<String> namePartition = widget.event.title.split(" ");
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllEvenEnlargedProfile(
                          currentUserId: widget.currentUserId,
                          event: widget.event,
                          author: widget.author,
                          user: widget.user,
                          feed: widget.feed,
                          exploreLocation: widget.exploreLocation,
                          askCount: 0,
                        ))),
            child: Center(
              child: Stack(alignment: FractionalOffset.bottomCenter, children: <
                  Widget>[
                Stack(children: <Widget>[
                  Hero(
                    tag: 'imageProfile' + widget.event.id.toString(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Color(0xFFf2f2f2),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AllEvenEnlargedProfile(
                                      currentUserId: widget.currentUserId,
                                      event: widget.event,
                                      author: widget.author,
                                      user: widget.user,
                                      exploreLocation: widget.exploreLocation,
                                      feed: widget.feed,
                                      askCount: null,
                                    ))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 8),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFF1a1a1a)
                                    : Color(0xFFeff0f2),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    widget.event.imageUrl,
                                  ),
                                  fit: BoxFit.cover,
                                )),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      colors: [
                                        widget.event.report.isNotEmpty
                                            ? Colors.black.withOpacity(.9)
                                            : Colors.black.withOpacity(.6),
                                        widget.event.report.isNotEmpty
                                            ? Colors.black.withOpacity(.9)
                                            : Colors.black.withOpacity(.6),
                                      ])),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 10.0, right: 10.0),
                      child: Container(
                          child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: widget.event.report.isNotEmpty
                            ? Center(child: ContentWarningMini())
                            : _toDaysDate.isAfter(_date)
                                ? EventCompletedWidget(
                                    date: widget.event.date,
                                    onPressed: () {},
                                    previousEvent: widget.event.previousEvent,
                                    type: widget.event.type,
                                    title: widget.event.title,
                                    time: widget.event.time,
                                  )
                                : Column(children: <Widget>[
                                    ShakeTransition(
                                      child: Tooltip(
                                        padding: EdgeInsets.all(20.0),
                                        message: widget.event.type
                                                .startsWith('F')
                                            ? 'FESTIVAL'
                                            : widget.event.type.startsWith('Al')
                                                ? 'ALBUM LAUNCH'
                                                : widget.event.type
                                                        .startsWith('Aw')
                                                    ? 'AWARD'
                                                    : widget.event.type
                                                            .startsWith('O')
                                                        ? 'OTHERS'
                                                        : widget.event.type
                                                                .startsWith('T')
                                                            ? 'TOUR'
                                                            : '',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: 35.0,
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                primary: Colors.blue,
                                                side: BorderSide(
                                                    width: 1.0,
                                                    color: Colors.white),
                                              ),
                                              child: Text(
                                                widget.event.type
                                                        .startsWith('F')
                                                    ? 'FE'
                                                    : widget.event.type
                                                            .startsWith('Al')
                                                        ? 'AL'
                                                        : widget.event.type
                                                                .startsWith(
                                                                    'Aw')
                                                            ? 'AW'
                                                            : widget.event.type
                                                                    .startsWith(
                                                                        'O')
                                                                ? 'OT'
                                                                : widget.event
                                                                        .type
                                                                        .startsWith(
                                                                            'T')
                                                                    ? 'TO'
                                                                    : '',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              onPressed: () => () {},
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ShakeTransition(
                                      axis: Axis.vertical,
                                      child: new Material(
                                        color: Colors.transparent,
                                        child: RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: namePartition[0]
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 50,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (namePartition.length > 1)
                                              TextSpan(
                                                text:
                                                    "\n${namePartition[1].toUpperCase()} ",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (namePartition.length > 2)
                                              TextSpan(
                                                text:
                                                    "\n${namePartition[2].toUpperCase()} ",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (namePartition.length > 3)
                                              TextSpan(
                                                text:
                                                    "\n${namePartition[3].toUpperCase()} ",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (namePartition.length > 4)
                                              TextSpan(
                                                text:
                                                    "\n${namePartition[4].toUpperCase()} ",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            if (namePartition.length > 5)
                                              TextSpan(
                                                text:
                                                    "\n${"namePartition"[5].toUpperCase()} ",
                                                style: TextStyle(
                                                  fontSize: 50,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                          ]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    ShakeTransition(
                                      child: Container(
                                        height: 1.0,
                                        width: 200,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: datePartition[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (datePartition.length > 1)
                                                TextSpan(
                                                  text:
                                                      "\n${datePartition[1].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (datePartition.length > 2)
                                                TextSpan(
                                                  text:
                                                      "\n${datePartition[2].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Container(
                                            height: 50,
                                            width: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        RichText(
                                          textScaleFactor:
                                              MediaQuery.of(context)
                                                  .textScaleFactor,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: timePartition[0]
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (timePartition.length > 1)
                                                TextSpan(
                                                  text:
                                                      "\n${timePartition[1].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              if (timePartition.length > 2)
                                                TextSpan(
                                                  text:
                                                      "\n${timePartition[2].toUpperCase()} ",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    ShakeTransition(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30.0),
                                        child: Text(
                                          widget.event.theme,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                    ),
                                    RichText(
                                      textScaleFactor: MediaQuery.of(context)
                                          .textScaleFactor,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: _different.toString(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '\nDays\nMore',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        width: 30,
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        width: 30,
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                        color: Colors.white,
                                        width: 30,
                                        height: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Text(
                                        widget.event.type.startsWith('Fe')
                                            ? 'Festival'
                                            : widget.event.type.startsWith('Al')
                                                ? 'Album Launch'
                                                : widget.event.type
                                                        .startsWith('Aw')
                                                    ? 'Award'
                                                    : widget.event.type
                                                            .startsWith('O')
                                                        ? 'Others'
                                                        : widget.event.type
                                                                .startsWith('T')
                                                            ? 'Tour'
                                                            : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Bessita',
                                        ),
                                      ),
                                    )
                                  ]),
                      )))
                ])
              ]),
            ),
          )),
    );
  }
}
