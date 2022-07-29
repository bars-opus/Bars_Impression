import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DeleteAccountReason extends StatefulWidget {
  static final id = 'DeleteAccountReason_screen';

  final AccountHolder user;

  const DeleteAccountReason({
    required this.user,
  });

  @override
  _DeleteAccountReasonState createState() => _DeleteAccountReasonState();
}

class _DeleteAccountReasonState extends State<DeleteAccountReason> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'Why?',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'You can submit a report if you think this  goes against Bars Impressions guidelines. This is important in helping us keep Bars Impression safe. We won\'t notify the account that you submitted this report. We will review this report, and actions will be taken if deemed a violation of guidelines',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    title: 'Non beneficail',
                    subTitle:
                        "Bars Impression platform is not beneficial to your in any way",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Issues With content',
                    subTitle: "You don't like the type of contents shared on Bars Impression",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Misinformation',
                    subTitle: "Health misinformation or conspiracies",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Hateful Activities',
                    subTitle:
                        "Prejudice, stereotypes, white supremacy, slurs, racism",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Dangerous goods',
                    subTitle: "Drugs, regulated products",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Harassment or privacy violations',
                    subTitle: "Insults, threats, personally identifiable info",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'Graphic violence',
                    subTitle: "Violent images or promotion of violence",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
              Divider(color: Colors.grey),
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DeleteAccount(
                              reason: '',
                              user: widget.user,
                            ))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IntroInfo(
                    onPressed: () {},
                    title: 'My intellectual property',
                    subTitle: "Copyright or trademark infringement.",
                    icon: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: ConfigBloc().darkModeOn
                          ? Color(0xFFf2f2f2)
                          : Color(0xFF1a1a1a),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
