import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';

class EditAdvice extends StatefulWidget {
  final UserAdvice advice;
  final AccountHolder user;
  final String currentUserId;
  static final id = 'Edit_advice';

  EditAdvice(
      {required this.advice, required this.user, required this.currentUserId});

  @override
  _EditAdviceState createState() => _EditAdviceState();
}

class _EditAdviceState extends State<EditAdvice> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';

  _showSelectImageDialog(advice) {
    return Platform.isIOS
        ? _iosBottomSheet(advice)
        : _androidDialog(context, advice);
  }

  _iosBottomSheet(advice) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this advice?',
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
                  _deleteAdvice(advice);
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

  _androidDialog(BuildContext parentContext, UserAdvice advice) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Are you sure you want to delete this advice?',
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
                    _deleteAdvice(advice);
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

  _deleteAdvice(UserAdvice advice) {
    HapticFeedback.heavyImpact();

    DatabaseService.deleteAdvice(
        currentUserId: widget.currentUserId, advice: advice, user: widget.user);
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

  @override
  void initState() {
    super.initState();
    _content = widget.advice.content;
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      UserAdvice advice = UserAdvice(
        id: widget.advice.id,
        content: _content,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.advice.timestamp,
        report: '',
        reportConfirmed: '',
      );

      try {
        HapticFeedback.heavyImpact();
        Navigator.pop(context);
        DatabaseService.editAdvice(advice, widget.user);
        final double width = MediaQuery.of(context).size.width;
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
      backgroundColor:
          ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        title: Material(
          color: Colors.transparent,
          child: Text(
            'Edit Advice',
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
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
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
                              hintText: "leave an advice",
                              hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                              labelText: 'Advice',
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
                    SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: 250.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
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
                                color: Colors.black,
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
                      onTap: () => _showSelectImageDialog(widget.advice),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          height: 40,
                          width: 40,
                          child: IconButton(
                              icon: Icon(Icons.delete_forever),
                              iconSize: 25,
                              color: Colors.black,
                              onPressed: () =>
                                  _showSelectImageDialog(widget.advice)),
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
