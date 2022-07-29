import 'package:bars/utilities/exports.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  late ConfigBloc configBloc;
  late bool getKeepAlive;

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  setupApp() async {
    configBloc = ConfigBloc();
    configBloc.darkModeOn = Bars.prefs!.getBool(Bars.darkModePref) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => configBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return MyApp();
        },
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  Widget _getScreenId() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            Provider.of<UserData>(context).currentUserId = snapshot.data!.uid;
            return HomeScreen();
          } else {
            return Intro();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserData(),
      child: MaterialApp(
        title: 'Bars',
        debugShowCheckedModeBanner: false,
        home: _getScreenId(),
        routes: {
          WelcomeScreen.id: (context) => WelcomeScreen(),
          LoginScreen.id: (context) => LoginScreen(),
          SignpsScreen.id: (context) => SignpsScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AcceptTerms.id: (context) => AcceptTerms(),
          TipScreen.id: (context) => TipScreen(),
          StoreSearch.id: (context) => StoreSearch(
                user: null,
              ),
          Intro.id: (context) => Intro(),
          Password.id: (context) => Password(),
        },
      ),
    );
  }
}
