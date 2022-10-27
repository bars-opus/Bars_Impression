import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditQuestion extends StatefulWidget {
  final Ask ask;
  final Event event;
  final String currentUserId;
  static final id = 'Edit_questionss';

  EditQuestion(
      {required this.ask, required this.event, required this.currentUserId});

  @override
  _EditQuestionState createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';

  @override
  void initState() {
    super.initState();
    _content = widget.ask.content;
  }

  _showSelectImageDialog(Ask ask) {
    return Platform.isIOS
        ? _iosBottomSheet(ask)
        : _androidDialog(
            context,
            ask,
          );
  }

  _iosBottomSheet(ask) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this question?',
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
                  _deleteAsk(ask);
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

  _androidDialog(BuildContext parentContext, ask) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to delete this question?',
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
                    _deleteAsk(ask);
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

  _deleteAsk(Ask ask) {
    HapticFeedback.heavyImpact();
    DatabaseService.deleteAsk(
        currentUserId: widget.currentUserId, ask: ask, event: widget.event);
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

      Ask ask = Ask(
        id: widget.ask.id,
        content: _content,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.ask.timestamp,
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
        DatabaseService.editAsk(ask, widget.event);
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
      backgroundColor: Color(0xFFFF2D55),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Color(0xFFFF2D55),
        title: Material(
          color: Colors.transparent,
          child: Text(
            'Edit Question',
            style: TextStyle(
                color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
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
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
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
                            tag: 'title' + widget.ask.id.toString(),
                            child: Material(
                              color: Colors.transparent,
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                autofocus: true,
                                initialValue: _content,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                decoration: InputDecoration(
                                    hintText: "ask more to know more",
                                    hintStyle: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Ask',
                                    labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                    enabledBorder: new UnderlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.transparent))),
                                validator: (input) => input!.trim().length < 1
                                    ? "Ask field can't be empty"
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
                          primary: ConfigBloc().darkModeOn
                              ? Color(0xFF1a1a1a)
                              : Colors.white,
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
                      onTap: () => _showSelectImageDialog(widget.ask),
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
                            onPressed: () => _showSelectImageDialog(widget.ask),
                          ),
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
