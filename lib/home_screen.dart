import 'package:bars/utilities/local_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:bars/utilities/exports.dart';
import 'package:store_redirect/store_redirect.dart';

class HomeScreen extends StatefulWidget {
  static final id = 'Home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  int _updateAppVersion = Platform.isIOS ? 5 : 5;
  late PageController _pageController;
  String notificationMsg = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    LocalNotificationService.initilize();
    _configureNotification();
    _setUpUser();
  }

  _setUpUser() async {
    final String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    AccountHolder profileUser =
        await DatabaseService.getUserWithId(currentUserId);
    if (mounted) {
      setState(() {
        Provider.of<UserData>(context, listen: false).setUser(profileUser);
      });
    }
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "${event.notification!.title}: " + "${event.notification!.body}",
            overflow: TextOverflow.ellipsis,
          ),
        ));
        LocalNotificationService.showNotificationOnForeground(event);
        setState(() {
          notificationMsg =
              "${event.notification!.title}  ${event.notification!.body}";
        });
      }
    });
  }

  _aboutBars() {
    showAboutDialog(
      context: context,
      applicationName: 'Bars Impression',
      applicationIcon: Container(
        width: 30,
        height: 30,
        child: Image.asset(
          'assets/images/barsw.png',
          color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
      ),
    );
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
          'Could luanch mail',
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
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: FutureBuilder(
          future: DatabaseService.getUpdateInfo(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return PostSchimmerSkeleton();
            }
            UpdateApp _updateApp = snapshot.data;
            int? version = Platform.isIOS
                ? _updateApp.updateVersionIos
                : _updateApp.updateVersionAndroid;
            return NestedScrollView(
                headerSliverBuilder: (context, innerBoxScrolled) => [],
                body: Responsive.isDesktop(context)
                    ? Scaffold(
                        backgroundColor: ConfigBloc().darkModeOn
                            ? Color(0xFF1f2022)
                            : Color(0xFFf2f2f2),
                        body: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
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
                                child: SafeArea(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                            icon: Icons.forum,
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
                                      Divider(color: Colors.grey),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, left: 30, bottom: 30),
                                        child: Text(
                                          'Bars \nImpression',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                              color: ConfigBloc().darkModeOn
                                                  ? Colors.white
                                                  : Colors.black),
                                        ),
                                      ),
                                      Divider(color: Colors.grey),
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
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 30.0, left: 30),
                                        child: GestureDetector(
                                          onTap: _aboutBars,
                                          child: Text(
                                            'App Infomation',
                                            style:
                                                TextStyle(color: Colors.blue),
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
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                      )
                    :
                    // _updateApp == null

                    //     ?
                    _updateAppVersion < version! &&
                            _updateApp.displayFullUpdate!
                        ? UpdateAppInfo(
                            updateNote: _updateApp.updateNote!,
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
                              child: Provider.of<UserData>(context,
                                          listen: false)
                                      .user!
                                      .disabledAccount!
                                  ? ReActivateAccount(
                                      user: Provider.of<UserData>(context,
                                              listen: false)
                                          .user!)
                                  : Stack(
                                      children: [
                                        Container(
                                          height: double.infinity,
                                          width: double.infinity,
                                          child: PageView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
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
                                            child: GestureDetector(
                                                child: UpdateInfoMini(
                                              updateNote:
                                                  _updateApp.updateNote!,
                                              showinfo:
                                                  _updateAppVersion < version
                                                      ? true
                                                      : false,
                                              displayMiniUpdate:
                                                  _updateApp.displayMiniUpdate!,
                                              onPressed: () {
                                                StoreRedirect.redirect(
                                                  androidAppId:
                                                      "com.barsOpus.barsImpression",
                                                  iOSAppId: "1610868894",
                                                );

                                              },
                                            ))),
                                        Positioned(
                                            bottom: 7, child: NoConnection()),
                                      ],
                                    ),
                            ),
                            bottomNavigationBar: Provider.of<UserData>(context,
                                        listen: false)
                                    .user!
                                    .disabledAccount!
                                ? SizedBox.shrink()
                                : Container(
                                    child: Wrap(
                                      children: [
                                        CupertinoTabBar(
                                          backgroundColor:
                                              ConfigBloc().darkModeOn
                                                  ? Color(0xFF1a1a1a)
                                                  : Colors.white,
                                          currentIndex: _currentTab,
                                          onTap: (int index) {
                                            setState(() {
                                              _currentTab = index;
                                            });

                                            _pageController.animateToPage(
                                              index,
                                              duration:
                                                  Duration(milliseconds: 10),
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height: 2,
                                                        curve: Curves.easeInOut,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _currentTab ==
                                                                  0
                                                              ? Colors.blue
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    child: Icon(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height: 2,
                                                        curve: Curves.easeInOut,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _currentTab ==
                                                                  1
                                                              ? Colors.blue
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    child: Icon(Icons.forum,
                                                        size: 25.0),
                                                  ),
                                                ],
                                              ),
                                              label: 'Forum',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height: 2,
                                                        curve: Curves.easeInOut,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _currentTab ==
                                                                  2
                                                              ? Colors.blue
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    child: Icon(Icons.event,
                                                        size: 25.0),
                                                  ),
                                                ],
                                              ),
                                              label: 'Event',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height: 2,
                                                        curve: Curves.easeInOut,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _currentTab ==
                                                                  3
                                                              ? Colors.blue
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    child: Icon(Icons.search,
                                                        size: 25.0),
                                                  ),
                                                ],
                                              ),
                                              label: 'Discover',
                                            ),
                                            BottomNavigationBarItem(
                                              icon: Column(
                                                children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0.0),
                                                      child: AnimatedContainer(
                                                        duration: Duration(
                                                            milliseconds: 500),
                                                        height: 2,
                                                        curve: Curves.easeInOut,
                                                        width: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _currentTab ==
                                                                  4
                                                              ? Colors.blue
                                                              : Colors
                                                                  .transparent,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    child: Icon(
                                                        Icons.account_circle,
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
                          )
                // : SizedBox.shrink(),
                );
          }),
    );
  }
}
