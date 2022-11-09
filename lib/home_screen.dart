import 'package:bars/general/pages/discover/discover_user.dart';
import 'package:bars/general/pages/forum_and_blog/forum/forum_feed.dart';
import 'package:bars/utilities/local_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'Home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _updateAppVersion = Platform.isIOS ? 9 : 9;
  String notificationMsg = '';

  @override
  void initState() {
    super.initState();
    LocalNotificationService.initilize();
    _configureNotification();
  }

  _configureNotification() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    FirebaseMessaging.instance.getToken().then((token) => {
          usersRef
              .doc(currentUserId)
              .update({'androidNotificationToken': token})
        });

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.instance.getInitialMessage().then((event) {
        if (event != null) {
          setState(() {
            notificationMsg =
                "${event.notification!.title}  ${event.notification!.body}";
          });
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        setState(() {
          notificationMsg =
              "${event.notification!.title}  ${event.notification!.body}";
        });
      });
    }

    FirebaseMessaging.onMessage.listen((event) {
      final String recipientId = event.data['recipient'];
      if (recipientId == currentUserId) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //     "${event.notification!.title}: " + "${event.notification!.body}",
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ));
        LocalNotificationService.showNotificationOnForeground(event);
        setState(() {
          notificationMsg =
              "${event.notification!.title}  ${event.notification!.body}";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: FutureBuilder(
          future: DatabaseService.getUpdateInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return ResponsiveScaffold(child: PostSchimmerSkeleton());
            }
            UpdateApp _updateApp = snapshot.data;
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled) => [],
                body: Responsive.isDesktop(context)
                    ? HomeDesktop(
                        updateApp: _updateApp,
                        updateAppVersion: _updateAppVersion,
                      )
                    : HomeMobile(
                        updateApp: _updateApp,
                        updateAppVersion: _updateAppVersion,
                      ));
          }),
    );
  }
}

class HomeMobile extends StatefulWidget {
  final UpdateApp updateApp;
  final int updateAppVersion;

  const HomeMobile(
      {Key? key, required this.updateApp, required this.updateAppVersion})
      : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  int _activityEventCount = 0;
  int _currentTab = 0;
  late PageController _pageController;
  int _version = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    int? version = Platform.isIOS
        ? widget.updateApp.updateVersionIos
        : widget.updateApp.updateVersionAndroid;
    _version = version!;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setUpInvitesActivities();
      initDynamicLinks();
    });
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    FirebaseDynamicLinks.instance.getInitialLink(); //
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final List<String> link = dynamicLinkData.link.path.toString().split("_");

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewSentContent(
                  contentId: link[1],
                  contentType: link[0].endsWith('punched')
                      ? 'Mood Punched'
                      : link[0].endsWith('forum')
                          ? 'Forum'
                          : link[0].endsWith('event')
                              ? 'Event'
                              : link[0].endsWith('user')
                                  ? 'User'
                                  : '')));
    }).onError((error) {});
  }

  _setUpInvitesActivities() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numEventInviteActivities(currentUserId)
        .listen((activityEventCount) {
      if (mounted) {
        setState(() {
          _activityEventCount = activityEventCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    final AccountHolder user = Provider.of<UserData>(context).user!;
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
    return widget.updateAppVersion < _version &&
            widget.updateApp.displayFullUpdate!
        ? UpdateAppInfo(
            updateNote: widget.updateApp.updateNote!,
            version: widget.updateApp.version!,
          )
        : Scaffold(
            body: Container(
              width: width,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 10),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                  )
                ],
              ),
              child: _user.disabledAccount!
                  ? ReActivateAccount(user: _user)
                  : Stack(
                      alignment: FractionalOffset.center,
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: <Widget>[
                              FeedScreenSliver(
                                currentUserId: currentUserId,
                              ),
                              ForumFeed(
                                currentUserId: currentUserId,
                              ),
                              EventsFeed(
                                currentUserId: currentUserId,
                              ),
                              DiscoverUser(
                                currentUserId: currentUserId,
                                isWelcome: false,
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
                        Positioned(bottom: 7, child: NoConnection()),
                        Positioned(
                          bottom: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AnimatedContainer(
                              curve: Curves.easeInOut,
                              duration: Duration(milliseconds: 800),
                              height: _activityEventCount != 0 ? 80.0 : 0.0,
                              width: width - 10,
                              decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Material(
                                  color: Colors.transparent,
                                  child: ListTile(
                                    leading: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Icon(
                                        Icons.info,
                                        color: Colors.black,
                                        size: 25.0,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.event_available),
                                      iconSize: 25.0,
                                      color: Colors.black,
                                      onPressed: () {},
                                    ),
                                    title: Text(
                                        '${_activityEventCount.toString()}  Event Invitations',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.black,
                                        )),
                                    subtitle: Text(
                                      'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              ActivityEventInvitation(
                                            currentUserId:
                                                Provider.of<UserData>(context,
                                                        listen: false)
                                                    .currentUserId!,
                                            count: _activityEventCount,
                                          ),
                                        )),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
            bottomNavigationBar: _user.disabledAccount!
                ? const SizedBox.shrink()
                : Container(
                    child: Wrap(
                      children: [
                        CupertinoTabBar(
                          backgroundColor: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
                          currentIndex: _currentTab,
                          onTap: (int index) {
                            setState(() {
                              _currentTab = index;
                            });

                            _pageController.animateToPage(
                              index,
                              duration: Duration(milliseconds: 10),
                              curve: Curves.easeIn,
                            );
                          },
                          activeColor: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                          items: [
                            BottomNavigationBarItem(
                              icon: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 2,
                                        curve: Curves.easeInOut,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: _currentTab == 0
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: const Icon(
                                      MdiIcons.home,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                              label: 'Home',
                            ),
                            BottomNavigationBarItem(
                              icon: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 2,
                                        curve: Curves.easeInOut,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: _currentTab == 1
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: const Icon(Icons.forum, size: 25.0),
                                  ),
                                ],
                              ),
                              label: 'Forum',
                            ),
                            BottomNavigationBarItem(
                              icon: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 2,
                                        curve: Curves.easeInOut,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: _currentTab == 2
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: const Icon(Icons.event, size: 25.0),
                                  ),
                                ],
                              ),
                              label: 'Event',
                            ),
                            BottomNavigationBarItem(
                              icon: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 2,
                                        curve: Curves.easeInOut,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: _currentTab == 3
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Icon(Icons.search, size: 25.0),
                                  ),
                                ],
                              ),
                              label: 'Discover',
                            ),
                            BottomNavigationBarItem(
                              icon: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 0.0),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        height: 2,
                                        curve: Curves.easeInOut,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          color: _currentTab == 4
                                              ? Colors.blue
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: const Icon(Icons.account_circle,
                                        size: 25.0),
                                  ),
                                ],
                              ),
                              label: 'Profile',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          );
  }
}

class HomeDesktop extends StatefulWidget {
  final UpdateApp updateApp;
  final int updateAppVersion;

  const HomeDesktop(
      {Key? key, required this.updateApp, required this.updateAppVersion})
      : super(key: key);

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  late PageController _pageController;
  int _currentTab = 0;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  int _activityEventCount = 0;
  String notificationMsg = '';
  int _version = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    int? version = Platform.isIOS
        ? widget.updateApp.updateVersionIos
        : widget.updateApp.updateVersionAndroid;
    _version = version!;
    WidgetsFlutterBinding.ensureInitialized();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _setUpInvitesActivities();
      initDynamicLinks();
    });
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    FirebaseDynamicLinks.instance.getInitialLink();
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        print("Incoming Link :" + uri.toString());
        final List<String> link = queryParams.toString().split("_");

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ViewSentContent(
                    contentId: link[1],
                    contentType: link[0].endsWith('punched')
                        ? 'Mood Punched'
                        : link[0].endsWith('forum')
                            ? 'Forum'
                            : link[0].endsWith('event')
                                ? 'Event'
                                : link[0].endsWith('user')
                                    ? 'User'
                                    : '')));
      }
    });
  }

  _setUpInvitesActivities() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.numEventInviteActivities(currentUserId)
        .listen((activityEventCount) {
      if (mounted) {
        setState(() {
          // _activityEventCount = activityEventCount;
        });
      }
    });
  }

  Future<void> _sendMail(String url) async {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Sorry',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          'Could\'nt launch mail',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = Provider.of<UserData>(context).currentUserId!;
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    AccountHolder _user = Provider.of<UserData>(context, listen: false).user!;
    return widget.updateAppVersion < _version &&
            widget.updateApp.displayFullUpdate!
        ? UpdateAppInfo(
            updateNote: widget.updateApp.updateNote!,
            version: widget.updateApp.version!,
          )
        : Scaffold(
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Color(0xFFf2f2f2),
            body: _user.disabledAccount!
                ? ReActivateAccount(user: _user)
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Provider.of<UserData>(context, listen: false).user ==
                                null
                            ? const SizedBox.shrink()
                            : Container(
                                decoration: BoxDecoration(
                                  color: ConfigBloc().darkModeOn
                                      ? Color(0xFF1a1a1a)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      offset: Offset(0, 5),
                                      blurRadius: 8.0,
                                      spreadRadius: 2.0,
                                    )
                                  ],
                                ),
                                width: 300,
                                height: width * 3,
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: UserWebsite(
                                        iconSize: 35,
                                        padding: 5,
                                        raduis: 100,
                                        arrowColor: Colors.transparent,
                                        title: '  Home',
                                        icon: MdiIcons.home,
                                        textColor: _currentTab != 0
                                            ? Colors.grey
                                            : ConfigBloc().darkModeOn
                                                ? Color(0xFFf2f2f2)
                                                : Color(0xFF1a1a1a),
                                        iconColor: _currentTab != 0
                                            ? Colors.grey
                                            : ConfigBloc().darkModeOn
                                                ? Color(0xFFf2f2f2)
                                                : Color(0xFF1a1a1a),
                                        onPressed: () {
                                          _pageController.animateToPage(
                                            _currentTab = 0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        containerColor: null,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: UserWebsite(
                                          containerColor: null,
                                          iconSize: 35,
                                          padding: 5,
                                          raduis: 100,
                                          arrowColor: Colors.transparent,
                                          title: '  Forum',
                                          icon: Icons.forum,
                                          textColor: _currentTab != 1
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          iconColor: _currentTab != 1
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          onPressed: () {
                                            _pageController.animateToPage(
                                              _currentTab = 1,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: UserWebsite(
                                          containerColor: null,
                                          iconSize: 35,
                                          padding: 5,
                                          raduis: 100,
                                          arrowColor: Colors.transparent,
                                          title: '  Event',
                                          icon: Icons.event,
                                          textColor: _currentTab != 2
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          iconColor: _currentTab != 2
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          onPressed: () {
                                            _pageController.animateToPage(
                                              _currentTab = 2,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: UserWebsite(
                                          containerColor: null,
                                          iconSize: 35,
                                          padding: 5,
                                          raduis: 100,
                                          arrowColor: Colors.transparent,
                                          title: '  Discover',
                                          icon: Icons.search,
                                          textColor: _currentTab != 3
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          iconColor: _currentTab != 3
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          onPressed: () {
                                            _pageController.animateToPage(
                                              _currentTab = 3,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          }),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: UserWebsite(
                                          containerColor: null,
                                          iconSize: 35,
                                          padding: 5,
                                          raduis: 100,
                                          arrowColor: Colors.transparent,
                                          title: '  Profile',
                                          icon: Icons.account_circle,
                                          textColor: _currentTab != 4
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          iconColor: _currentTab != 4
                                              ? Colors.grey
                                              : ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                          onPressed: () {
                                            _pageController.animateToPage(
                                              _currentTab = 4,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.easeInOut,
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    AnimatedContainer(
                                      curve: Curves.easeInOut,
                                      duration: Duration(milliseconds: 800),
                                      height:
                                          _activityEventCount != 0 ? 80.0 : 0.0,
                                      width: width - 10,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                      ),
                                      child: Material(
                                          color: Colors.transparent,
                                          child: ListTile(
                                            leading: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Icon(
                                                Icons.info,
                                                color: _activityEventCount != 0
                                                    ? Colors.black
                                                    : Colors.transparent,
                                                size: 25.0,
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(Icons.event_available),
                                              iconSize: 25.0,
                                              color: _activityEventCount != 0
                                                  ? Colors.black
                                                  : Colors.transparent,
                                              onPressed: () {},
                                            ),
                                            title: Text(
                                                '${_activityEventCount.toString()}  Event Invitations',
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.black,
                                                )),
                                            subtitle: Text(
                                              'You have ${_activityEventCount.toString()} new event invititation activities you have not seen.',
                                              style: TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      ActivityEventInvitation(
                                                    currentUserId:
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .currentUserId!,
                                                    count: _activityEventCount,
                                                  ),
                                                )),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    NoConnection(),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Divider(color: Colors.grey),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 30, bottom: 30),
                                      child: Text(
                                        'Bars \nImpression',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w100,
                                            color: ConfigBloc().darkModeOn
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    Divider(color: Colors.grey),
                                    Container(
                                      color: Colors.grey[300],
                                      child: UpdateInfoMini(
                                        updateNote:
                                            widget.updateApp.updateNote!,
                                        showinfo:
                                            widget.updateAppVersion < _version
                                                ? true
                                                : false,
                                        displayMiniUpdate:
                                            widget.updateApp.displayMiniUpdate!,
                                        onPressed: () {
                                          StoreRedirect.redirect(
                                            androidAppId:
                                                "com.barsOpus.barsImpression",
                                            iOSAppId: "1610868894",
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 30),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SuggestionBox()));
                                        },
                                        child: Text(
                                          'Suggestion Box',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 30),
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AboutUs())),
                                        child: Text(
                                          'About us',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 30),
                                      child: GestureDetector(
                                        onTap: () => setState(() {
                                          _sendMail(
                                              'mailto:support@barsopus.com');
                                        }),
                                        child: Text(
                                          'Contact us',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: 30,
                        ),
                        Container(
                          width: 600,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                offset: Offset(0, 10),
                                blurRadius: 8.0,
                                spreadRadius: 2.0,
                              )
                            ],
                          ),
                          child: PageView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: <Widget>[
                              FeedScreenSliver(
                                currentUserId: currentUserId,
                              ),
                              ForumFeed(
                                currentUserId: currentUserId,
                              ),
                              EventsFeed(
                                currentUserId: currentUserId,
                              ),
                              DiscoverUser(
                                isWelcome: false,
                                currentUserId: currentUserId,
                              ),
                              ProfileScreen(
                                currentUserId: currentUserId,
                                userId: currentUserId,
                                user: _user,
                              ),
                            ],
                            onPageChanged: (int index) {
                              setState(() {
                                _currentTab = index;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
