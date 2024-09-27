import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';

class WelcomeScreen extends StatefulWidget {
  static final id = 'Welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _index = 0;
  List imgList = [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
  ];

  List<Page> map<Page>(List list, Function handler) {
    List<Page> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_index < 2) {
        _index++;
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _index,
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _index = 0;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(
            _index,
          );
        }
      }
    });
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
    });
  }

  _documentText(String title, String url) {
    return GestureDetector(
      onTap: () async {
        if (!await launchUrl(Uri.parse(url))) {
          throw 'Could not launch link';
        }
        // _navigateToPage(MyWebView( title: '',
        //   url: url,
        // ));
      },
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _imageContainer(String url) {
    return Container(
      height: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF1a1a1a),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(url, fit: BoxFit.cover)),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveFontSize(context, 400),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LoginScreenOptions(
                from: 'Sign in',
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 25.0,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ResponsiveHelper.responsiveWidth(context, 200),
                      height: ResponsiveHelper.responsiveWidth(context, 200),
                      child: PageView(
                          controller: _pageController,
                          allowImplicitScrolling: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          onPageChanged: (int index) {
                            setState(() {
                              _index = index;
                            });
                          },
                          children: [
                            ShakeTransition(
                              axis: Axis.vertical,
                              child: _imageContainer(
                                'assets/images/1.png',
                              ),
                            ),
                            _imageContainer(
                              'assets/images/2.png',
                            ),
                            _imageContainer(
                              'assets/images/3.png',
                            ),
                          ]),
                    ),
                    SizedBox(height: 20),
                    SignUpButton(
                      buttonText: 'Sign in',
                      onPressed: () {
                        _showBottomSheet();
                        // _navigateToPage(
                        //   LoginScreenOptions(
                        //     from: 'Sign in',
                        //   ),
                        // );
                      },
                    ),
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 10),
                    ),
                    SignUpButton(
                      buttonText: 'Create account',
                      onPressed: () {
                        _navigateToPage(
                          AcceptTerms(),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    _documentText(
                      'Privacy',
                      'https://www.barsopus.com/privacy',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _documentText(
                      'Terms of Use',
                      'https://www.barsopus.com/terms-of-use',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _documentText(
                      'More about us.',
                      'https://www.barsopus.com/',
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
