import 'package:bars/utilities/exports.dart';

class FeatureInfoWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String number;

  FeatureInfoWidget({
    required this.subTitle,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontSize: 14,
                  color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: width - 80,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: title + '\n',
                      style: TextStyle(
                        fontSize: 16,
                        color: ConfigBloc().darkModeOn
                            ? Colors.white
                            : Colors.black,
                      )),
                  TextSpan(
                    text: subTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: ConfigBloc().darkModeOn
                          ? Colors.white54
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ]);
  }
}
