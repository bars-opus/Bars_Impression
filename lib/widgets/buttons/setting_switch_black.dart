import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SettingSwitchBlack extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool value;
  final Color color;
  final Function(bool) onChanged;

  SettingSwitchBlack(
      {required this.subTitle,
      required this.title,
      this.color = Colors.blue,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        child: Container(
          child: RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                    text: title + '\n',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 16.0),
                      color: Theme.of(context).secondaryHeaderColor,
                    )),
                TextSpan(
                  text: subTitle,
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ),
      Container(
        width: ResponsiveHelper.responsiveHeight(context, 50.0),
        child: Switch.adaptive(
            activeColor: color,
            splashRadius: ResponsiveHelper.responsiveHeight(context, 35.0),
            value: value,
            onChanged: onChanged),
      )
    ]);
  }
}
