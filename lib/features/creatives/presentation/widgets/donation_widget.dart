import 'package:bars/utilities/exports.dart';

class DonationWidget extends StatefulWidget {
  final DonationModel donation;
  final String currentUserId;
  final bool isDonor;

  const DonationWidget({
    super.key,
    required this.donation,
    required this.currentUserId,
    required this.isDonor,
  });

  @override
  State<DonationWidget> createState() => _DonationWidgetState();
}

class _DonationWidgetState extends State<DonationWidget> {

  void _showBottomSheetComfirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: widget.isDonor ? 'Donar' : 'Delete',
          onPressed: widget.isDonor
              ? () async {
                  Navigator.pop(context);
                  try {
                    // Call recursive function to delete documents in chunks
                    await DatabaseService.deleteDonarData(
                        widget.donation.id, widget.donation.donerId);
                    mySnackBar(context, 'Donation data deleted successfully');
                    // Navigator.pop(context);
                  } catch (e) {
                    _showBottomSheetErrorMessage('Error deleting payout data');
                  }
                }
              : () async {
                  Navigator.pop(context);
                  try {
                    // Call recursive function to delete documents in chunks
                    await DatabaseService.deleteDonarReceiverData(
                        widget.donation.id, widget.donation.receiverId);
                    mySnackBar(context, 'Donation data deleted successfully');
                    Navigator.pop(context);
                  } catch (e) {
                    _showBottomSheetErrorMessage('Error deleting payout data');
                  }
                },
          title: 'Are you sure you want to delete this donation data?',
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
    return PayoutDataWidget(
        label: lable,
        value: value,
        text2Ccolor: Theme.of(context).secondaryHeaderColor);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          _navigateToPage(
            ProfileScreen(
               accountType: 'Client',
              currentUserId: widget.currentUserId,
              userId: widget.isDonor
                  ? widget.donation.receiverId
                  : widget.donation.donerId,
              user: null,
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              thickness: .2,
              color: Colors.green,
            ),
            
            _payoutWidget(
              'name',
              widget.donation.userName,
            ),
            Divider(
              thickness: .2,
            ),
            _payoutWidget(
              'Amount',
              widget.donation.amount.toString(),
            ),
            Divider(
              thickness: .2,
            ),
            _payoutWidget(
              'Reason',
              widget.donation.reason,
            ),
            Divider(
              thickness: .2,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: IconButton(
                  onPressed: () {
                    _showBottomSheetComfirmDelete(context);
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                  )),
            ),
            
            Divider(
              thickness: .2,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
