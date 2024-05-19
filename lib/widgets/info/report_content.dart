import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class ReportContentPage extends StatefulWidget {
  static final id = 'ReportContentPage_screen';

  final String contentId;
  final String contentType;
  final String repotedAuthorId;
  final String? parentContentId;

  const ReportContentPage({
    required this.contentId,
    required this.contentType,
    required this.repotedAuthorId,
    required this.parentContentId,
  });

  @override
  _ReportContentPageState createState() => _ReportContentPageState();
}

class _ReportContentPageState extends State<ReportContentPage> {
  _widget(String title, String subTitle, String reportType) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: IntroInfo(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ReportContentSubmission(
                      parentContentId: widget.parentContentId!,
                      repotedAuthorId: widget.repotedAuthorId,
                      reportType: reportType,
                      contentType: widget.contentType,
                      contentId: widget.contentId,
                    ))),
        title: title,
        subTitle: subTitle,
        icon: Icons.arrow_forward_ios_outlined,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorLight,
        title: Material(
          color: Colors.transparent,
          child: Text(
            'Report ' + widget.contentType,
            style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 20.0),
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Select a reason ',
                  style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 16.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'You can submit a report if you think this ' +
                      widget.contentType +
                      ' goes against Bars Impressions guidelines. This is important in helping us keep Bars Impression safe. We won\'t notify the account that you submitted this report. We will review this report, and actions will be taken if deemed a violation of guidelines',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                  ),
                ),
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Spam',
                "Misleading or repetitive content",
                'Spam',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Nudity or Pornography',
                "Sexually explicit content",
                'Nudity or Pornography',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Misinformation',
                "Health misinformation or conspiracies",
                'Misinformation',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Hateful Activities',
                "Prejudice, stereotypes, white supremacy, slurs, racism",
                'Hateful Activities',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Dangerous goods',
                "Drugs, regulated products",
                'Dangerous goods',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Harassment or privacy violations',
                "Insults, threats, personally identifiable info",
                'Harassment or privacy violations',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'Graphic violence',
                "Violent images or promotion of violence",
                'Graphic violence',
              ),
              Divider( thickness: .2,color: Colors.grey),
              _widget(
                'My intellectual property',
                "Copyright or trademark infringement.",
                'My intellectual property',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
