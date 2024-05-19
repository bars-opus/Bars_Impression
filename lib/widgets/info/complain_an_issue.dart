import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class CompainAnIssue extends StatefulWidget {
  static final id = 'CompainAnIssue_screen';
  final String complainContentId;
  final String complainType;
  final String authorId;
  final String parentContentId;
  final String parentContentAuthorId;

  const CompainAnIssue({
    required this.complainContentId,
    required this.parentContentId,
    required this.authorId,
    required this.complainType,
    required this.parentContentAuthorId,
  });

  @override
  _CompainAnIssueState createState() => _CompainAnIssueState();
}

class _CompainAnIssueState extends State<CompainAnIssue> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String _comment = '';
  ComplaintIssueModel? currentComplaint;
  bool _isFetchingComplaint = true;

  @override
  void initState() {
    super.initState();
    _getComplaint();
  }

  _getComplaint() async {
    ComplaintIssueModel? complaint = await DatabaseService.getComplaintWithId(
        widget.authorId, widget.complainContentId);

    setState(() {
      currentComplaint = complaint;
      _isFetchingComplaint = false;
    });
  }

  _submit() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });

      ComplaintIssueModel reportContent = ComplaintIssueModel(
        // reportType: widget.reportType,
        complainType: widget.complainType,
        complainContentId: widget.complainContentId,
        // repotedAuthorId: widget.repotedAuthorId,
        parentContentId: widget.parentContentId,
        // reportConfirmation: '',
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
        issue: _comment, compaintEmail: '',
        parentContentAuthorId: widget.parentContentAuthorId, isResolve: false,
      );
      try {
        await DatabaseService.createComplainIssue(reportContent);
        // editContentReport(reportContent);
        Navigator.pop(context);
        mySnackBar(context, 'Thank You\nCompaint submitted successfully.');
      } catch (e) {
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        mySnackBar(context, 'Request Failed\n$result.toString(),');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  editContentReport(ReportContents reportContent) {
    usersGeneralSettingsRef.doc(reportContent.repotedAuthorId).update({
      'report': reportContent.reportType,
    });
  }

  _newComplaint() {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Container(
          child: Container(
            height: width * 2,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 10),
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      'Complaint\n' + widget.complainType + ' issue.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 2,
                  color: Colors.blue,
                  width: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30),
                    child: Text(
                      'We apologize for any inconvenience you may be experiencing with your ${widget.complainType}. At Bars Impression, we strive to ensure a seamless experience for all users, and we are dedicated to resolving any issues you may encounter promptly and effectively.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    )),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30, bottom: 50),
                    child: ContentFieldBlack(
                      onlyBlack: false,
                      labelText: 'How can we help you',
                      hintText: "We want to help you",
                      initialValue: '',
                      onSavedText: (input) => _comment = input,
                      onValidateText: (issue) =>
                          issue.trim() != null && issue.trim().length < 10
                              ? 'Please tell us your issue.'
                              : null,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0, bottom: 40),
                    child: BlueOutlineButton(
                      buttonText: 'Submit complaint',
                      onPressed: () {
                        _submit();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _alreadyComplaint() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You have already launched a complaint on this ${widget.complainType}. You can only have one complaint at a time. To launch another complaint, delete the current one.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.start,
          ),
          if (currentComplaint != null)
            ComplaintWidget(
              currentComplaint: currentComplaint!,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: _isFetchingComplaint
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              ),
            )
          : currentComplaint != null
              ? _alreadyComplaint()
              : _newComplaint(),
    );
  }
}
