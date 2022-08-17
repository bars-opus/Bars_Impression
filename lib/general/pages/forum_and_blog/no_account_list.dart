import 'package:bars/utilities/exports.dart';

class NoAccountList extends StatefulWidget {
  final String follower;

  NoAccountList({
    required this.follower,
  });

  @override
  _NoAccountListState createState() => _NoAccountListState();
}

class _NoAccountListState extends State<NoAccountList> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.follower.startsWith('Follower')
                    ? 'Followers'
                    : widget.follower.startsWith('Following')
                        ? 'Following'
                        : widget.follower.startsWith('Positive')
                            ? 'Positively Rating'
                            : widget.follower.startsWith('Negative')
                                ? 'Negatively Rating'
                                : '',
                style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(
                        widget.follower.startsWith('Follower')
                            ? Icons.people_outline
                            : widget.follower.startsWith('Following')
                                ? Icons.person_add_outlined
                                : widget.follower.startsWith('Positive')
                                    ? Icons.star_border_outlined
                                    : widget.follower.startsWith('Negative')
                                        ? Icons.star_border_outlined
                                        : widget.follower.startsWith('Blocked')
                                            ? Icons.people_outline
                                            : Icons.person_add_outlined,
                        color: Colors.grey,
                        size: 50.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.follower.startsWith('Follower')
                        ? 'No followers yet'
                        : widget.follower.startsWith('Following')
                            ? 'No followings yet'
                            : widget.follower.startsWith('Positive')
                                ? 'No positively ratings'
                                : widget.follower.startsWith('Negative')
                                    ? 'No negatively ratings'
                                    : '',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFFf2f2f2)
                            : Color(0xFF1a1a1a),
                        fontSize: 16.0,
                        height: 1),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30),
                    child: Text(
                      widget.follower.startsWith('Follower')
                          ? 'You don\'t have any followers yet. Make sure you have updated your profile with the necessary information and upload creative content for people to follow you.'
                          : widget.follower.startsWith('Following')
                              ? 'You are not following anybody yet. Follow people to see the contents they create and connect with them for collaborations.'
                              : widget.follower.startsWith('Positive')
                                  ? 'You have not rated creators positively'
                                  : widget.follower.startsWith('Negative')
                                      ? 'You have not rated creators negatively'
                                      : '',
                    
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12.0, height: 1),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
