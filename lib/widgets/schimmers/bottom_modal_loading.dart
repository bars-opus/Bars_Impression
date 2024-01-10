import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class BottomModalLoading extends StatelessWidget {
  final String title;

  BottomModalLoading({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ResponsiveHelper.responsiveHeight(
          context,
          300,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgress(isMini: true),
            RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Please ',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        16,
                      ),
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  TextSpan(
                    text: 'wait\n',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        30,
                      ),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  TextSpan(
                    text: title,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        16,
                      ),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: '...',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        18,
                      ),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ])),
          ],
        ));
  }
}
