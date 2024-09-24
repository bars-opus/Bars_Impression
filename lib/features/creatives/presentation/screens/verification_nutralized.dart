import 'package:bars/utilities/exports.dart';

class VerificationNutralized extends StatefulWidget {
  final AccountHolderAuthor user;
  final String from;

  VerificationNutralized({
    required this.user,
    required this.from,
  });

  @override
  _VerificationNutralizedState createState() => _VerificationNutralizedState();
}

class _VerificationNutralizedState extends State<VerificationNutralized> {
  _nothing() {}
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
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
                        size: ResponsiveHelper.responsiveHeight(context, 50),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Verified\nStatus',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize:
                              ResponsiveHelper.responsiveHeight(context, 50),
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
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
            new Material(
              color: Colors.transparent,
              child: Text(
                'Changes made to an account by the owner may result in loss of Verified status. User-made changes include, but are not limited to',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                '1. If you change your username (${widget.user.userName})\n2. If you change your account type (${widget.user.storeType})\n3. If your account becomes inactive or incomplete',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: Container(
                width: ResponsiveHelper.responsiveHeight(context, 250),
                child: TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                  ),
                  onPressed: () {
                    widget.from.startsWith('userName')
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfileName(
                                user: widget.user,
                              ),
                            ))
                        : widget.from.startsWith('accountType')
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditstoreType(
                                    user: widget.user,
                                  ),
                                ))
                            : _nothing();
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.from.startsWith('userName')
                          ? 'Change Username'
                          : widget.from.startsWith('accountType')
                              ? 'Select Account Type'
                              : '',
                      style: TextStyle(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
