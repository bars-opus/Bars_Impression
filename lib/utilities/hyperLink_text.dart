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
          textToLink.replaceAll('\n', ' '),
        )),
        style: widget.from!.startsWith('Profile')
            ? TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                color: Colors.white,
              )
            : widget.from!.startsWith('Caption')
                ? TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                    color: Colors.grey,
                  )
                : widget.from!.startsWith('Comment')
                    ? TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14),
                        color: Theme.of(context).secondaryHeaderColor,
                      )
                    : widget.from!.startsWith('Reply')
                        ? TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 14),
                            color: Theme.of(context).secondaryHeaderColor,
                          )
                        : widget.from!.startsWith('Advice')
                            ? TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14),
                                color: Colors.black,
                              )
                            : widget.from!.startsWith('Link')
                                ? Theme.of(context).textTheme.bodySmall
                                : widget.from!.startsWith('Message')
                                    ? TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14),
                                        color: Colors.black,
                                      )
                                    : widget.from!.startsWith('Verified')
                                        ? TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 14),
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          )
                                        : TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 12),
                                            color: Theme.of(context)
                                                .secondaryHeaderColor,
                                          ),
        textAlign: TextAlign.start,
        softWrap: true,
        maxLines: widget.from!.startsWith('Profile') ? 10 : null,
      );

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not make call');
    }
  }

  Future<void> _sendMail(String url) async {
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not  launch mail');
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
                    builder: (_) => WebDisclaimer(
                        icon: Icons.link,
                        link: linkToOpen,
                        contentType: 'Link'),
                  ),
                )
              // : 
              // type.startsWith('nameMention')
              //     ? Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (_) => TaggedUser(
              //             userId: linkToOpen,
              //             currentUserId: '',
              //           ),
              //         ),
              //       )
                  : type.startsWith('verified')
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WebDisclaimer(
                              icon: Icons.link,
                              link: linkToOpen,
                              contentType: 'Link',
                            ),
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
                                  : _nothing();
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

  _nothing() {}

  @override
  Widget build(BuildContext context) {
    return buildTextWithLinks(this.widget.text!);
  }
}
