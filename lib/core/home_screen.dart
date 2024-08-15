import 'package:bars/features/events/event_room_and_chat/presentation/screens/chats.dart';
import 'package:bars/features/gemini_ai/presentation/widgets/hope_action.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'Home_screen';
  final Key? key;

  const HomeScreen({this.key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final int _updateAppVersion = Platform.isIOS ? 27 : 27;
  String notificationMsg = '';
  // bool _isFecthing = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setUpactivityCount();
      _configureNotification();
      initDynamicLinks();
    });
  }

  _setUpactivityCount() {
    var _provider = Provider.of<UserData>(context, listen: false);
    final String currentUserId = _provider.currentUserId!;
    DatabaseService.numActivities(currentUserId).listen((activityCount) {
      if (mounted) {
        _provider.setActivityCount(activityCount);
      }
    });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<void> _configureNotification() async {
    final String? currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    if (currentUserId != null) {
      try {
        final token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await usersGeneralSettingsRef
              .doc(currentUserId)
              .update({'androidNotificationToken': token});
        }
      } catch (e) {}
      try {
        FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
          usersGeneralSettingsRef
              .doc(currentUserId)
              .update({'androidNotificationToken': newToken});
        });

        final authorizationStatus =
            await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          provisional: false,
          sound: true,
        );

        if (authorizationStatus.authorizationStatus ==
            AuthorizationStatus.authorized) {
          FirebaseMessaging.instance.getInitialMessage().then((message) {
            _handleNotification(
              message,
            );
          });

          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message.notification?.body ?? ""),
                action: SnackBarAction(
                  label: 'View',
                  onPressed: () {},
                ),
              ),
            );
          });

          FirebaseMessaging.onMessageOpenedApp.listen((message) {
            _handleNotification(message, fromBackground: true);
          });
        }
      } catch (e) {}
    }
  }

  void _handleNotification(RemoteMessage? message,
      {bool fromBackground = false}) async {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (message?.data != null) {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'com.example.barsImpression',
        'barsImpression',
        importance: Importance.max,
        playSound: true,
      );

      const IOSNotificationDetails iosNotificationDetails =
          IOSNotificationDetails(
        presentSound: true,
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: iosNotificationDetails,
      );

      // Extract data from the message
      if (message != null) {
        String? contentType = message.data['contentType'];
        String? contentId = message.data['contentId'];
        String? authorId = message.data['authorId'];
        String? eventAuthorId = message.data['eventAuthorId'];

        // Navigate to the correct page
        if (contentId != null) {
          contentType!.endsWith('ask') ||
                  contentType.endsWith('like') ||
                  contentType.endsWith('advice')
              ? _navigateToPage(
                  context, NotificationPage(currentUserId: currentUserId))
              : contentType.endsWith('follow')
                  ? _navigateToPage(
                      context,
                      ProfileScreen(
                        currentUserId:
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId!,
                        userId: authorId!,
                        user: null,
                      ))
                  : contentType.endsWith('ticketPurchased')
                      ? _navigateToPage(
                          context,
                          ProfileScreen(
                            currentUserId:
                                Provider.of<UserData>(context, listen: false)
                                    .currentUserId!,
                            userId: authorId!,
                            user: null,
                          ))
                      : contentType.endsWith('message')
                          ? _navigateToPage(
                              context,
                              ViewSentContent(
                                contentId: contentId,
                                contentType: 'message',
                                eventAuthorId: '',
                              ),
                            )
                          : contentType.endsWith('eventRoom')
                              ? _navigateToPage(
                                  context,
                                  ViewSentContent(
                                    contentId: contentId,
                                    contentType: 'eventRoom',
                                    eventAuthorId: '',
                                  ),
                                )
                              : contentType.endsWith('eventDeleted')
                                  ? _navigateToPage(
                                      context,
                                      ViewSentContent(
                                        contentId: contentId,
                                        contentType: 'eventDeleted',
                                        eventAuthorId: '',
                                      ),
                                    )
                                  : contentType.endsWith('refundProcessed')
                                      ? _navigateToPage(
                                          context,
                                          ViewSentContent(
                                            contentId: contentId,
                                            contentType: 'refundProcessed',
                                            eventAuthorId: eventAuthorId!,
                                          ),
                                        )
                                      : _navigateToPage(
                                          context,
                                          ViewSentContent(
                                            contentId: contentId,
                                            contentType: contentType.endsWith(
                                                    'FundsDistributed')
                                                ? 'Event'
                                                : contentType.endsWith(
                                                        'newEventInNearYou')
                                                    ? 'Event'
                                                    : contentType.endsWith(
                                                            'eventUpdate')
                                                        ? 'Event'
                                                        : contentType.endsWith(
                                                                'eventReminder')
                                                            ? 'Event'
                                                            : contentType.endsWith(
                                                                    'refundRequested')
                                                                ? 'Event'
                                                                : contentType
                                                                        .startsWith(
                                                                            'inviteRecieved')
                                                                    ? 'InviteRecieved'
                                                                    : '',
                                            eventAuthorId: eventAuthorId!,
                                          ),
                                        );
        }
        // }
      }
    }
  }

  Future<void> initDynamicLinks() async {
    // Handle the initial dynamic link if the app was opened with one
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      await _handleDynamicLink(initialLink);
    }

    // Listen for new dynamic links while the app is running
    FirebaseDynamicLinks.instance.onLink
        .listen((PendingDynamicLinkData? dynamicLinkData) async {
      await _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('Dynamic Link Failed: $error');
    });
  }

  Future<void> _handleDynamicLink(
      PendingDynamicLinkData? dynamicLinkData) async {
    final _provider = Provider.of<UserData>(context, listen: false);

    final Uri? link = dynamicLinkData?.link;
    if (link != null && link.path.isNotEmpty) {
      // Normalize the path by removing the leading slash if it exists
      final String normalizedPath =
          link.path.startsWith('/') ? link.path.substring(1) : link.path;
      final List<String> parts = normalizedPath.split("_");
      await AffiliateManager.saveEventAffiliateId(
          parts[1], parts.length > 3 ? parts[3].trim() : '');

      if (parts.length >= 2) {
        print('link     ' + link.toString());
        print(parts[1]);
        print(parts[0]);
        print(parts[2]);

        // Handle the dynamic link based on its type
        if (parts[0].endsWith('user')) {
          _navigateToPage(
            context,
            ProfileScreen(
              currentUserId: _provider.currentUserId!,
              userId: parts[1],
              user: null,
            ),
          );
        } else {
          _navigateToPage(
            context,
            ViewSentContent(
              contentId: parts[1],
              contentType: parts[0].endsWith('punched')
                  ? 'Mood Punched'
                  : parts[0].endsWith('event')
                      ? 'Event'
                      : '',
              eventAuthorId: parts[2].trim(),
            ),
          );
        }
      } else {
        print('Link format not as expected: $link');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: FutureBuilder<UpdateApp>(
          future: DatabaseService.getUpdateInfo(),
          builder: (BuildContext context, AsyncSnapshot<UpdateApp> snapshot) {
            if (snapshot.hasError) {
              return SizedBox.shrink();
            }
            if (!snapshot.hasData) {
              return PostSchimmerSkeleton();
            }
            final _updateApp = snapshot.data!;
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled) => [],
                body: HomeMobile(
                  updateApp: _updateApp,
                  updateAppVersion: _updateAppVersion,
                ));
          }),
    );
  }
}

//display home screen for mobile version
class HomeMobile extends StatefulWidget {
  final UpdateApp updateApp;
  final int updateAppVersion;

  const HomeMobile(
      {Key? key, required this.updateApp, required this.updateAppVersion})
      : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile>
    with SingleTickerProviderStateMixin {
  // FirebaseDynamicLinks dynamicLi,nks = FirebaseDynamicLinks.instance;
  int _currentTab = 1;
  late PageController _pageController;
  int _version = 0;
  bool _showInfo = false;
  int _affiliateCount = 0;

  // int _inviteCount = -1;

  List<InviteModel> _inviteList = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentTab,
    );
    _pageController.addListener(() {
      // Check if the scroll position indicates that the page has finished scrolling
      if ((_pageController.position.pixels %
              _pageController.position.viewportDimension) ==
          0) {
        triggerHapticFeedback(); // Trigger haptic feedback when the page finishes scrolling
      }
    });

    // _setUpInvitsCount();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      int? version = Platform.isIOS
          ? widget.updateApp.updateVersionIos
          : widget.updateApp.updateVersionAndroid;
      _version = version!;
      await _setUpInvites();
      await _setAffiliateCount();

      _setShowDelayInfo();
    });
  }

  void triggerHapticFeedback() {
    HapticFeedback.lightImpact(); // Use the desired haptic feedback method
  }

  DocumentSnapshot? lastDocument;
  final now = DateTime.now();

// Define a constant for how many documents to fetch at a time
  static const int inviteLimit = 2;
  _setAffiliateCount() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numUerAffiliates(
      currentUserId,
    ).listen((affiliateCount) {
      if (mounted) {
        setState(() {
          _affiliateCount = affiliateCount;
        });
      }
    });
  }

  _setUpInvites() async {
    final currentDate = DateTime(now.year, now.month, now.day);
    int sortNumberOfDays = 7;
    final sortDate = currentDate.add(Duration(days: sortNumberOfDays));
    try {
      final String currentUserId =
          Provider.of<UserData>(context, listen: false).currentUserId!;
      QuerySnapshot eventFeedSnapShot;

      // If lastDocument is null, this is the first fetch
      if (lastDocument == null) {
        eventFeedSnapShot = await userInvitesRef
            .doc(currentUserId)
            .collection('eventInvite')
            .where('answer', isEqualTo: '')
            .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
            .where('eventTimestamp', isLessThanOrEqualTo: sortDate)
            .orderBy('eventTimestamp')
            .limit(inviteLimit)
            .get();
      } else {
        // If lastDocument is not null, fetch the next batch starting after the last document
        eventFeedSnapShot = await userInvitesRef
            .doc(currentUserId)
            .collection('eventInvite')
            .where('answer', isEqualTo: '')
            .where('eventTimestamp', isGreaterThanOrEqualTo: currentDate)
            .where('eventTimestamp', isLessThanOrEqualTo: sortDate)
            .orderBy('eventTimestamp')
            .startAfterDocument(lastDocument!)
            .limit(inviteLimit)
            .get();
      }

      // If there are documents, set the last one
      if (eventFeedSnapShot.docs.isNotEmpty) {
        lastDocument = eventFeedSnapShot.docs.last;
      }

      List<InviteModel> invites = eventFeedSnapShot.docs
          .map((doc) => InviteModel.fromDoc(doc))
          .toList();

      if (mounted) {
        setState(() {
          _inviteList
              .addAll(invites); // append new invites to the existing list
        });
      }
      return invites;
    } catch (e) {
      // print('Error fetching invites: $e');
      _showBottomSheetErrorMessage('Failed to fetch invites.');
      return null; // return null or an empty list, depending on how you want to handle errors
    }
  }

  _setShowDelayInfo() {
    if (!_showInfo) {
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          _showInfo = true;
          _setShowInfo();
        }
      });
    }
  }

  _setShowInfo() {
    if (_showInfo) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _showInfo = false;
          });
        }
      });
    }
  }

  _tabColumn(IconData icon, int currentTab, int index) {
    var _provider = Provider.of<UserData>(context);

    return Column(
      children: [
        index != 4
            ? const SizedBox.shrink()
            : _provider.activityCount == 0
                ? const SizedBox.shrink()
                : CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 3,
                  ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 2,
          curve: Curves.easeInOut,
          width: 30.0,
          decoration: BoxDecoration(
            color: currentTab == index ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: -0.0),
          child: Icon(
            icon,
            size: 25.0,
          ),
        ),
      ],
    );
  }

  void _showBottomSheetErrorMessage(String title) {
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
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  var _provider = Provider.of<UserData>(context);

    // final String currentUserId = _provider.currentUserId!;
    // final AccountHolderAuthor user = _provider.user!;

    // final UserSettingsLoadingPreferenceModel userLocationSettings =
    //     _provider.userLocationPreference!;
    var _provider = Provider.of<UserData>(context);

    // Use conditional access and provide default/fallback values or handle the case where the value might be null
    final String? currentUserId = _provider.currentUserId;
    final AccountHolderAuthor? user = _provider.user;
    final UserSettingsLoadingPreferenceModel? userLocationSettings =
        _provider.userLocationPreference;

    // If any of these values are null, we handle it by showing an error message or taking some other action
    if (currentUserId == null || user == null || userLocationSettings == null) {
      // Handle the null case here, e.g., by showing an error or a loading indicator
      return PostSchimmerSkeleton(); // or some error message
    }

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    bool dontShowActivityCount = _provider.activityCount == 0 || !_showInfo;
    bool dontShowInvite = _inviteList.length < 1 || !_showInfo;

    return widget.updateAppVersion < _version &&
            widget.updateApp.displayFullUpdate!
        ? UpdateAppInfo(
            updateNote: widget.updateApp.updateNote!,
            version: widget.updateApp.version!,
          )
        : Stack(
            alignment: FractionalOffset.center,
            children: [
              Scaffold(
                backgroundColor: Theme.of(context).primaryColor,
                body: Container(
                  width: width,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 10),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                      )
                    ],
                  ),
                  child: Stack(
                    alignment: FractionalOffset.center,
                    children: [
                      SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: PageView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          controller: _pageController,
                          children: <Widget>[
                            Chats(
                              currentUserId: currentUserId,
                              userId: '',
                            ),
                            DiscoverEventScreen(
                              currentUserId: currentUserId,
                              userLocationSettings: userLocationSettings,
                              isLiveLocation: false,
                              liveCity: '',
                              liveCountry: '',
                              liveLocationIntialPage: 0,
                              sortNumberOfDays: 0,
                            ),
                            DiscoverUser(
                              currentUserId: currentUserId,
                              isWelcome: false,
                              isLiveLocation: false,
                              liveCity: '',
                              liveCountry: '',
                              liveLocationIntialPage: 0,
                            ),
                            TicketAndCalendarFeedScreen(
                              currentUserId: currentUserId,
                            ),
                            Chats(
                              currentUserId: currentUserId,
                              userId: '',
                            ),
                            ProfileScreen(
                              currentUserId: currentUserId,
                              userId: currentUserId,
                              user: user,
                            ),
                          ],
                          onPageChanged: (int index) {
                            setState(() {
                              _currentTab = index;
                            });
                          },
                        ),
                      ),
                      Positioned(
                          bottom: 7,
                          child: UpdateInfoMini(
                            updateNote: widget.updateApp.updateNote!,
                            showinfo: widget.updateAppVersion < _version
                                ? true
                                : false,
                            displayMiniUpdate:
                                widget.updateApp.displayMiniUpdate!,
                            onPressed: () {
                              StoreRedirect.redirect(
                                androidAppId: "com.barsOpus.barsImpression",
                                iOSAppId: "1610868894",
                              );
                            },
                          )),
                      Positioned(
                          bottom: widget.updateAppVersion < _version ? 90 : 7,
                          child: MiniAffiliateNote(
                            updateNote:
                                'Congratulations, you have one or more affiliate deals.',
                            showinfo: _affiliateCount > 0 ? true : false,
                            displayMiniUpdate:
                                widget.updateApp.displayMiniUpdate!,
                          )),
                      Positioned(bottom: 7, child: NoConnection()),
                    ],
                  ),
                ),
                bottomNavigationBar: _currentTab == 0
                    ? const SizedBox.shrink()
                    : Wrap(
                        children: [
                          BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            currentIndex: _currentTab - 1,
                            onTap: (int index) {
                              setState(() {
                                _currentTab = index + 1;
                              });

                              _pageController.animateToPage(
                                index + 1,
                                duration: const Duration(milliseconds: 10),
                                curve: Curves.easeIn,
                              );
                            },
                            showUnselectedLabels: true,
                            selectedLabelStyle: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 10.0),
                            ), // font size of selected item
                            unselectedLabelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 10.0),
                            ),
                            unselectedItemColor: Colors.grey,

                            selectedItemColor:
                                Theme.of(context).secondaryHeaderColor,

                            items: [
                              BottomNavigationBarItem(
                                icon: _tabColumn(Icons.event, _currentTab, 1),
                                label: 'Event',
                              ),
                              BottomNavigationBarItem(
                                icon: _tabColumn(Icons.search, _currentTab, 2),
                                label: 'Book',
                              ),
                              BottomNavigationBarItem(
                                icon: _tabColumn(
                                    MdiIcons.ticketOutline, _currentTab, 3),
                                label: 'Tickets',
                              ),
                              BottomNavigationBarItem(
                                icon: _tabColumn(
                                    Icons.send_outlined, _currentTab, 4),
                                label: 'Chats',
                              ),
                              BottomNavigationBarItem(
                                icon: _tabColumn(Icons.account_circle_outlined,
                                    _currentTab, 5),
                                label: 'Profile',
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
              dontShowInvite
                  ? const SizedBox.shrink()
                  : Container(
                      height: height,
                      width: width,
                      color: Colors.black.withOpacity(.7),
                    ),
              Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: AnimatedContainer(
                    curve: Curves.easeInOut,
                    duration: const Duration(milliseconds: 800),
                    height: dontShowInvite
                        ? 0
                        : ResponsiveHelper.responsiveHeight(context, 500.0),
                    width: width,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Material(
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 40,
                              width: width,
                              child: GestureDetector(
                                child: ListTile(
                                  trailing: GestureDetector(
                                    onTap: () {
                                      _navigateToPage(InvitationPages(
                                        currentUserId: currentUserId,
                                      ));
                                    },
                                    child: Text(
                                      'See all',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14.0),
                                      ),
                                    ),
                                  ),
                                  leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    iconSize: ResponsiveHelper.responsiveHeight(
                                        context, 25.0),
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    onPressed: () {
                                      _inviteList.clear();
                                    },
                                  ),
                                  title: Text(
                                    'Event\nInvitations',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Container(
                                height: ResponsiveHelper.responsiveHeight(
                                    context, 400),
                                child: ListView.builder(
                                  itemCount: _inviteList.length,
                                  itemBuilder: (context, index) {
                                    InviteModel invite = _inviteList[index];
                                    return InviteContainerWidget(
                                      invite: invite,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 1,
                child: GestureDetector(
                  onTap: () {
                    _navigateToPage(
                        NotificationPage(currentUserId: currentUserId));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: ResponsiveHelper.responsiveHeight(
                            context, _inviteList.length < 1 ? 100 : 70)),
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800),
                      height: dontShowActivityCount ? 0.0 : 40,
                      width: dontShowActivityCount ? 1 : 150,
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_active_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  NumberFormat.compact()
                                      .format(_provider.activityCount),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: dontShowActivityCount
                                          ? 0
                                          : ResponsiveHelper.responsiveFontSize(
                                              context, 16.0),
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _provider.shortcutBool
                  ? Positioned(
                      bottom: 0.0,
                      child: Material(
                        child: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                _provider.setShortcutBool(false);
                              }
                            },
                            child: Container()),
                      ),
                    )
                  : const SizedBox.shrink(),
              if (_provider.florenceActive)
                HopeActions(
                    showAffiliateNote: _inviteList.length > 0,
                    updateApp: widget.updateApp,
                    showUpdate: widget.updateAppVersion < _version),
              Positioned(
                bottom: ResponsiveHelper.responsiveHeight(
                    context,
                    _provider.int2 == 3
                        ? 50
                        : _inviteList.length < 1
                            ? 100
                            : 70),
                child: GestureDetector(
                  onTap: () async {
                    HapticFeedback.mediumImpact();
                    _provider.setFlorenceActive(
                        _provider.florenceActive ? false : true);
                    _provider.setInt2(0);
                  },
                  child: Container(
                    height: ResponsiveHelper.responsiveFontSize(context, 45),
                    width: ResponsiveHelper.responsiveFontSize(context, 60),
                    color: Colors.transparent,
                    child: AnimatedContainer(
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 800),
                      height: _provider.showEventTab && _provider.showUsersTab
                          ? 40
                          : 0,
                      width: _provider.showEventTab && _provider.showUsersTab
                          ? 40
                          : 0,
                      // padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _provider.int2 == 3
                            ? Theme.of(context)
                                .secondaryHeaderColor
                                .withOpacity(.6)
                            : _provider.florenceActive
                                ? Colors.transparent
                                : Theme.of(context).primaryColor,
                      ),
                      child: Center(
                        child: _provider.florenceActive
                            ? Icon(
                                Icons.close,
                                color: _provider.int2 == 3
                                    ? Theme.of(context)
                                        .primaryColorLight
                                        .withOpacity(.6)
                                    : _provider.florenceActive
                                        ? Colors.white
                                        : Colors.black,
                                size: _provider.florenceActive ? 30 : 20,
                              )
                            : AnimatedCircle(
                                size: 25,
                                stroke: 2,
                                animateSize: false,
                                animateShape: false,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
