import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ConfirmationPrompt extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final VoidCallback? onPressed;
  final int height;

  ConfirmationPrompt({
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.buttonText,
    this.height = 280,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, height.toDouble()),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
            child: MyBottomModelSheetAction(actions: [
              SizedBox(
                height: ResponsiveHelper.responsiveHeight(context, 40),
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 20,
              ),
              BottomModalSheetButtonBlue(
                onPressed: onPressed,
                buttonText: buttonText,
              ),
              SizedBox(height: ResponsiveHelper.responsiveHeight(context, 30)),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  size: ResponsiveHelper.responsiveHeight(context, 25),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ])));
  }
}
