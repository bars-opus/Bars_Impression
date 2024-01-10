import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ReportContentSubmission extends StatefulWidget {
  static final id = 'ReportContentSubmission_screen';
  final String contentId;
  final String contentType;
  final String reportType;
  final String repotedAuthorId;
  final String parentContentId;

  const ReportContentSubmission(
      {required this.contentId,
      required this.parentContentId,
      required this.repotedAuthorId,
      required this.contentType,
      required this.reportType});

  @override
  _ReportContentSubmissionState createState() =>
      _ReportContentSubmissionState();
}

class _ReportContentSubmissionState extends State<ReportContentSubmission> {
  bool _isLoading = false;
  // final _formKey = GlobalKey<FormState>();
  String _comment = '';

  _submit() async {
    // if (_formKey.currentState!.validate() && !_isLoading) {
    //   _formKey.currentState?.save();
    setState(() {
      _isLoading = true;
    });

    ReportContents reportContent = ReportContents(
      reportType: widget.reportType,
      contentType: widget.contentType,
      contentId: widget.contentId,
      repotedAuthorId: widget.repotedAuthorId,
      parentContentId: widget.parentContentId,
      reportConfirmation: '',
      authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
      timestamp: Timestamp.fromDate(DateTime.now()),
      id: '',
      comment: _comment,
    );
    try {
      DatabaseService.createReportContent(reportContent);
      editContentReport(reportContent);
      Navigator.pop(context);
      mySnackBar(context, 'Thank You\nReport submitted successfully.');
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
    // }
  }

  editContentReport(ReportContents reportContent) {

    reportContent.contentType.contains('Mood punched')
        ? postsRef
            .doc(reportContent.repotedAuthorId)
            .collection('userPosts')
            .doc(reportContent.parentContentId)
            .update({
            'report': reportContent.reportType,
          })
        : reportContent.contentType.contains('event')
            ? eventsRef
                .doc(reportContent.repotedAuthorId)
                .collection('userEvents')
                .doc(reportContent.parentContentId)
                .update({
                'report': reportContent.reportType,
              })
            : reportContent.contentType.contains('vibe')
                ? commentsRef
                    .doc(reportContent.parentContentId)
                    .collection('postComments')
                    .doc(reportContent.contentId)
                    .update({
                    'report': reportContent.reportType,
                  })
                : reportContent.contentType.contains('comment')
                    ? blogCommentsRef
                        .doc(reportContent.parentContentId)
                        .collection('blogComments')
                        .doc(reportContent.contentId)
                        .update({
                        'report': reportContent.reportType,
                      })
                    : reportContent.contentType.contains('thought')
                        ? thoughtsRef
                            .doc(reportContent.parentContentId)
                            .collection('forumThoughts')
                            .doc(reportContent.contentId)
                            .update({
                            'report': reportContent.reportType,
                          })
                        : reportContent.contentType.contains('question')
                            ? asksRef
                                .doc(reportContent.parentContentId)
                                .collection('eventAsks')
                                .doc(reportContent.contentId)
                                .update({
                                'report': reportContent.reportType,
                              })
                            : reportContent.contentType.contains('advice')
                                ? userAdviceRef
                                    .doc(reportContent.parentContentId)
                                    .collection('userAdvice')
                                    .doc(reportContent.contentId)
                                    .update({
                                    'report': reportContent.reportType,
                                  })
                                : reportContent.contentType.contains('advice')
                                    ? userAdviceRef
                                        .doc(reportContent.parentContentId)
                                        .collection('userAdvice')
                                        .doc(reportContent.contentId)
                                        .update({
                                        'report': reportContent.reportType,
                                      })
                                    : usersGeneralSettingsRef
                                        
                                        .doc(reportContent.repotedAuthorId)
                                        .update({
                                        'report': reportContent.reportType,
                                      });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Container(
              height: width * 2,
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        MdiIcons.flag,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'Report\n' + widget.contentType,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 20.0),
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
                      child: widget.reportType.startsWith('Spam')
                          ? Text(
                              'Bars Impression does not allow or promote any form or content related to ' +
                                  widget.reportType +
                                  ': Misleading or repetitive content',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )
                          : widget.reportType.startsWith('Nudity')
                              ? Text(
                                  'Bars Impression does not allow or promote any form or content related to ' +
                                      widget.reportType +
                                      ': Sexually explicit content',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                )
                              : widget.reportType.startsWith('Misinformation')
                                  ? Text(
                                      'Bars Impression does not allow or promote any form or content related to ' +
                                          widget.reportType +
                                          ': Health misinformation or conspiracies',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      textAlign: TextAlign.center,
                                    )
                                  : widget.reportType
                                          .startsWith('Hateful Activities')
                                      ? Text(
                                          'Bars Impression does not allow or promote any form or content related to ' +
                                              widget.reportType +
                                              ': Prejudice, stereotypes, white supremacy, slurs, racism',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                          textAlign: TextAlign.center,
                                        )
                                      : widget.reportType
                                              .startsWith('Dangerous goods')
                                          ? Text(
                                              'Bars Impression does not allow or promote any form or content related to ' +
                                                  widget.reportType +
                                                  ': Drugs, regulated products',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              textAlign: TextAlign.center,
                                            )
                                          : widget.reportType
                                                  .startsWith('Harassment')
                                              ? Text(
                                                  'Bars Impression does not allow or promote any form or content related to ' +
                                                      widget.reportType +
                                                      ': Insults, threats, personally identifiable info',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                  textAlign: TextAlign.center,
                                                )
                                              : widget.reportType
                                                      .startsWith('Graphic')
                                                  ? Text(
                                                      'Bars Impression does not allow or promote any form or content related to ' +
                                                          widget.reportType +
                                                          ': Violent images or promotion of violence',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  : widget.reportType.startsWith(
                                                          'My intellectual property')
                                                      ? Text(
                                                          'Bars Impression does not allow or promote any form or content related to ' +
                                                              widget
                                                                  .reportType +
                                                              ': Copyright or trademark infringement',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : const SizedBox
                                                          .shrink()),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30, bottom: 50),
                    child: ContentFieldBlack(
                      onlyBlack: false,
                      labelText: 'Comment(optional)',
                      hintText: "We want to hear your opinion",
                      initialValue: '',
                      onSavedText: (input) => _comment = input,
                      onValidateText: (_) {},
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 40),
                      child: BlueOutlineButton(
                        buttonText: 'Submit Report',
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
      ),
    );
  }
}
