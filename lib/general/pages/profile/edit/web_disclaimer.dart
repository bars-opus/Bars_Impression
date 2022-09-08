import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class WebDisclaimer extends StatefulWidget {
  static final id = 'WebDisclaimer_screen';
  final String link;
  final String contentType;

  const WebDisclaimer({
    required this.link,
    required this.contentType,
  });

  @override
  _WebDisclaimerState createState() => _WebDisclaimerState();
}

class _WebDisclaimerState extends State<WebDisclaimer> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          appBar: AppBar(
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
            iconTheme: IconThemeData(
                color: ConfigBloc().darkModeOn
                    ? Color(0xFFf2f2f2)
                    : Color(0xFF1a1a1a)),
            automaticallyImplyLeading: true,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  ShakeTransition(
                    child: Icon(
                      MdiIcons.link,
                      color: Colors.blue,
                      size: 100.0,
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      widget.contentType.contains('Link')
                          ? ''
                          : widget.contentType,
                      style: TextStyle(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFFf2f2f2)
                              : Color(0xFF1a1a1a),
                          fontWeight: FontWeight.w500,
                          fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.contentType.contains('Work')
                        ? 'You will be directed to a website where you can take a look at ' +
                            widget.contentType +
                            ' to see if you will like to do business. Bars Impression accepts no liability or responsibility for the information, views, or opinion contained therein.'
                        : widget.contentType.contains('Music Video')
                            ? 'Access the music video link featured with this mood punched. Note that the author of this mood punch might not be the owner or author of the music video link you are about to access. But rather an appreciator, lover, and promoter of the creativity of the original author(right owner/s).'
                            : widget.contentType.contains('Event ticket')
                                ? ' Even though Bars Impression would direct you to the website provided by the publisher of this event,  We strongly advise that: you thoroughly research this event if you are interested.'
                                : widget.contentType.contains('Previous Event')
                                    ? 'Watch the previous event to know how this upcoming event might be.'
                                    : widget.contentType.contains('Link')
                                        ? 'You are accessing an external link. Bars Impression accepts no liability or responsibility for the information, views, or opinion contained therein.'
                                        : '',
                    style: TextStyle(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFFf2f2f2)
                            : Color(0xFF1a1a1a),
                        fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: Container(
                      width: 250,
                      child: OutlinedButton(
                        
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(width: 1.0, color: Colors.blue),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MyWebView(
                                        url: widget.link,
                                      )));
                        },
                        child: Text(
                          'Access Link',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
