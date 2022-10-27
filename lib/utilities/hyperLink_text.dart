import 'package:bars/utilities/exports.dart';

class HyperLinkText extends StatefulWidget {
  final String? text;
  final String? from;

  HyperLinkText({Key? key, required this.text, required this.from})
      : super(key: key);

  @override
  State<HyperLinkText> createState() => _HyperLinkTextState();
}

class _HyperLinkTextState extends State<HyperLinkText> {
  Text buildTextWithLinks(String textToLink) => Text.rich(
        TextSpan(
            children: linkify(
          textToLink,
        )),
        style: widget.from!.startsWith('Profile')
            ? TextStyle(
                fontSize: 12.0,
                color: ConfigBloc().darkModeOn ? Colors.blueGrey : Colors.white,
              )
            : widget.from!.startsWith('Caption')
                ? TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  )
                : widget.from!.startsWith('forum')
                    ? TextStyle(
                        fontSize: 12.0,
                        color: ConfigBloc().darkModeOn
                            ? Colors.black
                            : Colors.white,
                      )
                    : widget.from!.startsWith('Advice')
                        ? TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          )
                        : widget.from!.startsWith('Link')
                            ? TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                              )
                            : widget.from!.startsWith('Message')
                                ? TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  )
                                : widget.from!.startsWith('Verified')
                                    ? TextStyle(
                                        fontSize: 14.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      )
                                    : TextStyle(
                                        fontSize: 12.0,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
        textAlign: widget.from!.startsWith('Profile') ||
                widget.from!.startsWith('Link')
            ? TextAlign.center
            : TextAlign.start,
      );

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

  static const String profainPattern =
      "(fuck|shit|pussy|dick|asshole|asshole|asshole|asshole|bitch|bastard|cunt|butthole|sex|porn|dick|bugger|twat|butt|idiot|fool|jerk|Cumbubble|kill|rape|killer|rapist|muderer)";
  static const String urlPattern = 'https?:/\/\\S+';

  static const String nameMention = (r"\@(\w+)");

  static const String emailPattern = r'\S+@\S+';

  static const String phonePattern = r'[\d-]{9,}';

  final RegExp linkRegExp = RegExp(
      '($urlPattern)|($emailPattern)|($phonePattern)|($profainPattern)|($nameMention)',
      caseSensitive: false);

  WidgetSpan buildLinkComponent(String text, String linkToOpen, String type) =>
      WidgetSpan(
          child: InkWell(
        child: Text(
          text,
          style: TextStyle(
            color: type.startsWith('Profaine')
                ? Colors.grey
                : widget.from!.startsWith('forum')
                    ? Colors.white
                    : Colors.blueAccent,
            decorationColor:
                type.startsWith('Profaine') ? Colors.red : Colors.blueAccent,
            decoration: type.startsWith('Profaine')
                ? TextDecoration.lineThrough
                : TextDecoration.underline,
          ),
        ),
        onTap: () {
          type.startsWith('Profile')
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        WebDisclaimer(link: linkToOpen, contentType: 'Link'),
                  ),
                )
              : type.startsWith('nameMention')
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TaggedUser(
                          user: linkToOpen,
                          currentUserId: '',
                        ),
                      ),
                    )
                  : type.startsWith('verified')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebDisclaimer(
                                link: linkToOpen, contentType: 'Link'),
                          ),
                        )
                      : type.startsWith('Profaine')
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViolatingTerms(
                                    link: linkToOpen, contentType: 'Safety'),
                              ),
                            )
                          : type.startsWith('mail')
                              ? _sendMail(linkToOpen)
                              : type.startsWith('contact')
                                  ? _makePhoneCall(linkToOpen)
                                  : () {};
        },
      ));

  List<InlineSpan> linkify(String text) {
    final List<InlineSpan> list = <InlineSpan>[];
    final RegExpMatch? match = linkRegExp.firstMatch(text);
    if (match == null) {
      list.add(
        TextSpan(
          text: text,
        ),
      );
      return list;
    }

    if (match.start > 0) {
      list.add(TextSpan(text: text.substring(0, match.start)));
    }

    final String? linkText = match.group(0);
    if (linkText!.contains(RegExp(urlPattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, 'Profile'));
    } else if (linkText.contains(RegExp(
      emailPattern,
      caseSensitive: false,
    ))) {
      list.add(buildLinkComponent(linkText, 'mailto:$linkText', 'mail'));
    } else if (linkText.contains(RegExp(phonePattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, 'tel:$linkText', 'contact'));
    } else if (linkText
        .contains(RegExp(profainPattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, 'Profaine'));
    } else if (linkText.contains(RegExp(nameMention, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, 'nameMention'));
    } else {
      throw 'Unexpected match: $linkText';
    }

    list.addAll(
      linkify(
        text.substring(match.start + linkText.length),
      ),
    );

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return buildTextWithLinks(this.widget.text!);
  }
}
