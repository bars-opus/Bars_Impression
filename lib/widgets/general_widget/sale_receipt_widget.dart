import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class SalesReceiptWidget extends StatelessWidget {
  final String lable;
  final String value;
  final String value2;

  final bool isRefunded;
  final Color? text2Ccolor;
  final int? width;
  final int? maxLines;
  final bool isTicket;
  final bool inMini;
  final Color? text1Ccolor;

  const SalesReceiptWidget(
      {super.key,
      required this.lable,
      required this.value,
      required this.isRefunded,
      this.text2Ccolor,
      this.isTicket = false,
      this.inMini = false,
      this.value2 = '',
      this.text1Ccolor,
      this.maxLines = 5,
      this.width});

  @override
  Widget build(BuildContext context) {
    var _textStyle = TextStyle(
      fontSize:
          ResponsiveHelper.responsiveFontSize(context, isTicket ? 14 : 12.0),
      color: isTicket
          ? Colors.black
          : text1Ccolor != null
              ? text1Ccolor
              : Colors.grey,
    );

    var _textStyle2 = TextStyle(
      fontSize:
          ResponsiveHelper.responsiveFontSize(context, inMini ? 12 : 14.0),
      color: text2Ccolor == null
          ? Theme.of(context).secondaryHeaderColor
          : text2Ccolor,
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
          child: RichText(
            textScaleFactor:
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
            text: TextSpan(
              children: [
                TextSpan(text: value, style: _textStyle2),
                if (value2.isNotEmpty)
                  TextSpan(
                    text: '\n${value2}',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: value2 == 'Open'
                          ? Colors.blue
                          : value2 == 'Closed'
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
          // Text(
          //   value,
          //   style: _textStyle2,
          //   maxLines: maxLines,
          //   overflow: TextOverflow.ellipsis,
          //   textAlign: TextAlign.start,
          // ),
        )
      ],
    );
  }
}
