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
  final _formKey = GlobalKey<FormState>();
  String _comment = '';

  _submit() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      _formKey.currentState?.save();
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
        final double width = MediaQuery.of(context).size.width;
        Navigator.pop(context);
        Flushbar(
          isDismissible: false,
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: ShakeTransition(
            axis: Axis.vertical,
            curve: Curves.easeInOutBack,
            child: Text(
              'Thank You',
              style: TextStyle(
                color: Colors.white,
                fontSize: width > 800 ? 22 : 14,
              ),
            ),
          ),
          messageText: Text(
            "Report submitted successfully.",
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            MdiIcons.checkCircleOutline,
            size: 30.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = MediaQuery.of(context).size.width;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
        print(e.toString());
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  editContentReport(ReportContents reportContent) {
    reportContent.contentType.contains('forum')
        ? forumsRef
            .doc(reportContent.repotedAuthorId)
            .collection('userForums')
            .doc(reportContent.parentContentId)
            .update({
            'report': reportContent.reportType,
          })
        : reportContent.contentType.contains('Mood punched')
            ? postsRef
                .doc(reportContent.repotedAuthorId)
                .collection('userPosts')
                .doc(reportContent.parentContentId)
                .update({
                'report': reportContent.reportType,
              })
            : reportContent.contentType.contains('blog')
                ? blogsRef
                    .doc(reportContent.repotedAuthorId)
                    .collection('userBlogs')
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
                                    : reportContent.contentType
                                            .contains('advice')
                                        ? userAdviceRef
                                            .doc(reportContent.parentContentId)
                                            .collection('userAdvice')
                                            .doc(reportContent.contentId)
                                            .update({
                                            'report': reportContent.reportType,
                                          })
                                        : reportContent.contentType.contains('advice')
                                            ? userAdviceRef.doc(reportContent.parentContentId).collection('userAdvice').doc(reportContent.contentId).update({
                                                'report':
                                                    reportContent.reportType,
                                              })
                                            : usersRef.doc(reportContent.repotedAuthorId).update({
                                                'report':
                                                    reportContent.reportType,
                                              });
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      appBar: AppBar(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn
                ? Color(0xFFf2f2f2)
                : Color(0xFF1a1a1a)),
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
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
                          size: 70.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Hero(
                        tag: "report",
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            'Report\n' + widget.contentType,
                            style: TextStyle(
                                color: ConfigBloc().darkModeOn
                                    ? Color(0xFFf2f2f2)
                                    : Color(0xFF1a1a1a),
                                fontSize: 40),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 2,
                      color: Colors.blue,
                      width: 10,
                    ),
                    ShakeTransition(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 30),
                          child: widget.reportType.startsWith('Spam')
                              ? Text(
                                  'Bars Impression does not allow or promote any form or content related to ' +
                                      widget.reportType +
                                      ': Misleading or repetitive content',
                                  style: TextStyle(
                                      color: ConfigBloc().darkModeOn
                                          ? Color(0xFFf2f2f2)
                                          : Color(0xFF1a1a1a),
                                      fontSize: 14),
                                  textAlign: TextAlign.center,
                                )
                              : widget.reportType.startsWith('Nudity')
                                  ? Text(
                                      'Bars Impression does not allow or promote any form or content related to ' +
                                          widget.reportType +
                                          ': Sexually explicit content',
                                      style: TextStyle(
                                          color: ConfigBloc().darkModeOn
                                              ? Color(0xFFf2f2f2)
                                              : Color(0xFF1a1a1a),
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    )
                                  : widget.reportType
                                          .startsWith('Misinformation')
                                      ? Text(
                                          'Bars Impression does not allow or promote any form or content related to ' +
                                              widget.reportType +
                                              ': Health misinformation or conspiracies',
                                          style: TextStyle(
                                              color: ConfigBloc().darkModeOn
                                                  ? Color(0xFFf2f2f2)
                                                  : Color(0xFF1a1a1a),
                                              fontSize: 14),
                                          textAlign: TextAlign.center,
                                        )
                                      : widget.reportType
                                              .startsWith('Hateful Activities')
                                          ? Text(
                                              'Bars Impression does not allow or promote any form or content related to ' +
                                                  widget.reportType +
                                                  ': Prejudice, stereotypes, white supremacy, slurs, racism',
                                              style: TextStyle(
                                                  color: ConfigBloc().darkModeOn
                                                      ? Color(0xFFf2f2f2)
                                                      : Color(0xFF1a1a1a),
                                                  fontSize: 14),
                                              textAlign: TextAlign.center,
                                            )
                                          : widget.reportType
                                                  .startsWith('Dangerous goods')
                                              ? Text(
                                                  'Bars Impression does not allow or promote any form or content related to ' +
                                                      widget.reportType +
                                                      ': Drugs, regulated products',
                                                  style: TextStyle(
                                                      color: ConfigBloc()
                                                              .darkModeOn
                                                          ? Color(0xFFf2f2f2)
                                                          : Color(0xFF1a1a1a),
                                                      fontSize: 14),
                                                  textAlign: TextAlign.center,
                                                )
                                              : widget.reportType
                                                      .startsWith('Harassment')
                                                  ? Text(
                                                      'Bars Impression does not allow or promote any form or content related to ' +
                                                          widget.reportType +
                                                          ': Insults, threats, personally identifiable info',
                                                      style: TextStyle(
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Color(
                                                                  0xFFf2f2f2)
                                                              : Color(
                                                                  0xFF1a1a1a),
                                                          fontSize: 14),
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  : widget.reportType
                                                          .startsWith('Graphic')
                                                      ? Text(
                                                          'Bars Impression does not allow or promote any form or content related to ' +
                                                              widget
                                                                  .reportType +
                                                              ': Violent images or promotion of violence',
                                                          style: TextStyle(
                                                              color: ConfigBloc()
                                                                      .darkModeOn
                                                                  ? Color(
                                                                      0xFFf2f2f2)
                                                                  : Color(
                                                                      0xFF1a1a1a),
                                                              fontSize: 14),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )
                                                      : widget.reportType
                                                              .startsWith(
                                                                  'My intellectual property')
                                                          ? Text(
                                                              'Bars Impression does not allow or promote any form or content related to ' +
                                                                  widget
                                                                      .reportType +
                                                                  ': Copyright or trademark infringement',
                                                              style: TextStyle(
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Color(
                                                                          0xFFf2f2f2)
                                                                      : Color(
                                                                          0xFF1a1a1a),
                                                                  fontSize: 14),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )
                                                          : const SizedBox
                                                              .shrink()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30, bottom: 50),
                      child: ContentField(
                        labelText: 'Comment(optional)',
                        hintText: "We want to hear your opinion",
                        initialValue: '',
                        onSavedText: (input) => _comment = input,
                        onValidateText: (_) {},
                      ),
                    ),
                    FadeAnimation(
                      0.5,
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0.0, bottom: 40),
                          child: Container(
                            width: 250.0,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1.0, color: Colors.blue),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                ),
                                child: Container(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Text(
                                      'Submit Report',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: _submit),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
