import 'package:bars/utilities/exports.dart';

class NameText extends StatelessWidget {
  final String name;
  final bool verified;
  final Color color;
  final double fontSize;

  NameText(
      {required this.name,
      required this.verified,
      this.color = Colors.red,
      this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Text(
            name,
            style: TextStyle(
              color: color == Colors.red
                  ? Theme.of(context).secondaryHeaderColor
                  : color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveHelper.responsiveFontSize(context, fontSize),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (verified) ...[
          SizedBox(width: 4), // add some space between name and icon
          Icon(
            Icons.check_circle,
            color: Colors.blue,
            size: ResponsiveHelper.responsiveHeight(
                context, 10.0), // you can adjust the size as needed
          ),
        ]
      ],
    );
  }
}
