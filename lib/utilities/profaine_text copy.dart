import 'package:bars/utilities/exports.dart';

class ProfainTextCheck extends StatefulWidget {
  final String? text;
  final String? from;
  final double fontSize;

  final Color color;

  ProfainTextCheck(
      {Key? key,
      required this.text,
      required this.fontSize,
      required this.color,
      required this.from})
      : super(key: key);

  @override
  State<ProfainTextCheck> createState() => _ProfainTextCheckState();
}

class _ProfainTextCheckState extends State<ProfainTextCheck> {
  Text buildTextWithLinks(String textToLink) => Text.rich(
        TextSpan(
            children: linkify(
          textToLink,
        )),
        style: TextStyle(
          fontSize: widget.fontSize,
          color: widget.color,
        ),
        textAlign: widget.from!.startsWith('Profile')
            ? TextAlign.center
            : TextAlign.start,
      );

  static const String profainPattern =
      "(fuck|shit|pussy|dick|asshole|asshole|asshole|asshole|bitch|bastard|cunt|butthole|sex|porn|dick|bugger|twat|butt|idiot|fool|jerk|Cumbubble|kill|rape|killer|rapist|muderer)";

  final RegExp linkRegExp = RegExp('($profainPattern)', caseSensitive: false);

  WidgetSpan buildLinkComponent(String text, String linkToOpen, String type) =>
      WidgetSpan(
          child: InkWell(
        child: Text(
          text,
          style: TextStyle(
            fontSize: widget.fontSize,
            color: Colors.blue,
            decorationColor: Colors.red,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ViolatingTerms(link: linkToOpen, contentType: 'Safety'),
              ));
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
    if (linkText!.contains(RegExp(profainPattern, caseSensitive: false))) {
      list.add(buildLinkComponent(linkText, linkText, 'Profaine'));
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
