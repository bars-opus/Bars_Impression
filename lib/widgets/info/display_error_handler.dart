import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class DisplayErrorHandler extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final VoidCallback? onPressed;

  DisplayErrorHandler(
      {required this.title,
      required this.subTitle,
      required this.onPressed,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 350),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
            child: MyBottomModelSheetAction(actions: [
              const SizedBox(
                height: 40,
              ),
              Icon(
                Icons.error_outline_outlined,
                color: Colors.red,
                size: ResponsiveHelper.responsiveHeight(context, 50),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              BottomModalSheetButtonBlue(
                dissable: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                buttonText: 'Ok',
              ),
            ])));
  }
}
