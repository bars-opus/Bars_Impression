import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class UserBooking extends StatefulWidget {
  final AccountHolder user;
  final String currentUserId;
  final String from;

  final int userIsCall;
  UserBooking({
    required this.user,
    required this.currentUserId,
    required this.userIsCall,
    required this.from,
  });

  @override
  State<UserBooking> createState() => _UserBookingState();
}

class _UserBookingState extends State<UserBooking> {
  Future launchURl(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {}
  }

  Future<void> _makePhoneCall(String url) async {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Sorry',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          'Could not make call',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  Future<void> _sendMail(String url) async {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      Flushbar(
        margin: EdgeInsets.all(8),
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        titleText: Text(
          'Sorry',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          'Could\'nt launch mail',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        icon: Icon(
          Icons.info_outline,
          size: 28.0,
          color: Colors.blue,
        ),
        duration: Duration(seconds: 3),
        leftBarIndicatorColor: Colors.blue,
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: Color(0xFF1a1a1a),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Color(0xFF1a1a1a),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Container(
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          ShakeTransition(
                            child: Icon(
                              widget.from.startsWith('Booking')
                                  ? Icons.mail
                                  : Icons.link,
                              color: widget.from.startsWith('Booking')
                                  ? Colors.blue
                                  : Colors.black,
                              size: 70.0,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ShakeTransition(
                                  child: Text(
                                      widget.from.startsWith('Booking')
                                          ? 'Booking Contact'
                                          : '${widget.user.userName} Works',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 24)),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                ShakeTransition(
                                  axis: Axis.vertical,
                                  child: Container(
                                    color: Colors.grey,
                                    height: 1,
                                    width: width / 8,
                                  ),
                                ),
                                RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: widget.from.startsWith('Booking')
                                            ? '\nEven though we try to get the contact of ${widget.user.userName!} for you, we cannot guarantee that this are the exact and correct contact of ${widget.user.userName!}, we therefore advice that you do extra research concerning the management of  ${widget.user.userName!}'
                                            : '\nYou will be directed to a website where you can take a look at ${widget.user.userName}\'s work to see if you will like to do business. Bars Impression accepts no liability or responsibility for the information, views, or opinion contained therein.',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () => setState(() {
                      _sendMail('mailto:${widget.user.email}');
                      kpiStatisticsRef
                          .doc('0SuQxtu52SyYjhOKiLsj')
                          .update({'actualllyBooked': FieldValue.increment(1)});
                    }),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onPressed: () => setState(() {
                      _makePhoneCall('tel:${widget.user.contacts}');
                      kpiStatisticsRef
                          .doc('0SuQxtu52SyYjhOKiLsj')
                          .update({'actualllyBooked': FieldValue.increment(1)});
                    }),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Call',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
