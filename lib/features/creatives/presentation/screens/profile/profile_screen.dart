import 'dart:ui';
import 'package:bars/features/creatives/presentation/screens/no_followers.dart';
import 'package:bars/utilities/exports.dart';
import 'package:collection/collection.dart';
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
  late ScrollController _hideButtonController;
  List<Event> _eventsList = [];
  AccountHolderAuthor? _profileUser;
  double coseTope = 10;
  late TabController _tabController;
  List<InviteModel> _inviteList = [];
  int limit = 5;
  int currentTab = 0;
  bool _hasNext = true;
  late final _lastInviteDocument = <DocumentSnapshot>[];
  late final _lastEventDocument = <DocumentSnapshot>[];

  @override
  void initState() {
    super.initState();
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
    // _setUpEvents();
    _setUpInvites();
    _fetchAndSetupUser();
  }

  bool _handleScrollNotification(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      if (_hideButtonController.position.extentAfter == 0) {
        selectedTabIndex == 0 ? _loadMoreEvents() : _loadMoreInvites();
      }
    }
    return false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _hideButtonController.dispose();
    super.dispose();
  }

  _nothing() {}

  Future<void> _fetchAndSetupUser() async {
    // Fetch the user data using whatever method you need
    var userSnapshot = await usersAuthorRef.doc(widget.userId).get();
    // Check if the snapshot contains data and if the user has a private account
    if (userSnapshot.exists) {
      AccountHolderAuthor user = AccountHolderAuthor.fromDoc(userSnapshot);
      // If the user has a private account, setup the follow request check
      if (user.privateAccount!) {
        await _setupIsFollowRequest();
      }
      // Set state with the new user data to update the UI
      if (mounted) {
        setState(() {
          _profileUser = user;
          _isFecthing = false;
        });
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

  _setupIsFollowRequest() async {
    bool isFollowingRequest = await DatabaseService.isFollowingRequested(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    if (mounted) {
      setState(() {
        _isFollowerResquested = isFollowingRequest;
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

  Set<String> addedEventIds = Set<String>();

  _loadMoreEvents() async {
    try {
      Query eventFeedSnapShot = eventsRef
          .doc(widget.userId)
          .collection('userEvents')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastEventDocument.last)
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

      _lastEventDocument.addAll(postFeedSnapShot.docs);

      if (mounted) {
        setState(() {
          _eventsList.addAll(moreEvents);

          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      return [];
    }
  }

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

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = widget.currentUserId == widget.userId
          ? userInvitesRef
              .doc(widget.userId)
              .collection('eventInvite')
              .orderBy('eventTimestamp', descending: true)
              .startAfterDocument(_lastInviteDocument.last)
              .limit(limit)
          : userInvitesRef
              .doc(widget.userId)
              .collection('eventInvite')
              .where('answer', isEqualTo: 'Accepted')
              .startAfterDocument(_lastInviteDocument.last)
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

      _lastInviteDocument.addAll(postFeedSnapShot.docs);

      if (mounted) {
        setState(() {
          _inviteList.addAll(moreInvites);
          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      _hasNext = false;
      return _hasNext;
    }
  }

  _followOrUnfollow(AccountHolderAuthor user) {
    HapticFeedback.heavyImpact();
    if (_isFollowing) {
      _showBottomSheetUnfollow(context, user, 'unfollow');
    } else {
      _followUser(user);
    }
  }

  _requestFollowOrUnfollow(AccountHolderAuthor user) {
    HapticFeedback.heavyImpact();
    if (_isFollowerResquested) {
      _showBottomSheetUnfollow(context, user, 'cancelFollowRequest');
    } else {
      _followUser(user);
    }
  }

  _blockOrUnBlock(AccountHolderAuthor user) {
    if (_isBlockingUser) {
      _showBottomSheetUnfollow(context, user, 'unBlock');
    } else {
      _showBottomSheetUnfollow(context, user, 'block');
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

  _cancelFollowRequest(AccountHolderAuthor user) {
    HapticFeedback.heavyImpact();
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
      backgroundColor: Colors.blue,
      content: Text(
        'Blocked ' + user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

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
    user.privateAccount!
        ? DatabaseService.sendFollowRequest(
            currentUserId: widget.currentUserId,
            privateUser: user,
            currentUser: Provider.of<UserData>(context, listen: false).user!,
          )
        : DatabaseService.followUser(
            currentUserId: widget.currentUserId,
            user: user,
            currentUser: Provider.of<UserData>(context, listen: false).user!,
          );

    if (mounted) {
      user.privateAccount!
          ? setState(() {
              _isFollowerResquested = true;
            })
          : setState(() {
              _isFollowing = true;
              _followerCount++;
            });
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        user.privateAccount!
            ? 'Follow request sent to ${user.userName!}'
            : 'Followed ${user.userName!}',
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

  _buildStatistics(AccountHolderAuthor user) {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;

    bool isAuthor = currentUserId == user.userId;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
            : navigateToPage(
                context,
                FollowerFollowing(
                  userId: user.userId!,
                  followerCount: _followerCount,
                  followingCount: _followingCount,
                  follower: 'Follower',
                )),
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
            : navigateToPage(
                context,
                FollowerFollowing(
                  userId: user.userId!,
                  followerCount: _followerCount,
                  followingCount: _followingCount,
                  follower: 'Following',
                )),
        title: '  Following',
        subTitle: 'The number of accounts you are following.',
      ),
    ]);
  }

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
              disableAdvice: false,
              hideAdvice: false,
              // user: user,
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
                chatLoaded: chat,
                userPortfolio: null,
                userId: user.userId!,
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
      BuildContext context, UserProfessionalModel _user) async {
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
                          : '${_user.userName} is not availbe to work at this moment.',
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

  _chatButton(AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;
    return Padding(
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
                _user.professionalImageUrls.isEmpty && _user.skills.isEmpty
                    ? _showBottomSheetNoPortolio(context, _user)
                    : _user.noBooking
                        ? _showBottomSheetNoBooking(context, _user)
                        : navigateToPage(
                            context,
                            DiscographyWidget(
                              currentUserId: widget.currentUserId,
                              userIndex: 0,
                              userPortfolio: _user,
                            ),
                          );
              } else {
                _showBottomSheetErrorMessage(user.userId.toString());
              }
            } catch (e) {
              _showBottomSheetErrorMessage(e);
            } finally {
              _isLoading = false;
            }
          }, 175, 'Left'),
          const SizedBox(
            width: 1,
          ),
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
                        Chat? _chat = await DatabaseService.getUserChatWithId(
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
              175,
              'Right'),
        ],
      ),
    );
  }

  _followContainer(AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;
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
                        navigateToPage(
                            context,
                            EditProfileScreen(
                              user: user,
                            ));
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
                            : CachedNetworkImageProvider(user.profileImageUrl!,   errorListener: (_) {
                                  return;
                                }),
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
              const SizedBox(
                height: 10,
              ),
              user.privateAccount!
                  ? _isFollowing
                      ? _buildStatistics(user)
                      : SizedBox.shrink()
                  : _buildStatistics(user),
              const SizedBox(
                height: 10,
              ),
              if (!_isAuthor)
                _button(
                    _isFollowing
                        ? 'unFollow'
                        : _isFollowerResquested
                            ? 'Pending follow request'
                            : 'Follow',
                    _isFollowerResquested
                        ? () {
                            _requestFollowOrUnfollow(user);
                          }
                        : () {
                            _followOrUnfollow(user);
                          },
                    350,
                    'All'),
              const SizedBox(
                height: 5,
              ),
              user.privateAccount!
                  ? _isFollowing
                      ? _chatButton(user)
                      : SizedBox.shrink()
                  : _chatButton(user),
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
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildInvite() {
    return CustomScrollView(
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
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
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

  Widget _buildEventList() {
    return CustomScrollView(
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
                ),
              );
            },
            childCount: _eventsList.length,
          ),
        ),
      ],
    );
  }

  Widget _eventDisplay(bool _isAuthor, String userName) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: eventsRef
                .doc(widget.userId)
                .collection('userEvents')
                .orderBy('timestamp', descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _loaindSchimmer();
              }

              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: NoContents(
                    icon: null,
                    title: 'No events',
                    subTitle: _isAuthor
                        ? 'The events you create would appear here.'
                        : '$userName hasn\'t created any events yet',
                  ),
                );
              }

              List<Event> events =
                  snapshot.data!.docs.map((doc) => Event.fromDoc(doc)).toList();

              if (!const DeepCollectionEquality().equals(_eventsList, events)) {
                _eventsList = events;
                _lastEventDocument.clear();
                _lastEventDocument.addAll(snapshot.data!.docs);
              }

              return _buildEventList();
            },
          ),
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

  Future<void> refreshData() async {
    // _setUp();
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
                child: user.privateAccount! && !_isAuthor && !_isFollowing
                    ? SizedBox.shrink()
                    : Container(
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
                                  labelColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorColor: Colors.blue,
                                  unselectedLabelColor: Colors.grey,
                                  dividerColor: Colors.transparent,

                                  isScrollable: false,
                                  // tabAlignment: TabAlignment.start,
                                  indicatorWeight: 2.0,
                                  tabs: <Widget>[
                                    _tabIcon(Icons.event_outlined,
                                        selectedTabIndex == 0),
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
        body: user.privateAccount! && !_isAuthor && !_isFollowing
            ? Container(
                color: Theme.of(context).primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: NoContents(
                      title: 'Private account',
                      subTitle:
                          'This account is private. Follow to see the content.',
                      icon: Icons.lock_outline_rounded),
                ),
              )
            : Material(
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
              ? 'Are you sure you want to unfollow ${user.userName}?'
              : from.startsWith('block')
                  ? 'Are you sure you want to block ${user.userName}?'
                  : from.startsWith('unBlock')
                      ? 'Are you sure you want to unblock ${user.userName}?'
                      : from.startsWith('cancelFollowRequest')
                          ? 'Are you sure you want to cancel your follow request to ${user.userName}?'
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

  void _showBottomSheet(BuildContext context, AccountHolderAuthor user) {
    bool _isAuthor = user.userId == widget.currentUserId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 550),
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
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                ListTile(
                  trailing: _isAuthor
                      ? GestureDetector(
                          onTap: () {
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
                                  user.profileImageUrl!,   errorListener: (_) {
                                  return;
                                }),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  title: RichText(
                    textScaler: MediaQuery.of(context).textScaler,
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
                                  sendContentType: 'User',
                                  sendImageUrl: user.profileImageUrl!,
                                  sendTitle: user.userName!,
                                ));
                      },
                      icon: _isAuthor ? Icons.add : Icons.send_outlined,
                      text: _isAuthor ? 'Create' : 'Send',
                    ),
                    BottomModelSheetIconActionWidget(
                      onPressed: () async {
                        Share.share(user.dynamicLink!);
                      },
                      icon: Icons.share_outlined,
                      text: 'Share',
                    ),
                  ],
                ),
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
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.qr_code,
                  onPressed: () {
                    navigateToPage(
                        context,
                        UserBarcode(
                          userDynamicLink: user.dynamicLink!,
                          bio: user.bio!,
                          userName: user.userName!,
                          userId: user.userId!,
                          profileImageUrl: user.profileImageUrl!,
                        ));
                  },
                  text: 'Bar code',
                ),
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
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.feedback_outlined,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SuggestionBox()));
                  },
                  text: 'Suggestion',
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      navigateToPage(
                          context,
                          CompainAnIssue(
                            parentContentId: user.userId!,
                            authorId: user.userId!,
                            complainContentId: user.userId!,
                            complainType: 'Account',
                            parentContentAuthorId: user.userId!,
                          ));
                    },
                    child: Text(
                      'Complain an issue.',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _displayScaffold() {
    AccountHolderAuthor user = widget.user!;
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

  mainProfileLoadingIdicator() {
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

  _fetchedUser() {
    if (_isFecthing) {
      return mainProfileLoadingIdicator();
    } else if (_userNotFound) {
      return UserNotFound(userName: 'User');
    } else {
      return _profileUser == null
          ? mainProfileLoadingIdicator()
          : _isBlockedUser || _profileUser!.disabledAccount!
              ? UserNotFound(
                  userName: _profileUser!.userName!,
                )
              : _profileUser!.reportConfirmed!
                  ? UserBanned(
                      userName: _profileUser!.userName!,
                    )
                  : _scaffold(context, _profileUser!);
    }
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);
    super.build(context);
    return widget.user == null
        ? _provider.user != null && widget.userId == widget.currentUserId
            ? _scaffold(context, _provider.user!)
            : _fetchedUser()
        : _displayScaffold();
  }
}
