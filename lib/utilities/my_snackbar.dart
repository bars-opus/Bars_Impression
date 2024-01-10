import 'package:bars/utilities/exports.dart';

void mySnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(10),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[900],
          ),
          child: ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: Colors.grey.withOpacity(.3),
            ),
            title: Text(
              message,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
            ),
          ),
        )),
  );
}
