// ignore_for_file: unnecessary_null_comparison

import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CreateEventWidget extends StatefulWidget {
  final AccountHolder? user;

  File? image;
  bool isEditting;
  String title;
  String rate;
  String venue;
  String time;
  String guess;
  String theme;
  String dj;
  String type;
  String imageUrl;
  String host;
  String artist;
  String dressCode;
  String date;
  String previousEvent;
  String ticketSite;
  String triller;
  String city;
  String country;
  String virtualVenue;
  Event? event;
  bool isVirtual;
  static final id = 'Create_event';

  CreateEventWidget({
    this.user,
    required this.image,
    required this.isEditting,
    required this.title,
    required this.rate,
    required this.venue,
    required this.time,
    required this.guess,
    required this.host,
    required this.artist,
    required this.dressCode,
    required this.date,
    required this.imageUrl,
    required this.dj,
    required this.type,
    required this.theme,
    required this.previousEvent,
    required this.ticketSite,
    required this.triller,
    required this.city,
    required this.country,
    required this.virtualVenue,
    required this.event,
    required this.isVirtual,
  });

  @override
  _CreateEventWidgetState createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
  int index = 0;
  int showDatePicker = 0;
  // late DateTime _date;
  // late DateTime _toDaysDate;
  // int _different = 0;
  int showTimePicker = 0;
  bool _isLoading = false;
  bool _isVirtual = false;
  bool _isPhysical = false;
  bool _isfetchingAddress = false;
  int eventTypeIndex = 0;
  int showEventTypePicker = 0;
  late PageController _pageController;
  int _indexx = 0;
  DateTime dateTime = DateTime.now();
  DateTime minDateTime = DateTime.now().subtract(Duration(days: 1));
  DateTime minTime = DateTime.now().subtract(Duration(minutes: 1));
  DateTime dayTime = DateTime.now();
  String selectedValue = '';
  String _type = '';

  final musicVideoLink =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    // _countDown();
    _type = widget.type;
    selectedValue = _type.isEmpty ? values.last : _type;
    _pageController = PageController(
      initialPage: widget.isEditting ? 1 : 0,
    );

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPostImage(null);
      Provider.of<UserData>(context, listen: false).setPost1(widget.title);
      Provider.of<UserData>(context, listen: false).setPost2(widget.theme);
      Provider.of<UserData>(context, listen: false).setPost3(widget.rate);
      Provider.of<UserData>(context, listen: false).setPost4(widget.host);
      Provider.of<UserData>(context, listen: false).setPost5(widget.venue);
      Provider.of<UserData>(context, listen: false).setPost6(widget.type);
      Provider.of<UserData>(context, listen: false).setPost7(widget.time);
      Provider.of<UserData>(context, listen: false).setPost8(widget.date);
      Provider.of<UserData>(context, listen: false).setPost9(widget.city);
      Provider.of<UserData>(context, listen: false).setPost10(widget.country);
    });
  }

  // _countDown() async {
  //   DateTime date = DateTime.parse(widget.date);
  //   final toDayDate = DateTime.now();
  //   // var different = date.difference(toDayDate).inDays;

  //   setState(() {
  //     // _different = different;
  //     _date = date;
  //     _toDaysDate = toDayDate;
  //   });
  // }

  _handleImage() async {
    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;
    if (file != null) {
      if (mounted) {
        Provider.of<UserData>(context, listen: false)
            .setPostImage(file as File);
      }
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

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
            title: Text('Are you sure you want to delete this event?'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('delete'),
                onPressed: () {
                  Navigator.pop(context);
                  _deleteEvent();
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

  _deleteEvent() {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId!;
    DatabaseService.deleteEvent(
        currentUserId: currentUserId, event: widget.event!, photoId: '');
    FirebaseStorage.instance
        .refFromURL(widget.event!.imageUrl)
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
              'Sorry',
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
        MdiIcons.checkCircleOutline,
        size: 30.0,
        color: Colors.blue,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _submitEdit() async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      _formKey.currentState?.save();
      String _imageUrl = widget.event!.imageUrl;
      Event event = Event(
        id: widget.event!.id,
        imageUrl: _imageUrl,
        type: Provider.of<UserData>(context, listen: false).post6,
        title: Provider.of<UserData>(context, listen: false).post1,
        rate: Provider.of<UserData>(context, listen: false).post3,
        venue: widget.isVirtual || _isVirtual
            ? ''
            : Provider.of<UserData>(context, listen: false).post5,
        time: Provider.of<UserData>(context, listen: false).post7,
        date: Provider.of<UserData>(context, listen: false).post8,
        theme: Provider.of<UserData>(context, listen: false).post2,
        dressCode: widget.dressCode,
        dj: widget.dj,
        guess: widget.guess,
        host: Provider.of<UserData>(context, listen: false).post4!,
        artist: widget.artist,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.event!.timestamp,
        previousEvent: widget.previousEvent,
        triller: widget.triller,
        reportConfirmed: '',
        city: Provider.of<UserData>(context, listen: false).post9,
        country: Provider.of<UserData>(context, listen: false).post10,
        virtualVenue: widget.isVirtual || _isVirtual
            ? Provider.of<UserData>(context, listen: false).post5
            : '',
        ticketSite: widget.ticketSite,
        isVirtual: widget.isVirtual,
        report: '',
      );

      try {
        DatabaseService.editEvent(event);
        Navigator.pop(context);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
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
            "Edited successfully. Refresh your event page",
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
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
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
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }
  }

  _reverseGeocoding() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Location> locations = await locationFromAddress(
          Provider.of<UserData>(context, listen: false).post5);
      List<Placemark> placemarks = await placemarkFromCoordinates(
          locations[0].latitude, locations[0].longitude);
      placemarks[0].toString();
      String s = Provider.of<UserData>(context, listen: false).post5;
      var pos = s.lastIndexOf('.');
      String result = (pos != -1) ? s.substring(0, pos) : s;
      setState(() {
        index = 0;
        Provider.of<UserData>(context, listen: false).setPost10(
            placemarks[0].country! == null ? result : placemarks[0].country!);
      });
    } catch (e) {}
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
    setState(() {
      _isLoading = false;
    });
    animateToPage();
  }

  _submitCreate() async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      _formKey.currentState?.save();
      setState(() {
        _isLoading = true;
      });
      final double width = Responsive.isDesktop(context)
          ? 600.0
          : MediaQuery.of(context).size.width;
      FocusScope.of(context).unfocus();
      Flushbar(
        maxWidth: MediaQuery.of(context).size.width,
        backgroundColor: Color(0xFF1a1a1a),
        margin: EdgeInsets.all(8),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Color(0xFF1a1a1a),
        progressIndicatorValueColor: AlwaysStoppedAnimation(Colors.blue),
        flushbarPosition: FlushbarPosition.TOP,
        boxShadows: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
        titleText: Text(
          'Creating event',
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 22 : 14,
          ),
        ),
        messageText: Text(
          "Please wait...",
          style: TextStyle(
            color: Colors.white,
            fontSize: width > 800 ? 20 : 12,
          ),
        ),
        duration: Duration(seconds: 3),
      )..show(context);

      String? imageUrl = await StorageService.uploadEvent(
          Provider.of<UserData>(context, listen: false).postImage!);

      Event event = Event(
        imageUrl: imageUrl,
        type: Provider.of<UserData>(context, listen: false).post6.isEmpty
            ? "Others"
            : Provider.of<UserData>(context, listen: false).post6,
        title: Provider.of<UserData>(context, listen: false).post1,
        rate: Provider.of<UserData>(context, listen: false).post3,
        venue: widget.isVirtual || _isVirtual
            ? ''
            : Provider.of<UserData>(context, listen: false).post5,
        time: Provider.of<UserData>(context, listen: false).post7,
        date: Provider.of<UserData>(context, listen: false).post8,
        theme: Provider.of<UserData>(context, listen: false).post2,
        dressCode: widget.dressCode,
        dj: widget.dj,
        guess: widget.guess,
        host: Provider.of<UserData>(context, listen: false).post4!,
        artist: widget.artist,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: Timestamp.fromDate(DateTime.now()),
        previousEvent: widget.previousEvent,
        triller: widget.triller,
        report: '',
        reportConfirmed: '',
        city: Provider.of<UserData>(context, listen: false).post9,
        country: Provider.of<UserData>(context, listen: false).post10,
        virtualVenue: widget.isVirtual || _isVirtual
            ? Provider.of<UserData>(context, listen: false).post5
            : '',
        ticketSite: widget.ticketSite,
        isVirtual: widget.isVirtual,
        id: '',
      );
      try {
        DatabaseService.createEvent(event);
        Navigator.pop(context);
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
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
            widget.user!.name!,
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            "Your event was created successfully.",
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
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
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
        widget.image = null;
        widget.title = '';
        widget.rate = '';
        widget.venue = '';
        widget.time = '';
        widget.dj = '';
        widget.guess = '';
        widget.host = '';
        widget.artist = '';
        widget.theme = '';
        widget.dressCode = '';
        widget.type = '';
        widget.date = '';
        _isLoading = false;
        setNull();
      });
    }
  }

  static const values = <String>[
    "Festival",
    "Award",
    "Tour",
    "Album_Launch",
    "Others",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(color: color, fontSize: 14),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _type = (this.selectedValue = value!);
                Provider.of<UserData>(context, listen: false)
                    .setPost6(this.selectedValue = value);
              },
            ),
          );
        }).toList()),
      );

  Widget buildEventTypePicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select event type.',
                style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildRadios(),
            ],
          ),
          SizedBox(height: 70),
          Container(
            width: 200,
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.blue,
                  side: BorderSide(
                    width: 1.0,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  'Pick Event Type',
                  style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  ),
                ),
                onPressed: () {
                  Provider.of<UserData>(context, listen: false)
                      .setPost6('Others');
                  animateToPage();
                }),
          ),
        ],
      );

  Widget buildTImePicker() => Column(
        children: [
          Text(
            widget.date.isEmpty
                ? MyDateFormat.toTime(dateTime)
                : MyDateFormat.toTime(DateTime.parse(widget.time)),
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CupertinoDatePicker(
                initialDateTime: widget.date.isEmpty
                    ? minDateTime
                    : DateTime.parse(widget.time),
                mode: CupertinoDatePickerMode.time,
                backgroundColor: Colors.white,
                onDateTimeChanged: (dayTime) =>
                    setState(() => this.dayTime = dayTime),
              ),
            ),
          ),
          SizedBox(height: 70),
          widget.isEditting
              ? AlwaysWhiteButton(
                  onPressed: () {
                    Provider.of<UserData>(context, listen: false)
                        .setPost7(dayTime.toString());
                    setState(() {
                      widget.time = dayTime.toString();
                    });
                    animateToPage();
                    print(
                      widget.time,
                    );
                  },
                  buttonText: widget.isEditting ? 'Next' : "Continue")
              : AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: minTime.isBefore(dayTime) ? 0.0 : null,
                  curve: Curves.bounceInOut,
                  child: Container(
                    width: 200,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(
                            width: 1.0,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Pick Time',
                          style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<UserData>(context, listen: false)
                              .setPost7(dayTime.toString());
                          setState(() {
                            widget.time = dayTime.toString();
                          });
                          animateToPage();
                          print(
                            widget.time,
                          );
                        }),
                  ),
                ),
        ],
      );

  Widget buildDatePicker() => Column(
        children: [
          Text(
            widget.date.isEmpty
                ? DateFormat.yMMMMEEEEd().format(dateTime)
                : MyDateFormat.toDate(
                    DateTime.parse(widget.date),
                  ),
            style: TextStyle(
                color: Colors.blue, fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            height: 300,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CupertinoDatePicker(
                minimumYear: 2021,
                maximumYear: 2023,
                minimumDate: minDateTime,
                initialDateTime: widget.date.isEmpty
                    ? minDateTime
                    : DateTime.parse(widget.date),
                backgroundColor:
                    ConfigBloc().darkModeOn ? Colors.white : Colors.transparent,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (dateTime) =>
                    setState(() => this.dateTime = dateTime),
              ),
            ),
          ),
          SizedBox(height: 70),
          widget.isEditting
              ? AlwaysWhiteButton(
                  onPressed: () {
                    Provider.of<UserData>(context, listen: false)
                        .setPost8(dateTime.toString());
                    setState(() {
                      widget.date = dateTime.toString();
                    });
                    animateToPage();
                  },
                  buttonText: widget.isEditting ? 'Next' : "Continue")
              : AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: minDateTime
                              .add(Duration(days: 1))
                              .isAtSameMomentAs(dateTime) ||
                          minDateTime.isAfter(dateTime) ||
                          minDateTime.add(Duration(days: 1)).isAfter(dateTime)
                      ? 0.0
                      : null,
                  curve: Curves.bounceInOut,
                  child: Container(
                    width: 200,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          side: BorderSide(
                            width: 1.0,
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Pick Date',
                          style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<UserData>(context, listen: false)
                              .setPost8(dateTime.toString());
                          setState(() {
                            widget.date = dateTime.toString();
                          });
                          animateToPage();
                        }),
                  ),
                ),
        ],
      );

  animateBack() {
    _pageController.animateToPage(
      _indexx - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToPage() {
    _pageController.animateToPage(
      _indexx + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  _isVirtualEvent() {
    setState(() {
      _isVirtual = true;
      widget.isVirtual = true;
      _isPhysical = false;
    });
  }

  _isPhysicalEvent() {
    setState(() {
      _isPhysical = true;
      _isVirtual = false;
      widget.isVirtual = false;
    });
  }

  _validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      animateToPage();
    }
  }

  _validate2() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      animateToPage2();
    }
  }

  animateToPage2() {
    _pageController.animateToPage(
      _indexx + 2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  _displayPostImage() {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    if (widget.imageUrl.isNotEmpty) {
      return Container(
          height: width,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: CachedNetworkImageProvider(widget.imageUrl),
            fit: BoxFit.cover,
          )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5),
            ])),
          ));
    } else {
      return GestureDetector(
        onTap: _handleImage,
        child: Container(
          child: Provider.of<UserData>(context).postImage == null
              ? Center(
                  child: InkBoxColumn(
                    size: 2,
                    onPressed: _handleImage,
                    icon: Icon(
                      Icons.add_a_photo,
                      size: 150,
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                    text: '',
                  ),
                )
              : Image(
                  height: width,
                  width: width,
                  image: FileImage(
                      File(Provider.of<UserData>(context).postImage!.path)),
                  fit: BoxFit.cover,
                ),
        ),
      );
    }
  }

  setNull() {
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setPost1('');
    Provider.of<UserData>(context, listen: false).setPost2('');
    Provider.of<UserData>(context, listen: false).setPost3('');
    Provider.of<UserData>(context, listen: false).setPost4('');
    Provider.of<UserData>(context, listen: false).setPost5('');
    Provider.of<UserData>(context, listen: false).setPost6('');
    Provider.of<UserData>(context, listen: false).setPost7('');
    Provider.of<UserData>(context, listen: false).setPost8('');
    Provider.of<UserData>(context, listen: false).setPost9('');
    Provider.of<UserData>(context, listen: false).setPost10('');
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  _pop() {
    Navigator.pop(context);
    setNull();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          ),
          leading: widget.isEditting
              ? IconButton(
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () {
                    _indexx == 1 || _indexx == 0
                        ? Navigator.pop(context)
                        : animateBack();
                  })
              : IconButton(
                  icon: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                  onPressed: () {
                    _indexx != 0 ? animateBack() : _pop();
                  }),
          elevation: 0,
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          title: Material(
            color: Colors.transparent,
            child: Text(
              widget.isEditting ? 'Edit Event' : 'Create Event',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: PageView(
              controller: _pageController,
              physics: AlwaysScrollableScrollPhysics(),
              onPageChanged: (int index) {
                setState(() {
                  _indexx = index;
                });
              },
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            child: DecisionContainer(
                              questions:
                                  'You can create an event where people can attend or you can also create a virtual event that can be hosted on virtual platforms, where people can interact with you. Are You Creating A you creating a physical event or a virtual event?',
                              answer1: 'Virtual Event',
                              answer2: 'Physical Event',
                              onPressed1: _isVirtualEvent,
                              onPressed2: _isPhysicalEvent,
                              isPicked1: _isVirtual,
                              isPicked2: _isPhysical,
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: _isVirtual || _isPhysical ? 130 : 0.0,
                            width: double.infinity,
                            curve: Curves.bounceInOut,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 70.0),
                                child: AlwaysWhiteButton(
                                    onPressed: () {
                                      animateToPage();
                                    },
                                    buttonText: "Continue"),
                              ),
                            ),
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: _isVirtual || _isPhysical ? 0.0 : width,
                            curve: Curves.bounceInOut,
                            child: SingleChildScrollView(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FeatureInfo(
                                              feature: 'Event',
                                            ))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: PageHint(
                                    more: 'more',
                                    body:
                                        "Create an event where people can attend, have fun, create memories, and have unforgettable experiences.",
                                    title: "Create Events.",
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DirectionWidget(
                            text:
                                'Select a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event and the information already provided in the previous stages. We advise you to select a great background image. ',
                            fontSize: null,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          _displayPostImage(),
                          widget.imageUrl.isNotEmpty && widget.isEditting
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 50.0),
                                  child: AlwaysWhiteButton(
                                      onPressed: _validate2,
                                      buttonText: "Next"),
                                )
                              : Provider.of<UserData>(context, listen: false)
                                          .postImage ==
                                      null
                                  ? SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 50.0),
                                      child: AlwaysWhiteButton(
                                          onPressed: _validate,
                                          buttonText: "Continue"),
                                    ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DirectionWidget(
                          fontSize: null,
                          text:
                              'Select an event type that matches the event you are creating. ',
                        ),
                        buildEventTypePicker(),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DirectionWidget(
                          fontSize: null,
                          text:
                              'Select the exact time your event would begin. ',
                        ),
                        SizedBox(height: 20),
                        buildTImePicker(),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DirectionWidget(
                          fontSize: null,
                          text:
                              'Select the exact date of your event. You cannot select today\'s date. ',
                        ),
                        SizedBox(height: 20),
                        buildDatePicker(),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 30,
                    ),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _isLoading
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: SizedBox(
                                      height: 2.0,
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.blue),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            Provider.of<UserData>(context, listen: false)
                                    .post5
                                    .isNotEmpty
                                ? AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: Provider.of<UserData>(context,
                                                listen: false)
                                            .post5
                                            .isEmpty
                                        ? 0.0
                                        : null,
                                    curve: Curves.easeInOut,
                                    child: Text(
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .post5
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : _isfetchingAddress
                                    ? SizedBox.shrink()
                                    : DirectionWidget(
                                        fontSize: null,
                                        text: widget.isVirtual || _isVirtual
                                            ? 'Enter the host link of the event. It will help other users virtually join the event if they are interested. '
                                            : 'Enter the address venue of the event. Make sure you select the correct address from the list suggested below. It will help other users navigate to the venue if they are interested. ',
                                      ),
                            Text(
                              Provider.of<UserData>(context, listen: false)
                                  .post10
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            widget.isVirtual || _isVirtual
                                ? ContentField(
                                    labelText: "Virtual venue",
                                    hintText: "Link to virtual event venue",
                                    initialValue: widget.virtualVenue,
                                    onSavedText: (input) =>
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .setPost5(input),
                                    onValidateText: (_) {},
                                  )
                                : TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: _controller,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    autovalidateMode: AutovalidateMode.always,
                                    onChanged: (value) => {
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .searchAddress(value),
                                      setState(() {
                                        _isfetchingAddress = true;
                                      })
                                    },
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    initialValue: widget.venue,
                                    decoration: InputDecoration(
                                        hintText: "Event venue address",
                                        hintStyle: TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.grey,
                                        ),
                                        labelText: 'Venue',
                                        labelStyle: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.grey))),
                                  ),
                            if (Provider.of<UserData>(context, listen: false)
                                    .addressSearchResults !=
                                null)
                              SizedBox(
                                height: 30,
                              ),
                            widget.isVirtual || _isVirtual
                                ? SizedBox.shrink()
                                : SizedBox.shrink(),
                            Container(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Tap to below to select the venue\'s address',
                                    style: TextStyle(
                                      color: ConfigBloc().darkModeOn
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (Provider.of<UserData>(
                                  context,
                                ).addressSearchResults !=
                                null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SingleChildScrollView(
                                  child: widget.isVirtual || _isVirtual
                                      ? SizedBox.shrink()
                                      : Column(
                                          children: [
                                            _isfetchingAddress
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0,
                                                            top: 10),
                                                    child: SizedBox(
                                                      height: 2.0,
                                                      child:
                                                          LinearProgressIndicator(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        valueColor:
                                                            AlwaysStoppedAnimation(
                                                                Colors.grey),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  100,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: ListView.builder(
                                                itemCount:
                                                    Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .addressSearchResults!
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                      title: Text(
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .addressSearchResults![
                                                                index]
                                                            .description,
                                                        style: TextStyle(
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .setPost5(Provider.of<
                                                                        UserData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .addressSearchResults![
                                                                    index]
                                                                .description);
                                                        setState(() {
                                                          _isfetchingAddress =
                                                              false;

                                                          widget
                                                              .venue = Provider
                                                                  .of<UserData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                              .addressSearchResults![
                                                                  index]
                                                              .description;
                                                        });
                                                        _reverseGeocoding();
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            SizedBox(height: 20),
                            widget.isEditting
                                ? AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: null,
                                    curve: Curves.easeInOut,
                                    child: Center(
                                      child: AlwaysWhiteButton(
                                          onPressed: _validate,
                                          buttonText: 'Next'),
                                    ),
                                  )
                                : AnimatedContainer(
                                    duration: Duration(milliseconds: 500),
                                    height: Provider.of<UserData>(context,
                                                listen: false)
                                            .post5
                                            .isEmpty
                                        ? 0.0
                                        : null,
                                    curve: Curves.easeInOut,
                                    child: Center(
                                      child: AlwaysWhiteButton(
                                          onPressed: _validate,
                                          buttonText: widget.isEditting
                                              ? 'Next'
                                              : "Continue"),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          DirectionWidget(
                            fontSize: null,
                            text:
                                'Provide the necessary information below correctly. The fields on this page cannot be empty. ',
                          ),
                          ContentField(
                            labelText: 'Title',
                            hintText: "Enter the title of your event",
                            initialValue:
                                Provider.of<UserData>(context, listen: false)
                                    .post1
                                    .toString(),
                            onSavedText: (input) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost1(input),
                            onValidateText: (input) => input.trim().length < 1
                                ? "The title cannot be empty"
                                : null,
                          ),
                          ContentField(
                            labelText: 'Theme',
                            hintText: "Enter a theme of event",
                            initialValue:
                                Provider.of<UserData>(context, listen: false)
                                    .post2
                                    .toString(),
                            onSavedText: (input) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost2(input),
                            onValidateText: (input) => input.trim().length < 5
                                ? "The theme is too short"
                                : null,
                          ),
                          ContentField(
                            labelText: 'Rate',
                            hintText:
                                "currency - amount: example (\$: 00.0) or Free   ",
                            initialValue:
                                Provider.of<UserData>(context, listen: false)
                                    .post3
                                    .toString(),
                            onSavedText: (input) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost3(input),
                            onValidateText: (input) => input.trim().length < 3
                                ? "The price rate cannot be empty"
                                : null,
                          ),
                          ContentField(
                            labelText: 'Host',
                            hintText: "Name of event host",
                            initialValue:
                                Provider.of<UserData>(context, listen: false)
                                    .post4
                                    .toString(),
                            onSavedText: (input) =>
                                Provider.of<UserData>(context, listen: false)
                                    .setPost4(input),
                            onValidateText: (input) => input.trim().length < 1
                                ? "The host cannot be empty"
                                : null,
                          ),
                          Provider.of<UserData>(context, listen: false)
                                  .post10
                                  .isEmpty
                              ? ContentField(
                                  labelText: 'Country',
                                  hintText: "Country of event",
                                  initialValue: Provider.of<UserData>(context,
                                          listen: false)
                                      .post4
                                      .toString(),
                                  onSavedText: (input) => Provider.of<UserData>(
                                          context,
                                          listen: false)
                                      .setPost4(input),
                                  onValidateText: (input) =>
                                      input.trim().length < 1
                                          ? "Enter the country of event"
                                          : null,
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 70),
                          AlwaysWhiteButton(
                              onPressed: _validate,
                              buttonText:
                                  widget.isEditting ? 'Next' : "Continue"),
                        ],
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        DirectionWidget(
                          fontSize: null,
                          text:
                              'You can provide the following information if available for your event. The information required on this page is optional. ',
                        ),
                        ContentField(
                          labelText: "Name of Dj",
                          hintText: 'Dj (optional)',
                          initialValue: widget.dj,
                          onSavedText: (input) => widget.dj = input,
                          onValidateText: (_) {},
                        ),
                        ContentField(
                          labelText: "Name(s) of guests",
                          hintText: 'Special Guests (optional)',
                          initialValue: widget.guess,
                          onSavedText: (input) => widget.guess = input,
                          onValidateText: (_) {},
                        ),
                        ContentField(
                          labelText: "Dress code for event",
                          hintText: 'Dress code (optional)',
                          initialValue: widget.dressCode,
                          onSavedText: (input) => widget.dressCode = input,
                          onValidateText: (_) {},
                        ),
                        ContentField(
                          labelText: "Name(s) of artists",
                          hintText: 'Artist Performing (optional)',
                          initialValue: widget.artist,
                          onSavedText: (input) => widget.artist = input,
                          onValidateText: (_) {},
                        ),
                        ContentField(
                          labelText: "Ticket site",
                          hintText: 'Website to purchase ticket (optional)',
                          initialValue: widget.ticketSite,
                          onSavedText: (input) => widget.ticketSite = input,
                          onValidateText: (_) {},
                        ),
                        ContentField(
                          labelText: "Previous event",
                          hintText:
                              'Music video link of previous events (optional)',
                          initialValue: widget.previousEvent,
                          onSavedText: (input) => widget.previousEvent = input,
                          onValidateText: (input) =>
                              !musicVideoLink.hasMatch(input) &&
                                      input.trim().length > 1
                                  ? "Enter a valid music video link"
                                  : null,
                        ),
                        SizedBox(height: 70),
                        _isLoading
                            ? SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: AvatarCircularButton(
                                  buttonText:
                                      widget.isEditting ? 'Save' : "Create",
                                  onPressed: widget.isEditting
                                      ? _submitEdit
                                      : _submitCreate,
                                ),
                              ),
                        widget.isEditting
                            ? Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: () => () {},
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
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
                                            onPressed: _showSelectImageDialog),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 50.0, right: 50),
                                    child: Text(
                                      " Provide accurate information.\nRefresh your page to see the effect of your event edited or deleted",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              )
                            : SizedBox.shrink(),
                        _isLoading
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: SizedBox(
                                  height: 2.0,
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.blue),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
