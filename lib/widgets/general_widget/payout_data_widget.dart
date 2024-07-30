import 'package:bars/utilities/exports.dart';

class PayoutDataWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? text2Ccolor;
  final Color? text1Ccolor;

  final bool inMini;
  final int? maxLines;

  const PayoutDataWidget({
    super.key,
    required this.label,
    required this.value,
    this.inMini = false,
    this.text2Ccolor,
    this.text1Ccolor,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return ShakeTransition(
      // axis: Axis.vertical,
      curve: Curves.linearToEaseOut,
      offset: -140,
      duration: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: SalesReceiptWidget(
          maxLines: maxLines,
          text1Ccolor: text1Ccolor,
          inMini: inMini,
          text2Ccolor: text2Ccolor,
          isRefunded: false,
          lable: label,
          value: value,
        ),
      ),
    );
    // };
  }
}
