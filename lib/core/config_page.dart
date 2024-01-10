import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool getKeepAlive = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeData _darkTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        primaryColorLight: Color(0xFF343434),
        secondaryHeaderColor: Colors.white,
        primaryColor: Color(0xFF2a2a2a),
        primaryColorDark: Colors.grey[800],
        indicatorColor: Colors.blue[700],
        cardColor: Color(0xFF424242),
        unselectedWidgetColor: Color(0xFFd7d6d6),
        hintColor: Colors.white,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 24.0),
            //  24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
            // 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleSmall: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 18.0),
            // 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            // 16.0,
            color: Colors.white,
          ),
          displayMedium: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              //  14.0,

              color: Colors.white,
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            // 14.0,
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),

            //  12.0,
            color: Colors.white,
          ),
        ),
      );

  ThemeData _lightTheme(BuildContext context) => ThemeData(
        brightness: Brightness.light,
        primaryColorLight: Colors.white,
        secondaryHeaderColor: Colors.black,
        primaryColor: Colors.grey[300],
        primaryColorDark: Colors.grey,
        indicatorColor: Colors.blue[50],
        cardColor: Color(0xFFe3e3e3),
        unselectedWidgetColor: Color(0xFF5c5c5c),
        hintColor: Colors.blue,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 24.0),
            //  24.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
            // 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 18.0),
            //  18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            //  16.0,
            color: Colors.black,
          ),
          displayMedium: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              // 14.0,

              color: Colors.black,
              fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            //  14.0,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
            // 12.0,
            color: Colors.black,
          ),
        ),
      );

  ThemeData _currentTheme = ThemeData();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {
      _currentTheme =
          SchedulerBinding.instance.window.platformBrightness == Brightness.dark
              ? _darkTheme(context)
              : _lightTheme(context);
    });
  }

  _showBottomSheetErrorMessage(Object e) {
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
          title: 'We run into an issue ',
          subTitle: result,
        );
      },
    );
  }

//

  Widget _getScreenId() {
    final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
    final accountLocationPreferenceBox =
        Hive.box<UserSettingsLoadingPreferenceModel>(
            'accountLocationPreference');

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasError) {
            // Replace this with your own error handling code
            return _showBottomSheetErrorMessage(snapshot.error!);
            //  Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData) {
            var _provider = Provider.of<UserData>(context);
            _provider.currentUserId = snapshot.data!.uid;

            /// Check if the Hive box is not empty
            if (accountAuthorbox.isNotEmpty &&
                accountLocationPreferenceBox.isNotEmpty) {
              /// Fetch the data from the Hive box
              AccountHolderAuthor? _user = accountAuthorbox.getAt(0);
              UserSettingsLoadingPreferenceModel? _setting =
                  accountLocationPreferenceBox.getAt(0);
              SchedulerBinding.instance.addPostFrameCallback((_) {
                if (_provider.user == null || _provider.user != _user) {
                  _provider.setUser(_user!);
                }
                if (_provider.userLocationPreference == null ||
                    _provider.userLocationPreference != _setting) {
                  _provider.setUserLocationPreference(_setting!);
                }
                if (!_provider.isLoading) {
                  _provider.setIsLoading(false);
                }
              });
              // print('Username: ${_user!.userName} 1111');
              // print('Profile Handle: ${_user.profileHandle} 1111');

              /// Then return the appropriate widget
              return _user!.userName == null ||
                      _user.userName!.isEmpty ||
                      _user.profileHandle == null ||
                      _user.profileHandle!.isEmpty
                  ? AuthCreateUserCredentials()
                  : _user.disabledAccount!
                      ? ReActivateAccount(user: _user)
                      : HomeScreen();
            } else {
              return FutureBuilder(
                  future: Future.wait<dynamic>([
                    DatabaseService.getUserWithId(snapshot.data!.uid),
                    DatabaseService.getUserLocationSettingWithId(
                        snapshot.data!.uid),
                  ]),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    // Check if there's an error and display it
                    if (snapshot.hasError) {
                      Future.delayed(Duration.zero, () {
                        _showBottomSheetErrorMessage(snapshot.error!);
                      });
                    }

                    // If the futures have not completed yet, display a loading indicator
                    if (!snapshot.hasData) {
                      return PostSchimmerSkeleton();
                    }

                    // Check if the futures returned null, and if so, return AuthCreateUserCredentials()
                    if (snapshot.data![0] == null ||
                        snapshot.data![1] == null) {
                      return AuthCreateUserCredentials();
                    }

                    // If the futures returned valid data, continue as normal
                    AccountHolderAuthor _user =
                        snapshot.data![0] as AccountHolderAuthor;
                    UserSettingsLoadingPreferenceModel _setting =
                        snapshot.data![1] as UserSettingsLoadingPreferenceModel;

                    SchedulerBinding.instance.addPostFrameCallback((_) {
                      if (_provider.user == null || _provider.user != _user) {
                        _provider.setUser(_user);
                        accountAuthorbox.put(_user.userId, _user);
                      }
                      if (_provider.userLocationPreference == null ||
                          _provider.userLocationPreference != _setting) {
                        _provider.setUserLocationPreference(_setting);

                        accountLocationPreferenceBox.put(
                            _setting.userId, _setting);
                      }
                      if (!_provider.isLoading) {
                        _provider.setIsLoading(false);
                      }
                    });

                    if (_user.userName == null ||
                        _user.userName!.isEmpty ||
                        _user.profileHandle == null ||
                        _user.profileHandle!.isEmpty) {
                      return AuthCreateUserCredentials();
                    } else {
                      return _user.disabledAccount!
                          ? ReActivateAccount(user: _user)
                          : HomeScreen();
                    }
                  });
            }
          } else {
            return Intro();
          }
        });
  }

  // Widget _getScreenId() {
  //   final accountAuthorbox = Hive.box<AccountHolderAuthor>('currentUser');
  //   final accountLocationPreferenceBox =
  //       Hive.box<UserSettingsLoadingPreferenceModel>(
  //           'accountLocationPreference');

  //   return StreamBuilder<User?>(
  //       stream: FirebaseAuth.instance.authStateChanges(),
  //       builder: (context, AsyncSnapshot<User?> snapshot) {
  //         if (snapshot.hasError) {
  //           return _showBottomSheetErrorMessage(snapshot.error!);
  //         }
  //         if (snapshot.hasData) {
  //           var _provider = Provider.of<UserData>(context);
  //           _provider.currentUserId = snapshot.data!.uid;

  //           // if (accountAuthorbox.isNotEmpty &&
  //           //     accountLocationPreferenceBox.isNotEmpty) {
  //           //   AccountHolderAuthor? _user = accountAuthorbox.getAt(0);
  //           //   UserSettingsLoadingPreferenceModel? _setting =
  //           //       accountLocationPreferenceBox.getAt(0);

  //           //   if (_user != null && _setting != null) {
  //           //     _updateProvider(_provider, _user, _setting);
  //           //   }

  //           //   return _user != null &&
  //           //           !_user.userName!.isEmpty &&
  //           //           !_user.profileHandle!.isEmpty
  //           //       ? HomeScreen()
  //           //       : AuthCreateUserCredentials();
  //           // } else

  //           {
  //             return FutureBuilder(
  //                 future: Future.wait<dynamic>([
  //                   DatabaseService.getUserWithId(snapshot.data!.uid),
  //                   DatabaseService.getUserLocationSettingWithId(
  //                       snapshot.data!.uid),
  //                 ]),
  //                 builder: (BuildContext context,
  //                     AsyncSnapshot<List<dynamic>> snapshot) {
  //                   if (snapshot.hasError) {
  //                     Future.delayed(Duration.zero, () {
  //                       _showBottomSheetErrorMessage(snapshot.error!);
  //                     });
  //                   }

  //                   if (snapshot.data![0] == null ||
  //                       snapshot.data![1] == null) {
  //                     // return AuthCreateUserCredentials();
  //                   }

  //                   AccountHolderAuthor _user =
  //                       snapshot.data![0] as AccountHolderAuthor;
  //                   UserSettingsLoadingPreferenceModel _setting =
  //                       snapshot.data![1] as UserSettingsLoadingPreferenceModel;

  //                   _updateProvider(_provider, _user, _setting);

  //                   accountAuthorbox.put(_user.userId, _user);
  //                   accountLocationPreferenceBox.put(_setting.userId, _setting);

  //                   return

  //                       // _user.userName!.isNotEmpty &&
  //                       //         _user.profileHandle!.isNotEmpty
  //                       //     ?

  //                       HomeScreen();
  //                   // : AuthCreateUserCredentials();
  //                 });
  //           }
  //         } else {
  //           return Intro();
  //         }
  //       });
  // }

  void _updateProvider(UserData _provider, AccountHolderAuthor _user,
      UserSettingsLoadingPreferenceModel _setting) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_provider.user == null || _provider.user != _user) {
        _provider.setUser(_user);
      }
      if (_provider.userLocationPreference == null ||
          _provider.userLocationPreference != _setting) {
        _provider.setUserLocationPreference(_setting);
      }
      if (!_provider.isLoading) {
        _provider.setIsLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentTheme =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark
            ? _darkTheme(context)
            : _lightTheme(context);
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _currentTheme,
        home: _getScreenId(),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignpsScreen.id: (context) => SignpsScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AcceptTerms.id: (context) => AcceptTerms(),
          // StoreSearch.id: (context) => StoreSearch(),
          Intro.id: (context) => Intro(),
          Password.id: (context) => Password(),
        },
      ),
    );
  }
}
