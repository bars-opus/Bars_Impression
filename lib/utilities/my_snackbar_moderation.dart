import 'package:bars/utilities/exports.dart';

void mySnackBarModeration(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.red,
          ),
          child: ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: Colors.grey.withOpacity(.3),
            ),
            title: RichText(
              textScaleFactor:
                  MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
              text: TextSpan(
                children: [
                  TextSpan(
                      text:
                      message,
                          
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.white,
                      )),
                  TextSpan(
                      text: 'our community guidelines ',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                      )),
                  TextSpan(
                      text: 'and avoid using offensive or sensitive language.',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.white,
                      )),
                ],
              ),
              textAlign: TextAlign.start,
            ),
          ),
        )),
  );
}
