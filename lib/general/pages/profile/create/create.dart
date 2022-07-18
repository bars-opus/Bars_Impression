import 'package:bars/utilities/exports.dart';

class CreateContents extends StatefulWidget {
  final AccountHolder user;

  CreateContents({required this.user});
  static final id = 'Create';

  @override
  _CreateContentsState createState() => _CreateContentsState();
}

class _CreateContentsState extends State<CreateContents> {
  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          title: Text(
            '',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateForum(
                            user: widget.user,
                          ),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.transparent
                                    : Colors.grey[500]!,
                                offset: Offset(4.0, 4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                              ),
                              BoxShadow(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.transparent
                                    : Colors.white,
                                offset: Offset(-4.0, -4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                              )
                            ]),
                        child: Container(
                          height: width / 4,
                          width: width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.forum,
                                color: Color(0xFF1a1a1a),
                                size: 40.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Forum',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateEvent(
                            user: widget.user,
                          ),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.transparent
                                    : Colors.grey[500]!,
                                offset: Offset(4.0, 4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                              ),
                              BoxShadow(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.transparent
                                    : Colors.white,
                                offset: Offset(-4.0, -4.0),
                                blurRadius: 15.0,
                                spreadRadius: 1.0,
                              )
                            ]),
                        child: Container(
                          height: width / 4,
                          width: width / 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.event,
                                color: Color(0xFF1a1a1a),
                                size: 40.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Material(
                                color: Colors.transparent,
                                child: Text(
                                  'Event',
                                  style: TextStyle(
                                      color: Color(0xFF1a1a1a), fontSize: 12.0),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 70.0,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Text(
                        "CREATE",
                        style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.grey
                                : Colors.black,
                            fontSize: 20,
                            letterSpacing: 7,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Create forums to share ideas and discuss topics in the music industry. Create flyers of events and invite people to come and share great experiences with you.",
                      style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Colors.grey
                            : Colors.black,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
