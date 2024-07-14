import 'package:bars/utilities/exports.dart';

class PayoutDataWidget extends StatelessWidget {
  final String label;
  final String value;
    final Color? color;

  const PayoutDataWidget({super.key, required this.label, required this.value,    this.color,});

  @override
  Widget build(BuildContext context) {
    // return  _payoutWidget(String lable, String value) {
    return ShakeTransition(
      // axis: Axis.vertical,
      curve: Curves.linearToEaseOut,
      offset: -140,
      duration: const Duration(seconds: 2),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: SalesReceiptWidget(
          color: color,
          isRefunded: false,
          lable: label,
          value: value,
        ),
      ),
    );
    // };
  }
}
