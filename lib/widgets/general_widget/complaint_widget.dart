import 'package:bars/utilities/exports.dart';

class ComplaintWidget extends StatelessWidget {
  final ComplaintIssueModel currentComplaint;
  const ComplaintWidget({super.key, required this.currentComplaint});

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
              await DatabaseService.deleteComplainIssue(currentComplaint);
              mySnackBar(context, 'Complaint deleted successfully');
              Navigator.pop(context);
            } catch (e) {
              _showBottomSheetErrorMessage(context, 'Error deleting complaint');
            }
          },
          title: 'Are you sure you want to Delete this complaint?',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetErrorMessage(BuildContext context, String errorTitle) {
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

  @override
  Widget build(BuildContext context) {
    var _textStyle3 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Theme.of(context).secondaryHeaderColor,
      decoration: currentComplaint.isResolve
          ? TextDecoration.lineThrough
          : TextDecoration.none,
    );

    var _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    var _textStyle2 = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
      color: Theme.of(context).secondaryHeaderColor,
      decoration: TextDecoration.none,
    );
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Resolved:               ',
                        style: _textStyle,
                      ),
                      TextSpan(
                        text: currentComplaint.isResolve.toString(),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: !currentComplaint.isResolve
                              ? Colors.red
                              : Colors.blue,
                        ),
                      ),
                      TextSpan(
                        text: '\nCategory:              ',
                        style: _textStyle,
                      ),
                      TextSpan(
                        text: currentComplaint.complainType,
                        style: _textStyle2,
                      ),
                      TextSpan(
                        text: '\nIssue:                     ',
                        style: _textStyle,
                      ),
                      TextSpan(
                        text: currentComplaint.issue,
                        style: _textStyle3,
                      ),
                      TextSpan(
                        text: '\nComplaint time:    ',
                        style: _textStyle,
                      ),
                      TextSpan(
                        text: MyDateFormat.toDate(
                            currentComplaint.timestamp.toDate()),
                        style: _textStyle2,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    _showBottomSheetComfirmDelete(context);
                  },
                  icon: Icon(
                    Icons.delete_forever_outlined,
                    color: Colors.red,
                    size: ResponsiveHelper.responsiveFontSize(context, 20),
                  ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Divider()
        ],
      ),
    );
  }
}
