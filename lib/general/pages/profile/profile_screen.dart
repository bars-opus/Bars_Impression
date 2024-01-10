import 'dart:ui';
import 'package:bars/general/pages/profile/statistics/no_followers.dart';
import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  static final id = 'Profile_screen';
  final String userId;
  final AccountHolderAuthor? user;
  ProfileScreen(
      {required this.currentUserId, required this.userId, required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isFollowing = false;
  bool _isFecthing = true;

  bool _isAFollower = false;
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  int _followerCount = 0;
  int _followingCount = 0;
  int pointCoint = 0;
  List<Post> _postsList = [];
  final _postSnapshot = <DocumentSnapshot>[];
  List<UserProfessionalModel> _usersAll = [];
  final _usersAllSnapshot = <DocumentSnapshot>[];
  bool _isLoading = false;
  bool _isLoadingChat = false;

  bool _isLoadingEvents = true;

  late ConnectivityResult _connectivityStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  late ScrollController _hideButtonController;

  // File? _video1;

  // List<Forum> _forums = [];
  List<Event> _eventsList = [];
  final _eventSnapshot = <DocumentSnapshot>[];

  late AccountHolderAuthor _profileUser;
  int _moodPunched = 0;
  bool _moodPunchedListView = false;
  int _artistFavoriteCount = 0;
  int _artistPunch = 0;
  double coseTope = 10;
  bool _showInfo = false;
  late TabController _tabController;
  bool _showSwipe = false;
  List<InviteModel> _inviteList = [];
  int limit = 5;
  int currentTab = 0;
  bool _isLoadingGeneralSettins = false;

  bool _hasNext = true;

  DocumentSnapshot? _lastInviteDocument;
  DocumentSnapshot? _lastEventDocument;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    widget.userId.isEmpty ? _nothing() : _setUp();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
    _hideButtonController = ScrollController();
  }

  _setUp() {
    _setupIsFollowing();
    _setUpFollowers();
    _setUpFollowing();
    _setupIsBlockedUser();
    _setupIsBlocking();
    _setupIsAFollowerUser();
    // _setupPosts();
    // _setupEvents();
    _setUpEvents();
    _setUpInvites();

    // _setUpForums();
    // _setUpEvents();
    // // _setUpPossitiveRated();
    // _setUpNegativeRated();
    _setUpProfileUser();
    __setShowDelsyInfo();
    // widget.currentUserId == widget.userId ? () {} : _setupUsersALl();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        selectedTabIndex == 0 ? _loadMoreEvents() : _loadMoreInvites();
        // if (_lastTicketOrderDocument != null) _loadMoreActivities();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hideButtonController.dispose();

    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult status;
    try {
      status = await _connectivity.checkConnectivity();
    } catch (e) {
      print("Error checking connectivity: $e");
      status = ConnectivityResult.none;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(status);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() => _connectivityStatus = result);
  }

  // _setupUsersALl() async {
  //   QuerySnapshot userFeedSnapShot = await usersRef
  //       // .where('profileHandle', isEqualTo: widget.profileHandle)
  //       .where('dontShowContentOnExplorePage', isEqualTo: true)
  //       .limit(10)
  //       .get();
  //   List<UserProfessionalModel> users = userFeedSnapShot.docs
  //       .map((doc) => UserProfessionalModel.fromDoc(doc))
  //       // .where((user) =>
  //       //     user.dontShowContentOnExplorePage == true) // <-- filter the list
  //       .toList()
  //     ..shuffle();
  //   _usersAllSnapshot.addAll((userFeedSnapShot.docs));
  //   if (mounted) {
  //     setState(() {
  //       // _hasNext = false;
  //       _usersAll = users;
  //     });
  //   }
  //   return users;
  // }

  _nothing() {}

  __setShowDelsyInfo() async {
    if (!_showInfo) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // setState(() {
          _showInfo = true;
          // });
          __setShowInfo();
        }
      });
    }
    if (!_showSwipe) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // setState(() {
          _showSwipe = true;
          // });
          __setShowInfo();
        }
      });
    }
  }

  __setShowInfo() async {
    if (_showInfo) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // setState(() {
          _showInfo = false;
          // });
        }
      });
    }
    if (_showSwipe) {
      Timer(Duration(seconds: 3), () {
        if (mounted) {
          // setState(() {
          _showSwipe = false;
          // });
        }
      });
    }
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    if (mounted) {
      setState(() {
        _isFollowing = isFollowingUser;
        _isFecthing = false;
      });
    }
  }

  _setupIsAFollowerUser() async {
    bool isAFollower = await DatabaseService.isAFollowerUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isAFollower = isAFollower;
      });
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setupIsBlocking() async {
    bool isBlockingUser = await DatabaseService.isBlokingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  _setUpFollowers() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
    if (mounted) {
      setState(() {
        _followerCount = userFollowerCount;
      });
    }
  }

  _setUpFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);
    if (mounted) {
      setState(() {
        _followingCount = userFollowingCount;
      });
    }
  }

  // _setupPosts() async {
  //   QuerySnapshot postFeedSnapShot = await postsRef
  //       .doc(widget.userId)
  //       .collection('userPosts')
  //       .orderBy('timestamp', descending: true)
  //       .limit(4)
  //       .get();
  //   List<Post> posts =
  //       postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();
  //   _postSnapshot.addAll((postFeedSnapShot.docs));
  //   if (mounted) {
  //     setState(() {
  //       // _hasNext = false;
  //       _postsList = posts;
  //     });
  //   }
  // }

  // _setupEvents() async {
  //   QuerySnapshot eventFeedSnapShot = await eventsRef
  //       .doc(widget.userId)
  //       .collection('userEvents')
  //       .orderBy('timestamp', descending: true)
  //       .limit(10)
  //       .get();
  //   List<Event> events =
  //       eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
  //   _eventSnapshot.addAll((eventFeedSnapShot.docs));
  //   if (mounted) {
  //     setState(() {
  //       _eventsList = events;
  //     });
  //   }
  //   return events;
  // }

  _setUpEvents() async {
    try {
      QuerySnapshot eventFeedSnapShot = await eventsRef
          .doc(widget.userId)
          .collection('userEvents')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();
      List<Event> eventList =
          eventFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
      if (eventFeedSnapShot.docs.isNotEmpty) {
        _lastEventDocument = eventFeedSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _eventsList = eventList;
          _isLoadingEvents = false;
        });
      }
      if (eventFeedSnapShot.docs.length < 10) {
        _hasNext = false; // No more documents to load
      }

      return eventList;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  Set<String> addedEventIds = Set<String>();

  _loadMoreEvents() async {
    try {
      Query eventFeedSnapShot = eventsRef
          .doc(widget.userId)
          .collection('userEvents')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastEventDocument!)
          .limit(limit);
      QuerySnapshot postFeedSnapShot = await eventFeedSnapShot.get();

      List<Event> events =
          postFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();

      List<Event> moreEvents = [];

      for (var event in events) {
        if (!addedEventIds.contains(event.id)) {
          addedEventIds.add(event.id);
          moreEvents.add(event);
        }
      }

      // documentSnapshot.addAll(eventFeedSnapShot.docs);
      // List<Event> moreEvents =
      //     postFeedSnapShot.docs.map((doc) => Event.fromDoc(doc)).toList();
      // if (postFeedSnapShot.docs.isNotEmpty) {
      _lastEventDocument = postFeedSnapShot.docs.last;
      // }
      if (mounted) {
        setState(() {
          _eventsList.addAll(moreEvents);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      print('Error fetching initial invites: $e');
      // Handle the error appropriately.
      return [];
    }
  }

  _setUpInvites() async {
    try {
      QuerySnapshot ticketOrderSnapShot = widget.currentUserId == widget.userId
          ? await userIviteRef
              .doc(widget.userId)
              .collection('eventInvite')
              // .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
              .orderBy('eventTimestamp', descending: true)
              .limit(10)
              .get()
          : await userIviteRef
              .doc(widget.userId)
              .collection('eventInvite')
              .where('answer', isEqualTo: 'Accepted')
              // .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
              // .orderBy('eventTimestamp', descending: true)
              .limit(2)
              .get();
      List<InviteModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => InviteModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument = ticketOrderSnapShot.docs.last;
      }
      if (mounted) {
        setState(() {
          _inviteList = ticketOrder;
          _isLoadingEvents = false;
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

  Set<String> addedInviteIds = Set<String>();

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = widget.currentUserId == widget.userId
          ? userIviteRef
              .doc(widget.userId)
              .collection('eventInvite')
              .orderBy('eventTimestamp', descending: true)
              .startAfterDocument(_lastInviteDocument!)
              .limit(limit)
          : userIviteRef
              .doc(widget.userId)
              .collection('eventInvite')
              .where('answer', isEqualTo: 'Accepted')
              // .orderBy('eventTimestamp', descending: true)
              .startAfterDocument(_lastInviteDocument!)
              .limit(limit);

      QuerySnapshot postFeedSnapShot = await activitiesQuery.get();

      List<InviteModel> ivites =
          postFeedSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
      List<InviteModel> moreInvites = [];

      for (var invite in ivites) {
        if (!addedInviteIds.contains(invite.eventId)) {
          addedInviteIds.add(invite.eventId);
          moreInvites.add(invite);
        }
      }

      // List<InviteModel> morePosts =
      //     postFeedSnapShot.docs.map((doc) => InviteModel.fromDoc(doc)).toList();
      // if (postFeedSnapShot.docs.isNotEmpty) {
      _lastInviteDocument = postFeedSnapShot.docs.last;
      // }
      if (mounted) {
        setState(() {
          _inviteList.addAll(moreInvites);
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

  // _setupPosts() async {
  // List<Post> posts = await DatabaseService.getUserPosts(widget.userId);
  // if (mounted) {
  //   setState(() {
  //     _posts = posts;
  //   });
  // }
  // }

  // _setUpForums() async {
  //   List<Forum> forums = await DatabaseService.getUserForums(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _forums = forums;
  //     });
  //   }
  // }

  // _setUpEvents() async {
  //   List<Event> events = await DatabaseService.getUserEvents(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _events = events;
  //     });
  //   }
  // }

  _setUpProfileUser() async {
    // AccountHolderAuthor profileUser = widget.user != null
    //     ? widget.user!
    //     : await DatabaseService.getUserWithId(widget.userId);
    // if (mounted) {
    //   setState(() {
    //     _profileUser = profileUser;
    //   });
    // }
  }

  _followOrUnfollow(AccountHolderAuthor user) {
    HapticFeedback.heavyImpact();
    if (_isFollowing) {
      _showBottomSheetUnfollow(context, user, 'unfollow');
      // _showSelectImageDialog2(user, 'unfollow');
    } else {
      _followUser(user);
    }
  }

  _blockOrUnBlock(AccountHolderAuthor user) {
    if (_isBlockingUser) {
      _showBottomSheetUnfollow(context, user, 'unBlock');

      // _showSelectImageDialog2(user, 'unBlock');
    } else {
      _showBottomSheetUnfollow(context, user, 'block');

      // _showSelectImageDialog2(user, 'block');
    }
  }

  _unBlockser(AccountHolderAuthor user) {
    HapticFeedback.heavyImpact();
    DatabaseService.unBlockUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = false;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'unBlocked ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _blockser(AccountHolderAuthor user) async {
    HapticFeedback.heavyImpact();
    AccountHolderAuthor? fromUser =
        await DatabaseService.getUserWithId(widget.currentUserId);
    if (fromUser != null) {
      DatabaseService.blockUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
        user: fromUser,
      );
    } else {
      mySnackBar(context, 'Could not bloack this person');
    }

    if (mounted) {
      setState(() {
        _isBlockingUser = true;
      });
    }
    if (_isAFollower) {
      DatabaseService.unfollowUser(
        currentUserId: widget.userId,
        userId: widget.currentUserId,
      );
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        'Blocked ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  // _setUpPossitiveRated() async {
  //   int userPossitiveRatedCount =
  //       await DatabaseService.numPosstiveRated(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _possitiveRatedCount = userPossitiveRatedCount;
  //     });
  // //   }
  // }

  // _setUpNegativeRated() async {
  //   int userNegativeRatedCount =
  //       await DatabaseService.numNegativeRated(widget.userId);
  //   if (mounted) {
  //     setState(() {
  //       _negativeRatedCount = userNegativeRatedCount;
  //     });
  //   }
  // }

  _unfollowUser(AccountHolderAuthor user) {
    DatabaseService.unfollowUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (mounted) {
      setState(() {
        _isFollowing = false;
        _followerCount--;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Unfollowed ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _followUser(AccountHolderAuthor user) async {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      user: user,
      currentUser: Provider.of<UserData>(context, listen: false).user!,
    );

    if (mounted) {
      setState(() {
        _isFollowing = true;
        _followerCount++;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        'Followed ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  // _displayButton(
  //   AccountHolderAuthor user,
  // ) {
  //   final width = MediaQuery.of(context).size.width;
  //   return user.userId == Provider.of<UserData>(context).currentUserId
  //       ? Padding(
  //           padding: EdgeInsets.fromLTRB(
  //             20.0,
  //             30.0,
  //             20.0,
  //             10.0,
  //           ),
  //           child: Column(
  //             children: <Widget>[
  //               user.userName!.isEmpty
  //                   ? const SizedBox.shrink()
  //                   : user.score!.isNegative
  //                       ? _displayBannnedUploadNote(user)
  //                       : Container(
  //                           width: width,
  //                           child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: ConfigBloc().darkModeOn
  //                                   ? Colors.blueGrey[100]
  //                                   : Colors.white,
  //                               foregroundColor: Colors.blue,
  //                               shape: RoundedRectangleBorder(
  //                                 borderRadius: BorderRadius.circular(20.0),
  //                               ),
  //                             ),
  //                             onPressed: () => Navigator.push(
  //                               context,
  //                               MaterialPageRoute(
  //                                 builder: (_) => CreateContents(
  //                                   user: user,
  //                                   from: 'Profile',
  //                                 ),
  //                               ),
  //                             ),
  //                             child: Material(
  //                               color: Colors.transparent,
  //                               child: Text(
  //                                 'Create',
  //                                 style: TextStyle(
  //                                   color: Colors.black,
  //                                   fontSize: width > 600 ? 20 : 14.0,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //               //  Wrap(
  //               //     direction: Axis.vertical,
  //               //     children: [
  //               //       Row(
  //               //         crossAxisAlignment: CrossAxisAlignment.center,
  //               //         mainAxisAlignment: MainAxisAlignment.center,
  //               //         children: <Widget>[
  //               //           Container(
  //               //             width: width > 600
  //               //                 ? 200
  //               //                 : width < 400
  //               //                     ? 120
  //               //                     : 150.0,
  //               //             child: ElevatedButton(
  //               //               style: ElevatedButton.styleFrom(
  //               //                 backgroundColor: ConfigBloc().darkModeOn
  //               //                     ? Colors.blueGrey[100]
  //               //                     : Colors.white,
  //               //                 foregroundColor: Colors.blue,
  //               //                 shape: RoundedRectangleBorder(
  //               //                   borderRadius:
  //               //                       BorderRadius.circular(20.0),
  //               //                 ),
  //               //               ),
  //               //               onPressed: () => Navigator.push(
  //               //                 context,
  //               //                 MaterialPageRoute(
  //               //                   builder: (_) => CreatePost(
  //               //                       // user: user,
  //               //                       ),
  //               //                 ),
  //               //               ),
  //               //               child: Material(
  //               //                 color: Colors.transparent,
  //               //                 child: Text(
  //               //                   'Punch',
  //               //                   style: TextStyle(
  //               //                     color: Colors.black,
  //               //                     fontSize: width > 600 ? 20 : 14.0,
  //               //                     fontWeight: FontWeight.bold,
  //               //                   ),
  //               //                 ),
  //               //               ),
  //               //             ),
  //               //           ),
  //               //           SizedBox(
  //               //             width: 10,
  //               //           ),
  //               //           Container(
  //               //             width: width > 600
  //               //                 ? 200
  //               //                 : width < 400
  //               //                     ? 120
  //               //                     : 150.0,
  //               //             child: ElevatedButton(
  //               //               style: ElevatedButton.styleFrom(
  //               //                 backgroundColor: ConfigBloc().darkModeOn
  //               //                     ? Colors.blueGrey[100]
  //               //                     : Colors.white,
  //               //                 foregroundColor: Colors.blue,
  //               //                 shape: RoundedRectangleBorder(
  //               //                   borderRadius:
  //               //                       BorderRadius.circular(20.0),
  //               //                 ),
  //               //               ),
  //               //               onPressed: () => Navigator.push(
  //               //                 context,
  //               //                 MaterialPageRoute(
  //               //                   builder: (_) => CreateContents(
  //               //                     user: user,
  //               //                     from: 'Profile',
  //               //                   ),
  //               //                 ),
  //               //               ),
  //               //               child: Material(
  //               //                 color: Colors.transparent,
  //               //                 child: Text(
  //               //                   'Create',
  //               //                   style: TextStyle(
  //               //                     color: Colors.black,
  //               //                     fontSize: width > 600 ? 20 : 14.0,
  //               //                     fontWeight: FontWeight.bold,
  //               //                   ),
  //               //                 ),
  //               //               ),
  //               //             ),
  //               //           ),
  //               //           Divider(),
  //               //         ],
  //               //       ),
  //               //     ],
  //               //   ),
  //               // user.userId == Provider.of<UserData>(context).currentUserId
  //               //     ? Column(
  //               //         mainAxisAlignment: MainAxisAlignment.center,
  //               //         crossAxisAlignment: CrossAxisAlignment.center,
  //               //         children: <Widget>[
  //               //           user.userName!.isEmpty
  // ? GestureDetector(
  //     onTap: () => Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => EditProfileScreen(
  //             user: user,
  //           ),
  //         )),
  //               //                   child: RichText(
  //               //                     text: TextSpan(
  //               //                       children: [
  //               //                         TextSpan(
  //               //                             text: "Hello ${user.name},",
  //               //                             style: TextStyle(
  //               //                               fontSize: width > 800 ? 14 : 12,
  //               //                               color: Colors.blue,
  //               //                             )),
  //               //                         TextSpan(
  //               //                             text:
  //               //                                 '\nYou registered with a nickname, please tap on edit profile below to choose your username, select an account type, and provide the necessary information to set up your profile. Without your username, you cannot be discovered on the discover page, and you cannot punch your mood, or create a forum, or an event.',
  //               //                             style: TextStyle(
  //               //                               fontSize: width > 800 ? 14 : 12,
  //               //                               color: Colors.blue,
  //               //                             )),
  //               //                         TextSpan(
  //               //                             text:
  //               //                                 '\n\nPlease note that all usernames on this platform are converted to uppercase.',
  //               //                             style: TextStyle(
  //               //                               fontSize: width > 800 ? 14 : 12,
  //               //                               color: Colors.blue,
  //               //                             )),
  //               //                       ],
  //               //                     ),
  //               //                   ),
  //               //                 )
  //               //               : const SizedBox.shrink(),
  //               //           SizedBox(
  //               //             height: 30.0,
  //               //           ),
  //               //           GestureDetector(
  //               //             onTap: () => Navigator.push(
  //               //                 context,
  //               //                 MaterialPageRoute(
  //               //                   builder: (_) => EditProfileScreen(
  //               //                     user: user,
  //               //                   ),
  //               //                 )),
  //               //             child: Stack(
  //               //               alignment: Alignment.center,
  //               //               children: [
  //               //                 user.userName!.isEmpty
  //               //                     ? AvatarGlow(
  //               //                         animate: true,
  //               //                         showTwoGlows: true,
  //               //                         shape: BoxShape.circle,
  //               //                         glowColor: Colors.blue,
  //               //                         endRadius: 30,
  //               //                         duration:
  //               //                             const Duration(milliseconds: 2000),
  //               //                         repeatPauseDuration:
  //               //                             const Duration(milliseconds: 3000),
  //               //                         child: Container())
  //               //                     : const SizedBox.shrink(),
  //               //                 Container(
  //               //                     width: 200,
  //               //                     color: Colors.transparent,
  //               //                     child: Align(
  //               //                       alignment: Alignment.center,
  //               //                       child: Padding(
  //               //                         padding: const EdgeInsets.all(8.0),
  //               //                         child: Text(
  //               //                           'Edit Profile',
  //               //                           style: TextStyle(
  //               //                               color: Colors.blue,
  //               //                               fontSize: width > 600 ? 14 : 12,
  //               //                               fontWeight: FontWeight.bold),
  //               //                         ),
  //               //                       ),
  //               //                     )),
  //               //               ],
  //               //             ),
  //               //           ),
  //               //         ],
  //               //       )
  //               //     : const SizedBox.shrink()
  //             ],
  //           ))
  //       : user.score!.isNegative
  //           ? const SizedBox.shrink()
  //           : Padding(
  //               padding: EdgeInsets.fromLTRB(
  //                 20.0,
  //                 30.0,
  //                 20.0,
  //                 20.0,
  //               ),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: <Widget>[
  // Container(
  //   width: 150.0,
  //   child: ElevatedButton(
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: _isFollowing || _isFecthing
  //           ? Colors.grey
  //           : Color(0xFFD38B41),
  //       foregroundColor: Colors.blue,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),
  //     ),
  //     onPressed: () => _followOrUnfollow(user),
  //     child: Text(
  //       _isFecthing
  //           ? 'loading..'
  //           : _isFollowing
  //               ? ' unfollow'
  //               : 'follow',
  //       style: TextStyle(
  //         fontSize: 14.0,
  //         color: _isFollowing ? Colors.black : Colors.white,
  //         fontWeight: _isFecthing
  //             ? FontWeight.normal
  //             : FontWeight.bold,
  //       ),
  //     ),
  //   ),
  // ),
  //                 ],
  //               ),
  //             );
  // }

  Widget buildBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  // _buildTilePost(
  //   Post post,
  // ) {
  //   final width = MediaQuery.of(context).size.width;
  //   return GridTile(
  //       child: Tooltip(
  //     showDuration: Duration(seconds: 10),
  //     padding: EdgeInsets.all(20.0),
  //     message: post.punch + '\n\n' + post.caption,
  //     child: Stack(alignment: FractionalOffset.center, children: <Widget>[
  //       OpenContainer(
  //         openColor: Theme.of(context).primaryColorLight,
  //         closedColor:
  //          Theme.of(context).primaryColor,
  //         transitionType: ContainerTransitionType.fade,
  //         closedBuilder: (BuildContext _, VoidCallback openContainer) {
  //           return Stack(alignment: Alignment.center, children: <Widget>[
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: ConfigBloc().darkModeOn
  //                     ? Color(0xFF1f2022)
  //                     : Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey[300]!,
  //                     blurRadius: 0.0,
  //                     spreadRadius: 0.0,
  //                   )
  //                 ],
  //               ),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(10.0),
  //                 child: Container(
  //                   height: MediaQuery.of(context).size.width,
  //                   decoration: BoxDecoration(
  //                       image: DecorationImage(
  //                     image: CachedNetworkImageProvider(post.imageUrl),
  //                     fit: BoxFit.cover,
  //                   )),
  //                   child: post.report.isNotEmpty
  //                       ? buildBlur(
  //                           borderRadius: BorderRadius.circular(0),
  //                           child: Container(
  //                             color: Colors.black.withOpacity(.8),
  //                           ))
  //                       : Container(
  //                           decoration: BoxDecoration(
  //                               gradient: LinearGradient(
  //                                   begin: Alignment.bottomRight,
  //                                   colors: [
  //                                 Colors.black.withOpacity(.7),
  //                                 Colors.black.withOpacity(.7),
  //                               ])),
  //                         ),
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
  //               child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: <Widget>[
  //                     Container(
  //                       height: width > 600 ? 150 : 100.0,
  //                       padding: EdgeInsets.symmetric(
  //                           horizontal: 2.0, vertical: 1.0),
  //                       width: MediaQuery.of(context).size.width,
  //                       child: Align(
  //                         alignment: post.report.isNotEmpty
  //                             ? Alignment.center
  //                             : Alignment.bottomCenter,
  //                         child: post.report.isNotEmpty
  //                             ? Icon(
  //                                 MdiIcons.eyeOff,
  //                                 color: Colors.grey,
  //                                 size: 30.0,
  //                               )
  //                             : Text(
  //                                 ' " ${post.punch} " '.toLowerCase(),
  //                                 style: TextStyle(
  //                                   fontSize: width > 600 ? 16 : 12.0,
  //                                   color: Colors.white,
  //                                   shadows: [
  //                                     BoxShadow(
  //                                       color: Colors.black26,
  //                                       offset: Offset(0, 3),
  //                                       blurRadius: 2.0,
  //                                       spreadRadius: 1.0,
  //                                     )
  //                                   ],
  //                                 ),
  //                                 textAlign: TextAlign.center,
  //                                 maxLines: 7,
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                       ),
  //                     ),
  //                     SizedBox(height: 3.0),
  //                     SizedBox(height: 2.0),
  //                     post.report.isNotEmpty
  //                         ? const SizedBox.shrink()
  //                         : Padding(
  //                             padding:
  //                                 const EdgeInsets.symmetric(horizontal: 16.0),
  //                             child: Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 Container(
  //                                   height: 2.0,
  //                                   color: Colors.white,
  //                                   padding: EdgeInsets.symmetric(
  //                                       horizontal: 2.0, vertical: 3.0),
  //                                   child: Text(
  //                                     ' @ ${post.artist} ',
  //                                     style: TextStyle(
  //                                       fontSize: 5.0,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                   ]),
  //             )
  //           ]);
  //         },
  //         openBuilder: (BuildContext context,
  //             void Function({Object? returnValue}) action) {
  //           return PunchExpandedProfileWidget(
  //             author: _profileUser,
  //             feed: 'Profile',
  //             currentUserId: widget.currentUserId,
  //             post: post,
  //             postList: [],
  //           );
  //         },
  //       )
  //     ]),
  //   ));
  // }

  // _buildMusicPreference(AccountHolderAuthor user) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 10.0, top: 30, right: 10),
  //     child: GestureDetector(
  //       onTap: () => Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (_) => ProfileMusicPref(
  //                     user: user,
  //                     currentUserId: widget.currentUserId,
  //                   ))),
  //       child: Table(
  //         border: TableBorder.all(
  //           color: Colors.grey,
  //           width: 0.5,
  //         ),
  //         children: [
  //           TableRow(children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 'Favorite Musician',
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 user.favouriteArtist!,
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //           ]),
  //           TableRow(children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 'Favorite Song',
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 user.favouriteSong!,
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //           ]),
  //           TableRow(children: [
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 'Favorite Album',
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //             Padding(
  //               padding:
  //                   const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
  //               child: Text(
  //                 user.favouriteAlbum!,
  //                 style: Theme.of(context).textTheme.bodyMedium,
  //               ),
  //             ),
  //           ])
  //         ],
  //       ),
  //     ),
  //   );
  // }

  _buildStatistics(AccountHolderAuthor user) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;

    bool isAuthor = currentUserId == user.userId;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // physics: ClampingScrollPhysics(),
        // shrinkWrap: true,
        // scrollDirection: Axis.horizontal,
        children: <Widget>[
          UserStatistics(
            count: NumberFormat.compact().format(_followerCount),
            countColor: Colors.white,
            titleColor: Colors.white,
            onPressed: () => _followerCount == 0
                ? navigateToPage(
                    context,
                    NoFollowers(
                      from: 'Follower',
                      isCurrentUser: isAuthor,
                      userName: user.userName!,
                    ))

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => NoAccountList(
                //               follower: 'Follower',
                //             )));

                : navigateToPage(
                    context,
                    FollowerFollowing(
                      currentUserId: currentUserId,
                      followerCount: _followerCount,
                      followingCount: _followingCount,
                      follower: 'Follower',
                    )),

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => FollowerFollowing(
            //               currentUserId: currentUserId,
            //               followerCount: _followerCount,
            //               followingCount: _followingCount,
            //               follower: 'Follower',
            //             ))),
            title: '  Followers',
            subTitle: 'The number of accounts following you.',
          ),
          const SizedBox(
            width: 20,
          ),
          UserStatistics(
            countColor: Colors.white,
            titleColor: Colors.white,
            count: NumberFormat.compact().format(_followingCount),
            onPressed: () => _followingCount == 0
                ? navigateToPage(
                    context,
                    NoFollowers(
                      from: 'Following',
                      isCurrentUser: isAuthor,
                      userName: user.userName!,
                    ))
                //  Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (_) => NoAccountList(
                //               follower: 'Following',
                //             )))
                : navigateToPage(
                    context,
                    FollowerFollowing(
                      currentUserId: currentUserId,
                      followerCount: _followerCount,
                      followingCount: _followingCount,
                      follower: 'Following',
                    )),

            //  Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => FollowerFollowing(
            //               followerCount: _followerCount,
            //               currentUserId: currentUserId,
            //               followingCount: _followingCount,
            //               follower: 'Following',
            //             ))),
            title: '  Following',
            subTitle: 'The number of accounts you are following.',
          ),
          // ListviewDivider(),
          // UserStatistics(
          //   countColor: Colors.grey,
          //   titleColor: Colors.grey,
          //   count:
          //       NumberFormat.compact().format(_postsList.length.toDouble()),
          //   onPressed: () => setState(() {
          //     _moodPunched = 0;
          //   }),
          //   title: 'Moods Punched',
          //   subTitle: "The number of moods you've punched.",
          // ),
          // ListviewDivider(),
          // UserStatistics(
          //   countColor: Colors.grey,
          //   titleColor: Colors.grey,
          //   count: NumberFormat.compact().format(_forumsL.length.toDouble()),
          //   onPressed: () => setState(() {
          //     _moodPunched = 1;
          //   }),
          //   title: 'Forums',
          //   subTitle: "The number of forums you've published.",
          // ),
          // ListviewDivider(),
          // UserStatistics(
          //   countColor: Colors.grey,
          //   titleColor: Colors.grey,
          //   count: NumberFormat.compact()
          //       .format(_eventsList.length.toDouble()),
          //   onPressed: () => setState(() {
          //     _moodPunched = 2;
          //   }),
          //   title: 'Events',
          //   subTitle: "The number of events you've published.",
          // ),
        ]);
  }

  // _buildArtistStatistics(AccountHolderAuthor user) {
  //   return Container(
  //     color:  Theme.of(context).primaryColor,
  //     height: MediaQuery.of(context).textScaleFactor > 1.2 ? 200 : 150.0,
  //     child: Padding(
  //       padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
  //       child: ListView(
  //           shrinkWrap: true,
  //           scrollDirection: Axis.horizontal,
  //           children: <Widget>[
  //             UserStatistics(
  //               countColor:
  //                    Theme.of(context).secondaryHeaderColor,
  //               titleColor:
  //                    Theme.of(context).secondaryHeaderColor,
  //               count: NumberFormat.compact().format(_artistPunch),
  //               onPressed: () => Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (_) => AllArtistPosts(
  //                     currentUserId: widget.currentUserId,
  //                     artist: user.userName!,
  //                     artistPunch: _artistPunch,
  //                     post: null,
  //                   ),
  //                 ),
  //               ),
  //               title: 'Punches Used',
  //               subTitle:
  //                   "The number of moods punched with ${user.userName}'s punchline.",
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor:
  //                    Theme.of(context).secondaryHeaderColor,
  //               titleColor:
  //                    Theme.of(context).secondaryHeaderColor,
  //               count: NumberFormat.compact().format(_artistFavoriteCount),
  //               onPressed: () => Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (_) => FavoriteArtists(
  //                             currentUserId: widget.currentUserId,
  //                             artist: user.userName!,
  //                             user: user,
  //                             artistFavoriteCount: _artistFavoriteCount,
  //                           ))),
  //               title: 'As Favorite Artist',
  //               subTitle:
  //                   'The number of accounts listing ${user.userName} as favorite artist.',
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor:
  //                   user.userId != Provider.of<UserData>(context).currentUserId
  //                       ? Colors.grey
  //                       : ConfigBloc().darkModeOn
  //                           ? Colors.white
  //                           : Colors.black,
  //               titleColor:
  //                   user.userId != Provider.of<UserData>(context).currentUserId
  //                       ? Colors.grey
  //                       : ConfigBloc().darkModeOn
  //                           ? Colors.white
  //                           : Colors.black,
  //               count: NumberFormat.compact().format(_followerCount),
  //               onPressed: () => user.userId ==
  //                       Provider.of<UserData>(context, listen: false)
  //                           .currentUserId
  //                   ? _followerCount == 0
  //                       ? Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (_) => NoAccountList(
  //                                     follower: 'Followers',
  //                                   )))
  //                       : Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (_) => FollowerFollowing(
  //                                     currentUserId: widget.currentUserId,
  //                                     followingCount: _followingCount - 1,
  //                                     follower: 'Followers',
  //                                     followerCount: _followerCount,
  //                                   )))
  //                   : () {},
  //               title: 'Followers',
  //               subTitle: 'The number of accounts following you.',
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor: user.userId !=
  //                       Provider.of<UserData>(context, listen: false)
  //                           .currentUserId
  //                   ? Colors.grey
  //                   : ConfigBloc().darkModeOn
  //                       ? Colors.white
  //                       : Colors.black,
  //               titleColor: user.userId !=
  //                       Provider.of<UserData>(context, listen: false)
  //                           .currentUserId
  //                   ? Colors.grey
  //                   : ConfigBloc().darkModeOn
  //                       ? Colors.white
  //                       : Colors.black,
  //               count: NumberFormat.compact().format(_followingCount),
  //               onPressed: () => user.userId ==
  //                       Provider.of<UserData>(context, listen: false)
  //                           .currentUserId
  //                   ? _followingCount == 0
  //                       ? Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (_) => NoAccountList(
  //                                     follower: 'Following',
  //                                   )))
  //                       : Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (_) => FollowerFollowing(
  //                                     currentUserId: widget.currentUserId,
  //                                     followingCount: _followingCount,
  //                                     followerCount: _followerCount,
  //                                     follower: 'Following',
  //                                   )))
  //                   : () {},
  //               title: 'Following',
  //               subTitle: 'The number of accounts you are following.',
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor: Colors.grey,
  //               titleColor: Colors.grey,
  //               count: NumberFormat.compact().format(_posts.length),
  //               onPressed: () {
  //                 if (mounted) {
  //                   setState(() {
  //                     _moodPunched = 0;
  //                   });
  //                 }
  //               },
  //               title: 'Moods Punched',
  //               subTitle: "The number of moods you've punched.",
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor: Colors.grey,
  //               titleColor: Colors.grey,
  //               count: NumberFormat.compact().format(_forums.length),
  //               onPressed: () {
  //                 if (mounted) {
  //                   setState(() {
  //                     _moodPunched = 1;
  //                   });
  //                 }
  //               },
  //               title: 'Forums',
  //               subTitle: "The number of forums you've published.",
  //             ),
  //             ListviewDivider(),
  //             UserStatistics(
  //               countColor: Colors.grey,
  //               titleColor: Colors.grey,
  //               count: NumberFormat.compact().format(_events.length),
  //               onPressed: () {
  //                 if (mounted) {
  //                   setState(() {
  //                     _moodPunched = 2;
  //                   });
  //                 }
  //               },
  //               title: 'Events',
  //               subTitle: "The number of events you've published.",
  //             ),
  //           ]),
  //     ),
  //   );
  // }

  // _buildDisplayPostsGrid() {
  //   List<GridTile> tiles = [];
  //   _posts.forEach((post) => tiles.add(_buildTilePost(
  //         post,
  //       )));
  //   // _posts
  //   //     .asMap()
  //   //     .map((i, e) {
  //   //       return MapEntry(
  //   //           i,
  //   //         );
  //   //     })
  //   //     .values
  //   //     .toList();

  //   return GridView.count(
  //     crossAxisCount: 2,
  //     childAspectRatio: 1.0,
  //     mainAxisSpacing: 2.0,
  //     crossAxisSpacing: 2.0,
  //     shrinkWrap: true,
  //     children: tiles,
  //     physics: NeverScrollableScrollPhysics(),
  //   );
  // }

  // _buildDisplayPostsList() {
  //   List<PostViewWidget> postViews = [];
  //   _posts.forEach((post) {
  //     postViews.add(PostViewWidget(
  //       post: post,
  //       // postList: _posts,
  //       currentUserId: widget.currentUserId,
  //     ));
  //   });
  //   return Column(children: postViews);
  //   // List<GridTile> tiles = [];
  //   // _posts.forEach((post) => tiles.add(_buildTilePost(
  //   //       post,
  //   //     )));
  //   // // _posts
  //   // //     .asMap()
  //   // //     .map((i, e) {
  //   // //       return MapEntry(
  //   // //           i,
  //   // //         );
  //   // //     })
  //   // //     .values
  //   // //     .toList();

  //   // return GridView.count(
  //   //   crossAxisCount: 2,
  //   //   childAspectRatio: 1.0,
  //   //   mainAxisSpacing: 2.0,
  //   //   crossAxisSpacing: 2.0,
  //   //   shrinkWrap: true,
  //   //   children: tiles,
  //   //   physics: NeverScrollableScrollPhysics(),
  //   // );
  // }

  // _buildDisplayForum() {
  //   List<ProfileForumView> forumViews = [];
  //   _forums.forEach((forum) {
  //     forumViews.add(ProfileForumView(
  //       feed: 'Profile',
  //       currentUserId: widget.currentUserId,
  //       forum: forum,
  //       author: _profileUser,
  //     ));
  //   });
  //   return Column(children: forumViews);
  // }

  // _buildDisplayEvent() {
  //   List<EventProfileView> eventViews = [];
  //   _events.forEach((event) {
  //     eventViews.add(EventProfileView(
  //        eventList: _eventsAll, postSnapshot: _eventSnapshot,
  //       // exploreLocation: '',
  //       // allEvents: false,
  //       // feed: 4,
  //       currentUserId: widget.currentUserId,
  //       event: event,
  //       user: _profileUser,
  //     ));
  //   });
  //   return Column(children: eventViews);
  // }

  // _buildMoodPunched(AccountHolderAuthor user) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 12.0),
  //     child: Container(
  //       height: 30,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: <Widget>[
  //           DisplayPosts(
  //             title: 'Mood Punched',
  //             color: _moodPunched == 0 ? Colors.blue : Colors.grey,
  //             fontWeight:
  //                 _moodPunched == 0 ? FontWeight.bold : FontWeight.normal,
  //             onPressed: () => setState(() {
  //               _moodPunched = 0;
  //             }),
  //           ),
  //           SizedBox(
  //             width: 30.0,
  //           ),
  //           DisplayPosts(
  //             title: 'Forums',
  //             color: _moodPunched == 1 ? Colors.blue : Colors.grey,
  //             fontWeight:
  //                 _moodPunched == 1 ? FontWeight.bold : FontWeight.normal,
  //             onPressed: () => setState(() {
  //               _moodPunched = 1;
  //             }),
  //           ),
  //           SizedBox(
  //             width: 30.0,
  //           ),
  //           DisplayPosts(
  //             title: 'Events',
  //             color: _moodPunched == 2 ? Colors.blue : Colors.grey,
  //             fontWeight:
  //                 _moodPunched == 2 ? FontWeight.bold : FontWeight.normal,
  //             onPressed: () => setState(() {
  //               _moodPunched = 2;
  //             }),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _buildDisplay(AccountHolderAuthor user) {
  //   // if (_moodPunched == 0) {
  //   //   return Column(
  //   //     children: <Widget>[
  //   //       _moodPunchedListView
  //   //           ? _buildDisplayPostsList()
  //   //           : _buildDisplayPostsGrid(),
  //   //     ],
  //   //   );
  //   // } else if (_moodPunched == 1) {
  //   //   return Column(
  //   //     children: <Widget>[
  //   //       _buildDisplayForum(),
  //   //     ],
  //   //   );
  //   // } else if (_moodPunched == 2) {
  //   //   return Column(
  //   //     children: <Widget>[_buildDisplayEvent()],
  //   //   );
  //   // }
  // }

  // _displayBannnedUploadNote(AccountHolderAuthor user) {
  //   return Text(' This account has been banned for violating user guidelines.',
  //       style: TextStyle(color: Colors.red, fontSize: 12),
  //       textAlign: TextAlign.center);
  // }

  // _dynamicLink() async {
  //   var linkUrl = _profileUser.profileImageUrl!.isEmpty
  //       ? Uri.parse(
  //           'https://firebasestorage.googleapis.com/v0/b/bars-5e3e5.appspot.com/o/IMG_8574.PNG?alt=media&token=ccb4e3b1-b5dc-470f-abd0-63edb5ed549f')
  //       : Uri.parse(_profileUser.profileImageUrl!);

  //   final dynamicLinkParams = DynamicLinkParameters(
  //     socialMetaTagParameters: SocialMetaTagParameters(
  //       imageUrl: linkUrl,
  //       title: _profileUser.userName,
  //       description: _profileUser.bio,
  //     ),
  //     link: Uri.parse('https://www.barsopus.com/user_${_profileUser.id}'),
  //     uriPrefix: 'https://barsopus.com/barsImpression',
  //     androidParameters:
  //         AndroidParameters(packageName: 'com.barsOpus.barsImpression'),
  //     iosParameters: IOSParameters(
  //       bundleId: 'com.bars-Opus.barsImpression',
  //       appStoreId: '1610868894',
  //     ),
  //   );
  //   var link =
  //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   Share.share(link.shortUrl.toString());
  //   // if (Platform.isIOS) {
  //   //   var link =
  //   //       await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
  //   //   Share.share(link.toString());
  //   // } else {
  //   //   var link =
  //   //       await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  //   //   Share.share(link.shortUrl.toString());
  //   // }
  // }

  // _showSelectImageDialog(AccountHolderAuthor user) {
  //   return Platform.isIOS
  //       ? _iosBottomSheet(user)
  //       : _androidDialog(context, user);
  // }

  // _showSelectImageDialog2(AccountHolderAuthor user, String from) {
  //   return Platform.isIOS
  //       ? _iosBottomSheet2(user, from)
  //       : _androidDialog2(context, user, from);
  // }

  // _buildMoodToggleButton() {
  //   return IconButton(
  //       icon: Icon(
  //         _moodPunchedListView ? FontAwesomeIcons.list : Icons.grid_view,
  //       ),
  //       // iconSize: 30,
  //       color: Colors.grey,
  //       onPressed: () async {
  //         HapticFeedback.heavyImpact();
  //         setState(() {
  //           _moodPunchedListView = !_moodPunchedListView;
  //         });
  //       });
  // }

  // final _physycsNotifier = ValueNotifier<bool>(false);
  // // double _flexibleSpaceMaxHeight = 200; // default value

  // _professionalImageContainer(String imageUrl, String from) {
  //   final width =
  //        MediaQuery.of(context).size.width;
  //   return Container(
  //     width: from.startsWith('Mini') ? width / 3.3 : width.toDouble(),
  //     height: from.startsWith('Mini') ? width / 3.3 : width.toDouble(),
  //     decoration: BoxDecoration(
  //       color: Colors.grey,
  //       borderRadius: BorderRadius.circular(from.startsWith('Mini') ? 0 : 10),
  //       image: DecorationImage(
  //         image: CachedNetworkImageProvider(imageUrl),
  //         fit: BoxFit.cover,
  //       ),
  //     ),
  //   );
  // }

  // void _showBottomSheetWork(BuildContext context, String link, IconData icon) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: MediaQuery.of(context).size.height.toDouble() / 2,
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: WebDisclaimer(
  //             link: link,
  //             contentType: 'Work',
  //             icon: icon,
  //           ));
  //     },
  //   );
  // }

  // _accesWork(String text, String link, IconData icon) {
  //   return ListTile(
  //     leading: Icon(
  //       icon,
  //       color: Colors.blue,
  //       size: 25.0,
  //     ),
  //     title: Text(
  //       text,
  //       // 'All\nevents',
  //       style: TextStyle(
  //           color: Colors.blue, fontWeight: FontWeight.normal, fontSize: 14),
  //       // textAlign: TextAlign.right,
  //     ),
  //     onTap: () {
  //       HapticFeedback.mediumImpact();
  //       _showBottomSheetWork(context, link, icon);
  //     },
  //   );
  // }

  // _buildDisplayPostsGrid() {
  //   List<GridTile> tiles = [];
  //   _postsList.forEach((post) => tiles.add(_buildTilePost(
  //         post,
  //       )));

  //   return GridView.count(
  //     crossAxisCount: 2,
  //     childAspectRatio: 1.0,
  //     mainAxisSpacing: 3.0,
  //     crossAxisSpacing: 3.0,
  //     shrinkWrap: true,
  //     children: tiles,
  //     physics: NeverScrollableScrollPhysics(),
  //   );
  // }

  // _buildTilePost(
  //   Post post,
  // ) {
  //   // final width = MediaQuery.of(context).size.width;
  //   return GridTile(
  //       child: Tooltip(
  //           showDuration: Duration(seconds: 10),
  //           padding: EdgeInsets.all(20.0),
  //           message: post.punch + '\n\n' + post.caption,
  //           child: Stack(alignment: Alignment.center, children: <Widget>[
  //             Container(
  //               height: MediaQuery.of(context).size.width,
  //               decoration: BoxDecoration(
  //                   image: DecorationImage(
  //                 image: CachedNetworkImageProvider(post.imageUrl),
  //                 fit: BoxFit.cover,
  //               )),
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     gradient:
  //                         LinearGradient(begin: Alignment.bottomRight, colors: [
  //                   Colors.black.withOpacity(.3),
  //                   Colors.black.withOpacity(.3),
  //                 ])),
  //               ),
  //             ),
  //             // )
  //           ])));
  // }

  // _writtenInfo(AccountHolderAuthor user) {
  //   var style1 = const TextStyle(
  //     fontSize: 12,
  //     color: Colors.grey,
  //   );
  //   var style2 = Theme.of(context).textTheme.bodyMedium;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
  //     child: RichText(
  //       textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
  //       text: TextSpan(children: [
  //         TextSpan(
  //           children: [
  //             TextSpan(
  //               text: 'Discography',
  //               style: Theme.of(context).textTheme.displayMedium,
  //             ),
  //             TextSpan(text: '\n\nNick name/ Stage name: ', style: style1),
  //             TextSpan(
  //               text: user.name!.replaceAll('\n', ' '),
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.subAccountType!.replaceAll('\n', ' ').isEmpty
  //                     ? ''
  //                     : "\nSub-account:   ",
  //                 style: style1),
  //             TextSpan(
  //               text: user.subAccountType!.replaceAll('\n', ' ').isEmpty
  //                   ? ''
  //                   : "${user.subAccountType}\n",
  //               style: Theme.of(context).textTheme.bodyMedium,
  //             ),
  //             TextSpan(text: '\nCity / Country / Continent: ', style: style1),
  //             TextSpan(
  //               text: user.city!.replaceAll('\n', ' ') + "/ ",
  //               style: style2,
  //             ),
  //             TextSpan(
  //               text: user.country!.replaceAll('\n', ' ') + "/ ",
  //               style: style2,
  //             ),
  //             TextSpan(
  //               text: user.continent!.replaceAll('\n', ' '),
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.profileHandle!.startsWith('Artist') ||
  //                         user.profileHandle!.startsWith('Producer')
  //                     ? '\nRecord Label:  '
  //                     : "\nCompany:   ",
  //                 style: style1),
  //             TextSpan(
  //               text: user.company!.replaceAll('\n', ' ') + '\n',
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.profileHandle!.startsWith('Ar')
  //                     ? 'Music Skills:'
  //                     : user.profileHandle!.startsWith('Co')
  //                         ? 'Design Skills:'
  //                         : user.profileHandle!.startsWith('Da')
  //                             ? 'Dance Skills:'
  //                             : user.profileHandle!.startsWith('Ph')
  //                                 ? 'Photography Skills:'
  //                                 : user.profileHandle!.startsWith('Re')
  //                                     ? 'Recording Services'
  //                                     : user.profileHandle!.startsWith('Mu')
  //                                         ? 'Video Skills:'
  //                                         : user.profileHandle!.startsWith('Bl')
  //                                             ? 'Blogging Skills:'
  //                                             : user.profileHandle!
  //                                                     .startsWith('Br')
  //                                                 ? 'Influencing Skills:'
  //                                                 : user.profileHandle!
  //                                                         .startsWith('Ba')
  //                                                     ? 'Battling Skills:'
  //                                                     : user.profileHandle!
  //                                                             .endsWith('J')
  //                                                         ? 'Dj Skills:'
  //                                                         : user.profileHandle!
  //                                                                 .endsWith(
  //                                                                     'xen')
  //                                                             ? 'Video Peforming Skills:'
  //                                                             : user.profileHandle!
  //                                                                     .startsWith(
  //                                                                         'Pr')
  //                                                                 ? 'Production Skills:'
  //                                                                 : " ",
  //                 style: style1),
  //             TextSpan(
  //               text: user.skills!.replaceAll('\n', ' ') + "\n",
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.profileHandle!.startsWith('Ar')
  //                     ? 'Music Performances: '
  //                     : user.profileHandle!.startsWith('Co')
  //                         ? 'Design Exhibitions: '
  //                         : user.profileHandle!.startsWith('Ph')
  //                             ? 'Photo Exhibitions: '
  //                             : user.profileHandle!.startsWith('Da')
  //                                 ? 'Dance performancess: '
  //                                 : user.profileHandle!.startsWith('Ba')
  //                                     ? 'Batlle Stages: '
  //                                     : user.profileHandle!.endsWith('J')
  //                                         ? 'Performances: '
  //                                         : '',
  //                 style: style1),
  //             TextSpan(
  //               text: user.profileHandle!.startsWith('Vi') ||
  //                       user.profileHandle!.startsWith("Bl") ||
  //                       user.profileHandle!.startsWith("Br") ||
  //                       user.profileHandle!.startsWith("Re") ||
  //                       user.profileHandle!.endsWith("xen") ||
  //                       user.profileHandle!.startsWith("Mu") ||
  //                       user.profileHandle!.startsWith("Pr")
  //                   ? ''
  //                   : user.performances!.replaceAll('\n', ' ') + "\n",
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.profileHandle!.startsWith('Ar')
  //                     ? 'Music Collaborations: '
  //                     : user.profileHandle!.startsWith('Co')
  //                         ? 'Design Collaborations: '
  //                         : user.profileHandle!.startsWith('Da')
  //                             ? 'Danced With: '
  //                             : user.profileHandle!.startsWith('Ph')
  //                                 ? 'Worked With: '
  //                                 : user.profileHandle!.startsWith('Mu')
  //                                     ? 'Video Works: '
  //                                     : user.profileHandle!.endsWith('xen')
  //                                         ? 'Video appearances: '
  //                                         : user.profileHandle!.startsWith('Bl')
  //                                             ? 'Blogged About: '
  //                                             : user.profileHandle!
  //                                                     .startsWith('Br')
  //                                                 ? 'Worked with: '
  //                                                 : user.profileHandle!
  //                                                         .startsWith('Ba')
  //                                                     ? 'Battled Against: '
  //                                                     : user.profileHandle!
  //                                                             .endsWith('J')
  //                                                         ? 'Dj Collaborations: '
  //                                                         : user.profileHandle!
  //                                                                 .startsWith(
  //                                                                     'Re')
  //                                                             ? 'Partners: '
  //                                                             : user.profileHandle!
  //                                                                     .startsWith(
  //                                                                         'Pr')
  //                                                                 ? 'Production Collaborations: '
  //                                                                 : '',
  //                 style: style1),
  //             TextSpan(
  //               text: user.collaborations!.replaceAll('\n', ' ') + "\n",
  //               style: style2,
  //             ),
  //             TextSpan(
  //                 text: user.profileHandle!.startsWith('Ar')
  //                     ? 'Music Awards:'
  //                     : user.profileHandle!.startsWith('Co')
  //                         ? 'Design Awards: '
  //                         : user.profileHandle!.startsWith('Da')
  //                             ? 'Dance Awards: '
  //                             : user.profileHandle!.startsWith('Ph')
  //                                 ? 'Photography Awards: '
  //                                 : user.profileHandle!.startsWith('Re')
  //                                     ? 'Awards: '
  //                                     : user.profileHandle!.startsWith('Mu')
  //                                         ? 'Video Awards: '
  //                                         : user.profileHandle!.endsWith('xen')
  //                                             ? 'Awards: '
  //                                             : user.profileHandle!
  //                                                     .startsWith('Bl')
  //                                                 ? 'Blogging Awards: '
  //                                                 : user.profileHandle!
  //                                                         .startsWith('Ba')
  //                                                     ? 'Battle Awards: '
  //                                                     : user.profileHandle!
  //                                                             .endsWith('J')
  //                                                         ? 'Dj Awards: '
  //                                                         : user.profileHandle!
  //                                                                 .startsWith(
  //                                                                     'Br')
  //                                                             ? 'Awards: '
  //                                                             : user.profileHandle!
  //                                                                     .startsWith(
  //                                                                         'Pr')
  //                                                                 ? 'Beat Production Awards: '
  //                                                                 : '',
  //                 style: style1),
  //             TextSpan(
  //               text: user.awards!.replaceAll('\n', ' ') + "\n",
  //               style: style2,
  //             ),
  //             TextSpan(text: 'Management: ', style: style1),
  //             TextSpan(
  //               text: user.management!.replaceAll('\n', ' '),
  //               style: style2,
  //             ),
  //           ],
  //         ),
  //       ]),
  //       textAlign: TextAlign.left,
  //       // overflow: TextOverflow.ellipsis,
  //     ),
  //   );
  // }

  // void _showBottomSheetProfessionalPicture(
  //     BuildContext context, AccountHolderAuthor user, int initialPage) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return ViewProfessionalImage(
  //         user: user,
  //         initialPage: initialPage,
  //       );
  //     },
  //   );
  // }

  // _professionalImage(AccountHolderAuthor user) {
  //   return user.professionalPicture1!.isEmpty
  //       ? const SizedBox.shrink()
  //       : Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   HapticFeedback.mediumImpact();
  //                   _showBottomSheetProfessionalPicture(context, user, 0);
  //                 },
  //                 child: _professionalImageContainer(
  //                     user.professionalPicture1!, 'Mini'),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   HapticFeedback.mediumImpact();
  //                   _showBottomSheetProfessionalPicture(context, user, 1);
  //                 },
  //                 child: _professionalImageContainer(
  //                     user.professionalPicture2!, 'Mini'),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   HapticFeedback.mediumImpact();
  //                   _showBottomSheetProfessionalPicture(context, user, 2);
  //                 },
  //                 child: _professionalImageContainer(
  //                     user.professionalPicture3!, 'Mini'),
  //               ),
  //             ],
  //           ),
  //         );
  // }

  // _accesWorkContainer(AccountHolderAuthor user) {
  //   return Container(
  //     color: Theme.of(context).primaryColorLight,
  //     child: Padding(
  //       padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [

  //         ],
  //       ),
  //     ),
  //   );
  // }

  // void _showBottomVideo() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return ConfirmationPrompt(
  //         buttonText: 'Add to Order',
  //         onPressed: () {
  //           HapticFeedback.mediumImpact();

  //           // Navigator.pop(context);
  //           // _purchaseTickets(finalPurchasintgTicket);
  //         },
  //         title:
  //             'Are you sure you want to add this ticket to your purchase order',
  //         subTitle: 'finalPurchasintgTicket.group',
  //       );
  //     },
  //   );
  // }

  _button(
      String text, VoidCallback onPressed, double width, String borderRaduis) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: ResponsiveHelper.responsiveHeight(context, width),
        height: ResponsiveHelper.responsiveHeight(context, 33.0),
        decoration: BoxDecoration(
          color: text.startsWith('Follow')
              ? Colors.blue
              : Colors.grey.withOpacity(.4),
          borderRadius: borderRaduis.startsWith('All')
              ? BorderRadius.circular(
                  10,
                )
              : borderRaduis.startsWith('Left')
                  ? BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    )
                  : borderRaduis.startsWith('Right')
                      ? BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        )
                      : BorderRadius.circular(
                          0,
                        ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                color:
                    text.startsWith('loading...') ? Colors.blue : Colors.white,
                fontWeight: _isFecthing ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // final _picker = ImagePicker();

  // _handelVideo() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getVideo(
  //     source: ImageSource.gallery,
  //     maxDuration: Duration(seconds: 60),
  //   );

  //   if (pickedFile != null) {
  //     // Initialize the video player controller with the picked file
  //     final videoPlayerController =
  //         VideoPlayerController.file(File(pickedFile.path));
  //     await videoPlayerController.initialize();

  //     // Display the video player widget to the user
  //     AccountHolderAuthor? _user = Provider.of<UserData>(context, listen: false).user;

  //     showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         content: AspectRatio(
  //           aspectRatio: videoPlayerController.value.aspectRatio,
  //           child: VideoPlayer(videoPlayerController),
  //         ),
  //         actions: [
  //           // FlatButton(
  //           //   onPressed: () {
  //           //     // Upload the video to Firebase Storage and navigate to the feed screen
  //           //   },
  //           //   child: Text('Upload'),
  //           // ),
  //           TextButton(
  //             onPressed: () async {
  //               // Stop the video player and close the dialog
  //               videoPlayerController.pause();
  //               // _uploadVideo(pickedFile);
  //               final storage = FirebaseStorage.instance;
  //               String? videoId = Uuid().v4();

  //               final storageRef = storage.ref().child(
  //                   'videos/professionalVideo1/${_user!.id}/professionalVideoUrl_$videoId.mp4');
  //               final uploadTask = storageRef.putFile(File(pickedFile.path));
  //               final snapshot = await uploadTask.whenComplete(() => null);

  //               // Get the download URL of the uploaded video
  //               final _videoUrl = await snapshot.ref.getDownloadURL();

  //               usersRef
  //                   .doc(
  //                 _user.id,
  //               )
  //                   .update({
  //                 'professionalVideo2': _videoUrl,
  //               });
  //               Navigator.pop(context);
  //               // Navigator.pop(context);
  //             },
  //             child: Text('Cancel'),
  //           ),
  //         ],
  //       ),
  //     );

  //     // Play the video
  //     videoPlayerController.play();
  //   }
  // }

  // _uploadVideo(PickedFile _video1) async {
  // AccountHolderAuthor? _user = Provider.of<UserData>(context, listen: false).user;
  //   String _videoUrl = '';
  //   // ignore: unnecessary_null_comparison
  //   if (_videoUrl == null) {
  //     _videoUrl = _user!.professionalVideo1!;
  //   } else {
  //     _videoUrl = await StorageService.uploadUserprofessionalVideo1(
  //       _user!.professionalVideo1!,
  //       _video1,
  //     );
  //   }

  // }
  void _showBottomSheetErrorMessage(Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          title: 'Failed to load booking portfolio.',
          subTitle: result,
        );
      },
    );
  }

  final picker = ImagePicker();

  void _showBottomSheetAdvice(
      BuildContext context, AccountHolderAuthor user) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: UserAdviceScreen(
              userId: user.userId!,
              currentUserId: widget.currentUserId,
              userName: user.userName!,
              isBlocked: _isBlockedUser,
              isBlocking: _isBlockingUser,
              updateBlockStatus: () {
                setState(() {});
              },
              user: user,
            ),
          ),
        );
      },
    );
  }

  void _bottomModalSheetMessage(
      BuildContext context, AccountHolderAuthor user, Chat? chat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: BottomModalSheetMessage(
                showAppbar: false,
                isBlocked: _isBlockedUser,
                isBlocking: _isBlockingUser,
                currentUserId: widget.currentUserId,
                user: user,
                userAuthor: null,
                chatLoaded: chat, userPortfolio: null, userId: user.userId!,
                // connectivityStatus: _connectivityStatus,
              ),
            ));
      },
    );
  }

  void _showModalBottomSheetAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CreateContent();
      },
    );
  }

  void _showBottomSheetNoPortolio(
      BuildContext context, UserProfessionalModel _user) async {
    bool _isAuthor = _user.id == widget.currentUserId;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height.toDouble() / 1.2,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NoContents(
                      title: 'No Portfolio',
                      subTitle: _isAuthor
                          ? 'Set up your portfolio to easily connect with other creatives and event organizers for business purposes. Your portfolio displays your skills, collaborations, and other necessary information to attract business opportunities.'
                          : 'A portfolio serves as a visual representation of a creative professional\'s skills, collaborations, and other essential information. It provides a background for connecting with fellow creatives, enabling them to explore potential business opportunities.',
                      icon: Icons.work_off_outlined),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 30),
                  ),
                  _isAuthor
                      ? BlueOutlineButton(
                          buttonText: 'Set up portfolio',
                          onPressed: () {
                            Navigator.pop(context);
                            navigateToPage(
                              context,
                              EditProfileProfessional(
                                user: _user,
                              ),
                            );
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              )),
        );
      },
    );
  }

  _followContainer(AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;

    // final width = MediaQuery.of(context).size.width;
    return Container(
      color: Color(0xFF1a1a1a),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: ResponsiveHelper.responsiveHeight(context, 80.0),
              ),
              GestureDetector(
                onTap: _isAuthor
                    ? () {
                        navigateToPage(context, CreateSubaccountForm());
                        // EditProfileScreen(
                        //   user: user,
                        // ));
                      }
                    : user.profileImageUrl!.isEmpty
                        ? () {}
                        : () {
                            navigateToPage(
                              context,
                              ViewImage(
                                imageUrl: user.profileImageUrl!,
                              ),
                            );
                          },
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.user == null
                          ? 'container1' + user.userId.toString()
                          : 'container1' + widget.user!.userId.toString(),
                      child: CircleAvatar(
                        backgroundColor: Color(0xFF1a1a1a),
                        radius:
                            ResponsiveHelper.responsiveHeight(context, 70.0),
                        backgroundImage: user.profileImageUrl!.isEmpty
                            ? AssetImage(
                                'assets/images/user_placeholder.png',
                              ) as ImageProvider
                            : CachedNetworkImageProvider(user.profileImageUrl!),
                      ),
                    ),
                    _isAuthor
                        ? Positioned(
                            bottom: 10,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(.4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Icon(
                                  size: ResponsiveHelper.responsiveHeight(
                                      context, 25.0),
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              new Material(
                color: Colors.transparent,
                child: Text(
                  user.profileHandle!,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              NameText(
                color: Colors.white,
                name: user.userName!.toUpperCase().trim().replaceAll('\n', ' '),
                verified: user.verified!,
              ),
              // Stack(
              //   alignment: Alignment.bottomCenter,
              //   children: [
              //     Padding(
              //       padding: EdgeInsets.only(
              //           right: user.verified!
              //               ? ResponsiveHelper.responsiveWidth(context, 18.0)
              //               : 0.0),
              //       child: new Material(
              //         color: Colors.transparent,
              //         child: Text(
              // user.userName!
              //     .toUpperCase()
              //     .trim()
              //     .replaceAll('\n', ' '),
              //           maxLines: 2,
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontSize: ResponsiveHelper.responsiveFontSize(
              //                 context, 16.0),
              //             fontWeight: FontWeight.bold,
              //           ),
              //           textAlign: TextAlign.center,
              //           overflow: TextOverflow.ellipsis,
              //         ),
              //       ),
              //     ),
              //     user.verified!
              //         ? const SizedBox.shrink()
              //         : Positioned(
              //             top: ResponsiveHelper.responsiveHeight(context, 5.0),
              //             right:
              //                 ResponsiveHelper.responsiveHeight(context, 0.0),
              //             child: Icon(
              //               MdiIcons.checkboxMarkedCircle,
              //               size: ResponsiveHelper.responsiveHeight(
              //                   context, 15.0),
              //               color: Colors.blue,
              //             ),
              //           ),
              //   ],
              // ),
              const SizedBox(
                height: 10,
              ),
              _buildStatistics(user),
              const SizedBox(
                height: 10,
              ),
              if (!_isAuthor)
                _button(_isFollowing ? 'unFollow' : 'Follow', () {
                  _followOrUnfollow(user);
                }, 350, 'All'),
              const SizedBox(
                height: 5,
              ),
              // user.userId == widget.currentUserId
              //     ? SizedBox.shrink()
              //     :
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
              //   child: _button('Follow', () {
              //     // _showBottomVideo();
              //     // _handelVideo();
              //   }, width.toDouble(), 'All'),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(_isLoading ? 'loading...' : 'Portfolio', () async {
                      if (_isLoading) return;

                      _isLoading = true;
                      try {
                        UserProfessionalModel? _user =
                            await DatabaseService.getUserProfessionalWithId(
                          user.userId!,
                        );

                        if (_user != null) {
                          _user.professionalImageUrls.isEmpty &&
                                  _user.skills.isEmpty
                              ? _showBottomSheetNoPortolio(context, _user)
                              : navigateToPage(
                                  context,
                                  DiscographyWidget(
                                    currentUserId: widget.currentUserId,
                                    userIndex: 0,
                                    userPortfolio: _user,
                                  ),
                                );
                        } else {}
                      } catch (e) {
                        _showBottomSheetErrorMessage(e);
                      } finally {
                        _isLoading = false;
                      }
                    }, 175, 'Left'),
                    const SizedBox(
                      width: 1,
                    ),
                    // _button(
                    //     user.userId == widget.currentUserId ? 'Edit' : 'Message',
                    //     () {
                    //   user.userId == widget.currentUserId
                    // ? navigateToPage(
                    //     context,
                    //     EditProfileScreen(
                    //       user: user,
                    //     ),
                    //   )
                    //       : _bottomModalSheetMessage(user);
                    //   // Navigator.push(
                    //   //     context,
                    //   //     MaterialPageRoute(
                    //   //       builder: (_) => EditProfileScreen(
                    //   //         user: user,
                    //   //       ),
                    //   //     ));
                    // }, width / 3.6, 'None'),
                    // const SizedBox(
                    //   width: 1,
                    // ),

                    _button(
                        _isAuthor
                            ? 'Advice'
                            : _isLoadingChat
                                ? 'loading...'
                                : 'Message',
                        _isAuthor
                            ? () {
                                _showBottomSheetAdvice(context, user);
                              }
                            : () async {
                                if (_isLoadingChat) return;

                                _isLoadingChat = true;
                                try {
                                  Chat? _chat =
                                      await DatabaseService.getUserChatWithId(
                                    widget.currentUserId,
                                    widget.userId,
                                  );

                                  _bottomModalSheetMessage(
                                    context,
                                    user,
                                    _chat,
                                  );
                                } catch (e) {
                                } finally {
                                  _isLoadingChat = false;
                                }
                              },

                        // () {

                        //     _showBottomSheetAdvice(context, user);
                        //   }
                        // : () {
                        //     _bottomModalSheetMessage(user);
                        //   },
                        175,
                        'Right'),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _showBottomSheetTermsAndConditions(user);
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user.bio!.trim().replaceAll('\n', ' '),
                    maxLines: _isAuthor ? 4 : 3,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                      color: Colors.white,

                      // fontWeight: FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     widget.currentUserId == user.id
              //         ? _buildStatistics(user)
              //         : SizedBox.shrink(),
              //     GestureDetector(
              //       onTap: () {
              //         widget.currentUserId == user.id
              //             ? navigateToPage(
              //                 context,
              //                 EditProfileScreen(
              //                   user: user,
              //                 ),
              //               )
              //             : _bottomModalSheetMessage(user);
              //       },
              //       child: Icon(
              //         widget.currentUserId == user.id
              //             ? Icons.edit
              //             : Icons.message,
              //         size: 20,
              //         color: Colors.blue,
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _slid(String text, String text2) {
    return ListTile(
      trailing: GestureDetector(
        onTap: () {},
        child: Text(
          text2,
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      title: Text(
        text,
        style: Theme.of(context).textTheme.displayMedium,
      ),
    );
  }

  _buildEvent() {
    return CustomScrollView(
      // physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              Event event = _eventsList[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: EventDisplayWidget(
                    currentUserId: widget.currentUserId,
                    eventList: _eventsList,
                    event: event,
                    pageIndex: 0,
                    eventSnapshot: [],
                    eventPagesOnly: true,
                    liveCity: '',
                    liveCountry: '',
                    isFrom: '',
                    sortNumberOfDays: 0,
                  ));
            },
            childCount: _eventsList.length,
          ),
        ),
      ],
    );
  }

  _buildInvite() {
    return CustomScrollView(
      // controller: _hideButtonController,
      // physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              InviteModel invite = _inviteList[index];
              return InviteContainerWidget(
                invite: invite,
              );
            },
            childCount: _inviteList.length,
          ),
        ),
      ],
    );
  }

  _loaindSchimmer() {
    return Container(
        height: ResponsiveHelper.responsiveHeight(
          context,
          450,
        ),
        child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
                10,
                (index) => EventAndUserScimmerSkeleton(
                      from: 'Event',
                    ))));
  }

  void _showBottomSheetTermsAndConditions(AccountHolderAuthor user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 1.2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 30,
                  // ),
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bio',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text: "\n\n${user.bio!.trim().replaceAll('\n', ' ')}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  _eventDisplay(bool _isAuthor, String userName) {
    return Column(
      children: [
        Expanded(
          child: _isLoadingEvents
              ? _loaindSchimmer()
              : _eventsList.isEmpty
                  ? Center(
                      child: NoContents(
                        icon: null,
                        title: 'No events',
                        subTitle: _isAuthor
                            ? 'The events you create would appear here.'
                            : '$userName hasn\'t created any events yet',
                      ),
                    )
                  : _buildEvent(),
        ),
      ],
    );
  }

  _inviteDisplay(bool _isAuthor, String userName) {
    return Material(
      color: widget.userId == widget.currentUserId
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColorLight,
      child: Column(
        children: [
          Expanded(
            child: _isLoadingEvents
                ? _loaindSchimmer()
                : _inviteList.isEmpty
                    ? Center(
                        child: NoContents(
                          icon: null,
                          title: 'No invites',
                          subTitle: _isAuthor
                              ? 'Your event invitations would appear here.'
                              : '$userName hasn\'t received any event invites yet',
                        ),
                      )
                    : _buildInvite(),
          ),
        ],
      ),
    );
  }

  _tabIcon(IconData icon, bool isSelected) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2,
      height: ResponsiveHelper.responsiveHeight(context, 40.0),
      child: Center(
          child: Icon(
        icon,
        size: ResponsiveHelper.responsiveHeight(context, 25.0),
        color:
            isSelected ? Theme.of(context).secondaryHeaderColor : Colors.grey,
      )),
    );
  }

  int selectedTabIndex = 0;
  // _pageBody() {
  //   return RefreshIndicator(
  //     backgroundColor: Colors.grey[300],
  //     onRefresh: () {
  //       return _setUp();
  //     },
  //     child: DefaultTabController(
  //       length: 2,
  //       child: Scaffold(
  //         backgroundColor: Theme.of(context).primaryColor,
  //         appBar: PreferredSize(
  //           preferredSize: Size.fromHeight(kToolbarHeight),
  //           child: TabBar(
  //             controller: _tabController,
  //             labelColor: Theme.of(context).secondaryHeaderColor,
  //             indicatorSize: TabBarIndicatorSize.label,
  //             indicatorColor: Colors.blue,
  //             unselectedLabelColor: Colors.grey,
  //             isScrollable: true,
  //             indicatorWeight: 2.0,
  //             tabs: <Widget>[
  //               _tabIcon(Icons.event_outlined, selectedTabIndex == 0),
  //               _tabIcon(FontAwesomeIcons.idBadge, selectedTabIndex == 1),
  //             ],
  //           ),
  //         ),
  //         body: NotificationListener<OverscrollIndicatorNotification>(
  //           onNotification: (overscroll) {
  //             overscroll.disallowIndicator();
  //             return true;
  //           },
  //           child: TabBarView(
  //             controller: _tabController,
  //             children: <Widget>[
  //               _eventDisplay(),
  //               _inviteDisplay(),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> refreshData() async {
    // _setUp();
    // mySnackBar(context, 'Profile refreshed');
  }

  final _physycsNotifier = ValueNotifier<bool>(false);

  _scaffold(BuildContext context, AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NestedScrollView(
        controller: _hideButtonController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Color(0xFF1a1a1a),
              leading: IconButton(
                icon: Icon(
                  size: ResponsiveHelper.responsiveHeight(context, 20.0),
                  _isAuthor
                      ? Icons.add
                      : Platform.isIOS
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  // HapticFeedback.mediumImpact();
                  _isAuthor
                      ? _showModalBottomSheetAdd(
                          context,
                        )
                      : Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    size: ResponsiveHelper.responsiveHeight(context, 25.0),
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // HapticFeedback.mediumImpact();
                    _showBottomSheet(context, user);
                  },
                ),
              ],
              expandedHeight: ResponsiveHelper.responsiveHeight(
                context,
                520,
              ),
              flexibleSpace: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF1a1a1a),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                ),
                child: FlexibleSpaceBar(
                  background: SafeArea(
                    child: _followContainer(user),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  color: Theme.of(context).primaryColorLight,
                  child: Listener(
                    onPointerMove: (event) {
                      final offset = event.delta.dx;
                      final index = _tabController.index;
                      //Check if we are in the first or last page of TabView and the notifier is false
                      if (((offset > 0 && index == 0) ||
                              (offset < 0 && index == 2 - 1)) &&
                          !_physycsNotifier.value) {
                        _physycsNotifier.value = true;
                      }
                    },
                    onPointerUp: (_) => _physycsNotifier.value = false,
                    child: ValueListenableBuilder<bool>(
                        valueListenable: _physycsNotifier,
                        builder: (_, value, __) {
                          return TabBar(
                            controller: _tabController,
                            labelColor: Theme.of(context).secondaryHeaderColor,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            isScrollable: true,
                            indicatorWeight: 2.0,
                            tabs: <Widget>[
                              _tabIcon(
                                  Icons.event_outlined, selectedTabIndex == 0),
                              _tabIcon(FontAwesomeIcons.idBadge,
                                  selectedTabIndex == 1),
                            ],
                          );
                        }),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Material(
          color: Theme.of(context).primaryColorLight,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              _eventDisplay(_isAuthor, user.userName!),
              _inviteDisplay(_isAuthor, user.userName!),
            ],
          ),
        ),
      ),
    );
    // CustomScrollView(
    //   // controller: _hideButtonController,
    //   slivers: <Widget>[
    //     SliverToBoxAdapter(
    //       child: RefreshIndicator(
    //           backgroundColor: Colors.grey[300],
    //           onRefresh: () => _setUpFollowers(),
    //           child: _followContainer(user)),
    //     ),
    //     // SliverToBoxAdapter(
    //     //   child: Column(
    //     //     children: [
    //     //       user.profileHandle!.startsWith('Fan')
    //     //           ? const SizedBox.shrink()
    //     //           : Container(
    //     //               color: Theme.of(context).primaryColorLight,
    //     //               child: Column(
    //     //                 children: [
    //     //                   const SizedBox(
    //     //                     height: 4,
    //     //                   ),
    //     //                   _writtenInfo(user),
    //     //                   Divider(),
    //     //                   _professionalImage(user),
    //     //                   const SizedBox(
    //     //                     height: 10,
    //     //                   ),
    //     //                   // Divider(),
    //     //                   _accesWork(
    //     //                     'My website',
    //     //                     user.website!,
    //     //                     Icons.work,
    //     //                   ),
    //     //                   Divider(
    //     //                     color: Colors.blue.withOpacity(.3),
    //     //                   ),
    //     //                   _accesWork(
    //     //                     'My works',
    //     //                     user.otherSites1!,
    //     //                     MdiIcons.web,
    //     //                   ),
    //     //                   Divider(
    //     //                     color: Colors.blue.withOpacity(.3),
    //     //                   ),
    //     //                   _accesWork(
    //     //                     'Other sites',
    //     //                     user.otherSites2!,
    //     //                     MdiIcons.link,
    //     //                   ),
    //     //                   // _accesWorkContainer(user),
    //     //                   const SizedBox(
    //     //                     height: 30,
    //     //                   ),
    //     //                 ],
    //     //               ),
    //     //             ),
    //     //     ],
    //     //   ),
    //     // ),
    //     // SliverToBoxAdapter(
    //     //   child: Padding(
    //     //     padding: const EdgeInsets.symmetric(vertical: 1.0),
    //     //     child: Container(
    //     //       color: Theme.of(context).primaryColorLight,
    //     //       // height: width.toDouble(), // Set the height of the grid
    //     //       child: Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: [
    //     //           const SizedBox(
    //     //             height: 30,
    //     //           ),
    //     //           Text(
    //     //             '   Music\n   preference',
    //     //             style: Theme.of(context).textTheme.displayMedium,
    //     //           ),
    //     //           const SizedBox(
    //     //             height: 10,
    //     //           ),
    //     //           _buildMusicPreference(user),
    //     //           const SizedBox(
    //     //             height: 10,
    //     //           ),
    //     //           Padding(
    //     //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //     //             child: Text(
    //     //               user.favouritePunchline!,
    //     //               style: Theme.of(context).textTheme.bodyMedium,
    //     //             ),
    //     //           ),
    //     //           const SizedBox(
    //     //             height: 30,
    //     //           ),
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),

    //     // SliverToBoxAdapter(
    //     //   child: Padding(
    //     //     padding: const EdgeInsets.only(bottom: 1.0),
    //     //     child: Container(
    //     //       color: Theme.of(context).primaryColorLight,
    //     //       height: width.toDouble() + 100, // Set the height of the grid
    //     //       child: Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: [
    //     //           const SizedBox(
    //     //             height: 30,
    //     //           ),
    //     //           // ListTile(
    //     //           //   trailing: Icon(
    //     //           //     Icons.arrow_back_ios_new,
    //     //           //     color: Colors.blue,
    //     //           //   ),
    //     //           //   title: Text(
    //     //           //     '   Moods\n   punched',
    //     //           //     style: Theme.of(context).textTheme.displayMedium,
    //     //           //   ),
    //     //           // ),
    //     //           _slid('   Moods\n   punched',
    //     //               _postsList.length < 3 ? '' : 'See all'),
    //     //           const SizedBox(
    //     //             height: 10,
    //     //           ),
    //     //           Padding(
    //     //             padding: const EdgeInsets.only(right: 10.0),
    //     //             child: _postsList.isEmpty
    //     //                 ? Container(
    //     //                     // color: Colors.blue[50],
    //     //                     height:
    //     //                         width.toDouble(), // Set the height of the grid
    //     //                     child: Container(
    //     //                       // color: Colors.blue[50],
    //     //                       height: width
    //     //                           .toDouble(), // Set the height of the grid
    //     //                       child: Center(
    //     //                         child: NoContents(
    //     //                           icon: (MdiIcons.camera),
    //     //                           title: 'No punches',
    //     //                           subTitle: '',
    //     //                         ),
    //     //                       ),
    //     //                     ))
    //     //                 : Container(
    //     //                     height: width.toDouble(),
    //     //                     child: CustomScrollView(
    //     //                       scrollDirection: Axis.horizontal,
    //     //                       slivers: <Widget>[
    //     //                         SliverGrid(
    //     //                           gridDelegate:
    //     //                               SliverGridDelegateWithFixedCrossAxisCount(
    //     //                             crossAxisCount: 2,
    //     //                             mainAxisExtent: width.toDouble() /
    //     //                                 2, // Set the width of the grid items
    //     //                             mainAxisSpacing: 0.0,
    //     //                             crossAxisSpacing: 0.0,
    //     //                             childAspectRatio: 1.0,
    //     //                           ),
    //     //                           delegate: SliverChildBuilderDelegate(
    //     //                             (context, index) {
    //     //                               Post post = _postsList[index];
    //     //                               return Container(
    //     //                                 child: FeedGrid(
    //     //                                   feed: 'All',
    //     //                                   currentUserId: widget.currentUserId,
    //     //                                   post: post,
    //     //                                 ),
    //     //                               );
    //     //                             },
    //     //                             childCount: _postsList.length,
    //     //                           ),
    //     //                         ),
    //     //                       ],
    //     //                     ),
    //     //                   ),
    //     //           ),
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),

    //     SliverToBoxAdapter(
    //       child: Container(
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).primaryColorLight,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black12,
    //               offset: Offset(0, 0),
    //               blurRadius: 8.0,
    //               spreadRadius: 2.0,
    //             )
    //           ],
    //         ),
    //         // color: Theme.of(context).primaryColorLight,
    //         // height: width.toDouble(), // Set the height of the grid
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             const SizedBox(
    //               height: 30,
    //             ),

    //             _slid('   Event', _eventsList.length < 3 ? '' : 'See all'),
    //             Divider(),
    //             // Text(
    //             //   '   Events',
    //             //   style: Theme.of(context).textTheme.displayMedium,
    //             // ),
    //             Padding(
    //               padding: const EdgeInsets.only(right: 10.0),
    //               child: _eventsList.isEmpty
    //                   ? Container(
    //                       // color: Colors.blue[50],
    //                       height:
    //                           width.toDouble(), // Set the height of the grid
    //                       child: Center(
    //                         child: NoContents(
    //                           icon: (Icons.event),
    //                           title: 'No events',
    //                           subTitle: '',
    //                         ),
    //                       ))
    //                   : Container(
    //                       height: width.toDouble(),
    //                       child: CustomScrollView(
    //                         scrollDirection: Axis.horizontal,
    //                         slivers: <Widget>[
    //                           SliverList(
    //                             delegate: SliverChildBuilderDelegate(
    //                               (context, index) {
    //                                 Event event = _eventsList[index];
    //                                 return Container(
    //                                     child: EventViewWidget(
    //                                   currentUserId: widget.currentUserId,
    //                                   eventList: _eventsList,
    //                                   event: event,
    //                                   pageIndex: 0,
    //                                   eventSnapshot: [],
    //                                   eventPagesOnly: true,
    //                                   liveCity: '',
    //                                   liveCountry: '',
    //                                   isFrom: '',
    //                                   sortNumberOfDays: 0,
    //                                 ));
    //                               },
    //                               childCount: _eventsList.length,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     // SliverToBoxAdapter(
    //     //   child: widget.currentUserId == user.id
    //     //       ? SizedBox.shrink()
    //     //       : Padding(
    //     //           padding: const EdgeInsets.only(top: 10.0),
    //     //           child: Container(
    //     //             decoration: BoxDecoration(
    //     //               color: Theme.of(context).primaryColorLight,
    //     //               boxShadow: [
    //     //                 BoxShadow(
    //     //                   color: Colors.black12,
    //     //                   offset: Offset(0, 0),
    //     //                   blurRadius: 8.0,
    //     //                   spreadRadius: 2.0,
    //     //                 )
    //     //               ],
    //     //             ),
    //     //             child: Column(
    //     //               crossAxisAlignment: CrossAxisAlignment.start,
    //     //               children: [
    //     //                 const SizedBox(
    //     //                   height: 50,
    //     //                 ),
    //     //                 Text(
    //     //                   '   Suggested\n   creatives',
    //     //                   style: Theme.of(context).textTheme.displayMedium,
    //     //                 ),
    //     //                 const SizedBox(
    //     //                   height: 30,
    //     //                 ),
    //     //                 Container(
    //     //                   color: Theme.of(context).primaryColor.withOpacity(.2),
    //     //                   height:
    //     //                       height.toDouble(), // Set the height of the grid

    //     //                   child: CustomScrollView(
    //     //                     physics: NeverScrollableScrollPhysics(),
    //     //                     // scrollDirection: Axis.horizontal,
    //     //                     slivers: <Widget>[
    //     //                       SliverList(
    //     //                         delegate: SliverChildBuilderDelegate(
    //     //                           (context, index) {
    //     //                             // AccountHolderAuthor user = _usersAll[index];
    //     //                             UserProfessionalModel userProfessional =
    //     //                                 _usersAll[index];

    //     //                             return UserView(
    //     //                               userSnapshot: _usersAllSnapshot,
    //     //                               userList: _usersAll,
    //     //                               currentUserId: widget.currentUserId,
    //     //                               // userId: userProfessional.id,
    //     //                               userProfessional: userProfessional,
    //     //                               pageIndex: 0, isFrom: '', liveCity: '',
    //     //                               liveCountry: '',
    //     //                               // user: user,
    //     //                             );

    //     //                             // Container(
    //     //                             //   // color: Theme.of(context).primaryColorLight,
    //     //                             //   child: UserView(
    //     //                             //     userSnapshot: _usersAllSnapshot,
    //     //                             //     userList: _usersAll,
    //     //                             //     currentUserId: widget.currentUserId,
    //     //                             //     userId: user.id!,
    //     //                             //     user: user,
    //     //                             //     pageIndex: 0,
    //     //                             //   ),
    //     //                             // );
    //     //                           },
    //     //                           childCount: _usersAll.length,
    //     //                         ),
    //     //                       ),
    //     //                     ],
    //     //                   ),
    //     //                 ),
    //     //               ],
    //     //             ),
    //     //           ),
    //     //         ),
    //     // ),

    //     //  EventViewWidget(
    //     //                         currentUserId: currentUserId,
    //     //                         event: event,
    //     //                         eventList: eventsList,
    //     //                         eventSnapshot: eventsSnapshot,
    //     //                         pageIndex: pageIndex,
    //     //                       );
    //     // SliverToBoxAdapter(
    //     //   child: Padding(
    //     //     padding: const EdgeInsets.symmetric(vertical: 5.0),
    //     //     child: Container(
    //     //       color: Theme.of(context).primaryColorLight,
    //     //       // height: width.toDouble(), // Set the height of the grid
    //     //       child: Column(
    //     //         crossAxisAlignment: CrossAxisAlignment.start,
    //     //         children: [
    //     //           const SizedBox(
    //     //             height: 30,
    //     //           ),
    //     //           Text(
    //     //             '   Music\n   preference',
    //     //             style: Theme.of(context).textTheme.displayMedium,
    //     //           ),
    //     //           const SizedBox(
    //     //             height: 30,
    //     //           ),
    //     //           Container(
    //     //               // color: Colors.blue[50],
    //     //               height:
    //     //                   width.toDouble() - 100, // Set the height of the grid
    //     //               child: CustomScrollView(
    //     //                 scrollDirection: Axis.horizontal,
    //     //                 slivers: <Widget>[
    //     // SliverList(
    //     //   delegate: SliverChildBuilderDelegate(
    //     //                       (context, index) {
    //     // AccountHolderAuthor userAll = _usersAll[index];
    //     // return Container(
    //     //   height: 200,
    //     //   child: UserView(
    //     //     userSnapshot: _usersAllSnapshot,
    //     //     userList: _usersAll,
    //     //     currentUserId: widget.currentUserId,
    //     //     userId: user.id!,
    //     //     user: userAll,
    //     //     pageIndex: 0,
    //     //   ),
    //     // );
    //     //                       },
    //     //                       childCount: _usersAll.length,
    //     //                     ),
    //     //                   ),
    //     //                   // SliverGrid(
    //     //                   //   gridDelegate:
    //     //                   //       SliverGridDelegateWithFixedCrossAxisCount(
    //     //                   //     crossAxisCount: 2,
    //     //                   //     mainAxisExtent: width.toDouble() /
    //     //                   //         2, // Set the width of the grid items
    //     //                   //     mainAxisSpacing: 0.0,
    //     //                   //     crossAxisSpacing: 0.0,
    //     //                   //     childAspectRatio: 1.0,
    //     //                   //   ),
    //     //                   //   delegate: SliverChildBuilderDelegate(
    //     //                   //     (context, index) {
    //     //                   //       Post post = _postsList[index];
    //     //                   //       return Container(
    //     //                   //         child: FeedGrid(
    //     //                   //           feed: 'All',
    //     //                   //           currentUserId: widget.currentUserId,
    //     //                   //           post: post,
    //     //                   //         ),
    //     //                   //       );
    //     //                   //     },
    //     //                   //     childCount: _postsList.length,
    //     //                   //   ),
    //     //                   // ),
    //     //                 ],
    //     //               )),
    //     //         ],
    //     //       ),
    //     //     ),
    //     //   ),
    //     // ),
    //   ],
    // );

    //  Scaffold(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     body:

    //  NestedScrollView(
    //   // controller: _hideButtonController,
    //   headerSliverBuilder: (context, innerBoxIsScrolled) {
    //     return [
    //       SliverAppBar(
    //         pinned: false,
    //         backgroundColor: Color(0xFF1a1a1a),
    //         expandedHeight: user.bio!.isEmpty ? 500 : 550,
    //         // expandedHeight: width.toDouble(),
    //         flexibleSpace: FlexibleSpaceBar(

    //             // title: Text('My App'),
    //             background: SafeArea(
    //           child: Padding(
    //             padding: const EdgeInsets.all(30.0),
    //             child: Column(
    //               children: [
    //           const SizedBox(
    //             height: 50,
    //           ),
    //           Hero(
    //             tag: widget.user == null
    //                 ? 'container1' + user.id.toString()
    //                 : 'container1' + widget.user!.id.toString(),
    //             child: GestureDetector(
    //               onTap: () => user.profileImageUrl!.isNotEmpty
    //                   ? Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                           builder: (_) => ViewImage(
    //                                 user: user,
    //                                 from: 'Profile',
    //                               )))
    //                   : () {},
    //               child: CircleAvatar(
    //                 backgroundColor: Color(0xFF1a1a1a),
    //                 radius: 70.0,
    //                 backgroundImage: user.profileImageUrl!.isEmpty
    //                     ? AssetImage(
    //                         'assets/images/user_placeholder.png',
    //                       ) as ImageProvider
    //                     : CachedNetworkImageProvider(
    //                         user.profileImageUrl!),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           Hero(
    //             tag: 'profileHandle',
    //             child: new Material(
    //               color: Colors.transparent,
    //               child: Text(
    //                 user.profileHandle!,
    //                 style: TextStyle(
    //                   color: Colors.blue,
    //                   fontSize: 12.0,
    //                   fontWeight: FontWeight.w400,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           Stack(
    //             alignment: Alignment.bottomCenter,
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.only(
    //                     right:
    //                         user.verified!.isNotEmpty ? 18.0 : 0.0),
    //                 child: new Material(
    //                   color: Colors.transparent,
    //                   child: Text(
    //                     user.userName!
    //                         .toUpperCase()
    //                         .trim()
    //                         .replaceAll('\n', ' '),
    //                     maxLines: 2,
    //                     style: TextStyle(
    //                       color: Colors.white,
    //                       fontSize: 16.0,
    //                       fontWeight: FontWeight.bold,
    //                     ),
    //                     textAlign: TextAlign.center,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //               ),
    //               user.verified!.isEmpty
    //                   ? const SizedBox.shrink()
    //                   : Positioned(
    //                       top: 5,
    //                       right: 0,
    //                       child: Icon(
    //                         MdiIcons.checkboxMarkedCircle,
    //                         size: 15,
    //                         color: Colors.blue,
    //                       ),
    //                     ),
    //             ],
    //           ),
    //           // const SizedBox(
    //           //   height: 20,
    //           // ),
    //           // Container(
    //           //   width: width / 2.5,
    //           //   child: ElevatedButton(
    //           //     style: ElevatedButton.styleFrom(
    //           //       backgroundColor: _isFollowing || _isFecthing
    //           //           ? Colors.grey
    //           //           : Colors.blue,
    //           //       foregroundColor: Colors.blue,
    //           //       shape: RoundedRectangleBorder(
    //           //         borderRadius: BorderRadius.circular(20.0),
    //           //       ),
    //           //     ),
    //           //     onPressed: () => _followOrUnfollow(user),
    //           //     child: Text(
    //           //       // _isFecthing
    //           //       //     ? 'loading..'
    //           //       //     : _isFollowing
    //           //       //         ? ' unfollow'
    //           //       //         :
    //           //       'Create',
    //           //       style: TextStyle(
    //           //         fontSize: 14.0,
    //           //         color:
    //           //             _isFollowing ? Colors.black : Colors.white,
    //           //         fontWeight: _isFecthing
    //           //             ? FontWeight.normal
    //           //             : FontWeight.bold,
    //           //       ),
    //           //     ),
    //           //   ),
    //           // ),
    //           const SizedBox(
    //             height: 20,
    //           ),

    //           Container(
    //             width: width.toDouble(),
    //             decoration: BoxDecoration(
    //                 color: Colors.blue,
    //                 borderRadius: BorderRadius.circular(10)),
    //             child: Center(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   // _isFecthing
    //                   // ? 'loading..'
    //                   // : _isFollowing
    //                   //     ? ' unfollow'
    //                   //     :
    //                   'Follow',
    //                   style: TextStyle(
    //                     fontSize: 12.0,
    //                     color: Colors.white,
    //                     fontWeight: _isFecthing
    //                         ? FontWeight.normal
    //                         : FontWeight.bold,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //           ),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               Container(
    //                 width: width / 3.8,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.withOpacity(.4),
    //                   borderRadius: BorderRadius.only(
    //                     topLeft: Radius.circular(10.0),
    //                     bottomLeft: Radius.circular(10.0),
    //                   ),
    //                 ),
    //                 child: Center(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       // _isFecthing
    //                       // ? 'loading..'
    //                       // : _isFollowing
    //                       //     ? ' unfollow'
    //                       //     :
    //                       'Book Me',
    //                       style: TextStyle(
    //                         fontSize: 12.0,
    //                         color: Colors.white,
    //                         fontWeight: _isFecthing
    //                             ? FontWeight.normal
    //                             : FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 1,
    //               ),
    //               Container(
    //                 width: width / 3.8,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.withOpacity(.4),
    //                   // borderRadius: BorderRadius.circular(10.0),
    //                 ),
    //                 child: Center(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       // _isFecthing
    //                       // ? 'loading..'
    //                       // : _isFollowing
    //                       //     ? ' unfollow'
    //                       //     :
    //                       'Message',
    //                       style: TextStyle(
    //                         fontSize: 12.0,
    //                         color: Colors.white,
    //                         fontWeight: _isFecthing
    //                             ? FontWeight.normal
    //                             : FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               const SizedBox(
    //                 width: 1,
    //               ),
    //               Container(
    //                 width: width / 3.8,
    //                 decoration: BoxDecoration(
    //                   color: Colors.grey.withOpacity(.4),
    //                   borderRadius: BorderRadius.only(
    //                     topRight: Radius.circular(10.0),
    //                     bottomRight: Radius.circular(10.0),
    //                   ),
    //                 ),
    //                 child: Center(
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(8.0),
    //                     child: Text(
    //                       // _isFecthing
    //                       // ? 'loading..'
    //                       // : _isFollowing
    //                       //     ? ' unfollow'
    //                       //     :
    //                       'Advice',
    //                       style: TextStyle(
    //                         fontSize: 12.0,
    //                         color: Colors.white,
    //                         fontWeight: _isFecthing
    //                             ? FontWeight.normal
    //                             : FontWeight.bold,
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Text(
    //               user.bio!.trim().replaceAll('\n', ' '),
    //               maxLines: 5,
    //               style: TextStyle(
    //                 fontSize: 12.0,
    //                 color: Colors.white,
    //                 fontWeight: FontWeight.normal,
    //               ),
    //               overflow: TextOverflow.ellipsis,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   )),
    // ),
    //     ];
    //   },
    //   body: Column(children: [
    //     const SizedBox(
    //       height: 5,
    //     ),

    // GestureDetector(
    //   onHorizontalDragEnd: (details) {
    //     if (details.primaryVelocity!.isNegative) {
    //       // User is swiping right
    //       if (tabController.index == tabController.length - 1) {
    //         // User is on the last tab and swiping right
    //         // Perform your action here
    //       }
    //     }
    //   },
    //   child: Container(),
    // )
    //   ListTile(
    //     title: Text(
    //       'Notification: 2454',
    //       style: Theme.of(context).textTheme.bodySmall,
    //     ),
    //     leading: IconButton(
    //       onPressed: () {
    //         HapticFeedback.mediumImpact();
    //         _showBottomSheetClearActivity(context);
    //       },
    //       icon: Icon(
    //         Icons.clear,
    //         color: Theme.of(context).secondaryHeaderColor,
    //       ),
    //     ),
    //     trailing: IconButton(
    //       onPressed: () {
    //         HapticFeedback.mediumImpact();
    //         _showBottomSheetSortNotifications(context);
    //       },
    //       icon: Icon(
    //         Icons.sort,
    //         color: Theme.of(context).secondaryHeaderColor,
    //       ),
    //     ),
    //   ),
    //   SizedBox(height: 8),
    //  Expanded(
    //           child: ListView(
    //           physics: const NeverScrollableScrollPhysics(),
    //           children: List.generate(
    //               8,
    //               (index) => EventAndUserScimmerSkeleton(
    //                     from: '',
    //                   )),
    //         )),
    //   SizedBox(height: 16),
    // Scaffold(
    //     appBar: AppBar(
    //       iconTheme: IconThemeData(
    //         color: Colors.white,
    //       ),
    //       automaticallyImplyLeading:
    //           widget.currentUserId == widget.userId ? false : true,
    //       actions: <Widget>[
    //         // widget.currentUserId == widget.userId
    //         //     ? Row(
    //         //         crossAxisAlignment: CrossAxisAlignment.center,
    //         //         children: <Widget>[
    //         //           // ConfigBloc().darkModeOn
    //         //           //     ?
    //         //           AnimatedContainer(
    //         //             curve: Curves.easeInOut,
    //         //             duration: Duration(milliseconds: 800),
    //         //             height: _showInfo ? 30.0 : 0.0,
    //         //             width: _showInfo ? 60.0 : 0.0,
    //         //             decoration: BoxDecoration(
    //         //                 color: Colors.transparent,
    //         //                 borderRadius: BorderRadius.circular(10)),
    //         //             child: Text(
    //         //               ConfigBloc().darkModeOn
    //         //                   ? 'lights\noff'
    //         //                   : 'lights\non',
    //         //               style: TextStyle(
    //         //                 fontSize: 10,
    //         //                 color: ConfigBloc().darkModeOn
    //         //                     ? Colors.blueGrey
    //         //                     : Colors.white,
    //         //               ),
    //         //               textAlign: TextAlign.right,
    //         //             ),
    //         //           ),
    //         //           // : Shimmer.fromColors(
    //         //           //     period: Duration(milliseconds: 1000),
    //         //           //     baseColor: Colors.white,
    //         //           //     highlightColor: Colors.grey,
    //         //           //     child: Text(
    //         //           //       'lights on',
    //         //           //       style: TextStyle(color: Colors.white),
    //         //           //     ),
    //         //           //   ),
    //         //           IconButton(
    //         //               icon: Icon(
    //         //                 // !_showInfo
    //         //                 //     ? FontAwesomeIcons.solidCircle
    //         //                 //     :
    //         //                 ConfigBloc().darkModeOn
    //         //                     ? FontAwesomeIcons.lightbulb
    //         //                     : FontAwesomeIcons.solidLightbulb,
    //         //               ),
    //         //               iconSize: 20,
    //         //               color: ConfigBloc().darkModeOn
    //         //                   ? Colors.blueGrey
    //         //                   : Colors.white,
    //         //               onPressed: () async {
    //         //                 HapticFeedback.heavyImpact();
    //         //                 ConfigBloc()
    //         //                     .add(DarkModeEvent(!ConfigBloc().darkModeOn));

    //         //                 if (!_showInfo) {
    //         //                   Timer(Duration(milliseconds: 300), () {
    //         //                     if (mounted) {
    //         //                       setState(() {
    //         //                         _showInfo = true;
    //         //                       });
    //         //                       __setShowInfo();
    //         //                     }
    //         //                   });
    //         //                 }
    //         //               }),
    //         //         ],
    //         //       )
    //     : Provider.of<UserData>(context, listen: false)
    //         //             .user!
    //         //             .score!
    //         //             .isNegative
    //         //         ? const SizedBox.shrink()
    //         //         : IconButton(
    //         //             icon: Icon(
    //         //               Icons.more_vert,
    //         //             ),
    //         //             color: Colors.white,
    //         //             onPressed: () => _showSelectImageDialog(user),
    //         //           ),
    //       ],
    //       elevation: 0,
    //       backgroundColor: Color(0xFF1a1a1a),
    //     ),
    //     backgroundColor: Theme.of(context).primaryColor,
    //     body: SingleChildScrollView(
    //       child:
    //           // Stack(
    //           //   alignment: FractionalOffset.center,
    //           //   children: [
    //           Container(
    //         height: MediaQuery.of(context).size.height - 100,

    //         // _moodPunchedListView && _moodPunched == 0
    //         //     ? MediaQuery.of(context).size.height
    //         //     :
    //         //     MediaQuery.of(context).size.height - 150,
    //         width: width.toDouble(),
    //         child: RefreshIndicator(
    //           backgroundColor: Colors.white,
    //           onRefresh: () async {
    //             _setupIsFollowing();
    //             _setUpFollowers();
    //             _setUpFollowing();
    //             _setupIsBlocking();
    //             // _setupPosts();
    //             // _setUpForums();
    //             // _setUpEvents();
    //             // _setUpPossitiveRated();
    //             // _setUpNegativeRated();
    //           },
    //           child: ListView(children: <Widget>[
    //             Container(
    //               color: Color(0xFF1a1a1a),
    //               // height: 800,
    //               child: Padding(
    //                 padding: const EdgeInsets.only(
    //                   left: 30.0,
    //                   right: 30,
    //                   bottom: 30,
    //                   // top: 10,
    //                 ),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   children: <Widget>[
    //                     SizedBox(
    //                       height: 20,
    //                     ),
    //                     user.userId == Provider.of<UserData>(context).currentUserId
    //                         ? user.profileHandle!.startsWith('Fan')
    //                             ? const SizedBox.shrink()
    //                             : user.professionalPicture1!.isEmpty
    //                                 ? GestureDetector(
    //                                     onTap: () => Navigator.push(
    //                                         context,
    //                                         MaterialPageRoute(
    //                                           builder: (_) =>
    //                                               EditProfileProfessional(
    //                                             user: user,
    //                                           ),
    //                                         )),
    //                                     child: RichText(
    //                                       text: TextSpan(
    //                                         children: [
    //                                           TextSpan(
    //                                               text:
    //                                                   '\nYou must provide your booking information to appear on the discover page. Tap here to provide information.\n',
    //                                               style: TextStyle(
    //                                                 fontSize: 12,
    //                                                 color: Colors.blue,
    //                                               )),
    //                                         ],
    //                                       ),
    //                                       textAlign: TextAlign.center,
    //                                     ),
    //                                   )
    //                                 : const SizedBox.shrink()
    //                         : const SizedBox.shrink(),
    //                     SizedBox(
    //                       height: 10,
    //                     ),
    //                     Container(
    //                       decoration: BoxDecoration(
    //                         color: Color(0xFF1a1a1a),
    //                         borderRadius: BorderRadius.circular(100.0),
    //                       ),
    //                       child: Hero(
    //                         tag: widget.user == null
    //                             ? 'container1' + user.id.toString()
    //                             : 'container1' + widget.user!.id.toString(),
    //                         child: GestureDetector(
    //                           onTap: () => user.profileImageUrl!.isNotEmpty
    //                               ? Navigator.push(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                       builder: (_) => ViewImage(
    //                                             user: user,
    //                                             from: 'Profile',
    //                                           )))
    //                               : () {},
    //                           child: CircleAvatar(
    //                             backgroundColor: Color(0xFF1a1a1a),
    //                             radius: 70.0,
    //                             backgroundImage: user.profileImageUrl!.isEmpty
    //                                 ? AssetImage(
    //                                     'assets/images/user_placeholder.png',
    //                                   ) as ImageProvider
    //                                 : CachedNetworkImageProvider(
    //                                     user.profileImageUrl!),
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       height: 20.0,
    //                     ),
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: [
    //                         Hero(
    //                           tag: 'profileHandle',
    //                           child: new Material(
    //                             color: Colors.transparent,
    //                             child: Text(
    //                               user.profileHandle!,
    //                               style: TextStyle(
    //                                 color: Colors.white,
    //                                 fontSize: 12.0,
    //                                 fontWeight: FontWeight.w400,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         Stack(
    //                           alignment: Alignment.bottomCenter,
    //                           children: [
    //                             Padding(
    //                               padding: EdgeInsets.only(
    //                                   right: user.verified!.isNotEmpty
    //                                       ? 18.0
    //                                       : 0.0),
    //                               child: new Material(
    //                                 color: Colors.transparent,
    //                                 child: Text(
    //                                   user.userName!.toUpperCase(),
    //                                   style: TextStyle(
    //                                     color: Colors.white,
    //                                     fontSize: 16.0,
    //                                     fontWeight: FontWeight.bold,
    //                                   ),
    //                                   textAlign: TextAlign.center,
    //                                 ),
    //                               ),
    //                             ),
    //                             user.verified!.isEmpty
    //                                 ? const SizedBox.shrink()
    //                                 : Positioned(
    //                                     top: 5,
    //                                     right: 0,
    //                                     child: Icon(
    //                                       MdiIcons.checkboxMarkedCircle,
    //                                       size: 15,
    //                                       color: Colors.blue,
    //                                     ),
    //                                   ),
    //                           ],
    //                         ),
    //                         const SizedBox(
    //                           height: 20,
    //                         ),
    //                         Container(
    //                           width: 200.0,
    //                           child: ElevatedButton(
    //                             style: ElevatedButton.styleFrom(
    //                               backgroundColor: _isFollowing || _isFecthing
    //                                   ? Colors.grey
    //                                   : Color(0xFFD38B41),
    //                               foregroundColor: Colors.blue,
    //                               shape: RoundedRectangleBorder(
    //                                 borderRadius: BorderRadius.circular(20.0),
    //                               ),
    //                             ),
    //                             onPressed: () {
    //                               Navigator.push(
    //                                   context,
    //                                   MaterialPageRoute(
    //                                     builder: (_) => EditProfileScreen(
    //                                       user: user,
    //                                     ),
    //                                   ));
    //                             },
    //                             child: Text(
    //                               'Create',
    //                               style: TextStyle(
    //                                 fontSize: 12.0,
    //                                 color: _isFollowing
    //                                     ? Colors.black
    //                                     : Colors.white,
    //                                 fontWeight: _isFecthing
    //                                     ? FontWeight.normal
    //                                     : FontWeight.bold,
    //                               ),
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 10.0,
    //                         ),
    //                         // user.profileHandle!.startsWith('F') ||
    //                         //         user.profileHandle!.isEmpty
    //                         //     ? const SizedBox.shrink()
    //                         //     :
    //                         Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               GestureDetector(
    //                                 onTap: () => Navigator.push(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (_) =>
    //                                             ProfileProfessionalProfile(
    //                                               user: user,
    //                                               currentUserId:
    //                                                   widget.currentUserId,
    //                                               userId: '',
    //                                             ))),
    //                                 child: Container(
    //                                   width: 50,
    //                                   height: 50,
    //                                   decoration: BoxDecoration(
    //                                     color: Colors.grey.withOpacity(.1),
    //                                     shape: BoxShape.circle,
    //                                   ),
    //                                   child: Padding(
    //                                     padding: const EdgeInsets.all(10.0),
    //                                     child: Align(
    //                                         alignment: Alignment.center,
    //                                         child: Icon(Icons.work,
    //                                             size: 30,
    //                                             color: Colors.grey[500])),
    //                                   ),
    //                                 ),
    //                               ),
    //                               widget.currentUserId == user.id
    //                                   ? const SizedBox.shrink()
    //                                   : const SizedBox(
    //                                       width: 20,
    //                                     ),
    //                               widget.currentUserId == user.id
    //                                   ? const SizedBox.shrink()
    //                                   : GestureDetector(
    //                                       onTap: () => Navigator.push(
    //                                           context,
    //                                           MaterialPageRoute(
    //                                               builder: (_) =>
    //                                                   ProfileProfessionalProfile(
    //                                                     user: user,
    //                                                     currentUserId: widget
    //                                                         .currentUserId,
    //                                                     userId: '',
    //                                                   ))),
    //                                       child: Container(
    //                                         width: 50,
    //                                         height: 50,
    //                                         decoration: BoxDecoration(
    //                                           color:
    //                                               Colors.grey.withOpacity(.1),
    //                                           shape: BoxShape.circle,
    //                                         ),
    //                                         child: Padding(
    //                                           padding:
    //                                               const EdgeInsets.all(10.0),
    //                                           child: Align(
    //                                               alignment: Alignment.center,
    //                                               child: Icon(Icons.send,
    //                                                   size: 30,
    //                                                   color: Colors.grey[500])),
    //                                         ),
    //                                       ),
    //                                     ),
    //                             ])
    //                         // user.profileHandle!.startsWith('F') ||
    //                         //         user.profileHandle!.isEmpty
    //                         //     ? const SizedBox.shrink()
    //                         //     : SizedBox(
    //                         //         height: 10.0,
    //                         //       ),
    //                         // user.profileHandle!.startsWith('F') ||
    //                         //         user.profileHandle!.isEmpty
    //                         //     ? const SizedBox.shrink()
    //                         //     : Row(
    //                         //         mainAxisAlignment: MainAxisAlignment.center,
    //                         //         children: [
    //                         //           GestureDetector(
    //                         //             onTap: () => Navigator.push(
    //                         //                 context,
    //                         //                 MaterialPageRoute(
    //                         //                     builder: (_) =>
    //                         //                         ProfileProfessionalProfile(
    //                         //                           user: user,
    //                         //                           currentUserId:
    //                         //                               widget.currentUserId,
    //                         //                           userId: '',
    //                         //                         ))),
    //                         //             child: Container(
    //                         //               width: 35,
    //                         //               height: 35,
    //                         //               decoration: BoxDecoration(
    //                         //                 color: Colors.transparent,
    //                         //                 shape: BoxShape.circle,
    //                         //                 border: Border.all(
    //                         //                     width: 1.0,
    //                         //                     color: Colors.white),
    //                         //               ),
    //                         //               child: Padding(
    //                         //                 padding: const EdgeInsets.all(1.0),
    //                         //                 child: Align(
    //                         //                   alignment: Alignment.center,
    //                         //                   child: Text(
    //                         //                     'B',
    //                         //                     style: TextStyle(
    //                         //                       color: Colors.white,
    //                         //                       fontSize: 14,
    //                         //                     ),
    //                         //                     textAlign: TextAlign.center,
    //                         //                   ),
    //                         //                 ),
    //                         //               ),
    //                         //             ),
    //                         //           ),
    //                         // SizedBox(
    //                         //   width: 10,
    //                         // ),
    //                         // SizedBox(
    //                         //   width: 10,
    //                         // ),
    //                         // GestureDetector(
    //                         //   onTap: () => Navigator.push(
    //                         //       context,
    //                         //       MaterialPageRoute(
    //                         //           builder: (_) =>
    //                         //               UserAdviceScreen(
    //                         //                 user: user,
    //                         //                 currentUserId:
    //                         //                     widget.currentUserId,
    //                         //               ))),
    //                         //   child: Container(
    //                         //     width: 35,
    //                         //     height: 35,
    //                         //     decoration: BoxDecoration(
    //                         //       color: Colors.transparent,
    //                         //       shape: BoxShape.circle,
    //                         //       border: Border.all(
    //                         //           width: 1.0,
    //                         //           color: Colors.white),
    //                         //     ),
    //                         //     child: Padding(
    //                         //       padding: const EdgeInsets.all(1.0),
    //                         //       child: Align(
    //                         //         alignment: Alignment.center,
    //                         //         child: Text(
    //                         //           'A',
    //                         //           style: TextStyle(
    //                         //             color: Colors.white,
    //                         //             fontSize: 14,
    //                         //           ),
    //                         //           textAlign: TextAlign.center,
    //                         //         ),
    //                         //       ),
    //                         //     ),
    //                         //   ),
    //                         // ),
    //                         //   ],
    //                         // ),
    //                       ],
    //                     ),
    //                     // SizedBox(
    //                     //   height: 10.0,
    //                     // ),
    //                     // Divider(
    //                     //   color: Colors.white,
    //                     // ),
    //                     // SizedBox(
    //                     //   height: 5.0,
    //                     // ),
    //                     // Padding(
    //                     //   padding: const EdgeInsets.all(8.0),
    //                     //   child: Text(
    //                     //     'Bio',
    //                     //     style: TextStyle(
    //                     //       color: ConfigBloc().darkModeOn
    //                     //           ? Colors.blueGrey[100]
    //                     //           : Colors.grey,
    //                     //       fontSize: width > 600 ? 16 : 12,
    //                     //       fontWeight: FontWeight.bold,
    //                     //     ),
    //                     //   ),
    //                     // ),

    //                     // _displayButton(
    //                     //   user,
    //                     // ),
    //                     const SizedBox(
    //                       height: 20,
    //                     ),
    //                     HyperLinkText(
    //                       from: 'Profile',
    //                       text: user.bio!.trim(),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),

    //                     // GestureDetector(
    //                     //     onTap: () => Navigator.push(
    //                     //         context,
    //                     //         MaterialPageRoute(
    //                     //           builder: (_) => EditProfileScreen(
    //                     //             user: user,
    //                     //           ),
    //                     //         )),
    //                     //     child: Container(
    //                     //         width: 200,
    //                     //         color: Colors.transparent,
    //                     //         child: Align(
    //                     //           alignment: Alignment.center,
    //                     //           child: Padding(
    //                     //             padding: const EdgeInsets.all(8.0),
    //                     //             child: Text(
    //                     //               'Edit Profile',
    //                     //               style: TextStyle(
    //                     //                   color: Colors.blue,
    //                     //                   fontSize: width > 600 ? 14 : 12,
    //                     //                   fontWeight: FontWeight.bold),
    //                     //             ),
    //                     //           ),
    //                     //         ))),

    //                     // Stack(
    //                     //   alignment: Alignment.bottomLeft,
    //                     //   children: [
    //                     //     Positioned(
    //                     //       left: 0.0,
    //                     //       top: 0.0,
    //                     //       child: Container(
    //                     //         height: 10,
    //                     //         width: 10,
    //                     //         color: Colors.blue,
    //                     //       ),
    //                     //     ),
    //                     //     user.favouritePunchline!.isEmpty
    //                     //         ? const SizedBox.shrink()
    //                     //         : Padding(
    //                     //             padding: const EdgeInsets.only(left: 20.0),
    //                     //             child: Material(
    //                     //               color: Colors.transparent,
    //                     //               child: SingleChildScrollView(
    //                     //                 child: Text(
    //                     //                   '${user.favouritePunchline} '
    //                     //                       .toLowerCase(),
    //                     //                   style: TextStyle(
    //                     //                     fontSize: 12,
    //                     //                     color: Colors.white,
    //                     //                   ),
    //                     //                   textAlign: TextAlign.left,
    //                     //                 ),
    //                     //               ),
    //                     //             ),
    //                     //           ),
    //                     //   ],
    //                     // ),

    //                     // Hero(
    //                     //   tag: 'nickName',
    //                     //   child: new Material(
    //                     //     color: Colors.transparent,
    //                     //     child: Text(
    //                     //       user.name!.trim(),
    //                     //       style: TextStyle(
    //                     //         color: ConfigBloc().darkModeOn
    //                     //             ? Colors.blueGrey
    //                     //             : Colors.white,
    //                     //         fontSize: 14.0,
    //                     //       ),
    //                     //     ),
    //                     //   ),
    //                     // ),

    //                     // user.profileHandle!.startsWith("Fan") ||
    //                     //         user.subAccountType!.isEmpty
    //                     //     ? const SizedBox.shrink()
    //                     //     : Material(
    //                     //         color: Colors.transparent,
    //                     //         child: Text(
    //                     //           user.subAccountType!,
    //                     //           style: TextStyle(
    //                     //             color: Colors.black,
    //                     //             fontSize: 12.0,
    //                     //             fontWeight: FontWeight.w400,
    //                     //           ),
    //                     //           textAlign: TextAlign.center,
    //                     //         ),
    //                     //       ),
    //                     // user.profileHandle!.startsWith('F') ||
    //                     //         user.profileHandle!.isEmpty
    //                     //     ? const SizedBox.shrink()
    //                     //     : Text(
    //                     //         user.company!.trim(),
    //                     //         style: TextStyle(
    //                     //           color: Colors.black,
    //                     //           fontSize: 14,
    //                     //         ),
    //                     //       ),
    //                     // SizedBox(
    //                     //   height: 20.0,
    //                     // ),
    //                     // SizedBox(
    //                     //   height: 40.0,
    //                     // ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             // ConfigBloc().darkModeOn
    //             //     ? Divider(color: Colors.white)
    //             //     : const SizedBox.shrink(),
    //             // SizedBox(
    //             //   height: 20.0,
    //             // ),

    //             // HyperLinkText(
    //             //   from: 'Profile',
    //             //   text: user.bio!.trim(),
    //             // ),

    //             // AnimatedInfoWidget(
    //             //   text: '<     Swipe',
    //             //   requiredBool: _showSwipe,
    //             // ),
    // _buildMusicPreference(user),

    //             // Row(
    //             //   crossAxisAlignment: CrossAxisAlignment.center,
    //             //   mainAxisAlignment: MainAxisAlignment.center,
    //             //   children: [
    //             //     AnimatedContainer(
    //             //       curve: Curves.easeInOut,
    //             //       duration: Duration(milliseconds: 800),
    //             //       height: _showSwipe ? 20.0 : 0.0,
    //             //       width: _showSwipe ? 70.0 : 0.0,
    //             //       decoration: BoxDecoration(
    //             //           color: Colors.transparent,
    //             //           borderRadius: BorderRadius.circular(5)),
    //             //       child: Text(
    //             //         '<     Swipe',
    //             //         style: TextStyle(
    //             //           fontSize: 12,
    //             //           color: Colors.blue,
    //             //         ),
    //             //         textAlign: TextAlign.center,
    //             //       ),
    //             //     ),
    //             //     AnimatedContainer(
    //             //       curve: Curves.easeInOut,
    //             //       duration: Duration(milliseconds: 800),
    //             //       height: _showSwipe ? 20.0 : 0.0,
    //             //       width: _showSwipe ? 20.0 : 0.0,
    //             //       decoration: BoxDecoration(
    //             //           color: Colors.blue,
    //             //           borderRadius: BorderRadius.circular(100)),
    //             //     ),
    //             //   ],
    //             // ),
    //             // _isFecthing
    //             //     ? Center(
    //             //         child: Text(
    //             //           'Loading...',
    //             //           style: TextStyle(
    //             //             color: Colors.grey,
    //             //             fontSize: 12,
    //             //           ),
    //             //         ),
    //             //       )
    //             //     : !user.profileHandle!.startsWith('Ar') ||
    //             //             user.profileHandle!.isEmpty
    //             //         ? _buildStatistics(user)
    //             //         : _buildArtistStatistics(user),

    // Padding(
    //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //   child: Text(
    //     'Favorite Punchline',
    //     style: TextStyle(
    //       color: Colors.grey,
    //       fontSize: 12,
    //     ),
    //   ),
    // ),
    //             user.favouritePunchline!.isEmpty
    //                 ? const SizedBox.shrink()
    //                 : Padding(
    //                     padding: const EdgeInsets.only(
    //                         left: 20.0, right: 20, bottom: 20, top: 20),
    //                     child: RichText(
    //                       text: TextSpan(
    //                         children: [
    //                           TextSpan(
    //                               text:
    //                                   '"  ${user.favouritePunchline!.toLowerCase()} "',
    //                               style: TextStyle(
    //                                 fontSize: 12,
    //                                 color:
    //                                     Theme.of(context).secondaryHeaderColor,
    //                               )),
    //                         ],
    //                       ),
    //                       textAlign: TextAlign.left,
    //                     ),
    //                   ),
    //             // SizedBox(
    //             //   height: 30,
    //             // ),
    //             // _buildMusicPreference(user),
    //             // SizedBox(
    //             //   height: 30,
    //             // ),
    //             // Row(
    //             //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             //   children: [
    //             //     Container(
    //             //       color: Colors.grey,
    //             //       height: 1,
    //             //       width: width / 4,
    //             //     ),
    //             //     Container(
    //             //       decoration: BoxDecoration(
    //             //           border: Border.all(color: Colors.grey, width: 1)),
    //             //       width: width / 3,
    //             //       child: Padding(
    //             //         padding: const EdgeInsets.all(5.0),
    //             //         child: Align(
    //             //           alignment: Alignment.center,
    //             //           child: Text(
    //             //             'contents',
    //             //             style: TextStyle(
    //             //               color: ConfigBloc().darkModeOn
    //             //                   ? Colors.grey
    //             //                   : Colors.black,
    //             //               fontSize: 12,
    //             //             ),
    //             //           ),
    //             //         ),
    //             //       ),
    //             //     ),
    //             //     Container(
    //             //       color: Colors.grey,
    //             //       height: 1,
    //             //       width: width / 4,
    //             //     ),
    //             //   ],
    //             // ),
    //             // SizedBox(
    //             //   height: 40.0,
    //             // ),
    //             // user.score!.isNegative
    //             //     ? const SizedBox.shrink()
    //             //     : Provider.of<UserData>(context, listen: false)
    //             //             .user!
    //             //             .score!
    //             //             .isNegative
    //             //         ? const SizedBox.shrink()
    //             //         : _buildMoodPunched(user),
    //             // _moodPunched == 0
    //             //     ? SizedBox(
    //             //         height: 30.0,
    //             //       )
    //             //     : const SizedBox.shrink(),
    //             // _moodPunched == 0
    //             //     ? _buildMoodToggleButton()
    //             //     : const SizedBox.shrink(),
    //             // SizedBox(
    //             //   height: 30.0,
    //             // ),
    //             // user.score!.isNegative
    //             //     ? const SizedBox.shrink()
    //             //     : Provider.of<UserData>(context, listen: false)
    //             //             .user!
    //             //             .score!
    //             //             .isNegative
    //             //         ? const SizedBox.shrink()
    //             //         : _buildDisplay(user),
    //             // SizedBox(
    //             //   height: 40.0,
    //             // ),
    //             const SizedBox(
    //               height: 10,
    //             ),

    //             DefaultTabController(
    //               length: 2,
    //               child: Container(
    //                 // color: Colors.blue,
    //                 height: 900,
    //                 width: width.toDouble(),
    //                 child: Scaffold(
    //                     backgroundColor: Colors.transparent,
    //                     appBar: TabBar(
    //                         controller: _tabController,
    //                         labelColor: Theme.of(context).secondaryHeaderColor,
    //                         indicatorSize: TabBarIndicatorSize.label,
    //                         indicatorColor: Colors.blue,
    //                         // onTap: (int index) {
    //                         //   Provider.of<UserData>(context, listen: false)
    //                         //       .setEventTab(index);
    //                         // },
    //                         unselectedLabelColor: Colors.grey,
    //                         isScrollable: true,
    //                         labelPadding: EdgeInsets.symmetric(
    //                           horizontal: 10,
    //                         ),
    //                         indicatorWeight: 2.0,
    //                         tabs: <Widget>[
    //                           Container(
    //                             width: width / 2,
    //                             child: Center(
    //                                 child: const Icon(
    //                               MdiIcons.postOutline,
    //                               size: 30,
    //                               color: Colors.grey,
    //                             )),
    //                           ),
    //                           Container(
    //                             width: width / 2,
    //                             child: Center(
    //                                 child: const Icon(
    //                               Icons.event,
    //                               size: 30,
    //                               color: Colors.grey,
    //                             )),
    //                           ),
    //                           // Container(
    //                           //   width: width / 4,
    //                           //   child: Center(
    //                           //     child: const Text(
    //                           //       'peference',
    //                           //     ),
    //                           //   ),
    //                           // ),
    //                           // const Text(
    //                           //   '',
    //                           // ),
    //                         ]),
    //                     body: Listener(
    //                       onPointerMove: (event) {
    //                         final offset = event.delta.dx;
    //                         final index = _tabController.index;

    //                         //Check if we are in the first or last page of TabView and the notifier is false
    //                         if (((offset > 0 && index == 0) ||
    //                                 (offset < 0 && index == 2 - 1)) &&
    //                             !_physycsNotifier.value) {
    //                           _physycsNotifier.value = true;
    //                         }
    //                       },
    //                       onPointerUp: (_) => _physycsNotifier.value = false,
    //                       child: ValueListenableBuilder<bool>(
    //                         valueListenable: _physycsNotifier,
    //                         builder: (_, value, __) {
    //                           return Padding(
    //                             padding: const EdgeInsets.only(top: 10.0),
    //                             child: TabBarView(
    //                               controller: _tabController,

    //                               // controller: widget.tabController,
    //                               physics: value
    //                                   ? NeverScrollableScrollPhysics()
    //                                   : null,
    //                               children: <Widget>[
    //                                 Padding(
    //                                     padding: const EdgeInsets.all(10.0),
    //                                     child: ProfilePostsDisplay(
    //                                       user: user,
    //                                     )),
    //                                 Padding(
    //                                     padding: const EdgeInsets.all(10.0),
    //                                     child: ProfileEventsDisplay(
    //                                       user: user,
    //                                     )),
    //                                 // Padding(
    //                                 //   padding: const EdgeInsets.all(10.0),
    //                                 //   child: ProfileMusicPrefernce(
    //                                 //     user: user,
    //                                 //   ),
    //                                 // ),

    //                                 // GestureDetector(
    //                                 //   onHorizontalDragEnd: (details) {
    //                                 //     if (details.primaryVelocity!.isNegative) {
    //                                 //       // User is swiping right
    //                                 //       if (tabController.index == tabController.length - 1) {
    //                                 //         // User is on the last tab and swiping right
    //                                 //         // Perform your action here
    //                                 //       }
    //                                 //     }
    //                                 //   },
    //                                 //   child: Container(),
    //                                 // )
    //                               ],
    //                             ),
    //                           );
    //                         },
    //                       ),
    //                     )),
    //               ),
    //             ),
    //           ]),
    //         ),
    //       ),
    //       //     Positioned(
    //       //       bottom: 0,
    //       //       child: Container(
    //       //         height: 200,
    //       //         width: width.toDouble(),
    //       //         decoration: BoxDecoration(
    //       //           color: Colors.grey[800],
    //       //         ),
    //       //         child: Padding(
    //       //           padding: const EdgeInsets.all(30.0),
    //       //           child: Column(
    //       //             children: [
    //       //               SizedBox(
    //       //                 width: width.toDouble(),
    //       //                 child: ElevatedButton(
    //       //                     style: ElevatedButton.styleFrom(
    //       //                       backgroundColor: Colors.cyan,
    //       //                       elevation: 0.0,
    //       //                       foregroundColor: Colors.white,
    //       //                       shape: RoundedRectangleBorder(
    //       //                         borderRadius: BorderRadius.circular(5.0),
    //       //                       ),
    //       //                     ),
    //       //                     child: Padding(
    //       //                       padding: const EdgeInsets.symmetric(
    //       //                           horizontal: 5.0, vertical: 2),
    //       //                       child: Text(
    //       //                         'Follow',
    //       //                         style: TextStyle(
    //       //                           color: Colors.white,
    //       //                           fontSize: 12,
    //       //                         ),
    //       //                         textAlign: TextAlign.center,
    //       //                       ),
    //       //                     ),
    //       //                     onPressed: () {}),
    //       //               ),
    //       //               const SizedBox(
    //       //                 height: 2,
    //       //               ),
    //       //             ],
    //       //           ),
    //       //         ),
    //       //       ),
    //       //     )
    //       //   ],
    //       // ),
    //     ));
  }

  void _showBottomSheetUnfollow(
      BuildContext context, AccountHolderAuthor user, String from) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: from.startsWith('unfollow')
              ? 'unFollow'
              : from.startsWith('block')
                  ? 'block'
                  : from.startsWith('unBlock')
                      ? 'unBlock'
                      : '',
          onPressed: () {
            Navigator.pop(context);
            from.startsWith('unfollow')
                ? _unfollowUser(user)
                : from.startsWith('block')
                    ? _blockser(user)
                    : from.startsWith('unBlock')
                        ? _unBlockser(user)
                        : _nothing();
          },
          title: from.startsWith('unfollow')
              ? 'Are you sure you want to unfollow ${user.userName}?'
              : from.startsWith('block')
                  ? 'Are you sure you want to block ${user.userName}?'
                  : from.startsWith('unBlock')
                      ? 'Are you sure you want to unblock ${user.userName}?'
                      : '',
          subTitle: '',
        );
      },
    );
  }

  // _iosBottomSheet2(AccountHolderAuthor user, String from) {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CupertinoActionSheet(
  //           title: Text(
  //             from.startsWith('unfollow')
  //                 ? 'Are you sure you want to unfollow ${user.userName}?'
  //                 : from.startsWith('block')
  //                     ? 'Are you sure you want to block ${user.userName}?'
  //                     : from.startsWith('unBlock')
  //                         ? 'Are you sure you want to unblock ${user.userName}?'
  //                         : '',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.black,
  //             ),
  //           ),
  //           actions: <Widget>[
  //             CupertinoActionSheetAction(
  //                 child: Text(
  //                   from.startsWith('unfollow')
  //                       ? 'unFollow'
  //                       : from.startsWith('block')
  //                           ? 'block'
  //                           : from.startsWith('unBlock')
  //                               ? 'unBlock'
  //                               : '',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   from.startsWith('unfollow')
  //                       ? _unfollowUser(user)
  //                       : from.startsWith('block')
  //                           ? _blockser(user)
  //                           : from.startsWith('unBlock')
  //                               ? _unBlockser(user)
  //                               : _nothing();
  //                 }),
  //           ],
  //           cancelButton: CupertinoActionSheetAction(
  //             child: Text(
  //               'Cancle',
  //               style: TextStyle(
  //                 color: Colors.red,
  //               ),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //         );
  //       });
  // }

  // _androidDialog2(BuildContext parentContext, AccountHolderAuthor user, String from) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text(
  //             from.startsWith('unfollow')
  //                 ? 'Are you sure you want to unfollow ${user.userName}?'
  //                 : from.startsWith('block')
  //                     ? 'Are you sure you want to block ${user.userName}?'
  //                     : from.startsWith('unBlock')
  //                         ? 'Are you sure you want to unblock ${user.userName}?'
  //                         : '',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           children: <Widget>[
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   from.startsWith('unfollow')
  //                       ? 'unFollow'
  //                       : from.startsWith('block')
  //                           ? 'block'
  //                           : from.startsWith('unBlock')
  //                               ? 'unBlock'
  //                               : '',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   from.startsWith('unfollow')
  //                       ? _unfollowUser(user)
  //                       : from.startsWith('block')
  //                           ? _blockser(user)
  //                           : from.startsWith('unBlock')
  //                               ? _unBlockser(user)
  //                               : _nothing();
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Cancel',
  //                 ),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // _chat(AccountHolderAuthor user) async {
  //   // AccountHolderAuthorAuthor user =
  //   //     await DatabaseService.getUserAuthorWithId(_profileUser.id!);
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => ChatMessageScreen(
  //         user: null,
  //         currentUserId: widget.currentUserId,
  //         // fromProfile: true,
  //         chat: null, userId: user.id!,
  //       ),
  //     ),
  //   );
  // }

  // _iosBottomSheet(AccountHolderAuthor user) {
  //   showCupertinoModalPopup(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return CupertinoActionSheet(
  //           title: Text(
  //             'Actions',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.black,
  //             ),
  //           ),
  //           actions: <Widget>[
  //             CupertinoActionSheetAction(
  //                 child: Text(
  //                   'Message',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   _bottomModalSheetMessage(user);
  //                   // _chat(user);
  //                 }
  //                 // =>

  //                 // user.profileHandle!.startsWith('Fan')
  //                 //     ?
  //                 //     _chat()
  //                 //     :
  //                 //     Navigator.push(
  //                 //         context,
  //                 //         MaterialPageRoute(
  //                 //           builder: (_) => StartChat(
  //                 //             user: user,
  //                 //             currentUserId: widget.currentUserId,
  //                 //           ),
  //                 //         ),)

  //                 ),
  //             CupertinoActionSheetAction(
  //                 child: Text(
  //                   'Share',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 onPressed: () => _dynamicLink()),
  //             CupertinoActionSheetAction(
  //                 child: Text(
  //                   _isFollowing ? 'unFollow' : 'Follow',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   // _followOrUnfollow(user);
  //                 }),
  //             CupertinoActionSheetAction(
  //                 child: Text(
  //                   _isBlockingUser ? 'unBlock' : 'Block',
  //                   style: TextStyle(
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   _blockOrUnBlock(user);
  //                 }),
  //             CupertinoActionSheetAction(
  //               child: Text(
  //                 'Report',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.push(
  //                     context,
  //                     MaterialPageRoute(
  //                         builder: (_) => ReportContentPage(
  //                               parentContentId: widget.userId,
  //                               repotedAuthorId: widget.userId,
  //                               contentId: widget.userId,
  //                               contentType: 'user',
  //                             )));
  //               },
  //             ),
  //           ],
  //           cancelButton: CupertinoActionSheetAction(
  //             child: Text(
  //               'Cancel',
  //               style: TextStyle(
  //                 color: Colors.red,
  //               ),
  //             ),
  //             onPressed: () => Navigator.pop(context),
  //           ),
  //         );
  //       });
  // }

  // _androidDialog(BuildContext parentContext, AccountHolderAuthor user) {
  //   return showDialog(
  //       context: parentContext,
  //       builder: (context) {
  //         return SimpleDialog(
  //           title: Text(
  //             'Actions',
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           children: <Widget>[
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Message',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (_) => StartChat(
  //                           user: user,
  //                           currentUserId: widget.currentUserId,
  //                         ),
  //                       ));
  //                 },
  //               ),
  //             ),
  //             Center(
  //               child: SimpleDialogOption(
  //                   child: Text(
  //                     'Share',
  //                     style: TextStyle(
  //                         fontWeight: FontWeight.bold, color: Colors.blue),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   onPressed: () => _dynamicLink()),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   _isFollowing ? 'unFollow' : 'Follow',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   // _followOrUnfollow(user);
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   _isBlockingUser ? 'unBlock' : 'Block',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   // _blockOrUnBlock(user);
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Report',
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.bold, color: Colors.blue),
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                   Navigator.pop(context);
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (_) => ReportContentPage(
  //                                 parentContentId: widget.userId,
  //                                 repotedAuthorId: widget.userId,
  //                                 contentId: widget.userId,
  //                                 contentType: user.userName!,
  //                               )));
  //                 },
  //               ),
  //             ),
  //             Divider(),
  //             Center(
  //               child: SimpleDialogOption(
  //                 child: Text(
  //                   'Cancel',
  //                 ),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void _showBottomSheetBookMe(BuildContext context, AccountHolderAuthor user) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: MediaQuery.of(context).size.height.toDouble() / 1.5,
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: UserBookingOption(
  //             bookingUser: user,
  //           ));
  //     },
  //   );
  // }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheet(BuildContext context, AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 500),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            child: MyBottomModelSheetAction(
              actions: [
                Icon(
                  size: ResponsiveHelper.responsiveHeight(context, 25),
                  Icons.horizontal_rule,
                  // size: 30,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  trailing: _isAuthor
                      ? GestureDetector(
                          onTap: () {
                            // HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                            navigateToPage(
                              context,
                              EditProfileScreen(
                                user: user,
                              ),
                            );
                          },
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                            size: ResponsiveHelper.responsiveHeight(
                                context, 30.0),
                          ),
                        )
                      : null,
                  leading: user.profileImageUrl!.isEmpty
                      ? Icon(
                          Icons.account_circle_outlined,
                          size: 60,
                          color: Colors.grey,
                        )
                      : Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  user.profileImageUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  title: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: user.userName!.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium),
                        TextSpan(
                          text: "\n${user.profileHandle}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12)),
                        )
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BottomModelSheetIconActionWidget(
                      onPressed: () {
                        // HapticFeedback.mediumImpact();
                        // await Future.delayed(Duration(milliseconds: 300));
                        _isAuthor
                            ? _showModalBottomSheetAdd(
                                context,
                              )
                            : navigateToPage(
                                context,
                                SendToChats(
                                  sendContentId: widget.userId,
                                  currentUserId: Provider.of<UserData>(context,
                                          listen: false)
                                      .currentUserId!,
                                  // userId: '',
                                  sendContentType: 'User',
                                  sendImageUrl: user.profileImageUrl!,
                                  sendTitle: user.userName!,
                                  // event: null,
                                  // post: null,
                                  // // forum: null,
                                  // user: user,
                                ));
                      },
                      icon: _isAuthor ? Icons.add : Icons.send_outlined,
                      text: _isAuthor ? 'Create' : 'Send',
                    ),
                    BottomModelSheetIconActionWidget(
                      onPressed: () async {
                        Share.share(user.dynamicLink!);

                        //      String link  await DatabaseService.myDynamicLink(
                        //     user.profileImageUrl!,
                        //     user.userName!,
                        //     user.bio,
                        //     'https://www.barsopus.com/user_${widget.user.id}');
                        // Share.share(link);
                        // HapticFeedback.mediumImpact();

                        // _dynamicLink();
                      },
                      icon: Icons.share_outlined,
                      text: 'Share',
                    ),
                  ],
                ),
                // BottomModalSheetButton(
                //   onPressed: () async {
                //     HapticFeedback.mediumImpact();
                //     await Future.delayed(Duration(milliseconds: 300));
                //     Navigator.pop(context);
                //     // Navigator.push(
                //     //     context,
                //     //     MaterialPageRoute(
                //     //         builder: (_) => ProfileScreen(
                //     //               currentUserId: Provider.of<UserData>(context)
                //     //                   .currentUserId,
                //     //               userId: user.id!,
                //     //               user: user,
                //     //             )));
                //   },
                //   width: width.toDouble(),
                //   child: Text(_isAuthor
                //       ? 'Invite a friend'
                //       : 'Block'),
                // ),

                BottomModelSheetListTileActionWidget(
                    colorCode: '',
                    icon: _isAuthor
                        ? Icons.mail_outline_rounded
                        : Icons.block_outlined,
                    onPressed: _isAuthor
                        ? () async {
                            Share.share(user.dynamicLink!);
                          }
                        : () {
                            _blockOrUnBlock(user);
                          },
                    text: _isAuthor ? 'Invite a friend' : 'Block'),
                const SizedBox(
                  height: 10,
                ),

                BottomModelSheetListTileActionWidget(
                    colorCode: '',
                    icon: _isAuthor
                        ? Icons.settings_outlined
                        : Icons.flag_outlined,
                    onPressed: _isAuthor
                        ? () async {
                            navigateToPage(
                              context,
                              ProfileSettings(
                                user: user,
                              ),
                            );
                            //                   if (_isLoadingGeneralSettins) return;
                            // _isLoadingGeneralSettins = true;
                            // try {
                            //   UserSettingsGeneralModel userGeneralSettings =
                            //       await DatabaseService.getUserGeneralSettingWithId(
                            //     widget.user!.userId!,
                            //   );

                            //   navigateToPage(
                            //     context,
                            //     ProfileSettings(
                            //       userGeneralSettings: userGeneralSettings,
                            //     ),
                            //   );
                            // } catch (e) {
                            //   _showBottomSheetErrorMessage('Failed to fetch booking data.');
                            // } finally {
                            //   _isLoadingGeneralSettins = false;
                            // }
                          }
                        : () {
                            navigateToPage(
                                context,
                                ReportContentPage(
                                  contentId: user.userId!,
                                  contentType: user.userName!,
                                  parentContentId: user.userId!,
                                  repotedAuthorId: user.userId!,
                                ));
                          },
                    text: _isAuthor ? 'Settings' : 'Report'),
                // BottomModalSheetButton(
                //   onPressed: () async {
                //     HapticFeedback.mediumImpact();
                //     await Future.delayed(Duration(milliseconds: 300));
                //     Navigator.pop(context);
                //     user.userId == widget.currentUserId
                //         ? navigateToPage(
                //             context,
                //             ProfileSettings(
                //               user: user,
                //             ),
                //           )
                //         : navigateToPage(
                //             context,
                //             ReportContentPage(
                //               contentId: user.id!,
                //               contentType: user.userName!,
                //               parentContentId: user.id!,
                //               repotedAuthorId: user.id!,
                //             ));
                //   },
                //   width: width.toDouble(),
                //   child: Text(
                //       user.userId == widget.currentUserId ? 'Settings' : 'Report'),
                // ),
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.feedback_outlined,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SuggestionBox()));
                  },
                  text: 'Suggestion',
                ),
                // BottomModalSheetButton(
                //   onPressed: () async {
                //     HapticFeedback.mediumImpact();
                //     await Future.delayed(Duration(milliseconds: 300));
                //     Navigator.pop(context);
                //     Navigator.push(context,
                //         MaterialPageRoute(builder: (_) => SuggestionBox()));
                //   },
                //   width: width.toDouble(),
                //   child: Text('Suggestion'),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  _displayScaffold() {
    AccountHolderAuthor user = widget.user!;

    // DatabaseService.numFavoriteArtist(user.userName!.toUpperCase())
    //     .listen((artistCount) {
    //   if (mounted) {
    //     setState(() {
    //       _artistFavoriteCount = artistCount;
    //     });
    //   }
    // });

    // DatabaseService.numArtistPunch(
    //         widget.currentUserId, user.userName!.toUpperCase())
    //     .listen((artistPunch) {
    //   if (mounted) {
    //     setState(() {
    //       _artistPunch = artistPunch;
    //     });
    //   }
    // });

    return _isBlockedUser || user.disabledAccount!
        ? UserNotFound(
            userName: user.userName!,
          )
        : user.reportConfirmed!
            ? UserBanned(
                userName: user.userName!,
              )
            : _scaffold(context, user);
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);

    super.build(context);

    return widget.user == null
        ? _provider.user != null && widget.userId == widget.currentUserId
            ? _scaffold(context, _provider.user!)
            : FutureBuilder(
                future: usersAuthorRef.doc(widget.userId).get(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      color: Color(0xFF1a1a1a),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 250,
                              width: 250,
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.grey,
                                ),
                                strokeWidth: 1,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Shimmer.fromColors(
                              period: Duration(milliseconds: 1000),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.white,
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "Loading ",
                                      style: TextStyle(
                                          fontSize:
                                              ResponsiveHelper.responsiveHeight(
                                                  context, 16.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)),
                                  TextSpan(text: 'Profile\nPlease Wait... '),
                                ],
                                style: TextStyle(
                                    fontSize: ResponsiveHelper.responsiveHeight(
                                        context, 16.0),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (!snapshot.data!.exists) {
                    return UserNotFound(userName: 'User');
                  }

                  AccountHolderAuthor user =
                      AccountHolderAuthor.fromDoc(snapshot.data);

                  return _isBlockedUser || user.disabledAccount!
                      ? UserNotFound(
                          userName: user.userName!,
                        )
                      : user.reportConfirmed!
                          ? UserBanned(
                              userName: user.userName!,
                            )
                          : _scaffold(context, user);
                })
        : _displayScaffold();
  }
}
