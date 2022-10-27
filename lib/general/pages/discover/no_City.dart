import 'package:bars/utilities/exports.dart';

class NoCity extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  NoCity({
    required this.user,
    required this.currentUserId,
  });

  @override
  _NoCityState createState() => _NoCityState();
}

class _NoCityState extends State<NoCity> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          title: Material(
            color: Colors.transparent,
            child: Text(
              '',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  Text("Set up your City, Country and Continent. ",
                      style: TextStyle(
                          fontSize: width > 800 ? 40 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      '${widget.user.name},  go to edit profile and enter the name of your City, Country, and Continent. It helps you discover and get discovered by people living around you.',
                      style: TextStyle(
                        fontSize: width > 800 ? 18 : 14,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      ),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 2.0,
                    width: 10,
                    color: Colors.pink,
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.0, vertical: 3.0),
                    child: Text(
                      "Explore with it",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: width > 800 ? 18 : 14,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
