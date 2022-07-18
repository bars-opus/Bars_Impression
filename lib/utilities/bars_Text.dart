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
        color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
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
        color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
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
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
      ),
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
