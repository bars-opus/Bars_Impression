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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width - 100;
    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      body: SafeArea(
        child: Center(
          child: ListView(children: <Widget>[
            SizedBox(
              height: 25.0,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MyWebView(
                                  url: 'https://www.barsopus.com/',
                                )));
                  },
                  child: Row(
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                        children: [
                          TextSpan(
                              text: "About Bars Impression?",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              )),
                        ],
                        style: TextStyle(color: Colors.blue),
                      )),
                      SizedBox(width: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.pink,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          child: Text(
                            'Tap here',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: width,
                    height: width,
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
                            child: Container(
                              height: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF1a1a1a),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset('assets/images/1.png',
                                      fit: BoxFit.cover)),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF1a1a1a),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/2.png',
                                    fit: BoxFit.cover)),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF1a1a1a),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/images/3.png',
                                    fit: BoxFit.cover)),
                          ),
                        ]),
                  ),
                  ShakeTransition(
                    curve: Curves.fastOutSlowIn,
                    duration: const Duration(milliseconds: 600),
                    child: Hero(
                      tag: 'Sign In',
                      child: Container(
                        width: 250.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 20.0,
                            onPrimary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoginScreenOptions(
                                  from: 'Sign in',
                                ),
                              )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width > 800 ? 24 : 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: width > 800 ? 40.0 : 20),
                  ShakeTransition(
                    axis: Axis.vertical,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.fastOutSlowIn,
                    child: Hero(
                      tag: 'Sign Up',
                      child: Container(
                        width: 250.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 20.0,
                            onPrimary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AcceptTerms(),
                              )),

                          //  Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => SignpsScreen(),
                          //     )),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: width > 800 ? 24 : 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyWebView(
                                    url:
                                        'https://www.barsopus.com/terms-of-use',
                                  )));
                    },
                    child: Text(
                      'Terms of Use',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: width > 800 ? 18 : 12,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => MyWebView(
                                    url: 'https://www.barsopus.com/privacy',
                                  )));
                    },
                    child: Text(
                      'Privacy',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: width > 800 ? 18 : 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
