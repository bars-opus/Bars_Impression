import 'package:bars/utilities/exports.dart';

class PayoutWidget extends StatefulWidget {
  final EventPayoutModel payout;
  final String currentUserId;

  const PayoutWidget({
    super.key,
    required this.payout,
    required this.currentUserId,
  });

  @override
  State<PayoutWidget> createState() => _PayoutWidgetState();
}

class _PayoutWidgetState extends State<PayoutWidget> {
  
  _payoutWidget(String lable, String value) {
    return PayoutDataWidget(
      label: lable,
      value: value,
      text2Ccolor: Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    var _amount = widget.payout.total / 100;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: Icon(
                Icons.check_circle_outline_outlined,
                size: ResponsiveHelper.responsiveHeight(context, 50.0),
                color: Colors.green,
              ),
            ),
          ),
          _payoutWidget(
            'Event',
            widget.payout.eventTitle,
          ),
          Divider(
            thickness: .2,
          ),
          _payoutWidget(
            'Status',
            widget.payout.status,
          ),
          Divider(
            thickness: .2,
          ),
        
          _payoutWidget(
            'Amount',
            _amount.toString(),
          ),
          Divider(
            thickness: .2,
          ),

          _payoutWidget(
            'Processed \ntime',
            MyDateFormat.toTime(widget.payout.timestamp.toDate()),
          ),
          Divider(
            thickness: .2,
          ),

          _payoutWidget(
            'Processed \ndate',
            MyDateFormat.toDate(widget.payout.timestamp.toDate()),
          ),

          Divider(
            thickness: .2,
          ),
        ],
      ),
    );
  }
}
