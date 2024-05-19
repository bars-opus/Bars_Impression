import 'package:bars/utilities/exports.dart';

class RefundWidget extends StatefulWidget {
  final RefundModel currentRefund;
  final String currentUserId;

  const RefundWidget(
      {super.key, required this.currentRefund, required this.currentUserId});

  @override
  State<RefundWidget> createState() => _RefundWidgetState();
}

class _RefundWidgetState extends State<RefundWidget> {
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
              await DatabaseService.deleteRefundRequestData(
                  widget.currentRefund);
              mySnackBar(context, 'Refund data deleted successfully');
              Navigator.pop(context);
            } catch (e) {
              _showBottomSheetErrorMessage('Error deleting refund data');
            }
          },
          title: 'Are you sure you want to delete this refund data?',
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

  _payoutWidget(String lable, String value) {
    return ShakeTransition(
      // axis: Axis.vertical,
      curve: Curves.linearToEaseOut,
      offset: -140,
      duration: const Duration(seconds: 2),
      child: SalesReceiptWidget(
        isRefunded: false,
        lable: lable,
        value: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _isLoading = true;
        try {
          Event? event = await DatabaseService.getEventWithId(
              widget.currentRefund.eventId);

          if (event != null) {
            _navigateToPage(EventEnlargedScreen(
              currentUserId: widget.currentUserId,
              event: event,
              type: event.type,
            ));
          } else {
            _showBottomSheetErrorMessage('Failed to fetch event.');
          }
        } catch (e) {
          _showBottomSheetErrorMessage('Failed to fetch event');
        } finally {
          _isLoading = false;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
        child: Column(
          children: [
            _payoutWidget(
              'Status',
              widget.currentRefund.status,
            ),
            Divider( thickness: .2,),
            _payoutWidget(
              'Amount',
              widget.currentRefund.amount.toString(),
            ),
            Divider( thickness: .2,),
            _payoutWidget(
              'Request \ntime',
              MyDateFormat.toTime(
                  widget.currentRefund.approvedTimestamp.toDate()),
            ),
            Divider( thickness: .2,),

            _payoutWidget(
              'Request \ndate',
              MyDateFormat.toDate(
                  widget.currentRefund.approvedTimestamp.toDate()),
            ),

            if (widget.currentRefund.expectedDate.isNotEmpty) Divider(),
            if (widget.currentRefund.expectedDate.isNotEmpty)
              _payoutWidget(
                'Expected \ndate',
                MyDateFormat.toDate(DateTime.parse(
                  widget.currentRefund.expectedDate,
                )),
              ),
            Divider( thickness: .2,),
            _payoutWidget(
              'Request\nReason',
              widget.currentRefund.reason,
            ),
            // SalesReceiptWidget(
            //   color: widget.currentRefund.status == 'pending'
            //       ? Colors.red
            //       : Colors.blue,
            //   isRefunded: false,
            //   lable: 'Status',
            //   value: widget.currentRefund.status,
            // ),
            // Divider(),
            // SalesReceiptWidget(
            //   isRefunded: false,
            //   lable: 'Amount',
            //   value: widget.currentRefund.amount.toString(),
            // ),
            // Divider(),
            // SalesReceiptWidget(
            //   isRefunded: false,
            //   lable: 'Processed \ntime',
            //   value: MyDateFormat.toTime(
            //       widget.currentRefund.approvedTimestamp.toDate()),
            // ),
            // Divider(),
            // SalesReceiptWidget(
            //   isRefunded: false,
            //   lable: 'Processed \ndate',
            //   value: MyDateFormat.toDate(
            //       widget.currentRefund.approvedTimestamp.toDate()),
            // ),
            // Divider(),
            // SalesReceiptWidget(
            //   isRefunded: false,
            //   lable: 'Expected \ndate',
            //   value: widget.currentRefund.expectedDate,
            // ),
            // Divider(),
            // SalesReceiptWidget(
            //   isRefunded: false,
            //   lable: 'Reason',
            //   value: widget.currentRefund.reason,
            // ),
            Divider( thickness: .2,),
            const SizedBox(
              height: 10,
            ),
            IconButton(
                onPressed: () {
                  _showBottomSheetComfirmDelete(context);
                },
                icon: Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                  // size: ResponsiveHelper.responsiveFontSize(context, 20),
                )),
            Divider( thickness: .2,),
          ],
        ),
      ),
    );
  }
}
