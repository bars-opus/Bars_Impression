import 'dart:math';

import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//14th August 2023 : 11:07pm
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class DiscographyPageView extends StatefulWidget {
  final String currentUserId;
  final String types;
  final UserStoreModel user;
  final int userIndex;
  final int pageIndex;
  final List<UserStoreModel> userList;
  final List<DocumentSnapshot> userSnapshot;
  final String liveCity;
  final String liveCountry;
  final String isFrom;

  DiscographyPageView({
    required this.userList,
    required this.userSnapshot,
    required this.currentUserId,
    required this.user,
    required this.userIndex,
    required this.pageIndex,
    required this.types,
    required this.liveCity,
    required this.liveCountry,
    required this.isFrom,
  });

  @override
  State<DiscographyPageView> createState() => _DiscographyPageViewState();
}

class _DiscographyPageViewState extends State<DiscographyPageView> {
  late PageController _pageController2;
  List<UserStoreModel> _filteredUsers = [];
  final _filteredUserSnapshot = <DocumentSnapshot>[];

  double page = 0.0;
  int limit = 2;

  int _currentPageIndex = 0;
  int _feedCount = 0;
  bool _isSnackbarShown = false;
  String _isSnackbarType = '';
  late Timer _timer;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _pageController2 = PageController(
      initialPage: widget.pageIndex,
    );
    _filteredUsers = widget.userList;
    _pageController2.addListener(_onPageChanged);
    _timer = Timer(Duration(seconds: 0), () {});
  }

  void _onPageChanged() {
    if (_timer.isActive) {
      _timer.cancel();
    }

    _timer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isSnackbarShown = false;
        });
      }
    });

    int pageIndex = _pageController2.page!.round();
    if (_currentPageIndex != pageIndex) {
      _updateUsers(pageIndex);
      _currentPageIndex = pageIndex;
    }
  }

  Future<void> _setUpFeedCount(String type) async {
    int feedCount = await DatabaseService.numUsersAll(type);
    if (mounted) {
      setState(() {
        _feedCount = feedCount;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController2.addListener(_onPageChanged);
    });
  }

  @override
  void dispose() {
    _pageController2.dispose();
    _pageController2.removeListener(_onPageChanged);
    _timer.cancel();

    super.dispose();
  }

  Map<int, String> eventTypes = {
    0: 'Salon',
    1: 'Producer',
    2: 'DJ',
    3: 'Dancer',
    4: 'Videographer',
    5: 'Content_creator',
    6: 'Photographer',
    7: 'Caterers',
    8: 'Sound_and_Light',
    9: 'Decorator',
    10: 'Record_Label',
    11: 'Brand_Influencer',
    12: 'Event_organiser',
    13: 'Barbershop',
    14: 'Instrumentalist',
    15: 'Graphic_Designer',
    16: 'Makeup_Salon',
    17: 'Video_Vixen',
    18: 'Blogger',
    19: 'MC(Host)',
    20: 'Choir',
    21: 'Spa',
    22: 'Fan',
  };

  void _updateUsers(int pageIndex) async {
    HapticFeedback.lightImpact();
    if (eventTypes.containsKey(pageIndex)) {
      _updating(pageIndex, eventTypes[pageIndex]!);
    }
  }

  _updating(int pageIndex, String type) {
    _setUpFeedCount(type);
    if (mounted) {
      setState(() {
        _currentPageIndex = pageIndex;
        _filteredUsers.clear();
        _filteredUserSnapshot.clear();
        _loading = true;
        _isSnackbarShown = true;
        _isSnackbarType = type;
      });
    }

    widget.liveCity.isNotEmpty
        ? _setupUsers(
            type: type,
            city: widget.liveCity,
            country: widget.liveCountry,
          )
        : widget.isFrom.isNotEmpty
            ? _setUpCityCountry(type)
            : _setupUsers(type: type);
  }

  _setUpCityCountry(
    String type,
  ) {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return widget.isFrom.startsWith('City')
        ? _setupUsers(
            city: _userLocationSettings!.city,
            country: _userLocationSettings.country,
            type: type,
          )
        : _setupUsers(
            country: _userLocationSettings!.country,
            type: type,
          );
  }

  void _showBottomSheetErrorMessage() {
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
          title: 'Failed to fetch creatives.',
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  Future<List<UserStoreModel>> _setupUsers({
    required String type,
    String? country,
    String? city,
    String? continent,
  }) async {
    setState(() {
      _loading = true;
    });

    var query = userProfessionalRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('shopType', isEqualTo: type)
        .where('noBooking', isEqualTo: false);

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (continent != null) {
      query = query.where('continent', isEqualTo: continent);
    }

    final randomValue = Random().nextDouble();

    try {
      QuerySnapshot eventFeedSnapShot = await query
          .where('randomId', isGreaterThanOrEqualTo: randomValue)
          .orderBy('randomId')
          .limit(2)
          .get();

      List<UserStoreModel> users = eventFeedSnapShot.docs
          .map((doc) => UserStoreModel.fromDoc(doc))
          .toList();

      if (mounted) {
        setState(() {
          _filteredUsers = users;
          _filteredUserSnapshot.addAll((eventFeedSnapShot.docs));
          _loading = false;
        });
      }
      return users;
    } catch (e) {
      _showBottomSheetErrorMessage();
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      return [];
    }
  }

  _noUsers(String type) {
    return Container(
      color: Colors.grey[300],
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            child: Center(
              child: NoContents(
                icon: Icons.account_circle_rounded,
                subTitle:
                    'There are no $type\s at the moment. We would update you if new $type\s are available. You can swipe left or right to explore other creatives.',
                title: 'No $type\s',
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 10,
            child: IconButton(
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back_ios),
              iconSize: 30.0,
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        alignment: FractionalOffset.bottomCenter,
        children: [
          PageView(
            controller: _pageController2,
            onPageChanged: _updateUsers,
            children: List.generate(23, (index) {
              String eventType = '';
              int tabIndex = 0;
              switch (index) {
                case 0:
                  eventType = 'Salon';
                  tabIndex = 0;
                  break;
                case 1:
                  eventType = 'Producer';
                  tabIndex = 1;
                  break;
                case 2:
                  eventType = 'DJ';
                  tabIndex = 2;
                  break;
                case 3:
                  eventType = 'Dancer';
                  tabIndex = 3;
                  break;
                case 4:
                  eventType = 'Videographer';
                  tabIndex = 4;
                  break;
                case 5:
                  eventType = 'Content_creator';
                  tabIndex = 5;
                  break;
                case 6:
                  eventType = 'Photographer';
                  tabIndex = 6;
                  break;
                case 7:
                  eventType = 'Caterers';
                  tabIndex = 7;
                  break;
                case 8:
                  eventType = 'Sound_and_Light';
                  tabIndex = 8;
                  break;
                case 9:
                  eventType = 'Decorator';
                  tabIndex = 9;
                  break;
                case 10:
                  eventType = 'Record_Label';
                  tabIndex = 10;
                  break;
                case 11:
                  eventType = 'Brand_Influencer';
                  tabIndex = 11;
                  break;
                case 12:
                  eventType = 'Event_organiser';
                  tabIndex = 12;
                  break;
                case 13:
                  eventType = 'Barbershop';
                  tabIndex = 13;
                  break;
                case 14:
                  eventType = 'Instrumentalist';
                  tabIndex = 14;
                  break;
                case 15:
                  eventType = 'Graphic_Designer';
                  tabIndex = 15;
                  break;
                case 16:
                  eventType = 'Makeup_Salon';
                  tabIndex = 16;
                  break;
                case 17:
                  eventType = 'Video_Vixen';
                  tabIndex = 17;
                  break;
                case 18:
                  eventType = 'Blogger';
                  tabIndex = 18;
                  break;
                case 19:
                  eventType = 'MC(Host)';
                  tabIndex = 19;
                  break;
                case 20:
                  eventType = 'Choir';
                  tabIndex = 20;
                  break;
                case 21:
                  eventType = 'Spa';
                  tabIndex = 21;
                  break;
                case 22:
                  eventType = 'Fan';
                  tabIndex = 22;
                  break;
              }
              return _loading
                  ? CircularProgress(isMini: false)
                  : _feedCount.isNegative
                      ? _noUsers(eventType)
                      : eventType.startsWith('Fan')
                          ? ProfileScreen(accountType: 'Shop',
                              currentUserId: widget.currentUserId,
                              user: null,
                              userId: widget.user.userId,
                            )
                          : DiscographyPages(
                              types: eventType,
                              pageIndex: tabIndex,
                              currentUserId: widget.currentUserId,
                              userIndex: widget.userIndex,
                              user: widget.user,
                              userList: _filteredUsers,
                              userSnapshot: _filteredUsers.isEmpty
                                  ? widget.userSnapshot
                                  : _filteredUserSnapshot,
                              liveCity: widget.liveCity,
                              liveCountry: widget.liveCountry,
                              isFrom: widget.isFrom,
                            );
            }),
          ),
          Positioned(
            bottom: 30,
            child: InfoWidget(
              info: _isSnackbarType,
              onPressed: () {},
              show: _isSnackbarShown,
            ),
          ),
        ],
      ),
    );
  }
}
