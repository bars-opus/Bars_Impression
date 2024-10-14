import 'dart:ui';
import 'package:bars/utilities/exports.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  static final id = 'Profile_screen';
  final String userId;
  final String accountType;
  final AccountHolderAuthor? user;

  ProfileScreen({
    required this.currentUserId,
    required this.accountType,
    required this.userId,
    required this.user,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _isFollowing = false;
  bool _isFollowerResquested = false;
  bool _isFecthing = true;
  bool _isAFollower = false;
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  int _followerCount = 0;
  int _followingCount = 0;
  int pointCoint = 0;
  bool _isLoading = false;
  bool _userNotFound = false;
  bool _isLoadingChat = false;
  bool _isLoadingEvents = true;
  List<Post> _postsList = [];
  UserStoreModel? _profileStore;
  AccountHolderAuthor? _profileClient;
  ShopWorkerModel? _profileWorker;

  double coseTope = 10;
  // late TabController _tabController;
  List<InviteModel> _inviteList = [];
  int limit = 5;
  int currentTab = 0;
  List<ReviewModel> _reviewList = [];
  bool _isFecthingRatings = true;
  RatingModel? _userRatings;

  bool isPayOutSetUp = false;
  bool creativeIsGhanaOrCurrencyGHS = false;
  bool currentUserGhanaOrCurrencyGHS = false;

  // PageController _pageController2 = PageController(
  //   initialPage: 0,
  // );
  // int _index = 0;

  bool _hasNext = true;
  late final _lastInviteDocument = <DocumentSnapshot>[];
  late final _lastPostDocument = <DocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
    widget.userId.isEmpty ? _nothing() : setUp();
    // _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(() {
    //   setState(() {
    //     selectedTabIndex = _tabController.index;
    //   });
    // });

    // _hideButtonController = ScrollController();
    // SchedulerBinding.instance.addPostFrameCallback((_) {});
    // Timer.periodic(Duration(seconds: 5), (Timer timer) {
    //   if (_index < 2) {
    //     _index++;
    //     if (_pageController2.hasClients) {
    //       _pageController2.animateToPage(
    //         _index,
    //         duration: Duration(milliseconds: 2000),
    //         curve: Curves.easeInOut,
    //       );
    //     }
    //   } else {
    //     _index = 0;
    //     if (_pageController2.hasClients) {
    //       _pageController2.jumpToPage(
    //         _index,
    //       );
    //     }
    //   }
    // });
  }

  // _addLists(UserData provider, UserStoreModel userPortfolio) {
  //   processCurrency(provider, userPortfolio);
  //   // var _provider = Provider.of<UserData>(context, listen: false);
  //   provider.setOverview(userPortfolio.overview);
  //   provider.setTermsAndConditions(userPortfolio.terms);
  //   provider.setNoBooking(userPortfolio.noBooking);

  //   // Add user awards
  //   List<PortfolioModel> awards = userPortfolio.awards;
  //   awards.forEach((award) => provider.setAwards(award));

  //   // Add userPortfolio companies
  //   // List<PortfolioCompanyModel> companies = widget.userPortfolio.company;
  //   // companies.forEach((company) => provider.setCompanies(company));

  //   // // Add userPortfolio contact
  //   List<PortfolioContactModel> contacts = userPortfolio.contacts;
  //   contacts.forEach((contact) => provider.setBookingContacts(contact));

  //   // Add links to work
  //   List<PortfolioModel> links = userPortfolio.links;
  //   links.forEach((link) => provider.setLinksToWork(link));

  //   // Add services
  //   List<PortfolioModel> services = userPortfolio.services;
  //   services.forEach((service) => provider.setServices(service));

  //   // Add skills
  //   // List<PortfolioModel> skills = userPortfolio.skills;
  //   // skills.forEach((skill) => provider.setServices(skill));

  //   // Add genre tags
  //   // List<PortfolioModel> genreTags = userPortfolio.genreTags;
  //   // genreTags.forEach((genre) => provider.setGenereTags(genre));

  //   // Add collaborations
  //   // List<PortfolioCollaborationModel> collaborations =
  //   //     userPortfolio.collaborations;
  //   // collaborations
  //   //     .forEach((collaboration) => provider.setCollaborations(collaboration));
  //   // // Add price
  //   // List<PriceModel> priceTags = userPortfolio.priceTags;
  //   // priceTags.forEach((priceTags) => provider.setPriceRate(priceTags));

  //   // Add professional image urls
  //   List<String> imageUrls = userPortfolio.professionalImageUrls;
  //   provider.setProfessionalImages(imageUrls);
  // }

  void processCurrency(UserData provider, UserStoreModel userPortfolio) {
    // Check if widget.userPortfolio.currency is null or empty
    if (userPortfolio.currency == null ||
        userPortfolio.currency.trim().isEmpty) {
      // Handle the case where currency is null or empty
      provider.setCurrency('');
      return;
    }

    // Proceed with normal processing if currency is not null or empty
    final List<String> currencyPartition =
        userPortfolio.currency.trim().replaceAll('\n', ' ').split("|");

    String _currency = currencyPartition.length > 1 ? currencyPartition[1] : '';

    // Check if _currency has at least 3 characters before accessing _currency[2]
    if (_currency.length >= 2) {
      provider.setCurrency(_currency);
      // print(_currency);
    } else {
      // Handle the case where _currency does not have enough characters
      provider.setCurrency('');
    }
  }

  // _clear(UserData provider) {
  //   if (mounted) {
  //     provider.setOverview('');
  //     provider.setTermsAndConditions('');
  //     provider.setCurrency('');
  //     provider.awards.clear();
  //     provider.priceRate.clear();
  //     // provider.company.clear();
  //     provider.bookingContacts.clear();
  //     provider.linksToWork.clear();
  //     // provider.performances.clear();
  //     provider.skills.clear();
  //     provider.genreTages.clear();
  //     provider.collaborations.clear();
  //     provider.professionalImages.clear();
  //     provider.setBookingPriceRate(null);
  //   }
  // }

  setUp() {
    _setupIsFollowing();
    _setUpFollowers();
    _setUpFollowing();
    _setupIsBlockedUser();
    _setupIsBlocking();
    _setupIsAFollowerUser();
    // _setUpEvents();
    _setUpInvites();

    if (widget.user == null || widget.user!.accountType != 'Client')
      _fetchProfile();
  }

  _setCurrency(UserData _provider, UserStoreModel userPortfolio) {
    try {
      UserSettingsLoadingPreferenceModel currentUserPayoutInfo =
          _provider.userLocationPreference!;

      bool _isPayOutSetUp = userPortfolio.transferRecepientId.isNotEmpty;

      bool _creativeIsGhanaOrCurrencyGHS = IsGhanain.isGhanaOrCurrencyGHS(
          userPortfolio.country, userPortfolio.currency);

      bool _currentUserGhanaOrCurrencyGHS = IsGhanain.isGhanaOrCurrencyGHS(
          currentUserPayoutInfo.country!, currentUserPayoutInfo.currency!);
      setState(() {
        isPayOutSetUp = _isPayOutSetUp;
        creativeIsGhanaOrCurrencyGHS = _creativeIsGhanaOrCurrencyGHS;
        currentUserGhanaOrCurrencyGHS = _currentUserGhanaOrCurrencyGHS;
      });
    } catch (e) {}
  }

  _nothing() {}

  Future<void> _fetchProfile() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    var userSnapshot = widget.accountType == 'Shop'
        ? await userProfessionalRef.doc(widget.userId).get()
        : widget.accountType == 'Worker'
            ? await usersWokerRef.doc(widget.userId).get()
            : await usersAuthorRef.doc(widget.userId).get();

    if (userSnapshot.exists) {
      if (widget.accountType == 'Shop') {
        UserStoreModel user = UserStoreModel.fromDoc(userSnapshot);
        if (mounted) {
          setState(() {
            _profileStore = user;
            _provider.setUserStore(user);
            _isFecthing = false;
          });
        }
      } else if (widget.accountType == 'Worker') {
        ShopWorkerModel user = ShopWorkerModel.fromDoc(userSnapshot);
        if (mounted) {
          setState(() {
            _profileWorker = user;
            _isFecthing = false;
          });
        }
      } else {
        AccountHolderAuthor user = AccountHolderAuthor.fromDoc(userSnapshot);
        if (mounted) {
          setState(() {
            _profileClient = user;
            _isFecthing = false;
          });
        }
      }
    } else {
      // Handle the case where the user data does not exist
      if (mounted) {
        setState(() {
          _userNotFound = true;
          _isFecthing = false;
        });
      }
    }
  }

  _setupIsFollowing() async {
    try {
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
    } catch (e) {}
  }

  // _setupIsFollowRequest() async {
  //   try {
  //     bool isFollowingRequest = await DatabaseService.isFollowingRequested(
  //       currentUserId: widget.currentUserId,
  //       userId: widget.userId,
  //     );

  //     if (mounted) {
  //       setState(() {
  //         _isFollowerResquested = isFollowingRequest;
  //         _isFecthing = false;
  //       });
  //     }
  //   } catch (e) {}
  // }

  _setupIsAFollowerUser() async {
    try {
      bool isAFollower = await DatabaseService.isAFollowerUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );
      if (mounted) {
        setState(() {
          _isAFollower = isAFollower;
        });
      }
    } catch (e) {}
  }

  _setupIsBlockedUser() async {
    try {
      bool isBlockedUser = await DatabaseService.isBlockedUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );
      if (mounted) {
        setState(() {
          _isBlockedUser = isBlockedUser;
        });
      }
    } catch (e) {}
  }

  _setupIsBlocking() async {
    try {
      bool isBlockingUser = await DatabaseService.isBlokingUser(
        currentUserId: widget.currentUserId,
        userId: widget.userId,
      );
      if (mounted) {
        setState(() {
          _isBlockingUser = isBlockingUser;
        });
      }
    } catch (e) {}
  }

  _setUpFollowers() async {
    try {
      int userFollowerCount = await DatabaseService.numFollowers(widget.userId);
      if (mounted) {
        setState(() {
          _followerCount = userFollowerCount;
        });
      }
    } catch (e) {}
  }

  _setUpFollowing() async {
    try {
      int userFollowingCount =
          await DatabaseService.numFollowing(widget.userId);
      if (mounted) {
        setState(() {
          _followingCount = userFollowingCount;
        });
      }
    } catch (e) {}
  }

  Stream<List<Event>> getUserEventsStream(String userId) {
    return eventsRef
        .doc(userId)
        .collection('userEvents')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Event.fromDoc(doc)).toList();
    });
  }

  Set<String> addedPostIds = Set<String>();

  _setUpInvites() async {
    try {
      QuerySnapshot ticketOrderSnapShot = widget.currentUserId == widget.userId
          ? await userInvitesRef
              .doc(widget.userId)
              .collection('eventInvite')
              .orderBy('eventTimestamp', descending: true)
              .limit(10)
              .get()
          : await userInvitesRef
              .doc(widget.userId)
              .collection('eventInvite')
              .where('answer', isEqualTo: 'Accepted')
              .limit(1)
              .get();
      List<InviteModel> ticketOrder = ticketOrderSnapShot.docs
          .map((doc) => InviteModel.fromDoc(doc))
          .toList();
      if (ticketOrderSnapShot.docs.isNotEmpty) {
        _lastInviteDocument.addAll(ticketOrderSnapShot.docs);
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
      return [];
    }
  }

  Set<String> addedInviteIds = Set<String>();

  // _followOrUnfollow(UserStoreModel user) {
  //   HapticFeedback.heavyImpact();
  //   if (_isFollowing) {
  //     _showBottomSheetUnfollow(context, user, 'unfollow');
  //   } else {
  //     _followUser(user);
  //   }
  // }

  // _requestFollowOrUnfollow(UserStoreModel user) {
  //   HapticFeedback.heavyImpact();
  //   if (_isFollowerResquested) {
  //     _showBottomSheetUnfollow(context, user, 'cancelFollowRequest');
  //   } else {
  //     _followUser(user);
  //   }
  // }

  _blockOrUnBlock(UserStoreModel user) {
    if (_isBlockingUser) {
      _showBottomSheetUnfollow(context, user, 'unBlock');
    } else {
      _showBottomSheetUnfollow(context, user, 'block');
    }
  }

  _unBlockser(UserStoreModel user) {
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
        'unBlocked ' + user.shopName,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _cancelFollowRequest(UserStoreModel user) {
    HapticFeedback.heavyImpact();
    try {
      DatabaseService.cancelFollowRequest(
        currentUserId: user.userId!,
        requesterUserId: widget.currentUserId,
      );
      if (mounted) {
        setState(() {
          _isFollowerResquested = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'follow request cancelled ',
          overflow: TextOverflow.ellipsis,
        ),
      ));
    } catch (e) {}
  }

  _blockser(UserStoreModel user) async {
    HapticFeedback.heavyImpact();
    try {
      // UserStoreModel? fromUser =
      //     await DatabaseService.getUserWithId(widget.currentUserId);
      // if (fromUser != null) {
      //   DatabaseService.blockUser(
      //     currentUserId: widget.currentUserId,
      //     userId: widget.userId,
      //     user: fromUser,
      //   );
      // } else {
      //   mySnackBar(context, 'Could not bloack this person');
      // }

      // if (mounted) {
      //   setState(() {
      //     _isBlockingUser = true;
      //   });
      // }
      // if (_isAFollower) {
      //   DatabaseService.unfollowUser(
      //     currentUserId: widget.userId,
      //     userId: widget.currentUserId,
      //   );
      // }
    } catch (e) {}
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
        'Blocked ' + user.shopName,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _unfollowUser(UserStoreModel user) {
    try {
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
    } catch (e) {}
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Unfollowed ' + user.shopName,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _followUser(UserStoreModel user) async {
    // user.isShop!
    //     ? DatabaseService.sendFollowRequest(
    //         currentUserId: widget.currentUserId,
    //         privateUser: user,
    //         currentUser: Provider.of<UserData>(context, listen: false).user!,
    //       )
    //     :

    //  DatabaseService.followUser(
    //     currentUserId: widget.currentUserId,
    //     user: user,
    //     currentUser: Provider.of<UserData>(context, listen: false).user!,
    //   );

    if (mounted) {
      // user.isShop!
      //     ? setState(() {
      //         _isFollowerResquested = true;
      //       })
      //     :

      setState(() {
        _isFollowing = true;
        _followerCount++;
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        // user.isShop!
        //     ? 'Follow request sent to ${user.userName!}'
        //     :

        'Followed ${user.shopName}',
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

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

  _buildStatistics(UserStoreModel user) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;

    bool isAuthor = currentUserId == user.userId;
    return UserStatistics(
      count: NumberFormat.compact().format(_followerCount),
      countColor: Colors.grey,
      titleColor: Colors.grey,
      onPressed: () => _followerCount == 0
          ? navigateToPage(
              context,
              NoFollowers(
                from: 'Clients',
                isCurrentUser: isAuthor,
                userName: user.shopName,
              ))
          : navigateToPage(
              context,
              FollowerFollowing(
                userId: user.userId!,
                followerCount: _followerCount,
                followingCount: _followingCount,
                follower: 'Clients',
              )),
      title: '  Clients',
      subTitle: 'The number of accounts following you.',
    );

    //  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
    //   UserStatistics(
    //     count: NumberFormat.compact().format(_followerCount),
    //     countColor: Colors.white,
    //     titleColor: Colors.white,
    //     onPressed: () => _followerCount == 0
    //         ? navigateToPage(
    //             context,
    //             NoFollowers(
    //               from: 'Follower',
    //               isCurrentUser: isAuthor,
    //               userName: user.userName!,
    //             ))
    //         : navigateToPage(
    //             context,
    //             FollowerFollowing(
    //               userId: user.userId!,
    //               followerCount: _followerCount,
    //               followingCount: _followingCount,
    //               follower: 'Follower',
    //             )),
    //     title: '  Followers',
    //     subTitle: 'The number of accounts following you.',
    //   ),
    //   const SizedBox(
    //     width: 20,
    //   ),
    //   UserStatistics(
    //     countColor: Colors.white,
    //     titleColor: Colors.white,
    //     count: NumberFormat.compact().format(_followingCount),
    //     onPressed: () => _followingCount == 0
    //         ? navigateToPage(
    //             context,
    //             NoFollowers(
    //               from: 'Following',
    //               isCurrentUser: isAuthor,
    //               userName: user.userName!,
    //             ))
    //         : navigateToPage(
    //             context,
    //             FollowerFollowing(
    //               userId: user.userId!,
    //               followerCount: _followerCount,
    //               followingCount: _followingCount,
    //               follower: 'Following',
    //             )),
    //     title: '  Following',
    //     subTitle: 'The number of accounts you are following.',
    //   ),
    // ]);
  }

  // _callButton() {
  //   return GestureDetector(
  //     onTap: () {
  //       _showBottomSheetContact(context, _profileUser!);
  //     },
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(5),
  //           decoration: BoxDecoration(
  //             color: Colors.grey,
  //             shape: BoxShape.circle,
  //           ),
  //           child: Icon(
  //             Icons.call_outlined,
  //             size: ResponsiveHelper.responsiveHeight(context, 20),
  //             color: Colors.white,
  //           ),
  //         ),
  //         const SizedBox(
  //           width: 10,
  //         ),
  //         Text(
  //           'Call',
  //           style: TextStyle(
  //             color: Colors.grey,
  //             fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
  //             fontWeight: FontWeight.bold,
  //           ),
  //           maxLines: 5,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // _button(String text, VoidCallback onPressed, String borderRaduis) {
  //   return GestureDetector(
  //     onTap: onPressed,
  //     child: Container(
  //       margin: const EdgeInsets.all(20.0),
  //       width: double.infinity,
  //       height: ResponsiveHelper.responsiveHeight(context, 33.0),
  //       decoration: BoxDecoration(
  //         color: Colors.blue,
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Center(
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Text(
  //             text,
  //             style: TextStyle(
  //               fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
  //               color: Colors.white,
  //               // text.startsWith('loading...') ? Colors.blue : Colors.white,
  //               // fontWeight: _isFecthing ? FontWeight.normal : FontWeight.bold,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
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

  void _showBottomSheetAdvice(BuildContext context, UserStoreModel user) async {
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
              userId: user.userId,
              currentUserId: widget.currentUserId,
              userName: user.shopName,
              isBlocked: _isBlockedUser,
              isBlocking: _isBlockingUser,
              updateBlockStatus: () {
                setState(() {});
              },
              disableAdvice: false,
              hideAdvice: false,
              // user: user,
            ),
          ),
        );
      },
    );
  }

  // void _bottomModalSheetMessage(
  //     BuildContext context, UserStoreModel user, Chat? chat) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           height: ResponsiveHelper.responsiveHeight(context, 650),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Padding(
  //               padding: const EdgeInsets.only(top: 30.0),
  //               child: SizedBox.shrink()

  //               // BottomModalSheetMessage(
  //               //   showAppbar: false,
  //               //   isBlocked: _isBlockedUser,
  //               //   isBlocking: _isBlockingUser,
  //               //   currentUserId: widget.currentUserId,
  //               //   user: user,
  //               //   userAuthor: null,
  //               //   chatLoaded: chat,
  //               //   userPortfolio: null,
  //               //   userId: user.userId!,
  //               // ),
  //               ));
  //     },
  //   );
  // }

  // void _showModalBottomSheetAdd(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return CreateContent();
  //     },
  //   );
  // }

  void _showBottomSheetNoPortolio(
      BuildContext context, UserStoreModel _user) async {
    bool _isAuthor = _user.userId == widget.currentUserId;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
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

  void _showBottomSheetEnableBooking(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Enable booking',
          onPressed: () async {
            Navigator.pop(context);
            try {
              WriteBatch batch = FirebaseFirestore.instance.batch();

              batch.update(
                usersGeneralSettingsRef.doc(userId),
                {
                  'disableBooking': false,
                },
              );

              batch.update(
                userProfessionalRef.doc(userId),
                {
                  'noBooking': false,
                },
              );
              try {
                batch.commit();
              } catch (error) {}

              // // _refundList.clear();
            } catch (e) {
              _showBottomSheetErrorMessage('Error enabling bookinh ');
            }
          },
          title: 'Are you sure you want to enable booking?',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetNoBooking(
      BuildContext context, UserStoreModel _user) async {
    bool _isAuthor = _user.userId == widget.currentUserId;

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
                      title: 'No Booking',
                      subTitle: _isAuthor
                          ? 'Enable bookings to be discovered on the creative page and get booked for work on projects.'
                          : '${_user.shopName} is not availbe to work at this moment.',
                      icon: Icons.work_off_rounded),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 30),
                  ),
                  _isAuthor
                      ? BlueOutlineButton(
                          buttonText: 'Enable booking.',
                          onPressed: () {
                            Navigator.pop(context);
                            _showBottomSheetEnableBooking(
                                context, _user.userId);
                          },
                        )
                      : const SizedBox.shrink(),
                ],
              )),
        );
      },
    );
  }

  // void _showBottomSheetBookingCalendar(bool fromPrice) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return BookingCalendar(
  //         currentUserId: widget.currentUserId,
  //         bookingUser: _profileUser!,
  //         // prices: _profileUser!.priceTags,
  //         fromPrice: fromPrice,
  //       );
  //     },
  //   );
  // }

  // _chatButton() {
  //   bool _isAuthor = _profileUser!.userId == widget.currentUserId;
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 0.0),
  //     child: Column(
  //       // mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         _button(
  //             // _isLoading ? 'loading...' :
  //             'Book', () async {
  //           _showBottomSheetBookingCalendar(false);
  //           // if (_isLoading) return;

  //           // _isLoading = true;
  //           // try {
  //           //   UserStoreModel? _user =
  //           //       await DatabaseService.getUserProfessionalWithId(
  //           //     user.userId!,
  //           //   );

  //           //   if (_user != null) {
  //           //     _user.professionalImageUrls.isEmpty && _user.skills.isEmpty
  //           //         ? _showBottomSheetNoPortolio(context, _user)
  //           //         : _user.noBooking
  //           //             ? _showBottomSheetNoBooking(context, _user)
  //           //             : navigateToPage(
  //           //                 context,
  //           //                 DiscographyWidget(
  //           //                   currentUserId: widget.currentUserId,
  //           //                   userIndex: 0,
  //           //                   userPortfolio: _user,
  //           //                 ),
  //           //               );
  //           //   } else {
  //           //     _showBottomSheetErrorMessage(user.userId.toString());
  //           //   }
  //           // } catch (e) {
  //           //   _showBottomSheetErrorMessage(e);
  //           // } finally {
  //           //   _isLoading = false;
  //           // }
  //         }, 'Left'),
  //         const SizedBox(
  //           width: 1,
  //         ),
  //         _button(
  //             // _isAuthor
  //             //     ? 'Advice'
  //             //     : _isLoadingChat
  //             //         ? 'loading...'
  //             //         :

  //             'Contact', () {
  //           _showBottomSheetContact(context, _profileUser!);
  //         }, 'Right'),
  //       ],
  //     ),
  //   );
  // }

  // _editProfile(UserStoreModel user) {
  //   bool _isAuthor = user.userId == widget.currentUserId;
  //   _isAuthor
  //       ? _showBottomSheetEditProfile()
  //       : user.shopLogomageUrl.isEmpty
  //           ? () {}
  //           : navigateToPage(
  //               context,
  //               ViewImage(
  //                 imageUrl: user.shopLogomageUrl,
  //               ),
  //             );
  // }

  // _launchMap(String address) {
  //   return MapsLauncher.launchQuery(address);
  // }

  // void _showBottomSheetOpeningHours(UserStoreModel user) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: ResponsiveHelper.responsiveHeight(context, 600),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColorLight,
  //             borderRadius: BorderRadius.circular(30)),
  //         child: ListView(
  //           padding: const EdgeInsets.all(10),
  //           children: [
  //             TicketPurchasingIcon(
  //               title: '',
  //             ),
  //             const SizedBox(
  //               height: 30,
  //             ),
  //             OpeninHoursWidget(
  //               openingHours: user.openingHours,
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // _profileImageWidget(
  //   String imageUrl,
  //   String userId,
  // ) {
  //   return Hero(
  //     tag: 'container1' + userId.toString(),
  //     child: imageUrl.isEmpty
  //         ? Icon(
  //             Icons.store,
  //             color: Colors.grey,
  //             size: ResponsiveHelper.responsiveHeight(context, 80),
  //           )
  //         : CircleAvatar(
  //             backgroundColor: Color(0xFF1e4848),
  //             radius: ResponsiveHelper.responsiveHeight(context, 40.0),
  //             backgroundImage:
  //                 CachedNetworkImageProvider(imageUrl, errorListener: (_) {
  //               return;
  //             }),
  //           ),
  //   );
  // }

  _profileImageHeaderWidget({
    required bool isClient,
    required bool isAuthor,
    required String imageUrl,
    required String userId,
    required bool verified,
    required String name,
    required String shopOrAccountType,
    required UserStoreModel? user,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            // _editProfile(user);
          },
          child: Stack(
            children: [
              ProfileImageDisplayWidget(
                imageUrl: imageUrl,
                userId: userId,
              ),
              // _profileImageWidget(imageUrl, userId),
              isAuthor
                  ? Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(.4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(
                            size: ResponsiveHelper.responsiveHeight(
                                context, 15.0),
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
          width: 10,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameText(
                color: Colors.black,
                name: name.toUpperCase().trim().replaceAll('\n', ' '),
                verified: verified,
              ),
              if (!isClient) _buildStatistics(user!),
              new Material(
                color: Colors.transparent,
                child: Text(
                  shopOrAccountType,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (!isClient)
                StarRatingWidget(
                  isMini: true,
                  enableTap: false,
                  onRatingChanged: (_) {},
                  rating: user!.averageRating ?? 0,
                ),
            ],
          ),
        ),
      ],
    );
  }

  // _followContainer(UserStoreModel user) {
  //   var divider = Divider(
  //     thickness: .2,
  //     height: 20,
  //   );
  //   bool _isAuthor = user.userId == widget.currentUserId;
  //   return Container(
  //     margin: const EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       color: Theme.of(context).primaryColorLight,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: SafeArea(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //         child: Column(
  //           children: [
  //             SizedBox(
  //               height: ResponsiveHelper.responsiveHeight(context, 40.0),
  //             ),
  //             _profileImageHeaderWidget(
  //                 isClient: false,
  //                 isAuthor: _isAuthor,
  //                 imageUrl: user.shopLogomageUrl,
  //                 userId: user.userId,
  //                 verified: user.verified,
  //                 name: user.shopName,
  //                 shopOrAccountType: user.shopType,
  //                 user: null),

  //             divider,
  //             GestureDetector(
  //                 onTap: () {
  //                   _showBottomSheetOpeningHours(user);
  //                 },
  //                 child: ShopOpenStatus(shop: user)),

  //             divider,
  //             GestureDetector(
  //               onTap: () {
  //                 _launchMap(user.address);
  //               },
  //               child: PayoutDataWidget(
  //                 inMini: true,
  //                 label: 'Location',
  //                 value: user.address,
  //                 text2Ccolor: Colors.blue,
  //               ),
  //             ),

  //             divider,
  //             GestureDetector(
  //               onTap: () {
  //                 _showBottomSheetTermsAndConditions(user);
  //               },
  //               child: Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   user.overview.trim().replaceAll('\n', ' '),
  //                   maxLines: _isAuthor ? 4 : 3,
  //                   style: TextStyle(
  //                     fontSize:
  //                         ResponsiveHelper.responsiveFontSize(context, 12),
  //                     color: Colors.black,
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                   textAlign: TextAlign.start,
  //                 ),
  //               ),
  //             ),

  //             // const SizedBox(
  //             //   height: 30,
  //             // ),
  //             // if (!_isAuthor)
  //             //   _button(
  //             //       _isFollowing
  //             //           ? 'unFollow'
  //             //           : _isFollowerResquested
  //             //               ? 'Pending follow request'
  //             //               : 'Follow',
  //             //       _isFollowerResquested
  //             //           ? () {
  //             //               _requestFollowOrUnfollow(user);
  //             //             }
  //             //           : () {
  //             //               _followOrUnfollow(user);
  //             //             },
  //             //       'All'),
  //             // const SizedBox(
  //             //   height: 5,
  //             // ),
  //             // // user.isShop!
  //             // //     ? _isFollowing
  //             // //         ? _chatButton(user)
  //             // //         : SizedBox.shrink()
  //             // // :
  //             // _chatButton(user),
  //             // const SizedBox(
  //             //   height: 30,
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // _buildInvite() {
  //   return CustomScrollView(
  //     slivers: [
  //       SliverList(
  //         delegate: SliverChildBuilderDelegate(
  //           (context, index) {
  //             InviteModel invite = _inviteList[index];
  //             return InviteContainerWidget(
  //               invite: invite,
  //             );
  //           },
  //           childCount: _inviteList.length,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // _loaindSchimmer() {
  //   return Container(
  //       height: ResponsiveHelper.responsiveHeight(
  //         context,
  //         450,
  //       ),
  //       child: EventAndUserScimmerSkeleton(
  //         from: 'Posts',
  //       )
  //       // ListView(
  //       //     physics: const NeverScrollableScrollPhysics(),
  //       //     children: List.generate(
  //       //         10,
  //       //         (index) => EventAndUserScimmerSkeleton(
  //       //               from: 'Event',
  //       //             )))

  //       );
  // }

  // void _showBottomSheetTermsAndConditions(UserStoreModel user) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return Container(
  //           height: MediaQuery.of(context).size.height.toDouble() / 1.2,
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).cardColor,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Padding(
  //             padding: const EdgeInsets.all(20.0),
  //             child: ListView(
  //               children: [
  //                 TicketPurchasingIcon(
  //                   title: '',
  //                 ),
  //                 const SizedBox(height: 20),
  //                 RichText(
  //                   textScaler: MediaQuery.of(context).textScaler,
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                         text: 'Overview',
  //                         style: Theme.of(context).textTheme.titleMedium,
  //                       ),
  //                       TextSpan(
  //                         text:
  //                             "\n\n${user.overview.trim().replaceAll('\n', ' ')}",
  //                         style: Theme.of(context).textTheme.bodyMedium,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //     },
  //   );
  // }

  // Widget _buildEventGrid() {
  //   return GridView.builder(
  //     padding: const EdgeInsets.all(8.0),
  //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 3, // Number of columns
  //       crossAxisSpacing: 8.0,
  //       mainAxisSpacing: 8.0,
  //       childAspectRatio: 1, // Adjust based on the aspect ratio of your items
  //     ),
  //     itemCount: _postsList.length,
  //     itemBuilder: (context, index) {
  //       Post post = _postsList[index];
  //       return EventDisplayWidget(
  //         currentUserId: widget.currentUserId,
  //         postList: _postsList,
  //         post: post,
  //         pageIndex: 0,
  //         eventSnapshot: [],
  //         eventPagesOnly: true,
  //         liveCity: '',
  //         liveCountry: '',
  //         isFrom: '',
  //         // sortNumberOfDays: 0,
  //       );
  //     },
  //   );
  // }

  // Widget _eventDisplay(bool _isAuthor, String userName) {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: StreamBuilder<QuerySnapshot>(
  //           stream: postsRef
  //               .doc(widget.userId)
  //               .collection('userPosts')
  //               .orderBy('timestamp', descending: true)
  //               .limit(10)
  //               .snapshots(),
  //           builder: (context, snapshot) {
  //             if (!snapshot.hasData) {
  //               return _loaindSchimmer();
  //             }

  //             if (snapshot.data!.docs.isEmpty) {
  //               return Center(
  //                 child: NoContents(
  //                   icon: null,
  //                   title: 'No images',
  //                   subTitle: _isAuthor
  //                       ? 'The images of your cleint\'s work you upload would appear here.'
  //                       : '$userName hasn\'t uploaded any client images',
  //                 ),
  //               );
  //             }

  //             List<Post> posts =
  //                 snapshot.data!.docs.map((doc) => Post.fromDoc(doc)).toList();

  //             if (!const DeepCollectionEquality().equals(_postsList, posts)) {
  //               _postsList = posts;
  //               _lastPostDocument.clear();
  //               _lastPostDocument.addAll(snapshot.data!.docs);
  //             }

  //             return _buildEventGrid();
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // _buildReview(BuildContext context, ReviewModel review, bool fullWidth) {
  //   // var _currentUserId =
  //   //     Provider.of<UserData>(context, listen: false).currentUserId;

  //   return ReviewWidget(
  //     review: review,
  //     fullWidth: fullWidth,
  //   );
  // }

  // _buildDisplayReviewList(BuildContext context) {
  //   List<Widget> forumViews = [];
  //   _reviewList.forEach((portfolio) {
  //     forumViews.add(_buildReview(context, portfolio, true));
  //   });
  //   return Column(children: forumViews);
  // }

  // void _showBottomSheetMore(String from) {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   // final double height = MediaQuery.of(context).size.height;
  //   final bool _isAuthor = widget.currentUserId == _profileUser!.userId;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: ResponsiveHelper.responsiveHeight(context, 650),
  //         decoration: BoxDecoration(
  //           color: Theme.of(context).primaryColorLight,
  //           borderRadius: BorderRadius.circular(30),
  //         ),
  //         child: ListView(
  //           children: [
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             TicketPurchasingIcon(
  //               title: from,
  //             ),
  //             from.startsWith('contacts')
  //                 ? PortfolioContactWidget(
  //                     portfolios: _provider.bookingContacts,
  //                     edit: _isAuthor,
  //                   )
  //                 // : from.startsWith('company')
  //                 //     ? PortfolioCompanyWidget(
  //                 //         portfolios: _provider.company,
  //                 //         seeMore: true,
  //                 //         edit: false,
  //                 //       )
  //                 : from.startsWith('services')
  //                     ? PortfolioWidget(
  //                         portfolios: _provider.services,
  //                         seeMore: true,
  //                         edit: false,
  //                       )
  //                     // : from.startsWith('performance')
  //                     //     ? PortfolioWidget(
  //                     //         portfolios: _provider.performances,
  //                     //         seeMore: true,
  //                     //         edit: false,
  //                     //       )
  //                     : from.startsWith('awards')
  //                         ? PortfolioWidget(
  //                             portfolios: _provider.awards,
  //                             seeMore: true,
  //                             edit: false,
  //                           )
  //                         : from.startsWith('work')
  //                             ? PortfolioWidgetWorkLink(
  //                                 portfolios: _provider.linksToWork,
  //                                 seeMore: true,
  //                                 edit: false,
  //                               )
  //                             : from.startsWith('price')
  //                                 ? Padding(
  //                                     padding: const EdgeInsets.only(top: 30.0),
  //                                     child: PriceRateWidget(
  //                                       edit: false,
  //                                       prices: _provider.priceRate,
  //                                       seeMore: true,
  //                                     ),
  //                                   )
  //                                 // : from.startsWith('collaborations')
  //                                 //     ? Padding(
  //                                 //         padding:
  //                                 //             const EdgeInsets.only(top: 30.0),
  //                                 //         child: PortfolioCollaborationWidget(
  //                                 //           edit: false,
  //                                 //           seeMore: true,
  //                                 //           collaborations:
  //                                 //               _provider.collaborations,
  //                                 //         ),
  //                                 //       )
  //                                 : from.startsWith('review')
  //                                     ? Padding(
  //                                         padding:
  //                                             const EdgeInsets.only(top: 30.0),
  //                                         child:
  //                                             _buildDisplayReviewList(context),
  //                                       )
  //                                     : PortfolioWidget(
  //                                         portfolios: [],
  //                                         seeMore: true,
  //                                         edit: false,
  //                                       ),
  //             const SizedBox(
  //               height: 40,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // _inviteDisplay(bool _isAuthor, UserStoreModel user) {
  //   var _provider = Provider.of<UserData>(
  //     context,
  //   );
  //   bool _isCurrentUser = _profileStore == null
  //       ? false
  //       : widget.currentUserId == _profileStore!.userId;

  //   return Material(
  //     color:

  //         //  widget.userId == widget.currentUserId
  //         //     ? Theme.of(context).primaryColor
  //         //     :

  //         Theme.of(context).primaryColorLight,
  //     child: MediaQuery.removePadding(
  //       context: context,
  //       removeTop: true,
  //       child: ListView(
  //         children: [
  //           const SizedBox(
  //             height: 10,
  //           ),
  //           _button('Book', () {
  //             _showBottomSheetBookingCalendar(false);
  //           }, 'Right'),

  //           const SizedBox(
  //             height: 10,
  //           ),
  //           _callButton(),

  //           _divider('Services', 'services',
  //               user.services.length >= 4 ? true : false),
  //           PortfolioWidget(
  //             portfolios: user.services,
  //             seeMore: false,
  //             edit: false,
  //           ),

  //           Container(
  //             height: ResponsiveHelper.responsiveFontSize(context, 500),
  //             width: double.infinity,
  //             child: PageView(
  //               controller: _pageController2,
  //               physics: AlwaysScrollableScrollPhysics(),
  //               children: user.professionalImageUrls
  //                   .asMap()
  //                   .entries
  //                   .map<Widget>((entry) {
  //                 var image = entry.value;
  //                 return _professionalImageContainer(image, 'Max');
  //               }).toList(),
  //             ),
  //           ),
  //           _divider('Opening hours', 'opening', false),
  //           OpeninHoursWidget(
  //             openingHours: user.openingHours,
  //             // openingHours: {
  //             //   "Monday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Tuesday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Wednesday":
  //             //       DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Thursday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Friday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Saturday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             //   "Sunday": DateTimeRange(start: DateTime(0), end: DateTime(0)),
  //             // },
  //           ),
  //           _divider('Ratings', 'ratings', false),
  //           Container(
  //             color: Theme.of(context).primaryColorLight,
  //             height: ResponsiveHelper.responsiveHeight(context, 150),
  //             width: double.infinity,
  //             child: Center(
  //               child: SingleChildScrollView(
  //                 physics: const NeverScrollableScrollPhysics(),
  //                 child: RatingAggregateWidget(
  //                   isCurrentUser: _isCurrentUser,
  //                   starCounts: _userRatings == null
  //                       ? {
  //                           5: 0,
  //                           4: 0,
  //                           3: 0,
  //                           2: 0,
  //                           1: 0,
  //                         }
  //                       : {
  //                           5: _userRatings!.fiveStar,
  //                           4: _userRatings!.fourStar,
  //                           3: _userRatings!.threeStar,
  //                           2: _userRatings!.twoStar,
  //                           1: _userRatings!.oneStar,
  //                         },
  //                 ),
  //               ),
  //             ),
  //           ),
  //           _divider('Reviews', 'review', false),
  //           if (!_isFecthingRatings) _buildDisplayReviewGrid(context),

  //           _divider('Price list and service', 'price', false),
  //           if (_provider.appointmentSlots.isNotEmpty && !_isCurrentUser)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   '',
  //                   // "${_provider.currency} ${_provider.bookingPriceRate!.price.toString()}",
  //                   style: Theme.of(context).textTheme.titleLarge,
  //                 ),
  //                 Align(
  //                   alignment: Alignment.bottomRight,
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(bottom: 30.0, right: 10),
  //                     child: MiniCircularProgressButton(
  //                         color: Colors.blue,
  //                         text: 'Book',
  //                         onPressed: () {
  //                           _showBottomSheetBookingCalendar(true);
  //                         }),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           Container(
  //             color: Theme.of(context).cardColor,
  //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //             child: TicketGroup(
  //               fromProfile: true,
  //               fromPrice: false,
  //               appointmentSlots: user.appointmentSlots,
  //               edit: false,
  //               openingHours: user.openingHours,
  //               bookingShop: _profileStore,
  //             ),
  //           ),
  //           // PriceRateWidget(
  //           //   edit: false,
  //           //   prices: _provider.userStore!.priceTags,
  //           //   seeMore: true,
  //           //   // currency: _provider,
  //           // ),

  //           // _divider('Performance', 'performance',
  //           //     _provider.performances.length >= 4 ? true : false),
  //           // PortfolioWidget(
  //           //   portfolios: _provider.performances,
  //           //   seeMore: false,
  //           //   edit: false,
  //           // ),
  //           _divider(
  //               'Awards', 'awards', user.awards.length >= 4 ? true : false),
  //           PortfolioWidget(
  //             portfolios: user.awards,
  //             seeMore: false,
  //             edit: false,
  //           ),

  //           _divider('Website and Social media', 'website and Social media',
  //               user.links.length >= 4 ? true : false),
  //           PortfolioWidget(
  //             portfolios: user.links,
  //             seeMore: false,
  //             edit: false,
  //           ),

  //           const SizedBox(
  //             height: 100,
  //           ),
  //           GestureDetector(
  //             onTap: () {
  //               _navigateToPage(
  //                   context,
  //                   UserBarcode(
  //                     profileImageUrl: user.shopLogomageUrl,
  //                     userDynamicLink: user.dynamicLink,
  //                     bio: user.overview,
  //                     userName: user.shopName,
  //                     userId: user.userId,
  //                   ));
  //             },
  //             child: Hero(
  //                 tag: user.userId,
  //                 child: Icon(
  //                   Icons.qr_code,
  //                   color: Colors.blue,
  //                   size: ResponsiveHelper.responsiveHeight(context, 30),
  //                 )),
  //           ),
  //           const SizedBox(
  //             height: 30,
  //           ),
  //           Center(
  //             child: GestureDetector(
  //               onTap: () {},
  //               child: Text(
  //                 'Share link.',
  //                 style: TextStyle(
  //                   color: Colors.blue,
  //                   fontSize:
  //                       ResponsiveHelper.responsiveFontSize(context, 12.0),
  //                 ),
  //                 textAlign: TextAlign.start,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(
  //             height: 50,
  //           ),
  //           // Expanded(
  //           //   child: _isLoadingEvents
  //           //       ? _loaindSchimmer()
  //           //       : _inviteList.isEmpty
  //           //           ? Center(
  //           //               child: NoContents(
  //           //                 icon: null,
  //           //                 title: 'No invites',
  //           //                 subTitle: _isAuthor
  //           //                     ? 'Your event invitations would appear here.'
  //           //                     : '$userName hasn\'t received any event invites yet',
  //           //               ),
  //           //             )
  //           //           : _buildInvite(),
  //           // ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // _tabIcon(IconData icon, bool isSelected) {
  //   final width = MediaQuery.of(context).size.width;
  //   return Container(
  //     width: width / 2,
  //     height: ResponsiveHelper.responsiveHeight(context, 40.0),
  //     child: Center(
  //         child: Icon(
  //       icon,
  //       size: ResponsiveHelper.responsiveHeight(context, 25.0),
  //       color:
  //           isSelected ? Theme.of(context).secondaryHeaderColor : Colors.grey,
  //     )),
  //   );
  // }

  Future<void> refreshData() async {
    // _setUp();
  }

  // _shopScaffold(UserStoreModel user) {
  //   bool _isAuthor = user.userId == widget.currentUserId;
  //   return
  // }

  _cleintScaffold(AccountHolderAuthor profileClient) {
    // bool _isAuthor = profileClient.userId == widget.currentUserId;
    return SizedBox.shrink();
    //  NotificationListener<ScrollNotification>(
    //   onNotification: _handleScrollNotification,
    //   child: NestedScrollView(
    //     controller: _hideButtonController,
    //     headerSliverBuilder: (context, innerBoxIsScrolled) {
    //       return [
    //         SliverAppBar(
    //           pinned: true,
    //           backgroundColor: Theme.of(context).primaryColorLight,
    //           leading: IconButton(
    //             icon: Icon(
    //               size: ResponsiveHelper.responsiveHeight(context, 20.0),
    //               _isAuthor
    //                   ? Icons.add
    //                   : Platform.isIOS
    //                       ? Icons.arrow_back_ios
    //                       : Icons.arrow_back,
    //               color: Theme.of(context).secondaryHeaderColor,
    //             ),
    //             onPressed: () {
    //               // HapticFeedback.mediumImpact();
    //               _isAuthor
    //                   ? _navigateToPage(
    //                       context,
    //                       SetUpBrand(
    //                           // isEditting: false,
    //                           // post: null,
    //                           // isCompleted: false,
    //                           // isDraft: false,
    //                           )
    //                       // CreateEventScreen(
    //                       //   isEditting: false,
    //                       //   post: null,
    //                       //   // isCompleted: false,
    //                       //   // isDraft: false,
    //                       // ),

    //                       )
    //                   : Navigator.pop(context);
    //             },
    //           ),
    //           actions: [
    //             IconButton(
    //               icon: Icon(
    //                 size: ResponsiveHelper.responsiveHeight(context, 25.0),
    //                 Icons.supervisor_account_rounded,
    //                 color: Colors.grey,
    //               ),
    //               onPressed: () {
    //                 // _showBottomSheet(context, user);
    //               },
    //             ),
    //             IconButton(
    //               icon: Icon(
    //                 size: ResponsiveHelper.responsiveHeight(context, 25.0),
    //                 Icons.more_vert_rounded,
    //                 color: Theme.of(context).secondaryHeaderColor,
    //               ),
    //               onPressed: () {
    //                 // _showBottomSheet(context, user);
    //               },
    //             ),
    //           ],
    //           expandedHeight: ResponsiveHelper.responsiveHeight(
    //             context,
    //             350,
    //           ),
    //           flexibleSpace: Container(
    //             width: double.infinity,
    //             decoration: BoxDecoration(
    //               color: Colors.transparent,
    //             ),
    //             child: FlexibleSpaceBar(
    //               background: SafeArea(
    //                 child: ListTile(
    //                   leading: _profileImageWidget(
    //                       profileClient.profileImageUrl!,
    //                       profileClient.userId!),
    //                 ),

    //                 //       _profileImageHeaderWidget(
    //                 //           isClient: false,
    //                 //           isAuthor: _isAuthor,
    //                 //           imageUrl: user.shopLogomageUrl,
    //                 //           userId: user.userId,
    //                 //           verified: user.verified,
    //                 //           name: user.shopName,
    //                 //           shopOrAccountType: user.shopType,
    //                 //           user: null),

    //                 //       // _followContainer(user),
    //               ),
    //             ),
    //           ),
    //           bottom: PreferredSize(
    //             preferredSize: Size.fromHeight(kToolbarHeight),
    //             child:

    //                 //  user.isShop! && !_isAuthor && !_isFollowing
    //                 //     ? SizedBox.shrink()
    //                 //     :

    //                 Container(
    //               color: Theme.of(context).primaryColorLight,
    //               child: Listener(
    //                 onPointerMove: (event) {
    //                   final offset = event.delta.dx;
    //                   final index = _tabController.index;
    //                   //Check if we are in the first or last page of TabView and the notifier is false
    //                   if (((offset > 0 && index == 0) ||
    //                           (offset < 0 && index == 2 - 1)) &&
    //                       !_physycsNotifier.value) {
    //                     _physycsNotifier.value = true;
    //                   }
    //                 },
    //                 onPointerUp: (_) => _physycsNotifier.value = false,
    //                 child: ValueListenableBuilder<bool>(
    //                     valueListenable: _physycsNotifier,
    //                     builder: (_, value, __) {
    //                       return TabBar(
    //                         controller: _tabController,
    //                         labelColor: Theme.of(context).secondaryHeaderColor,
    //                         indicatorSize: TabBarIndicatorSize.label,
    //                         indicatorColor: Colors.blue,
    //                         unselectedLabelColor: Colors.grey,
    //                         dividerColor: Colors.grey.withOpacity(.5),
    //                         dividerHeight: .1,

    //                         isScrollable: false,
    //                         // tabAlignment: TabAlignment.start,
    //                         indicatorWeight: 2.0,
    //                         tabs: <Widget>[
    //                           _tabIcon(
    //                               Icons.store_outlined, selectedTabIndex == 0),
    //                           _tabIcon(
    //                               Icons.image_outlined, selectedTabIndex == 1),
    //                         ],
    //                       );
    //                     }),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ];
    //     },
    //     body: Material(
    //       color: Theme.of(context).primaryColorLight,
    //       child: TabBarView(
    //         controller: _tabController,
    //         children: <Widget>[
    //           _inviteDisplay(_isAuthor, user),
    //           _eventDisplay(_isAuthor, user.shopName),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  _workerScaffold(AccountHolderAuthor profileClient) {
    bool _isAuthor = profileClient.userId == widget.currentUserId;
    return SizedBox.shrink();

    // NotificationListener<ScrollNotification>(
    //   onNotification: _handleScrollNotification,
    //   child: NestedScrollView(
    //     controller: _hideButtonController,
    //     headerSliverBuilder: (context, innerBoxIsScrolled) {
    //       return [
    //         // SliverAppBar(
    //         //   pinned: true,
    //         //   backgroundColor: Theme.of(context).primaryColorLight,
    //         //   leading: IconButton(
    //         //     icon: Icon(
    //         //       size: ResponsiveHelper.responsiveHeight(context, 20.0),
    //         //       _isAuthor
    //         //           ? Icons.add
    //         //           : Platform.isIOS
    //         //               ? Icons.arrow_back_ios
    //         //               : Icons.arrow_back,
    //         //       color: Theme.of(context).secondaryHeaderColor,
    //         //     ),
    //         //     onPressed: () {
    //         //       // HapticFeedback.mediumImpact();
    //         //       _isAuthor
    //         //           ? _navigateToPage(
    //         //               context,
    //         //               SetUpBrand(
    //         //                   // isEditting: false,
    //         //                   // post: null,
    //         //                   // isCompleted: false,
    //         //                   // isDraft: false,
    //         //                   )
    //         //               // CreateEventScreen(
    //         //               //   isEditting: false,
    //         //               //   post: null,
    //         //               //   // isCompleted: false,
    //         //               //   // isDraft: false,
    //         //               // ),

    //         //               )
    //         //           : Navigator.pop(context);
    //         //     },
    //         //   ),
    //         //   actions: [
    //         //     IconButton(
    //         //       icon: Icon(
    //         //         size: ResponsiveHelper.responsiveHeight(context, 25.0),
    //         //         Icons.supervisor_account_rounded,
    //         //         color: Colors.grey,
    //         //       ),
    //         //       onPressed: () {
    //         //         // _showBottomSheet(context, user);
    //         //       },
    //         //     ),
    //         //     IconButton(
    //         //       icon: Icon(
    //         //         size: ResponsiveHelper.responsiveHeight(context, 25.0),
    //         //         Icons.more_vert_rounded,
    //         //         color: Theme.of(context).secondaryHeaderColor,
    //         //       ),
    //         //       onPressed: () {
    //         //         // _showBottomSheet(context, user);
    //         //       },
    //         //     ),
    //         //   ],
    //         //   expandedHeight: ResponsiveHelper.responsiveHeight(
    //         //     context,
    //         //     350,
    //         //   ),
    //         //   flexibleSpace: Container(
    //         //     width: double.infinity,
    //         //     decoration: BoxDecoration(
    //         //       color: Colors.transparent,
    //         //     ),
    //         //     child: FlexibleSpaceBar(
    //         //       background: SafeArea(
    //         //         child: ListTile(
    //         //           leading: _profileImageWidget(
    //         //               profileClient.profileImageUrl!,
    //         //               profileClient.userId!),
    //         //         ),

    //         //         //       _profileImageHeaderWidget(
    //         //         //           isClient: false,
    //         //         //           isAuthor: _isAuthor,
    //         //         //           imageUrl: user.shopLogomageUrl,
    //         //         //           userId: user.userId,
    //         //         //           verified: user.verified,
    //         //         //           name: user.shopName,
    //         //         //           shopOrAccountType: user.shopType,
    //         //         //           user: null),

    //         //         //       // _followContainer(user),
    //         //       ),
    //         //     ),
    //         //   ),
    //         //   bottom: PreferredSize(
    //         //     preferredSize: Size.fromHeight(kToolbarHeight),
    //         //     child:

    //         //         //  user.isShop! && !_isAuthor && !_isFollowing
    //         //         //     ? SizedBox.shrink()
    //         //         //     :

    //         //         Container(
    //         //       color: Theme.of(context).primaryColorLight,
    //         //       child: Listener(
    //         //         onPointerMove: (event) {
    //         //           final offset = event.delta.dx;
    //         //           final index = _tabController.index;
    //         //           //Check if we are in the first or last page of TabView and the notifier is false
    //         //           if (((offset > 0 && index == 0) ||
    //         //                   (offset < 0 && index == 2 - 1)) &&
    //         //               !_physycsNotifier.value) {
    //         //             _physycsNotifier.value = true;
    //         //           }
    //         //         },
    //         //         onPointerUp: (_) => _physycsNotifier.value = false,
    //         //         child: ValueListenableBuilder<bool>(
    //         //             valueListenable: _physycsNotifier,
    //         //             builder: (_, value, __) {
    //         //               return TabBar(
    //         //                 controller: _tabController,
    //         //                 labelColor: Theme.of(context).secondaryHeaderColor,
    //         //                 indicatorSize: TabBarIndicatorSize.label,
    //         //                 indicatorColor: Colors.blue,
    //         //                 unselectedLabelColor: Colors.grey,
    //         //                 dividerColor: Colors.grey.withOpacity(.5),
    //         //                 dividerHeight: .1,

    //         //                 isScrollable: false,
    //         //                 // tabAlignment: TabAlignment.start,
    //         //                 indicatorWeight: 2.0,
    //         //                 tabs: <Widget>[
    //         //                   _tabIcon(
    //         //                       Icons.store_outlined, selectedTabIndex == 0),
    //         //                   _tabIcon(
    //         //                       Icons.image_outlined, selectedTabIndex == 1),
    //         //                 ],
    //         //               );
    //         //             }),
    //         //       ),
    //         //     ),
    //         //   ),
    //         // ),
    //       ];
    //     },
    //     body:
    //         //  user.isShop! && !_isAuthor && !_isFollowing
    //         //     ?

    //         //      Container(
    //         //         color: Theme.of(context).primaryColorLight,
    //         //         child: Padding(
    //         //           padding: const EdgeInsets.only(top: 80.0),
    //         //           child: NoContents(
    //         //               title: 'Private account',
    //         //               subTitle:
    //         //                   'This account is private. Follow to see the content.',
    //         //               icon: Icons.lock_outline_rounded),
    //         //         ),
    //         //       )
    //         //     :

    //         Material(
    //       color: Theme.of(context).primaryColorLight,
    //       child: TabBarView(
    //         controller: _tabController,
    //         children: <Widget>[
    //           _inviteDisplay(_isAuthor, user),
    //           _eventDisplay(_isAuthor, user.shopName),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  // final _physycsNotifier = ValueNotifier<bool>(false);
  // _scaffold(BuildContext context, UserStoreModel user) {
  //   return NotificationListener<ScrollNotification>(
  //       onNotification: _handleScrollNotification, child: _cleintScaffold(user)
  //       // _shopScaffold(user)

  //       );
  // }

  void _showBottomSheetUnfollow(
      BuildContext context, UserStoreModel user, String from) {
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
                      : from.startsWith('cancelFollowRequest')
                          ? 'Cancel Request'
                          : '',
          onPressed: () {
            Navigator.pop(context);
            from.startsWith('unfollow')
                ? _unfollowUser(user)
                : from.startsWith('block')
                    ? _blockser(user)
                    : from.startsWith('unBlock')
                        ? _unBlockser(user)
                        : from.startsWith('cancelFollowRequest')
                            ? _cancelFollowRequest(user)
                            : _nothing();
          },
          title: from.startsWith('unfollow')
              ? 'Are you sure you want to unfollow ${user.shopName}?'
              : from.startsWith('block')
                  ? 'Are you sure you want to block ${user.shopName}?'
                  : from.startsWith('unBlock')
                      ? 'Are you sure you want to unblock ${user.shopName}?'
                      : from.startsWith('cancelFollowRequest')
                          ? 'Are you sure you want to cancel your follow request to ${user.shopName}?'
                          : '',
          subTitle: '',
        );
      },
    );
  }

  void navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // _sortByWidget(
  //   VoidCallback onPressed,
  //   IconData icon,
  //   String title,
  //   Color? color,
  //   notFullLength,
  // ) {
  //   return NewModalActionButton(
  //     onPressed: onPressed,
  //     icon: icon,
  //     color: color,
  //     title: title,
  //     fromModalSheet: notFullLength,
  //   );
  // }

  // void _showBottomSheetBookMe(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: ResponsiveHelper.responsiveHeight(context, 700),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).cardColor,
  //             borderRadius: BorderRadius.circular(30)),
  //         child: UserBookingOption(
  //           bookingUser: _profileUser!,
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showBottomSheetContact(BuildContext context, UserStoreModel user) {
  //   // bool _isAuthor = user.userId == widget.currentUserId;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: ResponsiveHelper.responsiveHeight(context, 250),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColorLight,
  //             borderRadius: BorderRadius.circular(30)),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
  //           child: MyBottomModelSheetAction(
  //             actions: [
  //               Icon(
  //                 size: ResponsiveHelper.responsiveHeight(context, 25),
  //                 Icons.horizontal_rule,
  //                 color: Theme.of(context).secondaryHeaderColor,
  //               ),
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               _sortByWidget(
  //                 () {
  //                   _showBottomSheetBookMe(context);
  //                 },
  //                 Icons.call_outlined,
  //                 'Call',
  //                 null,
  //                 true,
  //               ),
  //               _sortByWidget(
  //                 () async {
  //                   if (_isLoadingChat) return;

  //                   _isLoadingChat = true;
  //                   try {
  //                     Chat? _chat = await DatabaseService.getUserChatWithId(
  //                       widget.currentUserId,
  //                       widget.userId,
  //                     );

  //                     _bottomModalSheetMessage(
  //                       context,
  //                       user,
  //                       _chat,
  //                     );
  //                   } catch (e) {
  //                   } finally {
  //                     _isLoadingChat = false;
  //                   }
  //                 },
  //                 Icons.message,
  //                 'Message',
  //                 null,
  //                 true,
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showBottomSheet(BuildContext context, UserStoreModel user) {
  //   bool _isAuthor = user.userId == widget.currentUserId;
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         height: ResponsiveHelper.responsiveHeight(context, 500),
  //         decoration: BoxDecoration(
  //             color: Theme.of(context).primaryColorLight,
  //             borderRadius: BorderRadius.circular(30)),
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
  //           child: MyBottomModelSheetAction(
  //             actions: [
  //               Icon(
  //                 size: ResponsiveHelper.responsiveHeight(context, 25),
  //                 Icons.horizontal_rule,
  //                 color: Theme.of(context).secondaryHeaderColor,
  //               ),
  //               const SizedBox(
  //                 height: 30,
  //               ),
  //               ListTile(
  //                 trailing: _isAuthor
  //                     ? GestureDetector(
  //                         onTap: () {
  //                           Navigator.pop(context);
  //                           // _editProfile(user);
  //                         },
  //                         child: Icon(
  //                           Icons.edit_outlined,
  //                           color: Colors.blue,
  //                           size: ResponsiveHelper.responsiveHeight(
  //                               context, 30.0),
  //                         ),
  //                       )
  //                     : null,
  //                 leading: user.shopLogomageUrl.isEmpty
  //                     ? Icon(
  //                         Icons.account_circle_outlined,
  //                         size: 60,
  //                         color: Colors.grey,
  //                       )
  //                     : Container(
  //                         height: 40,
  //                         width: 40,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Theme.of(context).primaryColor,
  //                           image: DecorationImage(
  //                             image: CachedNetworkImageProvider(
  //                                 user.shopLogomageUrl, errorListener: (_) {
  //                               return;
  //                             }),
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                 title: RichText(
  //                   textScaler: MediaQuery.of(context).textScaler,
  //                   text: TextSpan(
  //                     children: [
  //                       TextSpan(
  //                           text: user.shopName.toUpperCase(),
  //                           style: Theme.of(context).textTheme.bodyMedium),
  //                       TextSpan(
  //                         text: "\n${user.shopType}",
  //                         style: TextStyle(
  //                             color: Colors.blue,
  //                             fontSize: ResponsiveHelper.responsiveFontSize(
  //                                 context, 12)),
  //                       )
  //                     ],
  //                   ),
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               const SizedBox(
  //                 height: 20,
  //               ),
  //               _sortByWidget(
  //                 () {
  //                   _isAuthor
  //                       ? _navigateToPage(
  //                           context,
  //                           CreateEventScreen(
  //                             isEditting: false,
  //                             post: null,
  //                             // isCompleted: false,
  //                             // isDraft: false,
  //                           ))
  //                       : navigateToPage(
  //                           context,
  //                           SendToChats(
  //                             sendContentId: widget.userId,
  //                             currentUserId:
  //                                 Provider.of<UserData>(context, listen: false)
  //                                     .currentUserId!,
  //                             sendContentType: 'User',
  //                             sendImageUrl: user.shopLogomageUrl,
  //                             sendTitle: user.shopName,
  //                           ));
  //                 },
  //                 _isAuthor ? Icons.add : Icons.send_outlined,
  //                 _isAuthor ? 'Create' : 'Send',
  //                 null,
  //                 true,
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),

  //               _sortByWidget(
  //                 _isAuthor
  //                     ? () async {
  //                         Share.share(user.dynamicLink!);
  //                       }
  //                     : () {
  //                         _blockOrUnBlock(user);
  //                       },
  //                 _isAuthor ? Icons.mail_outline_rounded : Icons.block_outlined,
  //                 _isAuthor ? 'Invite a friend' : 'Block',
  //                 null,
  //                 true,
  //               ),
  //               // BottomModelSheetListTileActionWidget(
  //               //     colorCode: '',
  //               //     icon: _isAuthor
  //               //         ? Icons.mail_outline_rounded
  //               //         : Icons.block_outlined,
  //               //     onPressed: _isAuthor
  //               //         ? () async {
  //               //             Share.share(user.dynamicLink!);
  //               //           }
  //               //         : () {
  //               //             _blockOrUnBlock(user);
  //               //           },
  //               // //     text: _isAuthor ? 'Invite a friend' : 'Block'),
  //               // _sortByWidget(
  //               //   () {
  //               //     navigateToPage(
  //               //         context,
  //               //         UserBarcode(
  //               //           userDynamicLink: user.dynamicLink!,
  //               //           bio: user.bio!,
  //               //           userName: user.userName!,
  //               //           userId: user.userId!,
  //               //           profileImageUrl: user.profileImageUrl!,
  //               //         ));
  //               //   },
  //               //   Icons.qr_code,
  //               //   'Bar code',
  //               //   null,
  //               //   true,
  //               // ),
  //               // // BottomModelSheetListTileActionWidget(
  //               //   colorCode: '',
  //               //   icon: Icons.qr_code,
  //               //   onPressed: () {
  //               //     navigateToPage(
  //               //         context,
  //               //         UserBarcode(
  //               //           userDynamicLink: user.dynamicLink!,
  //               //           bio: user.bio!,
  //               //           userName: user.userName!,
  //               //           userId: user.userId!,
  //               //           profileImageUrl: user.profileImageUrl!,
  //               //         ));
  //               //   },
  //               //   text: 'Bar code',
  //               // ),

  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   _sortByWidget(
  //                     () {
  //                       navigateToPage(
  //                           context,
  //                           UserBarcode(
  //                             userDynamicLink: user.dynamicLink,
  //                             bio: user.overview,
  //                             userName: user.shopName,
  //                             userId: user.userId,
  //                             profileImageUrl: user.shopLogomageUrl,
  //                           ));
  //                     },
  //                     Icons.qr_code,
  //                     'Barcode',
  //                     null,
  //                     false,
  //                   ),
  //                   _sortByWidget(
  //                     () async {
  //                       Share.share(user.dynamicLink!);
  //                     },
  //                     Icons.share_outlined,
  //                     'Share',
  //                     null,
  //                     false,
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                 children: [
  //                   _sortByWidget(
  //                     () {
  //                       Navigator.push(context,
  //                           MaterialPageRoute(builder: (_) => SuggestionBox()));
  //                     },
  //                     Icons.feedback_outlined,
  //                     'Suggestion',
  //                     null,
  //                     false,
  //                   ),
  //                   _sortByWidget(
  //                     _isAuthor
  //                         ? () async {
  //                             // navigateToPage(
  //                             //   context,
  //                             //   ProfileSettings(
  //                             //     user: user,
  //                             //   ),
  //                             // );
  //                           }
  //                         : () {
  //                             navigateToPage(
  //                                 context,
  //                                 ReportContentPage(
  //                                   contentId: user.userId,
  //                                   contentType: user.shopName,
  //                                   parentContentId: user.userId,
  //                                   repotedAuthorId: user.userId,
  //                                 ));
  //                           },
  //                     _isAuthor ? Icons.settings_outlined : Icons.flag_outlined,
  //                     _isAuthor ? 'Settings' : 'Report',
  //                     _isAuthor ? null : Colors.red,
  //                     false,
  //                   ),
  //                 ],
  //               ),
  //               // const SizedBox(
  //               //   height: 10,
  //               // ),
  //               // BottomModelSheetListTileActionWidget(
  //               //     colorCode: '',
  //               //     icon: _isAuthor
  //               //         ? Icons.settings_outlined
  //               //         : Icons.flag_outlined,
  //               //     onPressed: _isAuthor
  //               //         ? () async {
  //               //             navigateToPage(
  //               //               context,
  //               //               ProfileSettings(
  //               //                 user: user,
  //               //               ),
  //               //             );
  //               //           }
  //               //         : () {
  //               //             navigateToPage(
  //               //                 context,
  //               //                 ReportContentPage(
  //               //                   contentId: user.userId!,
  //               //                   contentType: user.userName!,
  //               //                   parentContentId: user.userId!,
  //               //                   repotedAuthorId: user.userId!,
  //               //                 ));
  //               //           },
  //               //     text: _isAuthor ? 'Settings' : 'Report'),

  //               Padding(
  //                 padding:
  //                     const EdgeInsets.only(left: 30.0, right: 30, top: 20),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     navigateToPage(
  //                         context,
  //                         CompainAnIssue(
  //                           parentContentId: user.userId!,
  //                           authorId: user.userId!,
  //                           complainContentId: user.userId!,
  //                           complainType: 'Account',
  //                           parentContentAuthorId: user.userId!,
  //                         ));
  //                   },
  //                   child: Text(
  //                     'Complain an issue.',
  //                     style: TextStyle(
  //                       color: Colors.blue,
  //                       fontSize:
  //                           ResponsiveHelper.responsiveFontSize(context, 12.0),
  //                     ),
  //                     textAlign: TextAlign.start,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _showBottomSheetEditProfile() {
  //   var _provider = Provider.of<UserData>(context, listen: false);

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return GestureDetector(
  //         onTap: () {
  //           FocusScope.of(context).unfocus();
  //         },
  //         child: Container(
  //             height: ResponsiveHelper.responsiveHeight(
  //                 context, _provider.user!.accountType == 'Sop' ? 400 : 600),
  //             padding: const EdgeInsets.all(20),
  //             decoration: BoxDecoration(
  //                 color: Theme.of(context).primaryColorLight,
  //                 borderRadius: BorderRadius.circular(30)),
  //             child: EditProfileScreen(
  //               user: _provider.user!,
  //               userStore: _profileUser!,
  //             )),
  //       );
  //     },
  //   );
  // }

  // _displayScaffold() {
  //   UserStoreModel user = widget.user!;
  //   return

  //       // _isBlockedUser || user.disabledAccount!
  //       //     ? UserNotFound(
  //       //         userName: user.userName!,
  //       //       )
  //       //     : user.reportConfirmed!
  //       //         ? UserBanned(
  //       //             userName: user.userName!,
  //       //           )
  //       // :
  //       _scaffold(context, user);
  // }

  mainProfileLoadingIdicator() {
    return Container(
      color: Theme.of(context).primaryColorLight,
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
                              ResponsiveHelper.responsiveHeight(context, 16.0),
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey)),
                  TextSpan(text: 'Profile\nPlease Wait... '),
                ],
                style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveHeight(context, 16.0),
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )),
            ),
          ],
        ),
      ),
    );
  }

  _fetchedProfile(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    bool isAuthor = widget.currentUserId == widget.userId;

    print(isAuthor);

    if (_isFecthing) {
      return mainProfileLoadingIdicator();
    } else if (_userNotFound) {
      return UserNotFound(userName: 'User');
    } else {
      return widget.accountType == 'Shop'
          ? _profileStore == null || _provider.userStore == null
              ? mainProfileLoadingIdicator()
              : ShopProfile(
                  shop: isAuthor ? _provider.userStore! : _profileStore!,
                  clientCount: _followerCount,
                  currentUserId: widget.currentUserId,
                )
          : widget.accountType == 'Worker'
              ? _profileWorker == null
                  ? mainProfileLoadingIdicator()
                  : ShopProfile(
                      clientCount: _followerCount,
                      shop: _profileStore!,
                      currentUserId: widget.currentUserId,
                    )
              : _profileClient == null
                  ? mainProfileLoadingIdicator()
                  : ClientProfile(
                      clientCount: _followerCount,
                      client: _profileClient!,
                      currentUserId: widget.currentUserId,
                    );
    }
  }

  _shopScaffoldSetUp(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    bool isAuthor = widget.currentUserId == widget.userId;
    return _profileStore != null
        ? ShopProfile(
            shop: isAuthor ? _provider.userStore! : _profileStore!,
            currentUserId: widget.currentUserId,
            clientCount: _followerCount,
          )
        //  _shopScaffold(_profileStore!)
        : _fetchedProfile(context);
  }

  _clientScaffoldSetUp(BuildContext context) {
    return widget.user == null
        ? _profileClient != null && widget.userId == widget.currentUserId
            ? ClientProfile(
                client: _profileClient!,
                currentUserId: widget.currentUserId,
                clientCount: _followerCount,
              )

            // _cleintScaffold(_profileClient!)
            : _fetchedProfile(context)
        : ClientProfile(
            client: widget.user!,
            currentUserId: widget.currentUserId,
            clientCount: _followerCount,
          );
  }

  _workerScaffoldSetUp(BuildContext context) {
    return _profileWorker != null && widget.userId == widget.currentUserId
        ? _cleintScaffold(_profileClient!)
        : _fetchedProfile(context);
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    // var _provider = Provider.of<UserData>(context);
    super.build(context);
    return widget.accountType == 'Shop'
        ? _shopScaffoldSetUp(context)
        : widget.accountType == 'Client'
            ? _clientScaffoldSetUp(context)
            : _workerScaffoldSetUp(context);
  }
}
