import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditForum extends StatefulWidget {
  final Forum forum;
  final String currentUserId;
  static final id = 'Edit_forum';

  EditForum({required this.forum, required this.currentUserId});

  @override
  _EditForumState createState() => _EditForumState();
}

class _EditForumState extends State<EditForum> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _subTitle = '';
  bool _isLoading = false;

  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this Forum?',
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
                  _deletePost();
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

  _androidDialog(BuildContext parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Are you sure you want to delete this Forum?'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _deletePost();
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

  _deletePost() {
    DatabaseService.deleteForum(
        currentUserId: widget.currentUserId, forum: widget.forum, photoId: '');
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
        "Deleted successfully. Refresh your forum page",
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
  }

  @override
  void initState() {
    super.initState();
    _title = widget.forum.title;
    _subTitle = widget.forum.subTitle;
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Forum forum = Forum(
        id: widget.forum.id,
        title: _title,
        subTitle: _subTitle,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId,
        timestamp: widget.forum.timestamp,
        report: '',
        reportConfirmed: '',
      );
      try {
        DatabaseService.editForum(
          forum,
        );
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
            "Edited succesfully. Refesh your forum page",
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
    return Form(
      key: _formKey,
      child: CreateForumWidget(
        title: _title,
        pageHint: SizedBox.shrink(),
        subTitle: _subTitle,
        onSavedSubTitle: (input) => _subTitle = input,
        appBarTitle: 'Edit Forum',
        buttonText: 'Save Edit',
        initialSubTitle: _subTitle,
        initialTitle: _title,
        onSavedTitle: (input) => _title = input,
        onValidateTitle: (input) => input.trim().isEmpty
            ? 'Please enter the title for your forum'
            : input.trim().length > 200
                ? 'The title is too long (less than 200 characters)'
                : input.trim().length < 20
                    ? 'The title is too short (more than 20 characters)'
                    : null,
        onValidatesubTitle: (input) => input.trim().isEmpty
            ? 'Please give a brief explanation of your title'
            : input.trim().length > 500
                ? 'The subtitle is too long (less then 500 characters)'
                : input.trim().length < 30
                    ? 'The title is too short (more than 30 characters)'
                    : null,
        onPressedSubmite: () => _submit(),
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
            : SizedBox.shrink(),
        deletWidget: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => _showSelectImageDialog(),
              child: Ink(
                decoration: BoxDecoration(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: 40,
                  width: 40,
                  child: IconButton(
                      icon: Icon(Icons.delete_forever),
                      iconSize: 25,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                      onPressed: () => _showSelectImageDialog()),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50),
              child: Text(
                " No fields should be empty\nRefresh your page to see the effect of your forum edited or deleted",
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
