import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:bars/utilities/exports.dart';

class ExpandAllCityUsers extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  ExpandAllCityUsers({required this.currentUserId, required this.user});
  @override
  _ExpandAllCityUsersState createState() => _ExpandAllCityUsersState();
}

class _ExpandAllCityUsersState extends State<ExpandAllCityUsers> {
  final _pageController = PageController();
  bool _showInfo = true;
  double page = 0.0;
  List<AccountHolder> _userList = [];
  final _userSnapshot = <DocumentSnapshot>[];
  int limit = 5;
  bool _hasNext = true;
  bool _isFectchingUser = false;

  @override
  void initState() {
    _pageController.addListener(_listenScroll);
    _setShowInfo();
    _setupUsers();
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

  _setupUsers() async {
    QuerySnapshot userFeedSnapShot = await usersRef
        .where('profileHandle!', isEqualTo: widget.user.profileHandle!)
        .where('city', isEqualTo: widget.user.city)
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
        .where('profileHandle!', isEqualTo: widget.user.profileHandle!)
        .where('city', isEqualTo: widget.user.city)
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Explore\nUsers",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    textAlign: TextAlign.end,
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
                    ShakeTransition(
                    axis: Axis.vertical,
                    curve: Curves.easeInOut,
                    offset: 40,
                    child: AnimatedContainer(
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 800),
                        height: _showInfo ? 40 : 0.0,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Center(
                          child: AnimatedInfoWidget(
                            buttonColor: Colors.white,
                            text: '< < < Swipe',
                            requiredBool: _showInfo,
                          ),
                          // Swipinfo(
                          //   color: _showInfo ? Colors.white : Colors.transparent,
                          //   text: 'Swipe',
                          // ),
                        )),
                  ),
                    _userList.length > 0
                        ? Expanded(
                            child: PageView.builder(
                                controller: _pageController,
                                itemCount: _userList.length,
                                onPageChanged: (i) {
                                  if (i == _userList.length - 1) {
                                    _loadMoreUsers();
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
    // int _point = _possitiveRatedCount - _negativeRatedCount;
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
      child: ListView(
        children: [
          SingleChildScrollView(
            child: Container(
              child: SingleChildScrollView(
                child: Padding(
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
                      color:
                          ConfigBloc().darkModeOn ? Colors.grey : Colors.white,
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
                              color: ConfigBloc().darkModeOn
                                  ? Color(0xFF1f2022)
                                  : Color(0xFFf2f2f2),
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Hero(
                              tag: 'container1' + widget.user.id.toString(),
                              child: ShakeTransition(
                                curve: Curves.easeOutBack,
                                child: CircleAvatar(
                                  backgroundColor: ConfigBloc().darkModeOn
                                      ? Color(0xFF1f2022)
                                      : Color(0xFFf2f2f2),
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
                        const  SizedBox(height: 30),
                        
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                  color: ConfigBloc().darkModeOn ? Colors.grey : Colors.white,
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
                      Container(
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // widget.user.profileHandle!.startsWith('F') ||
                            //         widget.user.profileHandle!.isEmpty
                            //     ? const SizedBox.shrink()
                            //     : Hero(
                            //         tag: 'container2' +
                            //             widget.user.id.toString(),
                            //         child: RichText(
                            //           textScaleFactor: MediaQuery.of(context)
                            //               .textScaleFactor,
                            //           text: TextSpan(
                            //             children: [
                            //               TextSpan(
                            //                   text: NumberFormat.compact()
                            //                       .format(_point),
                            //                   style: TextStyle(
                            //                       fontSize: 30,
                            //                       color: ConfigBloc().darkModeOn
                            //                           ? Colors.white
                            //                           : Colors.black,
                            //                       fontWeight: FontWeight.bold)),
                            //               TextSpan(
                            //                   text: "\nBars score. ",
                            //                   style: TextStyle(
                            //                     fontSize: 14,
                            //                     color: Colors.black,
                            //                   )),
                            //               TextSpan(
                            //                 text:
                            //                     "\nBased on ${_point.toString()} ratings. ",
                            //                 style: TextStyle(
                            //                   fontSize: 14,
                            //                   color: Colors.black,
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //           textAlign: TextAlign.center,
                            //         ),
                            //       ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Stars(
                                //   score: widget.user.score!,
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ShakeTransition(
                              child: Container(
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RichText(
                          textScaleFactor:
                              MediaQuery.of(context).textScaleFactor,
                          text: TextSpan(children: [
                            TextSpan(
                                children: [
                                  TextSpan(
                                      text: 'Username: ',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.userName}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: 'Nick name/ Stage name: ',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.name}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: 'City/ Country & Continent: ',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.city}/ ",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.country}/ ",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.continent}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                    text: widget.user.profileHandle!
                                            .startsWith('Ar')
                                        ? 'Music Skills:'
                                        : widget.user.profileHandle!
                                                .startsWith('Co')
                                            ? 'Design Skills'
                                            : widget.user.profileHandle!
                                                    .startsWith('Da')
                                                ? 'Dance Skills'
                                                : widget.user.profileHandle!
                                                        .startsWith('Ph')
                                                    ? 'Photography Skills'
                                                    : widget.user.profileHandle!
                                                            .startsWith('Re')
                                                        ? 'Recording Services'
                                                        : widget.user
                                                                .profileHandle!
                                                                .startsWith(
                                                                    'Mu')
                                                            ? 'Video Skills'
                                                            : widget.user
                                                                    .profileHandle!
                                                                    .startsWith(
                                                                        'Bl')
                                                                ? 'Blogging Skills'
                                                                : widget.user
                                                                        .profileHandle!
                                                                        .startsWith(
                                                                            'Br')
                                                                    ? 'Influencing Skills'
                                                                    : widget.user
                                                                            .profileHandle!
                                                                            .startsWith('Ba')
                                                                        ? 'Battling Skills'
                                                                        : widget.user.profileHandle!.endsWith('J')
                                                                            ? 'Dj Skills'
                                                                            : widget.user.profileHandle!.endsWith('xen')
                                                                                ? 'Video Peforming Skills'
                                                                                : widget.user.profileHandle!.startsWith('Pr')
                                                                                    ? 'Production Skills'
                                                                                    : " ",
                                    style: TextStyle(
                                      fontSize: width > 600 ? 14 : 12.0,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.blueGrey
                                          : Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                      text: "${widget.user.skills}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                              .startsWith('Ar')
                                          ? 'Music Performances: '
                                          : widget.user.profileHandle!
                                                  .startsWith('Co')
                                              ? 'Design Exhibitions: '
                                              : widget.user.profileHandle!
                                                      .startsWith('Ph')
                                                  ? 'Photo Exhibitions: '
                                                  : widget.user.profileHandle!
                                                          .startsWith('Da')
                                                      ? 'Dance performancess: '
                                                      : widget.user
                                                              .profileHandle!
                                                              .startsWith('Ba')
                                                          ? 'Batlle Stages: '
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .endsWith('J')
                                                              ? 'Performances: '
                                                              : '',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                                  .startsWith('Vi') ||
                                              widget.user.profileHandle!
                                                  .startsWith("Bl") ||
                                              widget.user.profileHandle!
                                                  .startsWith("Br") ||
                                              widget.user.profileHandle!
                                                  .startsWith("Re") ||
                                              widget.user.profileHandle!
                                                  .endsWith("xen") ||
                                              widget.user.profileHandle!
                                                  .startsWith("Mu") ||
                                              widget.user.profileHandle!
                                                  .startsWith("Pr")
                                          ? ''
                                          : " ${widget.user.performances}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                              .startsWith('Ar')
                                          ? 'Music Collaborations: '
                                          : widget.user.profileHandle!
                                                  .startsWith('Co')
                                              ? 'Design Collaborations: '
                                              : widget.user.profileHandle!
                                                      .startsWith('Da')
                                                  ? 'Danced With: '
                                                  : widget.user.profileHandle!
                                                          .startsWith('Ph')
                                                      ? 'Worked With: '
                                                      : widget.user
                                                              .profileHandle!
                                                              .startsWith('Mu')
                                                          ? 'Video Works: '
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .endsWith(
                                                                      'xen')
                                                              ? 'Video appearances: '
                                                              : widget.user
                                                                      .profileHandle!
                                                                      .startsWith(
                                                                          'Bl')
                                                                  ? 'Blogged About: '
                                                                  : widget.user
                                                                          .profileHandle!
                                                                          .startsWith(
                                                                              'Br')
                                                                      ? 'Worked with: '
                                                                      : widget.user.profileHandle!.startsWith('Ba')
                                                                          ? 'Battled Against: '
                                                                          : widget.user.profileHandle!.endsWith('J')
                                                                              ? 'Dj Collaborations: '
                                                                              : widget.user.profileHandle!.startsWith('Re')
                                                                                  ? 'Partners: '
                                                                                  : widget.user.profileHandle!.startsWith('Pr')
                                                                                      ? 'Production Collaborations: '
                                                                                      : '',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.collaborations}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: widget.user.profileHandle!
                                              .startsWith('Ar')
                                          ? 'Music Awards:'
                                          : widget.user.profileHandle!
                                                  .startsWith('Co')
                                              ? 'Design Awards: '
                                              : widget.user.profileHandle!
                                                      .startsWith('Da')
                                                  ? 'Dance Awards: '
                                                  : widget.user.profileHandle!
                                                          .startsWith('Ph')
                                                      ? 'Photography Awards: '
                                                      : widget.user
                                                              .profileHandle!
                                                              .startsWith('Re')
                                                          ? 'Awards: '
                                                          : widget.user
                                                                  .profileHandle!
                                                                  .startsWith(
                                                                      'Mu')
                                                              ? 'Video Awards: '
                                                              : widget.user
                                                                      .profileHandle!
                                                                      .endsWith(
                                                                          'xen')
                                                                  ? 'Awards: '
                                                                  : widget.user
                                                                          .profileHandle!
                                                                          .startsWith(
                                                                              'Bl')
                                                                      ? 'Blogging Awards: '
                                                                      : widget.user.profileHandle!.startsWith('Ba')
                                                                          ? 'Battle Awards: '
                                                                          : widget.user.profileHandle!.endsWith('J')
                                                                              ? 'Dj Awards: '
                                                                              : widget.user.profileHandle!.startsWith('Br')
                                                                                  ? 'Awards: '
                                                                                  : widget.user.profileHandle!.startsWith('Pr')
                                                                                      ? 'Beat Production Awards: '
                                                                                      : '',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: " ${widget.user.awards}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  TextSpan(
                                      text: 'Management: ',
                                      style: TextStyle(
                                        fontSize: width > 600 ? 14 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.blueGrey
                                            : Colors.grey,
                                      )),
                                  TextSpan(
                                      text: "${widget.user.management}\n",
                                      style: TextStyle(
                                        fontSize: width > 600 ? 16 : 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ],
                                style: TextStyle(
                                  color: Colors.black,
                                )),
                          ]),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        color: Colors.grey,
                        height: 1,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(height: 40),
                      SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
