import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:collection/collection.dart';

class ShopProfile extends StatefulWidget {
  final UserStoreModel shop;
  final String currentUserId;
  final int clientCount;

  const ShopProfile(
      {super.key,
      required this.shop,
      required this.currentUserId,
      required this.clientCount});

  @override
  State<ShopProfile> createState() => _ShopProfileState();
}

class _ShopProfileState extends State<ShopProfile>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController _hideButtonController;
  late TabController _tabController;
  int selectedTabIndex = 0;
  List<InviteModel> _inviteList = [];
  int limit = 5;
  bool _hasNext = true;
  late final _lastInviteDocument = <DocumentSnapshot>[];
  late final _lastPostDocument = <DocumentSnapshot>[];
  Set<String> addedInviteIds = Set<String>();
  List<Post> _postsList = [];
  List<ReviewModel> _reviewList = [];
  RatingModel? _userRatings;
  bool _isLoadingChat = false;

  bool _isFecthingRatings = true;
  PageController _pageController2 = PageController(
    initialPage: 0,
  );
  int _index = 0;

  Set<String> addedPostIds = Set<String>();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });

    _hideButtonController = ScrollController();
    SchedulerBinding.instance.addPostFrameCallback((_) {});
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_index < 2) {
        _index++;
        if (_pageController2.hasClients) {
          _pageController2.animateToPage(
            _index,
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _index = 0;
        if (_pageController2.hasClients) {
          _pageController2.jumpToPage(
            _index,
          );
        }
      }
    });
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

  _loadMoreEvents() async {
    try {
      Query eventFeedSnapShot = postsRef
          .doc(widget.shop.userId)
          .collection('userPosts')
          .orderBy('timestamp', descending: true)
          .startAfterDocument(_lastPostDocument.last)
          .limit(limit);
      QuerySnapshot postFeedSnapShot = await eventFeedSnapShot.get();

      List<Post> posts =
          postFeedSnapShot.docs.map((doc) => Post.fromDoc(doc)).toList();

      List<Post> morePosts = [];

      for (var post in posts) {
        if (!addedPostIds.contains(post.id)) {
          addedPostIds.add(post.id!);
          morePosts.add(post);
        }
      }

      _lastPostDocument.addAll(postFeedSnapShot.docs);

      if (mounted) {
        setState(() {
          _postsList.addAll(morePosts);

          _hasNext = postFeedSnapShot.docs.length == limit;
        });
      }
      return _hasNext;
    } catch (e) {
      return [];
    }
  }

  _loadMoreInvites() async {
    try {
      Query activitiesQuery = widget.currentUserId == widget.shop.userId
          ? userInvitesRef
              .doc(widget.shop.userId)
              .collection('eventInvite')
              .orderBy('eventTimestamp', descending: true)
              .startAfterDocument(_lastInviteDocument.last)
              .limit(limit)
          : userInvitesRef
              .doc(widget.shop.userId)
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

  @override
  void dispose() {
    _tabController.dispose();
    _hideButtonController.dispose();
    super.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
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

  void _showBottomSheetBookMe(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: UserBookingOption(
            bookingUser: widget.shop,
          ),
        );
      },
    );
  }

  void _showBottomSheetMore(String from) {
    var _provider = Provider.of<UserData>(context, listen: false);
    // final double height = MediaQuery.of(context).size.height;
    final bool _isAuthor = widget.currentUserId == widget.shop.userId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              TicketPurchasingIcon(
                title: from,
              ),
              from.startsWith('contacts')
                  ? PortfolioContactWidget(
                      portfolios: _provider.bookingContacts,
                      edit: _isAuthor,
                    )
                  // : from.startsWith('company')
                  //     ? PortfolioCompanyWidget(
                  //         portfolios: _provider.company,
                  //         seeMore: true,
                  //         edit: false,
                  //       )
                  : from.startsWith('services')
                      ? PortfolioWidget(
                          portfolios: _provider.services,
                          seeMore: true,
                          edit: false,
                        )
                      // : from.startsWith('performance')
                      //     ? PortfolioWidget(
                      //         portfolios: _provider.performances,
                      //         seeMore: true,
                      //         edit: false,
                      //       )
                      : from.startsWith('awards')
                          ? PortfolioWidget(
                              portfolios: _provider.awards,
                              seeMore: true,
                              edit: false,
                            )
                          : from.startsWith('work')
                              ? PortfolioWidgetWorkLink(
                                  portfolios: _provider.linksToWork,
                                  seeMore: true,
                                  edit: false,
                                )
                              : from.startsWith('price')
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 30.0),
                                      child: PriceRateWidget(
                                        edit: false,
                                        prices: _provider.priceRate,
                                        seeMore: true,
                                      ),
                                    )
                                  // : from.startsWith('collaborations')
                                  //     ? Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 30.0),
                                  //         child: PortfolioCollaborationWidget(
                                  //           edit: false,
                                  //           seeMore: true,
                                  //           collaborations:
                                  //               _provider.collaborations,
                                  //         ),
                                  //       )
                                  : from.startsWith('review')
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(top: 30.0),
                                          child:
                                              _buildDisplayReviewList(context),
                                        )
                                      : PortfolioWidget(
                                          portfolios: [],
                                          seeMore: true,
                                          edit: false,
                                        ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  _divider(
    String text,
    String from,
    bool shouldEpand,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Divider(
          thickness: .2,
        ),
        text.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 20),
        ListTile(
          title: Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          trailing: shouldEpand
              ? IconButton(
                  icon: Icon(
                    Icons.expand_more_outlined,
                    color: Colors.blue,
                    size: ResponsiveHelper.responsiveHeight(context, 25),
                  ),
                  onPressed: () {
                    _showBottomSheetMore(from);
                  },
                )
              : null,
        ),
      ],
    );
  }

  _buildReview(BuildContext context, ReviewModel review, bool fullWidth) {
    // var _currentUserId =
    //     Provider.of<UserData>(context, listen: false).currentUserId;

    return ReviewWidget(
      review: review,
      fullWidth: fullWidth,
    );
  }

  _buildDisplayReviewList(BuildContext context) {
    List<Widget> forumViews = [];
    _reviewList.forEach((portfolio) {
      forumViews.add(_buildReview(context, portfolio, true));
    });
    return Column(children: forumViews);
  }

  _buildDisplayReviewGrid(
    BuildContext context,
  ) {
    List<Widget> tiles = [];
    _reviewList
        .forEach((people) => tiles.add(_buildReview(context, people, false)));

    return _reviewList.isEmpty
        ? Center(
            child: Text(
              'No reviews yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container(
            color: Theme.of(context).primaryColorLight,
            height: ResponsiveHelper.responsiveHeight(context, 140),
            child: GridView.count(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1, // Items down the screen
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio:
                  0.4, // Adjust this to change the vertical size, smaller number means smaller height
              children: tiles,
            ),
          );
  }

  void _showBottomSheetTermsAndConditions() {
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
                          text: 'Overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextSpan(
                          text:
                              "\n\n${widget.shop.overview.trim().replaceAll('\n', ' ')}",
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

  _launchMap(String address) {
    return MapsLauncher.launchQuery(address);
  }

  void _showBottomSheetOpeningHours() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              const SizedBox(
                height: 30,
              ),
              OpeninHoursWidget(
                openingHours: widget.shop.openingHours,
              )
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheetEditProfile() {
    var _provider = Provider.of<UserData>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              height: ResponsiveHelper.responsiveHeight(
                  context, _provider.user!.accountType == 'Sop' ? 400 : 600),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: EditProfileScreen(
                user: _provider.user!,
                shop: widget.shop,
                worker: null,
                accountType: widget.shop.accountType!,
              )

              //  EditProfileScreen(
              //   user: _provider.user!,
              //   userStore: widget.shop,
              // ),

              ),
        );
      },
    );
  }

  _followContainer() {
    var divider = Divider(
      thickness: .2,
      height: 20,
    );
    bool _isAuthor = widget.shop.userId == widget.currentUserId;
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: ResponsiveHelper.responsiveHeight(context, 40.0),
              ),
              ProfileImageHeaderWidget(
                isClient: false,
                isAuthor: _isAuthor,
                imageUrl: widget.shop.shopLogomageUrl,
                userId: widget.shop.userId,
                verified: widget.shop.verified,
                name: widget.shop.shopName,
                shopOrAccountType: widget.shop.shopType,
                user: widget.shop,
                clientCount: widget.clientCount,
                currentUserId: widget.currentUserId,
                onPressed: () {
                  _showBottomSheetEditProfile();
                },
              ),

              divider,
              GestureDetector(
                  onTap: () {
                    _showBottomSheetOpeningHours();
                  },
                  child: ShopOpenStatus(shop: widget.shop)),

              divider,
              GestureDetector(
                onTap: () {
                  _launchMap(widget.shop.address);
                },
                child: PayoutDataWidget(
                  inMini: true,
                  label: 'Location',
                  value: widget.shop.address,
                  text2Ccolor: Colors.blue,
                ),
              ),

              divider,
              GestureDetector(
                onTap: () {
                  _showBottomSheetTermsAndConditions();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.shop.overview.trim().replaceAll('\n', ' '),
                    maxLines: _isAuthor ? 4 : 3,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12),
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              // const SizedBox(
              //   height: 30,
              // ),
              // if (!_isAuthor)
              //   _button(
              //       _isFollowing
              //           ? 'unFollow'
              //           : _isFollowerResquested
              //               ? 'Pending follow request'
              //               : 'Follow',
              //       _isFollowerResquested
              //           ? () {
              //               _requestFollowOrUnfollow(user);
              //             }
              //           : () {
              //               _followOrUnfollow(user);
              //             },
              //       'All'),
              // const SizedBox(
              //   height: 5,
              // ),
              // // user.isShop!
              // //     ? _isFollowing
              // //         ? _chatButton(user)
              // //         : SizedBox.shrink()
              // // :
              // _chatButton(user),
              // const SizedBox(
              //   height: 30,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _professionalImageContainer(String imageUrl, String from) {
    final width = MediaQuery.of(context).size.width;
    return ShakeTransition(
      axis: Axis.vertical,
      // curve: Curves.easeInOutBack,
      child: Container(
        width: from.startsWith('Mini') ? width / 1.5 : width.toDouble(),
        height: from.startsWith('Mini') ? width / 1.5 : width.toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(from.startsWith('Mini') ? 0 : 0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              imageUrl,
              errorListener: (_) {
                return;
              },
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.6),
                Colors.black.withOpacity(.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _bottomModalSheetMessage(
      BuildContext context, UserStoreModel user, Chat? chat) {
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
                child: SizedBox.shrink()

                // BottomModalSheetMessage(
                //   showAppbar: false,
                //   isBlocked: _isBlockedUser,
                //   isBlocking: _isBlockingUser,
                //   currentUserId: widget.currentUserId,
                //   user: user,
                //   userAuthor: null,
                //   chatLoaded: chat,
                //   userPortfolio: null,
                //   userId: user.userId!,
                // ),
                ));
      },
    );
  }

  _sortByWidget(
    VoidCallback onPressed,
    IconData icon,
    String title,
    Color? color,
    notFullLength,
  ) {
    return NewModalActionButton(
      onPressed: onPressed,
      icon: icon,
      color: color,
      title: title,
      fromModalSheet: notFullLength,
    );
  }

  _button(String text, VoidCallback onPressed, String borderRaduis) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(20.0),
        width: double.infinity,
        height: ResponsiveHelper.responsiveHeight(context, 33.0),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                color: Colors.white,
                // text.startsWith('loading...') ? Colors.blue : Colors.white,
                // fontWeight: _isFecthing ? FontWeight.normal : FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetContact(
    BuildContext context,
  ) {
    // bool _isAuthor = user.userId == widget.currentUserId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 250),
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
                _sortByWidget(
                  () {
                    _showBottomSheetBookMe(context);
                  },
                  Icons.call_outlined,
                  'Call',
                  null,
                  true,
                ),
                _sortByWidget(
                  () async {
                    if (_isLoadingChat) return;

                    _isLoadingChat = true;
                    try {
                      Chat? _chat = await DatabaseService.getUserChatWithId(
                        widget.currentUserId,
                        widget.shop.userId,
                      );

                      _bottomModalSheetMessage(
                        context,
                        widget.shop,
                        _chat,
                      );
                    } catch (e) {
                    } finally {
                      _isLoadingChat = false;
                    }
                  },
                  Icons.message,
                  'Message',
                  null,
                  true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // void _showBottomSheet(
  //   BuildContext context,
  // ) {
  //   bool _isAuthor = widget.shop.userId == widget.currentUserId;
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
  //                 leading: widget.shop.shopLogomageUrl.isEmpty
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
  //                                 widget.shop.shopLogomageUrl,
  //                                 errorListener: (_) {
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
  //                           text: widget.shop.shopName.toUpperCase(),
  //                           style: Theme.of(context).textTheme.bodyMedium),
  //                       TextSpan(
  //                         text: "\n${widget.shop.shopType}",
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
  //                       : _navigateToPage(
  //                           context,
  //                           SendToChats(
  //                             sendContentId: widget.shop.userId,
  //                             currentUserId:
  //                                 Provider.of<UserData>(context, listen: false)
  //                                     .currentUserId!,
  //                             sendContentType: 'User',
  //                             sendImageUrl: widget.shop.shopLogomageUrl,
  //                             sendTitle: widget.shop.shopName,
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
  //                         Share.share(widget.shop.dynamicLink!);
  //                       }
  //                     : () {
  //                         // _blockOrUnBlock(widget.shop);
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
  //               //             Share.share(widget.shop.dynamicLink!);
  //               //           }
  //               //         : () {
  //               //             _blockOrUnBlock(widget.shop);
  //               //           },
  //               // //     text: _isAuthor ? 'Invite a friend' : 'Block'),
  //               // _sortByWidget(
  //               //   () {
  //               //     navigateToPage(
  //               //         context,
  //               //         UserBarcode(
  //               //           widget.shopDynamicLink: widget.shop.dynamicLink!,
  //               //           bio: widget.shop.bio!,
  //               //           widget.shopName: widget.shop.widget.shopName!,
  //               //           widget.shopId: widget.shop.widget.shopId!,
  //               //           profileImageUrl: widget.shop.profileImageUrl!,
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
  //               //           widget.shopDynamicLink: user.dynamicLink!,
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
  //                       _navigateToPage(
  //                           context,
  //                           UserBarcode(
  //                             userDynamicLink: widget.shop.dynamicLink,
  //                             bio: widget.shop.overview,
  //                             userName: widget.shop.shopName,
  //                             userId: widget.shop.userId,
  //                             profileImageUrl: widget.shop.shopLogomageUrl,
  //                           ));
  //                     },
  //                     Icons.qr_code,
  //                     'Barcode',
  //                     null,
  //                     false,
  //                   ),
  //                   _sortByWidget(
  //                     () async {
  //                       Share.share(widget.shop.dynamicLink);
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
  //                             _navigateToPage(
  //                                 context,
  //                                 ReportContentPage(
  //                                   contentId: widget.shop.userId,
  //                                   contentType: widget.shop.shopName,
  //                                   parentContentId: widget.shop.userId,
  //                                   repotedAuthorId: widget.shop.userId,
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
  //                     _navigateToPage(
  //                         context,
  //                         CompainAnIssue(
  //                           parentContentId: widget.shop.userId!,
  //                           authorId: widget.shop.userId!,
  //                           complainContentId: widget.shop.userId!,
  //                           complainType: 'Account',
  //                           parentContentAuthorId: widget.shop.userId!,
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

  _callButton() {
    return GestureDetector(
      onTap: () {
        _showBottomSheetContact(
          context,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.call_outlined,
              size: ResponsiveHelper.responsiveHeight(context, 20),
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'Call',
            style: TextStyle(
              color: Colors.grey,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showBottomSheetBookingCalendar(bool fromPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookingCalendar(
          currentUserId: widget.currentUserId,
          bookingUser: widget.shop,
          // prices: _profileUser!.priceTags,
          fromPrice: fromPrice,
        );
      },
    );
  }

  _mainShopInfo(bool _isAuthor, UserStoreModel user) {
    var _provider = Provider.of<UserData>(
      context,
    );
    bool _isCurrentUser = widget.currentUserId == widget.shop.userId;

    return Material(
      color:

          //  widget.shop.userId == widget.currentUserId
          //     ? Theme.of(context).primaryColor
          //     :

          Theme.of(context).primaryColorLight,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            _button('Book', () {
              _showBottomSheetBookingCalendar(false);
            }, 'Right'),
            const SizedBox(
              height: 10,
            ),
            _callButton(),
            _divider('Services', 'services',
                user.services.length >= 4 ? true : false),
            PortfolioWidget(
              portfolios: user.services,
              seeMore: false,
              edit: false,
            ),
            Container(
              height: ResponsiveHelper.responsiveFontSize(context, 500),
              width: double.infinity,
              child: PageView(
                controller: _pageController2,
                physics: AlwaysScrollableScrollPhysics(),
                children: user.professionalImageUrls
                    .asMap()
                    .entries
                    .map<Widget>((entry) {
                  var image = entry.value;
                  return _professionalImageContainer(image, 'Max');
                }).toList(),
              ),
            ),
            _divider('Opening hours', 'opening', false),
            OpeninHoursWidget(
              openingHours: user.openingHours,
            ),
            _divider('Ratings', 'ratings', false),
            Container(
              color: Theme.of(context).primaryColorLight,
              height: ResponsiveHelper.responsiveHeight(context, 150),
              width: double.infinity,
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: RatingAggregateWidget(
                    isCurrentUser: _isCurrentUser,
                    starCounts: _userRatings == null
                        ? {
                            5: 0,
                            4: 0,
                            3: 0,
                            2: 0,
                            1: 0,
                          }
                        : {
                            5: _userRatings!.fiveStar,
                            4: _userRatings!.fourStar,
                            3: _userRatings!.threeStar,
                            2: _userRatings!.twoStar,
                            1: _userRatings!.oneStar,
                          },
                  ),
                ),
              ),
            ),
            _divider('Reviews', 'review', false),
            if (!_isFecthingRatings) _buildDisplayReviewGrid(context),
            _divider('Price list and service', 'price', false),
            if (_provider.appointmentSlots.isNotEmpty && !_isCurrentUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    // "${_provider.currency} ${_provider.bookingPriceRate!.price.toString()}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0, right: 10),
                      child: MiniCircularProgressButton(
                          color: Colors.blue,
                          text: 'Book',
                          onPressed: () {
                            _showBottomSheetBookingCalendar(true);
                          }),
                    ),
                  ),
                ],
              ),
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TicketGroup(
                fromProfile: true,
                fromPrice: false,
                appointmentSlots: user.appointmentSlots,
                edit: false,
                openingHours: user.openingHours,
                bookingShop: widget.shop,
              ),
            ),
            _divider(
                'Awards', 'awards', user.awards.length >= 4 ? true : false),
            PortfolioWidget(
              portfolios: user.awards,
              seeMore: false,
              edit: false,
            ),
            _divider('Website and Social media', 'website and Social media',
                user.links.length >= 4 ? true : false),
            PortfolioWidget(
              portfolios: user.links,
              seeMore: false,
              edit: false,
            ),
            const SizedBox(
              height: 100,
            ),
            GestureDetector(
              onTap: () {
                _navigateToPage(
                    context,
                    UserBarcode(
                      profileImageUrl: user.shopLogomageUrl,
                      userDynamicLink: user.dynamicLink,
                      bio: user.overview,
                      userName: user.shopName,
                      userId: user.userId,
                    ));
              },
              child: Hero(
                  tag: user.userId,
                  child: Icon(
                    Icons.qr_code,
                    color: Colors.blue,
                    size: ResponsiveHelper.responsiveHeight(context, 30),
                  )),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  'Share link.',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  _loaindSchimmer() {
    return Container(
        height: ResponsiveHelper.responsiveHeight(
          context,
          450,
        ),
        child: EventAndUserScimmerSkeleton(
          from: 'Posts',
        ));
  }

  Widget _buildEventGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1, // Adjust based on the aspect ratio of your items
      ),
      itemCount: _postsList.length,
      itemBuilder: (context, index) {
        Post post = _postsList[index];
        return EventDisplayWidget(
          currentUserId: widget.currentUserId,
          postList: _postsList,
          post: post,
          pageIndex: 0,
          eventSnapshot: [],
          eventPagesOnly: true,
          liveCity: '',
          liveCountry: '',
          isFrom: '',
          // sortNumberOfDays: 0,
        );
      },
    );
  }

  Widget _shopPosts(bool _isAuthor, String userName) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: postsRef
                .doc(widget.shop.userId)
                .collection('userPosts')
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
                    title: 'No images',
                    subTitle: _isAuthor
                        ? 'The images of your cleint\'s work you upload would appear here.'
                        : '$userName hasn\'t uploaded any client images',
                  ),
                );
              }

              List<Post> posts =
                  snapshot.data!.docs.map((doc) => Post.fromDoc(doc)).toList();

              if (!const DeepCollectionEquality().equals(_postsList, posts)) {
                _postsList = posts;
                _lastPostDocument.clear();
                _lastPostDocument.addAll(snapshot.data!.docs);
              }

              return _buildEventGrid();
            },
          ),
        ),
      ],
    );
  }

  final _physycsNotifier = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    bool _isAuthor = widget.shop.userId == widget.currentUserId;
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: NestedScrollView(
        controller: _hideButtonController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Theme.of(context).primaryColorLight,
              leading: ProfileAddIconWidget(isAuthor: _isAuthor),
              actions: [
                IconButton(
                  icon: Icon(
                    size: ResponsiveHelper.responsiveHeight(context, 25.0),
                    Icons.supervisor_account_rounded,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // _showBottomSheet(
                    //   context,
                    // );
                  },
                ),
                MoreIconWidget(
                  isAuthor: _isAuthor,
                  imageUrl: widget.shop.shopLogomageUrl,
                  dynamicLink: widget.shop.dynamicLink,
                  userId: widget.shop.userId,
                  userName: widget.shop.shopName,
                  currentUserId: widget.currentUserId,
                  accountType: widget.shop.shopType,
                  overview: widget.shop.overview,
                ),
                // IconButton(
                //   icon: Icon(
                //     size: ResponsiveHelper.responsiveHeight(context, 25.0),
                //     Icons.more_vert_rounded,
                //     color: Theme.of(context).secondaryHeaderColor,
                //   ),
                //   onPressed: () {
                //     _showBottomSheet(
                //       context,
                //     );
                //   },
                // ),
              ],
              expandedHeight: ResponsiveHelper.responsiveHeight(
                context,
                350,
              ),
              flexibleSpace: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: FlexibleSpaceBar(
                  background: SafeArea(
                    child: _followContainer(),
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
                            dividerColor: Colors.grey.withOpacity(.5),
                            dividerHeight: .1,

                            isScrollable: false,
                            // tabAlignment: TabAlignment.start,
                            indicatorWeight: 2.0,
                            tabs: <Widget>[
                              _tabIcon(
                                  Icons.store_outlined, selectedTabIndex == 0),
                              _tabIcon(
                                  Icons.image_outlined, selectedTabIndex == 1),
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
              _mainShopInfo(_isAuthor, widget.shop),
              _shopPosts(_isAuthor, widget.shop.shopName),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
