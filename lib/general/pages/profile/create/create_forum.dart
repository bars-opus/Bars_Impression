import 'package:bars/utilities/exports.dart';

class CreateForum extends StatefulWidget {
  final AccountHolder user;
  static final id = 'Create_forum';

  CreateForum({required this.user});

  @override
  _CreateForumState createState() => _CreateForumState();
}

class _CreateForumState extends State<CreateForum> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _subTitle = '';
  bool _isLoading = false;
  bool _isPrivate = false;

  _submit() async {
    if (_formKey.currentState!.validate() &&
        !_isLoading &&
        _title.isNotEmpty &&
        _subTitle.isNotEmpty) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Forum forum = Forum(
        title: _title,
        subTitle: _subTitle,
        report: '',
        reportConfirmed: '',
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        id: '',
        isPrivate: _isPrivate,
        linkedContentId: '',
        mediaType: '',
        mediaUrl: '',
        forumType: '', authorName: widget.user.userName!,
      );
      try {
        DatabaseService.createForum(forum);
        final double width = MediaQuery.of(context).size.width;
        Navigator.pop(context);
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
            widget.user.name!,
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Your Forum was published successfully.",
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
          duration: Duration(seconds: 1),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      } catch (e) {
        final double width = MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
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
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
        print(e.toString());
      }

      setState(() {
        _title = '';
        _subTitle = '';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CreateForumWidget(
          title: _title,
          initialSubTitle: '',
          initialTitle: '',
          subTitle: _subTitle,
          onSavedSubTitle: (input) => _subTitle = input,
          appBarTitle: 'Create Forum',
          buttonText: 'Publish Forum',
          onSavedTitle: (input) => _title = input,
          onValidateTitle: (input) => input.trim().isEmpty
              ? 'Please, enter a title for your forum.'
              : input.trim().length > 200
                  ? 'The title is too long (fewer than 200 characters)'
                  : input.trim().length < 20
                      ? 'The title is too short (more than 20 characters)'
                      : null,
          onValidatesubTitle: (input) => input.trim().isEmpty
              ? 'Please, give a brief explanation of your title'
              : input.trim().length > 500
                  ? 'The subtitle is too long (fewer then 500 characters)'
                  : input.trim().length < 30
                      ? 'The title is too short (more than 30 characters)'
                      : null,
          onPressedSubmite: () => _submit(),
          deletWidget: const SizedBox.shrink(),
          loadingWidget: _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    height: 2.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          pageHint: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => FeatureInfo(
                          feature: 'Forum',
                        ))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: PageHint(
                more: 'more',
                body:
                    "Create forums to share ideas and discuss topics in the music industry. You can create forums to debate on music topics, ask for advice and guidance when creating music works like beat production, video editing, and many more. You can also create forums asking for suggestions of people for collaborations and businesses. ",
                title: "Create Forums",
              ),
            ),
          )),
    );
  }
}
