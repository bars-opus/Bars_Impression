import 'package:bars/utilities/exports.dart';

class BarsTextHeading extends StatelessWidget {
  final String text;

  BarsTextHeading({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    );
  }
}

class BarsTextTitle extends StatelessWidget {
  final String text;

  BarsTextTitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Theme.of(context).secondaryHeaderColor,
      ),
    );
  }
}

class BarsTextSubTitle extends StatelessWidget {
  final String text;

  BarsTextSubTitle({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return HyperLinkText(
      from: '',
      text: text,
    );
  }
}

class BarsTextFooter extends StatelessWidget {
  final String text;

  BarsTextFooter({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
      ),
    );
  }
}

class BarsTextStrikeThrough extends StatelessWidget {
  final String text;
  final double fontSize;

  BarsTextStrikeThrough({
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.grey,
        decorationColor: Colors.grey,
        decorationStyle: TextDecorationStyle.solid,
        decoration: TextDecoration.lineThrough,
      ),
      maxLines: 5,
    );
  }
}

class BarsTextConfirm extends StatelessWidget {
  final String text;
  final String subText;

  BarsTextConfirm({
    required this.text,
    required this.subText,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        textScaleFactor: MediaQuery.of(context).textScaleFactor,
        text: TextSpan(children: [
          TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          TextSpan(
            text: "\n$subText",
            style: TextStyle(
              fontSize: 16.0,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          )
        ]));
  }
}

