import 'package:bars/utilities/exports.dart';

class StartChat extends StatefulWidget {
  final AccountHolder user;
  final String currentUserId;
  static final id = 'Create_forum';

  StartChat({required this.user, required this.currentUserId});

  @override
  _StartChatState createState() => _StartChatState();
}

class _StartChatState extends State<StartChat> {
  _chat() async {
    AccountHolderAuthor user =
        await DatabaseService.getUserAuthorWithId(widget.user.id!);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatMessageScreen(
          chat: null,
          user: user,
          currentUserId: widget.currentUserId,
          fromProfile: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Colors.teal[400] : Color(0xFF064635),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Colors.teal[400] : Color(0xFF064635),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ShakeTransition(
                  child: new Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Icon(
                          Icons.send,
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Color(0xFFCEE5D0),
                          size: 50.0,
                        ),
                        SizedBox(height: 20),
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              'Direct Message',
                              textStyle: TextStyle(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.black
                                      : Colors.white),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 10,
                          pause: const Duration(milliseconds: 7000),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 20,
                    height: 1,
                    color: ConfigBloc().darkModeOn
                        ? Colors.white
                        : Color(0xFFD38B41),
                  ),
                ),
                new Material(
                  color: Colors.transparent,
                  child: Text(
                    'Direct Messages are meant for friendly conversations. We, therefore, advise you to send an email or call the booking number of ${widget.user.userName} if you intend to talk business rather than sending a direct message. You can contact ${widget.user.userName} for business on ${widget.user.userName}\'s booking page.',
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
                Container(
                  width: width - 100,
                  child: TextButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConfigBloc().darkModeOn
                          ? Color(0xFF1a1a1a)
                          : Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                    ),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileProfessionalProfile(
                                  user: widget.user,
                                  currentUserId: widget.currentUserId,
                                  userId: widget.user.id!,
                                ))),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Booking page',
                        style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2),
                widget.user.score!.isNegative
                    ? const SizedBox.shrink()
                    : Container(
                        width: width - 100,
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Colors.white,
                            foregroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3.0),
                            ),
                          ),
                          onPressed: () {
                            _chat();
                          },
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              'Send Message',
                              style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
