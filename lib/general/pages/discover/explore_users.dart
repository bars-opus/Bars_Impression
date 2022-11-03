import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:bars/utilities/exports.dart';

class UsersExpand extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  final String exploreLocation;
  UsersExpand(
      {required this.currentUserId,
      @required required this.exploreLocation,
      required this.user});
  @override
  _UsersExpandState createState() => _UsersExpandState();
}

class _UsersExpandState extends State<UsersExpand> {
  final _pageController = PageController();
  bool _showInfo = true;
  double page = 0.0;
  List<AccountHolder> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 5;
  bool _hasNext = true;
  bool _isFectchingUser = false;
  String _city = '';
  String _country = '';
  late double userLatitude;
  late double userLongitude;

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    _setShowInfo();
    widget.exploreLocation.endsWith('Live') ? _getCurrentLocation() : _nothing();
    widget.exploreLocation.endsWith('City')
        ? _setupCityUsers()
        : widget.exploreLocation.endsWith('Country')
            ? _setupCountryUsers()
            : widget.exploreLocation.endsWith('Live')
                ? _setupLiveUsers()
                : widget.exploreLocation.endsWith('Continent')
                    ? _setupContinentUsers()
                    : _setupUsers();
    // _setupUsers();
    super.initState();
  }

  _nothing(){}

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

  _setupUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        // .where('city', isEqualTo: widget.user.city)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _setupCityUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('city', isEqualTo: widget.user.city)
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreCityUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('city', isEqualTo: widget.user.city)
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _setupCountryUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreCountryUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('country', isEqualTo: widget.user.country)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _setupContinentUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('continent', isEqualTo: widget.user.continent)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreContinentUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('continent', isEqualTo: widget.user.continent)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  _setupLiveUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .limit(limit)
        .get();
    List<AccountHolder> users =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _hasNext = false;
        _userList = users;
      });
    }
    return users;
  }

  _loadMoreLiveUsers() async {
    if (_isFectchingUser) return;
    _isFectchingUser = true;
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle', isEqualTo: widget.user.profileHandle)
        .where('city', isEqualTo: _city)
        .where('country', isEqualTo: _country)
        .limit(limit)
        .startAfterDocument(_userSnapshot.last)
        .get();
    List<AccountHolder> moreusers =
        userFeedSnapShot.docs.map((doc) => AccountHolder.fromDoc(doc)).toList();
    if (_userSnapshot.length < limit) _hasNext = false;
    List<AccountHolder> allusers = _userList..addAll(moreusers);
    _userSnapshot.addAll((userFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        _userList = allusers;
      });
    }
    _hasNext = false;
    _isFectchingUser = false;
    return _hasNext;
  }

  @override
  void dispose() {
    _pageController.removeListener(_listenScroll);
    _pageController.dispose();
    super.dispose();
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
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                widget.user.profileImageUrl!.isEmpty
                    ? Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                        ),
                      )
                    : Container(
                        height: double.infinity,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Color(0xFFeff0f2),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.user.profileImageUrl!,
                              ),
                              fit: BoxFit.cover,
                            )),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: [
                                Colors.black.withOpacity(.5),
                                Colors.black.withOpacity(.5),
                              ])),
                        ),
                      ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.3)),
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Hero(
                              tag: 'work' + widget.user.id.toString(),
                              child: Material(
                                  color: Colors.transparent,
                                  child: ExploreClose()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: width / 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      widget.exploreLocation.startsWith('City')
                                          ? "Explore\n${widget.user.profileHandle}s\nin ${widget.user.city}"
                                          : widget.exploreLocation
                                                  .startsWith('Country')
                                              ? "Explore\n${widget.user.profileHandle}s in ${widget.user.country}"
                                              : widget.exploreLocation
                                                      .startsWith('Continent')
                                                  ? "Explore\n${widget.user.profileHandle}s in ${widget.user.continent}"
                                                  : widget.exploreLocation
                                                          .startsWith('Live')
                                                      ? "Explore\n${widget.user.profileHandle}s in $_city"
                                                      : 'Explore\n${widget.user.profileHandle}s',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            color:
                                _showInfo ? Colors.white : Colors.transparent,
                            text: 'Swipe',
                          ),
                        )),
                    _userList.length > 0
                        ? Expanded(
                            child: PageView.builder(
                                controller: _pageController,
                                itemCount: _userList.length,
                                onPageChanged: (i) {
                                  if (i == _userList.length - 1) {
                                    widget.exploreLocation.endsWith('City')
                                        ? _loadMoreCityUsers()
                                        : widget.exploreLocation
                                                .endsWith('Country')
                                            ? _loadMoreCountryUsers()
                                            : widget.exploreLocation
                                                    .endsWith('Live')
                                                ? _loadMoreLiveUsers()
                                                : widget.exploreLocation
                                                        .endsWith('Continent')
                                                    ? _loadMoreContinentUsers()
                                                    : _loadMoreUsers();
                                  }
                                },
                                itemBuilder: (context, index) {
                                  final user = _userList[index];
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
                                      ..rotateY(vector
                                          .radians(45 * factor * percent)),
                                    child: Opacity(
                                      opacity: (1 - opacity),
                                      child: UserExpandedWidget(
                                        user: user,
                                        currentUserId:
                                            Provider.of<UserData>(context)
                                                .currentUserId!,
                                        userId: widget.user.id!,
                                        userList: _userList,
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Expanded(
                            child: ListView(
                              children: [
                                PunchSchimmerSkeleton(),
                                PunchSchimmerSkeleton(),
                              ],
                            ),
                          )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserExpandedWidget extends StatefulWidget {
  final AccountHolder user;
  final String currentUserId;
  final String userId;
  final List<AccountHolder> userList;

  UserExpandedWidget(
      {required this.userList,
      required this.userId,
      required this.currentUserId,
      required this.user});

  @override
  _UserExpandedWidgetState createState() => _UserExpandedWidgetState();
}

class _UserExpandedWidgetState extends State<UserExpandedWidget> {
  // bool _isRatingUserPossitively = false;

  // int _possitiveRatedCount = 0;

  // int _possitiveRatingCount = 0;

  // bool _isRatingUserNegatively = false;

  // int _negativeRatedCount = 0;

  // int _negativeRatingCount = 0;

  // void initState() {
  //   super.initState();
  //   _setUpIsPossitivelyRating();
  //   _setUpPossitiveRated();
  //   _setUpPossitiveRating();
  //   _setUpIsNegativelyRating();
  //   _setUpNegativeRated();
  //   _setUpNegativeRating();
  // }

  // _setUpIsPossitivelyRating() async {
  //   bool isRattingUserPossitively =
  //       await DatabaseService.isPossitivelyRatingUser(
  //     currentUserId: widget.currentUserId,
  //     userId: widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _isRatingUserPossitively = isRattingUserPossitively;
  //     });
  //   }
  //   return _isRatingUserPossitively;
  // }

  // _setUpIsNegativelyRating() async {
  //   bool isRattingUserNegatively = await DatabaseService.isNegativelyRatingUser(
  //     currentUserId: widget.currentUserId,
  //     userId: widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _isRatingUserNegatively = isRattingUserNegatively;
  //     });
  //   }
  //   return _isRatingUserNegatively;
  // }

  // _setUpPossitiveRated() async {
  //   int userPossitiveRatedCount = await DatabaseService.numPosstiveRated(
  //     widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _possitiveRatedCount = userPossitiveRatedCount;
  //     });
  //   }
  //   return _possitiveRatedCount;
  // }

  // _setUpNegativeRated() async {
  //   int userNegativeRatedCount = await DatabaseService.numNegativeRated(
  //     widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _negativeRatedCount = userNegativeRatedCount;
  //     });
  //   }
  //   return _negativeRatedCount;
  // }

  // _setUpPossitiveRating() async {
  //   int userPossitiveRatingCount = await DatabaseService.numPossitiveRating(
  //     widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _possitiveRatingCount = userPossitiveRatingCount;
  //     });
  //   }
  //   return _possitiveRatingCount;
  // }

  // _setUpNegativeRating() async {
  //   int userNegativeRatingCount = await DatabaseService.numNegativeRating(
  //     widget.user.id!,
  //   );
  //   if (mounted) {
  //     setState(() {
  //       _negativeRatingCount = userNegativeRatingCount;
  //     });
  //   }
  //   return _negativeRatingCount;
  // }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProfileProfessionalProfile(
                    currentUserId:
                        Provider.of<UserData>(context).currentUserId!,
                    user: widget.user,
                    userId: widget.user.id!,
                  ))),
      child: Container(
        height: 800,
        width: double.infinity,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20,
                bottom: 30,
              ),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 10),
                      blurRadius: 10.0,
                      spreadRadius: 4.0,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100.0),
                        ),
                        child: Hero(
                          tag: 'container1' + widget.user.id.toString(),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: width > 600 ? 120 : 80.0,
                            backgroundImage:
                                widget.user.profileImageUrl!.isEmpty
                                    ? AssetImage(
                                        ConfigBloc().darkModeOn
                                            ? 'assets/images/user_placeholder.png'
                                            : 'assets/images/user_placeholder2.png',
                                      ) as ImageProvider
                                    : CachedNetworkImageProvider(
                                        widget.user.profileImageUrl!),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          new Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.user.name!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontFamily: 'Bessita',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.user.profileHandle!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              widget.user.company!,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width > 600 ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.user.bio!,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width > 600 ? 16 : 12.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                 const     SizedBox(height: 30),
                     
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
