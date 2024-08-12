import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SettingSwitch extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool value;
  final Color color;
  final bool isAlwaysWhite;

  final Function(bool) onChanged;

  SettingSwitch(
      {required this.subTitle,
      required this.title,
      this.color = Colors.blue,
      this.isAlwaysWhite = false,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
        // color: Colors.red,
        // width: ResponsiveHelper.responsiveHeight(context, 200.0),
        child: RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(
                  text: title + '\n',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 16.0),
                    color: isAlwaysWhite
                        ? Colors.white
                        : Theme.of(context).secondaryHeaderColor,
                  )),
              TextSpan(
                text: subTitle,
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: isAlwaysWhite ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.start,
        ),
      ),
      Transform.scale(
          scale: 1,
          child: Switch.adaptive(
              activeColor: color,
              splashRadius: 35,
              value: value,
              onChanged: onChanged))
    ]);
  }
}
