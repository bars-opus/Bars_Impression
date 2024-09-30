import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hive_flutter/hive_flutter.dart';

class ProfileSettings extends StatefulWidget {
  final AccountHolderAuthor user;

  ProfileSettings({
    required this.user,
  });

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  bool _isLoadingGeneralSettins = false;
  bool _isLoading = false;

  void _showBottomSheetErrorMessage(String title, String error) {
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
          subTitle: error,
        );
      },
    );
  }

  static final _auth = FirebaseAuth.instance;
  void _logOutUser() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.currentUserId = '';
    try {
      setState(() {
        _isLoading = true;
      });
      // Helper function to clear a box
      Future<void> _clearBox<T>(String boxName) async {
        Box<T> box;
        if (Hive.isBoxOpen(boxName)) {
          box = Hive.box<T>(boxName);
        } else {
          box = await Hive.openBox<T>(boxName);
        }
        await box.clear();
      }

      await usersGeneralSettingsRef
          .doc(_auth.currentUser!.uid)
          .update({'androidNotificationToken': ''});
      // Clear all the required Hive boxes
      await _clearBox<ChatMessage>('chatMessages');
      await _clearBox<Chat>('chats');
      await _clearBox<AccountHolderAuthor>('accountHolderAuthor');
      await _clearBox<TicketIdModel>('ticketIds');
      await _clearBox<AccountHolderAuthor>('currentUser');
      await _clearBox<UserSettingsLoadingPreferenceModel>(
          'accountLocationPreference');
      await AffiliateManager.clearAllEventAffiliates();
      await _auth.signOut();
      _provider.setUserGeneralSettings(null);
      _provider.setUserLocationPreference(null);
      _provider.setIsLoading(false);
      _provider.setUser(null);

      HapticFeedback.lightImpact();
      setState(() {
        _isLoading = false;
      });
      // // Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (Route<dynamic> route) => false);
      mySnackBar(context, 'Logged Out');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      String error = e.toString();
      String result = error.contains(']')
          ? error.substring(error.lastIndexOf(']') + 1)
          : error;
      _showBottomSheetErrorMessage('Failed to log out', result);
    }
  }

  Future<void> _sendMail(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not launch mail');
    }
  }

  void _showBottomSheetLogOut() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Log Out',
          onPressed: () {
            Navigator.pop(context);

            _logOutUser();
          },
          title: 'Are you sure you want to log out of this account?',
          subTitle: '',
        );
      },
    );
  }

  _aboutBars() {
    showAboutDialog(
        context: context,
        applicationName: 'Bars Impression',
        applicationVersion: 'Version 2.2.1',
        applicationIcon: Container(
          width: 40,
          height: 40,
          child: Image.asset(
            'assets/images/barsw.png',
            color: Colors.black,
          ),
        ),
        children: [
          Column(children: <Widget>[
            RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Version Release Date: September 2024\n",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.black,
                        )),
                    TextSpan(
                        text: "Language: English.",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.black,
                        )),
                  ],
                )),
          ])
        ]);
  }

  void _showBottomSheetAboutUs(BuildContext contextm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height.toDouble() / 1.2,
          decoration: BoxDecoration(
              color: Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/barsw.png',
                      height: 50, width: 50, fit: BoxFit.cover)),
              SizedBox(height: 50),
              Divider(
                thickness: .2,
                color: Colors.grey,
              ),
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                        Uri.parse('https://www.barsopus.com/contact'))) {
                      throw 'Could not launch link';
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MyWebView(
                    //               url: 'https://www.barsopus.com/contact',
                    //               title: '',
                    //             )));
                  },
                  child: Text(
                    'Contact us',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                        Uri.parse('https://www.barsopus.com/terms-of-use'))) {
                      throw 'Could not launch link';
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MyWebView(
                    //               url: 'https://www.barsopus.com/terms-of-use',
                    //               title: '',
                    //             )));
                  },
                  child: Text(
                    'Terms of use',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: () async {
                    if (!await launchUrl(
                        Uri.parse('https://www.barsopus.com/privacy'))) {
                      throw 'Could not launch link';
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MyWebView(
                    //               title: '',
                    //               url: 'https://www.barsopus.com/privacy',
                    //             )));
                  },
                  child: Text(
                    'Privacy policies',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: GestureDetector(
                  onTap: _aboutBars,
                  child: Text(
                    'App info',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14.0),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.copyright,
                    size: 15,
                    color: Colors.white,
                  ),
                  Text(
                    ' BARS OPUS LTD',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _accountRegistryInfo() {
    var _userLocation =
        Provider.of<UserData>(context, listen: false).userLocationPreference;
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
      text: TextSpan(
        children: [
          TextSpan(
            text: 'You registered your account on \n',
          ),
          TextSpan(
            text: MyDateFormat.toDate(_userLocation!.timestamp!.toDate()),
          ),
          TextSpan(
            text: ', at ${MyDateFormat.toTime(
              _userLocation.timestamp!.toDate(),
            )}.',
          ),
          TextSpan(
            text: '\n' +
                timeago.format(
                  _userLocation.timestamp!.toDate(),
                ),
          ),
        ],
        style: TextStyle(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
          color: Colors.grey,
        ),
      ),
      textAlign: TextAlign.center,
    );
  }

  _divider() {
    return Container(
      color: Colors.grey,
      height: 0.5,
    );
  }

  _settingCategoryColumn(Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 10.0, top: 10, bottom: 10, left: 30),
            child: widget,
          )),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomDraft(BuildContext context, List<Event> eventsList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventDrafts(eventsList: eventsList);
      },
    );
  }

  // final _googleGenerativeAIService = GoogleGenerativeAIService();
  // String _generatedResponse = '';

  // Future<void> _generateResponse(String prompt) async {
  //   final response = await _googleGenerativeAIService.generateResponse(prompt);
  //   setState(() {
  //     _generatedResponse = response!;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var provider = Provider.of<UserData>(
      context,
    );

    var _userLocation = _provider.userLocationPreference;

    return EditProfileScaffold(
      title: 'Account Settings',
      widget: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _divider(),
          _settingCategoryColumn(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IntroInfo(
                  isLoading: _isLoadingGeneralSettins,
                  leadingIcon: Icons.notifications_active_outlined,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Notification settings',
                  onPressed: () async {
                    if (_isLoadingGeneralSettins) return;
                    _isLoadingGeneralSettins = true;
                    try {
                      UserSettingsGeneralModel? userGeneralSettings =
                          await DatabaseService.getUserGeneralSettingWithId(
                        widget.user.userId!,
                      );

                      if (userGeneralSettings != null) {
                        _navigateToPage(
                          context,
                          ProfileSettingsNotification(
                            userGeneralSettings: userGeneralSettings,
                          ),
                        );
                      } else {
                        _showBottomSheetErrorMessage(
                            'Failed to fetch settings.',
                            'Check your internet connection and try again');
                      }
                    } catch (e) {
                      _showBottomSheetErrorMessage('Failed to fetch settings.',
                          'Check your internet connection and try again');
                    } finally {
                      _isLoadingGeneralSettins = false;
                    }
                  },
                  subTitle: "Customize your notification.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                // IntroInfo(
                //   leadingIcon: Icons.calendar_month_outlined,
                //   titleColor: Theme.of(context).secondaryHeaderColor,
                //   title: 'Booking',
                //   onPressed: () {
                //     _navigateToPage(
                //       context,
                //       UserBooking(
                //         currentUserId: widget.user.userId!,
                //       ),
                //     );
                //   },
                //   subTitle: "Your booking information.",
                //   icon: Icons.arrow_forward_ios_outlined,
                // ),
                // Divider(
                //   thickness: .2,
                //   color: Colors.grey,
                // ),
                IntroInfo(
                  isLoading: provider.isLoading,
                  leadingIcon: Icons.event_outlined,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Event drafts',
                  onPressed: () async {
                    _provider.setIsLoading(true);
                    Query eventQuery = await eventsDraftRef
                        .doc(widget.user.userId)
                        .collection('events')
                        .orderBy('timestamp', descending: true);
                    QuerySnapshot postFeedSnapShot = await eventQuery.get();

                    List<Event> events = await postFeedSnapShot.docs
                        .map((doc) => Event.fromDoc(doc))
                        .toList();
                    _provider.setIsLoading(false);

                    _showBottomDraft(context, events);
                  },
                  subTitle: "unpublished events.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: MdiIcons.transfer,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Payouts',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      UserPayouts(
                        currentUserId: widget.user.userId!,
                      ),
                    );
                  },
                  subTitle: "Payout for event ticket sales.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: Icons.request_quote_outlined,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Refunds',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      UserRefunds(
                        currentUserId: widget.user.userId!,
                      ),
                    );
                  },
                  subTitle: "Refund for tickets.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: Icons.attach_money,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Affiliates',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      UserAffilate(
                        currentUserId: widget.user.userId!,
                        eventId: '',
                        marketingType: '',
                        isUser: true,
                        fromActivity: false,
                      ),
                    );
                  },
                  subTitle: "Your affiliate marketing.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: MdiIcons.vectorLink,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Tags',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      UserTags(
                        currentUserId: widget.user.userId!,
                        eventId: '',
                        marketingType: '',
                        isUser: true,
                        fromActivity: false,
                      ),
                    );
                  },
                  subTitle:
                      "Events and collaborations you have been tagged in.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                // IntroInfo(
                //   leadingIcon: MdiIcons.giftOutline,
                //   titleColor: Theme.of(context).secondaryHeaderColor,
                //   title: 'Donations',
                //   onPressed: () {
                //     _navigateToPage(
                //       context,
                //       UserDonations(
                //         currentUserId: widget.user.userId!,
                //       ),
                //     );
                //   },
                //   subTitle: "Donations received and donations made.",
                //   icon: Icons.arrow_forward_ios_outlined,
                // ),
                // Divider(
                //   thickness: .2,
                //   color: Colors.grey,
                // ),
                // IntroInfo(
                //   leadingIcon: Icons.star_border_outlined,
                //   titleColor: Theme.of(context).secondaryHeaderColor,
                //   title: 'Reviews',
                //   onPressed: () {
                //     _navigateToPage(
                //       context,
                //       UserReviews(
                //         currentUserId: widget.user.userId!,
                //       ),
                //     );
                //   },
                //   subTitle: "Reviews received and reviews made.",
                //   icon: Icons.arrow_forward_ios_outlined,
                // ),
                // Divider(
                //   thickness: .2,
                //   color: Colors.grey,
                // ),
                IntroInfo(
                  leadingIcon: Icons.block,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Blocked Accounts',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      BlockedAccounts(),
                    );
                  },
                  subTitle: "Accounts you have blocked.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: Icons.bug_report_outlined,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Complaints',
                  onPressed: () {
                    _navigateToPage(
                      context,
                      UserComplaints(
                        currentUserId: widget.user.userId!,
                      ),
                    );
                  },
                  subTitle: "Your issue complaints to Bars Impression.",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
                Divider(
                  thickness: .2,
                  color: Colors.grey,
                ),
                IntroInfo(
                  leadingIcon: Icons.delete_outlined,
                  titleColor: Theme.of(context).secondaryHeaderColor,
                  title: 'Delete Account',
                  onPressed: () {
                    _navigateToPage(
                        context,
                        DeleteAccount(
                          user: widget.user,
                        ));
                  },
                  subTitle: "Delete your account",
                  icon: Icons.arrow_forward_ios_outlined,
                ),
              ],
            ),
          ),
          _divider(),
          _settingCategoryColumn(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: IntroInfo(
                    title: 'Share Account',
                    onPressed: () {
                      Share.share(widget.user.dynamicLink!);
                    },
                    subTitle: "Share your account with other people.",
                    icon: Icons.share,
                  ),
                ),
                Divider(thickness: .2, color: Colors.grey),
                GestureDetector(
                  onTap: () {},
                  child: IntroInfo(
                    title: 'Invite people',
                    onPressed: () {
                      Share.share(widget.user.dynamicLink!);
                    },
                    subTitle:
                        "Invite your friends and other music creatives to use Bars impression.",
                    icon: Icons.people,
                  ),
                ),
                Divider(thickness: .2, color: Colors.grey),
                GestureDetector(
                  onTap: () => _navigateToPage(context, FeatureSurvey()),
                  child: IntroInfo(
                    onPressed: () => _navigateToPage(context, FeatureSurvey()),
                    title: 'Take a Survey',
                    subTitle:
                        "Take a survey and let us know what you think about Bars Impression.",
                    icon: Icons.arrow_forward_ios_outlined,
                  ),
                ),
              ],
            ),
          ),
          // ElevatedButton(
          //   onPressed: () => _generateResponse(
          //       'What would be the wather conditon on july 21 in Tema Ghana'),
          //   child: Text('Generate Response'),
          // ),
          // SizedBox(height: 16.0),
          // if (_generatedResponse.isNotEmpty)
          //   Text(
          //     'Generated Response:\n$_generatedResponse',
          //     style: TextStyle(fontSize: 16.0),
          //   ),
          _divider(),
          const SizedBox(height: 30),
          if (_userLocation != null) _accountRegistryInfo(),
          _isLoading
              ? CircularProgress(
                  isMini: true,
                  indicatorColor: Colors.blue,
                )
              : Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 40),
                    child: BlueOutlineButton(
                      buttonText: 'Log Out',
                      onPressed: () {
                        _showBottomSheetLogOut();
                      },
                    ),
                  ),
                ),
          const SizedBox(height: 40),
          IconButton(
            icon: Icon(Icons.close),
            iconSize: 30.0,
            color: Colors.grey,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                _showBottomSheetAboutUs(
                  context,
                );
              },
              child: Text(
                'About Us.',
                style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () => setState(() {
                _sendMail('mailto:support@barsopus.com');
              }),
              child: Text(
                'Contact us',
                style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 70),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse('https://www.barsopus.com/'))) {
                throw 'Could not launch link';
              }
            },
            child: Text(
              '          BARS IMPRESSION',
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 11.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (!await launchUrl(Uri.parse('https://www.barsopus.com/'))) {
                throw 'Could not launch link';
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copyright,
                  size: 15,
                  color: Colors.blueGrey,
                ),
                Text(
                  ' BARS OPUS LTD',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 11.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
