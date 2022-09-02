import 'package:bars/utilities/exports.dart';

class VerificationInfo extends StatefulWidget {
  final AccountHolder user;
  final Verification? verification;

  VerificationInfo({
    required this.user,
    required this.verification,
  });

  @override
  _VerificationInfoState createState() => _VerificationInfoState();
}

class _VerificationInfoState extends State<VerificationInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ShakeTransition(
              child: new Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Center(
                      child: Icon(
                        MdiIcons.checkboxMarkedCircle,
                        size: 50,
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1a1a1a)
                            : Colors.white,
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.user.verified!.isNotEmpty
                            ? "Account\nVerified"
                            : 'Verified\nStatus',
                        style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w100,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 150),
              child: Container(
                width: 20,
                height: 1,
                color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color:
                    ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Material(
                    color: Colors.transparent,
                    child: HyperLinkText(
                      from: 'Verified',
                      text: widget.user.verified!.isNotEmpty
                          ? 'Your account has been verified with the following credentials:\n\nEmail: ${widget.verification!.email}\nContact: ${widget.verification!.phoneNumber}\nId card: ${widget.verification!.govIdType}\nWebsite: ${widget.verification!.website}\nWikipedia: ${widget.verification!.wikipedia}\nNews coverage: ${widget.verification!.newsCoverage}\nSocial Meida: ${widget.verification!.socialMedia}\nOther link: ${widget.verification!.otherLink}'
                          : 'Your verification request was ${widget.verification!.status}\non ${MyDateFormat.toDate(
                              widget.verification!.timestamp!.toDate(),
                            )} at ${MyDateFormat.toTime(
                              widget.verification!.timestamp!.toDate(),
                            )}\nwith the followig credentials:\n\nEmail: ${widget.verification!.email}\nContact: ${widget.verification!.phoneNumber}\nId card: ${widget.verification!.govIdType}\nWebsite: ${widget.verification!.website}\nWikipedia: ${widget.verification!.wikipedia}\nNews coverage: ${widget.verification!.newsCoverage}\nSocial Meida: ${widget.verification!.socialMedia}\nOther link: ${widget.verification!.otherLink}',
                    )),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
