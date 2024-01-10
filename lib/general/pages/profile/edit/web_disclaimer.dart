import 'dart:ui';

import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class WebDisclaimer extends StatefulWidget {
  static final id = 'WebDisclaimer_screen';
  final String link;
  final String contentType;
  final IconData icon;

  const WebDisclaimer({
    required this.link,
    required this.contentType,
    required this.icon,
  });

  @override
  _WebDisclaimerState createState() => _WebDisclaimerState();
}

class _WebDisclaimerState extends State<WebDisclaimer> {
  Widget buildBlur({
    required Widget child,
    double sigmaX = 5,
    double sigmaY = 5,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width.toDouble(),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DisclaimerWidget(
              title:
                  widget.contentType.contains('Link') ? '' : widget.contentType,
              subTitle: widget.contentType.contains('Work')
                  ? 'You will be directed to a website where you can take a look at ${widget.contentType} to see if you will like to do business. Please be aware that Bars Impression bears no liability or responsibility for the information, views, or opinions presented on that website.'
                  : widget.contentType.contains('Music Video')
                      ? 'Access the music video link featured with this mood punched. Note that the author of this mood punch might not be the owner or author of the music video link you are about to access. But rather an appreciator, lover, and promoter of the creativity of the original author(right owner/s).'
                      : widget.contentType.contains('Event ticket')
                          ? ' Even though Bars Impression would direct you to the website provided by the publisher of this event,  We strongly advise that: you thoroughly research this event if you are interested.'
                          : widget.contentType.contains('Previous Event')
                              ? 'Watch the previous event to get an idea of what to expect at the upcoming event.'
                              : widget.contentType.contains('Link') ||
                                      widget.contentType
                                          .contains('External Profile')
                                  ? 'You are accessing an external link. Please be aware that Bars Impression bears no liability or responsibility for the information, views, or opinions presented on that website.'
                                  : '',
              icon: widget.icon,
            ),
            const SizedBox(
              height: 30,
            ),
            BottomModalSheetButtonBlue(
              buttonText: 'Continue',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MyWebView(
                              url: widget.link, title: widget.contentType,
                            )));
              },
            ),
          ],
        ),
      ),
    );
  }
}
