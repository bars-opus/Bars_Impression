import 'package:bars/utilities/exports.dart';

class PayoutWidget extends StatefulWidget {
  final EventPayoutModel payout;
  final String currentUserId;

  const PayoutWidget(
      {super.key, required this.payout, required this.currentUserId});

  @override
  State<PayoutWidget> createState() => _PayoutWidgetState();
}

class _PayoutWidgetState extends State<PayoutWidget> {
  bool _isLoading = false;

  void _showBottomSheetComfirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Delete',
          onPressed: () async {
            Navigator.pop(context);
            try {
              // Call recursive function to delete documents in chunks
              await DatabaseService.deletePayoutData(
                  widget.payout, widget.currentUserId);
              mySnackBar(context, 'Payout data deleted successfully');
              Navigator.pop(context);
            } catch (e) {
              _showBottomSheetErrorMessage('Error deleting payout data');
            }
          },
          title: 'Are you sure you want to delete this payout data?',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: errorTitle,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _payoutWidget(String lable,String value) {
    return ShakeTransition(
      // axis: Axis.vertical,
      curve: Curves.linearToEaseOut,
      offset: -140,
      duration: const Duration(seconds: 2),
      child: SalesReceiptWidget(
        isRefunded: false,
        lable: lable,
        value: value,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Colors.black,
      decoration: TextDecoration.none,
    );

    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _payoutWidget(
            'Event',
            widget.payout.eventTitle,
          ),
          Divider( thickness: .2,),
          _payoutWidget(
            'Status',
            widget.payout.status,
          ),
          Divider( thickness: .2,),
          // SalesReceiptWidget(
          //   color: widget.payout.status == 'pending' ? Colors.red : Colors.blue,
          //   isRefunded: false,
          //   lable: 'Status',
          //   value: widget.payout.status,
          // ),
          _payoutWidget(
            'Amount',
            widget.payout.total.toString(),
          ),
          Divider( thickness: .2,),

          _payoutWidget(
            'Processed \ntime',
            MyDateFormat.toTime(widget.payout.timestamp.toDate()),
          ),
          Divider( thickness: .2,),

          _payoutWidget(
            'Processed \ndate',
            MyDateFormat.toDate(widget.payout.timestamp.toDate()),
          ),

          Divider( thickness: .2,),
        ],
      ),
    );
  }
}
