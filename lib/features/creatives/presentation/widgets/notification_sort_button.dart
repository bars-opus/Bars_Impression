import 'package:bars/utilities/exports.dart';

class NotificationSortButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final bool isMini;
  final bool fromModalSheet;

  final Color? color;
  const NotificationSortButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.isMini = false,
    this.fromModalSheet = false,
    this.color,
  }) : super(key: key);

  _icon(BuildContext context) {
    return Icon(
      size: ResponsiveHelper.responsiveFontSize(context, 20.0),
      icon,
      color: color ?? Colors.blue,
    );
  }

  _text(BuildContext context) {
    var textStyle = TextStyle(
        color: color,
        fontSize: ResponsiveHelper.responsiveFontSize(context, 12));
    _animatedText(String text) {
      return TyperAnimatedText(
        speed: const Duration(milliseconds: 100),
        text,
        textStyle: Theme.of(context).textTheme.bodySmall,
      );
    }

    return isMini
        ? AnimatedTextKit(
            repeatForever: false,
            totalRepeatCount: 2,
            pause: const Duration(seconds: 2),
            animatedTexts: [
                _animatedText(
                  title,
                  // suggestions,
                ),
              ])
        : Text(
            title,
            style: !fromModalSheet
                ? color != null
                    ? textStyle
                    : Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyMedium,
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: !fromModalSheet
          ? Column(
              children: [
                _icon(context),
                SizedBox(
                  height: 5,
                ),
                _text(context),
              ],
            )
          : Row(
              mainAxisAlignment:
                  isMini ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                _icon(context),
                SizedBox(
                  width: !fromModalSheet ? 10 : 30,
                ),
                _text(context),
              ],
            ),
    );
  }
}
