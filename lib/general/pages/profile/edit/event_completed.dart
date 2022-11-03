import 'package:flutter/cupertino.dart';
import 'package:bars/utilities/exports.dart';

class EventCompleted extends StatefulWidget {
  final Event event;
  final String currentUserId;
  final String date;
  static final id = 'Edit_event';

  EventCompleted(
      {required this.event, required this.currentUserId, required this.date});

  @override
  _EventCompletedState createState() => _EventCompletedState();
}

class _EventCompletedState extends State<EventCompleted> {
  _showSelectImageDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog(context);
  }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              'Are you sure you want to delete this event?',
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
                  _deleteEvent();
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
            title: Text(
              'Are you sure you want to delete this event?',
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
                    _deleteEvent();
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

  _deleteEvent() {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.deleteEvent(
        currentUserId: currentUserId, event: widget.event, photoId: '');
    FirebaseStorage.instance
        .refFromURL(widget.event.imageUrl)
        .delete()
        .catchError(
          (e) => Flushbar(
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
          )..show(context),
        );
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
        'Done!!',
        style: TextStyle(
          color: Colors.white,
          fontSize: width > 800 ? 22 : 14,
        ),
      ),
      messageText: Text(
        "Deleted successfully. Refresh your event page",
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
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
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
            title: Text(
              'Event Completed',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  NoContents(
                      title: 'Congratulation',
                      subTitle: widget.event.title +
                          ' Which was dated on\n' +
                          widget.date +
                          ' has been successfully completed.\nAn event that is ongoing or completed can not be edited',
                      icon: Icons.done),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => () {},
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
                            color: Colors.blue,
                            onPressed: _showSelectImageDialog),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
