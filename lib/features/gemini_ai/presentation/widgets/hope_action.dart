import 'package:bars/utilities/exports.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';

import '../screens/_activity_summary.dart';

class HopeActions extends StatefulWidget {
  final UpdateApp updateApp;
  final bool showUpdate;
  final bool showAffiliateNote;

  const HopeActions(
      {required this.updateApp,
      required this.showUpdate,
      required this.showAffiliateNote,
      super.key});

  @override
  State<HopeActions> createState() => _HopeActionsState();
}

class _HopeActionsState extends State<HopeActions> {
  final _inputController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  PageController _pageController2 = PageController(
    initialPage: 0,
  );

  // final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _pageController2 = PageController(
      initialPage: 0,
    );
    _inputController.addListener(_oninputChanged);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _introAnimate();
      Provider.of<UserData>(context, listen: false).setInt2(0);
      Provider.of<UserData>(context, listen: false).setFlorenceActionChoice('');
    });
  }

  _introAnimate() async {
    await Future.delayed(Duration(microseconds: 2));

    animateToPage(1);
  }

  void _oninputChanged() {
    if (_inputController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  animateToPage(int index) {
    int page = _pageController2.page!.toInt() + index;
    _pageController2.animateToPage(
      page,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
    if (mounted) {
      _setInt2(page);
    }

    // _setInt2(page);
  }

  animateToBack(int index) {
    int page = _pageController2.page!.toInt() - index;
    // if (mounted) {
    _pageController2.animateTo(
      page.toDouble(),

      // Provider.of<UserData>(context, listen: false).int1 - index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );

    // }
    // print(page.toString());
  }

  _setInt2(int page) async {
    var _provider = Provider.of<UserData>(context, listen: false);
    await Future.delayed(Duration(seconds: 1));
    _provider.setInt2(page);
    if (_provider.int2 == 3) FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    super.dispose();

    _inputController.dispose();
  }

  _animatedContainer(double? height, Widget child, Duration? duration,
      BoxDecoration? decoration) {
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: duration == null ? Duration(milliseconds: 800) : duration,
        height: height,
        decoration: decoration,
        child: child);
  }

  _florenceButton(
      VoidCallback onPressed1,
      IconData icon1,
      String buttonText1,
      VoidCallback onPressed2,
      IconData icon2,
      String buttonText2,
      int duration,
      bool isOne) {
    var _provider = Provider.of<UserData>(context);
    double _progress =
        _pageController2.hasClients ? _pageController2.page ?? 0 : 1;
    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 50),
      // width: ResponsiveHelper.responsiveFontSize(context, 100),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: duration),
        height: 0 + _progress * 60,
        // heigh: double.infinity,
        width: double.infinity,
        //  curve: Curves.linearToEaseOut,

        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
            color: _provider.int2 == 1
                ? Colors.black54
                : Colors.grey.withOpacity(.8),
            borderRadius: BorderRadius.circular(_provider.int2 == 1 ? 20 : 0)),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HopeActionButton(
                  isOne: isOne,
                  ready: _provider.int2 == 1 ? true : false,
                  onPressed: onPressed1,
                  icon: icon1,
                  title: buttonText1),
              if (!isOne)
                Container(
                  color: Colors.grey,
                  height: 60,
                  width: 1,
                ),
              if (!isOne)
                HopeActionButton(
                    ready: _provider.int2 == 1 ? true : false,
                    onPressed: onPressed2,
                    icon: icon2,
                    title: buttonText2),
            ],
          ),
        ),
      ),
    );
  }

  _animatedContainerWrapper(bool value, Widget child) {
    return IgnorePointer(
      ignoring: !value,
      child: AnimatedOpacity(
          opacity: value ? 1.0 : 0.0,
          duration: Duration(milliseconds: 1300),
          curve: Curves.easeInOut,
          child: child),
    );
  }

  _promptInput(String gidance) {
    return Container(
      height: 600,
      child: ListView(children: [
        _inputController.text.trim().isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: Align(
                    alignment: Alignment.centerRight,
                    child: MiniCircularProgressButton(
                        color: Colors.blue,
                        text: 'next',
                        onPressed: () {
                          animateToPage(1);
                        })),
              )
            : SizedBox(
                height: 60,
              ),
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: UnderlinedTextField(
              isFlorence: true,
              autofocus: true,
              controler: _inputController,
              labelText: 'Enter',
              hintText: '',
              onValidateText: () {},
            ),
          ),
        ),
        Text(gidance,
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
              color: Colors.white,
            )),
      ]),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomEditLocation(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 400,
          buttonText: 'set up city',
          onPressed: () async {
            Navigator.pop(context);
            // _navigateToPage(
            //     context,
            //     EditProfileSelectLocation(
            //       user: _userLocation!,
            //       notFromEditProfile: true,
            //     ));
          },
          title: 'Set up your city',
          subTitle:
              'In order to create an event, it is necessary to set up your city information. This enables us to provide targeted public event suggestions to individuals residing in close proximity to you, as well as recommend local public events that may be of interest to you. Please note that providing your precise location or community details is not required; specifying your city is sufficient.',
        );
      },
    );
  }

  void _showBottomSheetErrorMessage(String e) {
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
          title: e,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  _noInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection
      _showBottomSheetErrorMessage('No internet connection available. ');
      return;
    } else {}
  }

  _options() {
    var _provider = Provider.of<UserData>(context);

    var _userLocation = _provider.userLocationPreference;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_provider.florenceActive)
          Center(
            child: ShakeTransition(
                axis: Axis.vertical,
                duration: Duration(seconds: 2),
                child: AnimatedCircle(
                  size: 30,
                  stroke: 2,
                  animateSize: _provider.int2 == 1 ? true : false,
                  animateShape: _provider.int2 == 1 ? true : false,
                )),
          ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Text(
            "Whats up?",
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 30),
              color: Colors.white,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 800),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: _provider.int2 == 1
                  ? Colors.white.withOpacity(.8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _animatedContainer(
                    _provider.int2 == 1 ? 20 : 0,
                    Text(
                      "   Actions",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Duration(seconds: 2),
                    null),
                _florenceButton(() {
                  _provider.setFlorenceActionChoice('SearchEvent');
                  animateToPage(1);
                },
                    Icons.search,
                    'Look for event',
                    _userLocation != null
                        ? () {
                            _provider.setFlorenceActive(
                                _provider.florenceActive ? false : true);

                            // _userLocation.city!.isEmpty
                            //     ? _showBottomEditLocation(context)
                            //     : _navigateToPage(
                            //         context,
                            //         CreateEventScreen(
                            //           isEditting: false,
                            //           event: null,
                            //           isCompleted: false,
                            //           isDraft: false,
                            //         ));
                          }
                        : () {},
                    Icons.add,
                    'Create event',
                    800,
                    false),
                _florenceButton(
                  () {
                    animateToPage(2);
                  },
                  Icons.people_outline_outlined,
                  'Brand matching',
                  () {
                    _provider.setFlorenceActionChoice('bookCreative');
                    animateToPage(1);
                  },
                  Icons.call,
                  'Book a creative',
                  1400,
                  true,
                ),
              ]),
        ),
        const SizedBox(
          height: 10,
        ),
        AnimatedContainer(
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 800),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: _provider.int2 == 1
                  ? Colors.white.withOpacity(.8)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20)),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _animatedContainer(
                    _provider.int2 == 1 ? 20 : 0,
                    Text(
                      "   Analyse",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12),
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Duration(seconds: 2),
                    null),
                _florenceButton(
                  () async {
                    await _noInternet();
                    _provider.setFlorenceActionChoice('notification');
                    animateToPage(1);
                  },
                  Icons.notifications_active_outlined,
                  'Notifications',
                  () async {
                    await _noInternet();
                    animateToPage(1);
                    _provider.setFlorenceActionChoice('myTickets');
                  },
                  Icons.payment_outlined,
                  'Tickets',
                  1200,
                  false,
                ),
                _florenceButton(
                  () async {
                    await _noInternet();
                    animateToPage(1);
                    _provider.setFlorenceActionChoice('eventsCreated');
                  },
                  Icons.event,
                  'Events created',
                  () async {
                    await _noInternet();
                    animateToPage(1);
                    _provider.setFlorenceActionChoice('invites');
                  },
                  FontAwesomeIcons.idBadge,
                  'Invites',
                  1200,
                  false,
                ),
              ]),
        ),
      ],
    );
  }

  _prompts() {
    var _provider = Provider.of<UserData>(context);
    return _provider.florenceActionChoice == 'SearchEvent'
        ? HopeSearch(
            isEvent: true,
          )
        : _provider.florenceActionChoice == 'bookCreative'
            ? HopeSearch(
                isEvent: false,
              )
            : _provider.florenceActionChoice == 'notification'
                ? ActivitySummary(
                    showAffiliateNote: widget.showAffiliateNote,
                    updateApp: widget.updateApp,
                    showUpdate: widget.showUpdate,
                  )
                // : _provider.florenceActionChoice == 'myTickets'
                //     ? TicketsSummary()
                // :
                //  _provider.florenceActionChoice == 'eventsCreated'
                //     ? EventCreatedSummary()
                //     :
                // _provider.florenceActionChoice == 'invites'
                //     ? InviteSummary()
                : _promptInput('Not sure what you want?');
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);

    return _animatedContainerWrapper(
      _provider.florenceActive,
      GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: _provider.int2 == 2 ? true : false,
            backgroundColor: Colors.black.withOpacity(.8),
            body: Padding(
              padding: EdgeInsets.all(
                  _provider.florenceActionChoice == 'SearchEvent' ||
                          _provider.florenceActionChoice == 'bookCreative' ||
                          _provider.florenceActionChoice == 'notification' ||
                          _provider.florenceActionChoice == 'myTickets' ||
                          _provider.florenceActionChoice == 'invites' ||
                          _provider.florenceActionChoice == 'eventsCreated'
                      ? 0
                      : _provider.int2 == 3
                          ? 5
                          : 15.0),
              child: PageView(
                  scrollDirection: Axis.vertical,
                  controller: _pageController2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SizedBox(),
                    _options(),
                    _prompts(),
                    UserBrandMatching(
                      eventId: '',
                    ),
                  ]),
            )),
      ),
    );
  }
}
