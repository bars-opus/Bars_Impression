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
  bool _isLoading = false;

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
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
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
            title: Text('Are you sure you want to delete this vibe'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteComment(comment);
                },
              ),
              SimpleDialogOption(
                child: Text('cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  _deleteComment(Comment comment) {
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
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Comment comment = Comment(
        id: widget.comment.id,
        content: _content,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: widget.comment.timestamp,
        report: '',
        reportConfirmed: '',
      );

      try {
        Navigator.pop(context);
        DatabaseService.editComments(comment, widget.post);
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
            "Edited succesfully. Refesh your vibe page",
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
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        title: Material(
          color: Colors.transparent,
          child: Text(
            'Edit Vibe',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    _isLoading
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
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
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
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                labelText: 'Vibe',
                                labelStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.grey))),
                            validator: (input) => input!.trim().length < 1
                                ? "Comment field can't be empty"
                                : null,
                            onChanged: (input) => _content = input,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: 250.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.cyan[600],
                          elevation: 20.0,
                          onPrimary: Colors.blue,
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
                              'Save Edit',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => _showSelectImageDialog(widget.comment),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.cyan[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                              icon: Icon(Icons.delete_forever),
                              iconSize: 25,
                              color: ConfigBloc().darkModeOn
                                  ? Colors.black
                                  : Colors.white,
                              onPressed: () =>
                                  _showSelectImageDialog(widget.comment)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50),
                      child: Text(
                        "Refresh your page to see effect of your vibe edited or deleted",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Vibe fields can't be empty.",
                      style: TextStyle(color: Colors.blueGrey, fontSize: 12.0),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _isLoading
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
                        : SizedBox.shrink(),
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
