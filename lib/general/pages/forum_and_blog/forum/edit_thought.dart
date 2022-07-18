import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditThought extends StatefulWidget {
  final Thought thought;
  final Forum forum;
  final String currentUserId;
  static final id = 'Edit_thought';

  EditThought(
      {required this.thought,
      required this.forum,
      required this.currentUserId});

  @override
  _EditThoughtState createState() => _EditThoughtState();
}

class _EditThoughtState extends State<EditThought> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  bool _isLoading = false;
  _showSelectImageDialog() {
    return Platform.isIOS
        ? _iosBottomSheet()
        : _androidDialog(
            context,
          );
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this thought?',
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
                  _deleteThought();
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

  _androidDialog(
    BuildContext parentContext,
  ) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Are you sure you want to delete this thought?'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteThought();
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

  _deleteThought() {
    DatabaseService.deleteThought(
        currentUserId: widget.currentUserId,
        thought: widget.thought,
        forum: widget.forum);
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

  @override
  void initState() {
    super.initState();
    _content = widget.thought.content;
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      Thought thought = Thought(
        id: widget.thought.id,
        content: _content,
        authorId: Provider.of<UserData>(context).currentUserId,
        timestamp: widget.thought.timestamp, count: null, report: '', reportConfirmed: '',
      );

      try {
        Navigator.pop(context);
        DatabaseService.editThought(thought, widget.forum);
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
            "Edited succesfully. Refesh your thought page",
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
            'Edit Thought',
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
                        tag: 'title' + widget.thought.id.toString(),
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
                                    "lets know your perspective on this topic",
                                hintStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                                labelText: 'Thought',
                                labelStyle: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                enabledBorder: new UnderlineInputBorder(
                                    borderSide:
                                        new BorderSide(color: Colors.grey))),
                            validator: (input) => input!.trim().length < 1
                                ? "Thought field can't be empty"
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
                          primary: Colors.blue,
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
                      onTap: () => _showSelectImageDialog(),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.blue,
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
                            onPressed: () => _showSelectImageDialog(),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, right: 50),
                      child: Text(
                        "Refresh your page to see effect of your thought edited or deleted",
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Thought fields can't be empty.",
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
