import 'package:bars/utilities/exports.dart';

class NotificationSortButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final bool isMini;
  const NotificationSortButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.isMini = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _animatedText(String text) {
      return TyperAnimatedText(
        speed: const Duration(milliseconds: 100),
        text,
        textStyle: Theme.of(context).textTheme.bodySmall,
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment:
            isMini ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(
            size: ResponsiveHelper.responsiveFontSize(context, 20.0),
            icon,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 30,
          ),
          isMini
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
        ],
      ),
    );
  }
}
