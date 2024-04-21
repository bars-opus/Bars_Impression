import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class SalesReceiptWidget extends StatelessWidget {
  final String lable;
  final String value;
  final bool isRefunded;
  final Color? color;
  final int? width;
  final bool isTicket;
  const SalesReceiptWidget(
      {super.key,
      required this.lable,
      required this.value,
      required this.isRefunded,
      this.color,
      this.isTicket = false,
      this.width});

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      fontSize:
          ResponsiveHelper.responsiveFontSize(context, isTicket ? 14 : 12.0),
      color: isTicket ? Colors.black : Colors.grey,
    );

    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: color == null ? Theme.of(context).secondaryHeaderColor : color,
      decoration: isRefunded ? TextDecoration.lineThrough : TextDecoration.none,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // color: Colors.red,
          width: ResponsiveHelper.responsiveWidth(
              context, width == null ? 90 : width!.toDouble()),
          child: Text(
            lable,
            style: _textStyle,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: _textStyle2,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }
}
