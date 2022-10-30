import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditComments extends StatefulWidget {
  final Comment comment;
  final Post post;
  final String currentUserId;
  static final id = 'Edit_comments';

  EditComments(
      {required this.comment, required this.post, required this.currentUserId});

  @override
  _EditCommentsState createState() => _EditCommentsState();
}

class _EditCommentsState extends State<EditComments> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';

  @override
  void initState() {
    super.initState();
    _content = widget.comment.content;
  }

  _showSelectImageDialog(comment) {
    return Platform.isIOS
        ? _iosBottomSheet(comment)
        : _androidDialog(context, comment);
  }

  _iosBottomSheet(comment) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this vibe?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  'delete',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteComment(comment);
                },
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancle',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog(BuildContext parentContext, Comment comment) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to delete this vibe',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteComment(comment);
                  },
                ),
              ),
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    'Cancel',
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          );
        });
  }

  _deleteComment(Comment comment) {
    HapticFeedback.heavyImpact();
    DatabaseService.deleteComment(
        currentUserId: widget.currentUserId,
        comment: comment,
        post: widget.post);
    Navigator.pop(context);
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
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Deleted successfully",
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
      duration: Duration(seconds: 1),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      AccountHolder user = Provider.of<UserData>(context, listen: false).user!;
      Comment comment = Comment(
        id: widget.comment.id,
        content: _content,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.comment.timestamp,
        report: '',
        reportConfirmed: '',
        mediaType: '',
        mediaUrl: '',
        authorName: user.userName!,
        authorProfileHanlde: user.profileHandle!,
        authorProfileImageUrl: user.profileImageUrl!,
        authorVerification: '',
      );

      try {
        HapticFeedback.heavyImpact();
        Navigator.pop(context);
        DatabaseService.editComments(comment, widget.post);
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan[600],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.cyan[600],
        title: Material(
          color: Colors.transparent,
          child: Text(
            'Edit Vibe',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: ConfigBloc().darkModeOn
                                ? Color(0xFF1a1a1a)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: Hero(
                            tag: 'title' + widget.comment.id.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                initialValue: _content,
                                autofocus: true,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                decoration: InputDecoration(
                                    hintText:
                                        "lets know your perspective on this punch",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Vibe',
                                    labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.transparent))),
                                validator: (input) => input!.trim().length < 1
                                    ? "Comment field can't be empty"
                                    : null,
                                onChanged: (input) => _content = input,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: 250.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
                          elevation: 20.0,
                          foregroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () => _submit(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 10.0,
                            ),
                            Text(
                              'Save',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _showSelectImageDialog(widget.comment),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                              icon: Icon(Icons.delete_forever),
                              iconSize: 25,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: () =>
                                  _showSelectImageDialog(widget.comment)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
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
