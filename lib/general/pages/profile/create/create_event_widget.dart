// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';
import 'package:bars/widgets/create_content_white.dart';
import 'package:blurhash/blurhash.dart';
import 'package:bars/utilities/exports.dart';
import 'package:currency_picker/currency_picker.dart';
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
  String clossingDay;
  Event? event;
  bool isVirtual;
  bool isPrivate;
  bool isFree;
  bool isCashPayment;
  bool showOnExplorePage;
  bool showToFollowers;
  static final id = 'Create_event';

  CreateEventWidget(
      {this.user,
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
      required this.isPrivate,
      required this.isFree,
      required this.isCashPayment,
      required this.clossingDay,
      required this.showOnExplorePage,
      required this.showToFollowers});

  @override
  _CreateEventWidgetState createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
  int index = 0;
  int showDatePicker = 0;
  int showTimePicker = 0;
  bool _isfetchingAddress = false;
  int eventTypeIndex = 0;
  int showEventTypePicker = 0;
  late PageController _pageController;
  // int _indexx = 0;
  DateTime dateTime = DateTime.now();
  DateTime minDateTime = DateTime.now().subtract(Duration(days: 1));
  DateTime minTime = DateTime.now().subtract(Duration(minutes: 1));
  DateTime dayTime = DateTime.now();
  String selectedValue = '';
  String selectedclosingDay = '';
  String _type = '';
  bool _showSheet = false;

  String _closingDay = '';

  final musicVideoLink =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    _type = widget.type;
    // _indexx = widget.isEditting ? 5 : 0;
    selectedValue = _type.isEmpty ? values.last : _type;
    selectedclosingDay =
        _closingDay.isEmpty ? eventClossingDay.first : _closingDay;
    _pageController = PageController(
      initialPage: widget.isEditting ? 5 : 0,
    );

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setInt1(
        widget.isEditting ? 5 : 0,
      );
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
      Provider.of<UserData>(context, listen: false).setPost11(widget.guess);
      Provider.of<UserData>(context, listen: false).setPost12(widget.artist);
      Provider.of<UserData>(context, listen: false).setBool1(widget.isPrivate);
      Provider.of<UserData>(context, listen: false).setBool2(widget.isVirtual);
      Provider.of<UserData>(context, listen: false).setBool3(widget.isFree);
      Provider.of<UserData>(context, listen: false)
          .setPost13(widget.clossingDay);
      Provider.of<UserData>(context, listen: false).setPost14('');
      Provider.of<UserData>(context, listen: false).setIsLoading(false);
      Provider.of<UserData>(context, listen: false)
          .setBool4(widget.isCashPayment);
      Provider.of<UserData>(context, listen: false)
          .setBool5(widget.showOnExplorePage);
      Provider.of<UserData>(context, listen: false)
          .setBool6(widget.showToFollowers);
    });
  }

  // _handleImage() async {
  //   final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
  //   if (file == null) return;
  //   if (file != null) {
  //     if (mounted) {
  //       Provider.of<UserData>(context, listen: false)
  //           .setPostImage(file as File);
  //     }
  //   }
  // }

  _handleImage() async {
    HapticFeedback.heavyImpact();

    final file = await PickCropImage.pickedMedia(cropImage: _cropImage);
    if (file == null) return;

    if (mounted) {
      Provider.of<UserData>(context, listen: false).setPostImage(file as File);
    }
  }

  Future<File> _cropImage(File imageFile) async {
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.5),
    );
    return croppedImage!;
  }

  _showSelectImageDialog(String action) {
    return Platform.isIOS
        ? _iosBottomSheet(action)
        : _androidDialog(context, action);
  }

  _iosBottomSheet(String action) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text(
              action.startsWith('create')
                  ? 'Certiain information of an event cannot be modified once an event is created. Information such as date, time, category, flyer background, and event settings cannot be changed.\nWould you like to continue and create event?'
                  : 'Are you sure you want to delete this event?',
              textAlign: action.startsWith('create')
                  ? TextAlign.start
                  : TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(
                  action.startsWith('create') ? 'Create' : 'Delete',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  action.startsWith('create')
                      ? _submitCreate()
                      : _deleteEvent();
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

  _androidDialog(BuildContext parentContext, String action) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              action.startsWith('create')
                  ? 'Certiain information of an event cannot be modified once an event is created. Information such as date, time, category, flyer background, and event settings cannot be changed.\nWould you like to continue and create event?'
                  : 'Are you sure you want to delete this event?',
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: action.startsWith('create')
                  ? TextAlign.start
                  : TextAlign.center,
            ),
            children: <Widget>[
              Divider(),
              Center(
                child: SimpleDialogOption(
                  child: Text(
                    action.startsWith('create') ? 'Create' : 'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    action.startsWith('create')
                        ? _submitCreate()
                        : _deleteEvent();
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
              e.contains(']')
                  ? e.substring(e.lastIndexOf(']') + 1).toString()
                  : e.toString(),
              // e.toString(),
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
      duration: Duration(seconds: 2),
      leftBarIndicatorColor: Colors.blue,
    )..show(context);
  }

  _submitEdit() async {
    if (_formKey.currentState!.validate() &
        !Provider.of<UserData>(context, listen: false).isLoading) {
      _formKey.currentState?.save();
      String _imageUrl = widget.event!.imageUrl;
      Event event = Event(
        blurHash: widget.event!.blurHash,
        id: widget.event!.id,
        imageUrl: _imageUrl,
        type: Provider.of<UserData>(context, listen: false).post6,
        title: Provider.of<UserData>(context, listen: false).post1,
        rate: Provider.of<UserData>(context, listen: false).post3,
        venue: Provider.of<UserData>(context, listen: false).bool2
            ? ''
            : Provider.of<UserData>(context, listen: false).post5,
        time: Provider.of<UserData>(context, listen: false).post7,
        date: Provider.of<UserData>(context, listen: false).post8,
        theme: Provider.of<UserData>(context, listen: false).post2,
        dressCode: widget.dressCode,
        dj: widget.dj,
        guess: Provider.of<UserData>(context, listen: false).post11,
        artist: Provider.of<UserData>(context, listen: false).post12,
        host: Provider.of<UserData>(context, listen: false).post4!,
        authorId: Provider.of<UserData>(context, listen: false).currentUserId!,
        timestamp: widget.event!.timestamp,
        previousEvent: widget.previousEvent,
        triller: widget.triller,
        reportConfirmed: '',
        city: Provider.of<UserData>(context, listen: false).post9,
        country: Provider.of<UserData>(context, listen: false).post10,
        virtualVenue: Provider.of<UserData>(context, listen: false).bool2
            ? Provider.of<UserData>(context, listen: false).post5
            : '',
        ticketSite: widget.ticketSite,
        isVirtual: Provider.of<UserData>(context, listen: false).bool2,
        isFree: Provider.of<UserData>(context, listen: false).bool3,
        report: '',
        isPrivate: Provider.of<UserData>(context, listen: false).bool1,
        isCashPayment: Provider.of<UserData>(context, listen: false).bool4,
        showOnExplorePage: Provider.of<UserData>(context, listen: false).bool5,
        showToFollowers: Provider.of<UserData>(context, listen: false).bool6,
        clossingDay: Provider.of<UserData>(context, listen: false).post13,
        mediaType: '',
        mediaUrl: '',
        authorName:
            Provider.of<UserData>(context, listen: false).user!.userName!,
      );

      try {
        DatabaseService.editEvent(event);
        _pop();
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
          duration: Duration(seconds: 2),
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
    Provider.of<UserData>(context, listen: false).setIsLoading(true);
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
    Provider.of<UserData>(context, listen: false).setIsLoading(false);
    animateToPage();
  }

  _submitCreate() async {
    if (_formKey.currentState!.validate() &
        !Provider.of<UserData>(context, listen: false).isLoading) {
      _formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      animateToPage();
      Provider.of<UserData>(context, listen: false).setIsLoading(true);

      DateTime date =
          DateTime.parse(Provider.of<UserData>(context, listen: false).post8);
      final closeDate = Provider.of<UserData>(context, listen: false)
              .post13
              .startsWith('On')
          ? date.add(const Duration(hours: 12))
          : Provider.of<UserData>(context, listen: false).post13.startsWith('A')
              ? date.add(const Duration(days: 1))
              : Provider.of<UserData>(context, listen: false)
                      .post13
                      .startsWith('3')
                  ? date.add(const Duration(days: 3))
                  : Provider.of<UserData>(context, listen: false)
                          .post13
                          .startsWith('1')
                      ? date.add(const Duration(days: 7))
                      : date.add(const Duration(hours: 12));
      Provider.of<UserData>(context, listen: false)
          .setPost13(closeDate.toString());

      try {
        String imageUrl = await StorageService.uploadEvent(
            Provider.of<UserData>(context, listen: false).postImage!);

        Uint8List bytes =
            await (Provider.of<UserData>(context, listen: false).postImage!)
                .readAsBytes();
        var blurHash = await BlurHash.encode(bytes, 4, 3);

        Event event = Event(
          blurHash: blurHash,
          imageUrl: imageUrl,
          type: Provider.of<UserData>(context, listen: false).post6.isEmpty
              ? "Others"
              : Provider.of<UserData>(context, listen: false).post6,
          title: Provider.of<UserData>(context, listen: false).post1,
          rate: Provider.of<UserData>(context, listen: false).post3,
          venue: Provider.of<UserData>(context, listen: false).post5,
          time: Provider.of<UserData>(context, listen: false).post7,
          date: Provider.of<UserData>(context, listen: false).post8,
          theme: Provider.of<UserData>(context, listen: false).post2,
          dressCode: widget.dressCode,
          dj: widget.dj,
          guess: Provider.of<UserData>(context, listen: false).post11,
          artist: Provider.of<UserData>(context, listen: false).post12,
          host: Provider.of<UserData>(context, listen: false).post4!,
          authorId:
              Provider.of<UserData>(context, listen: false).currentUserId!,
          timestamp: Timestamp.fromDate(DateTime.now()),
          previousEvent: widget.previousEvent,
          triller: widget.triller,
          report: '',
          reportConfirmed: '',
          city: Provider.of<UserData>(context, listen: false).post9,
          country: Provider.of<UserData>(context, listen: false).post10,
          virtualVenue: Provider.of<UserData>(context, listen: false).bool2
              ? Provider.of<UserData>(context, listen: false).post5
              : '',
          ticketSite: widget.ticketSite,
          isVirtual: Provider.of<UserData>(context, listen: false).bool2,
          isPrivate: Provider.of<UserData>(context, listen: false).bool1,
          id: '',
          isFree: Provider.of<UserData>(context, listen: false).bool3,
          isCashPayment: Provider.of<UserData>(context, listen: false).bool4,
          showOnExplorePage:
              Provider.of<UserData>(context, listen: false).bool5,
          showToFollowers: Provider.of<UserData>(context, listen: false).bool6,
          clossingDay: Provider.of<UserData>(context, listen: false).post13,
          mediaType: '',
          mediaUrl: '',
          authorName: widget.user!.userName!,
        );
        DatabaseService.createEvent(event);

        _pop();

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
            "Your event was published successfully.",
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
          duration: Duration(seconds: 2),
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
        Provider.of<UserData>(context, listen: false).setIsLoading(false);
        setNull();
      });
    }
  }

  static const eventClossingDay = <String>[
    "On event day",
    "A day after",
    "3 days after",
    "1 week after",
  ];

  Widget buildClosingDay() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: Column(
            children: eventClossingDay.map((value) {
          final selected = this.selectedclosingDay == value;
          final color = selected ? Colors.blue : Colors.white;

          return RadioListTile<String>(
              value: value,
              groupValue: selectedclosingDay,
              title: Text(
                value,
                style: TextStyle(color: color, fontSize: 14),
              ),
              activeColor: Colors.blue,
              onChanged: (value) {
                Provider.of<UserData>(context, listen: false)
                    .setPost13(this.selectedclosingDay = value!);
                animateToPage();
              }

              //  => setState(
              //   () {
              //     _closingDay = (this.selectedclosingDay = value!);
              //     Provider.of<UserData>(context, listen: false).setPost13(value);
              //   },
              // ),
              );
        }).toList()),
      );

  Widget buildClosingDayPicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildClosingDay(),
            ],
          ),
          SizedBox(height: 70),
          Container(
            width: 250,
            child: AlwaysWhiteButton(
                onPressed: () {
                  animateToPage();
                },
                buttonText: "Pick day"),

            //  OutlinedButton(
            //     style: OutlinedButton.styleFrom(
            //       primary: Colors.blue,
            //       side: BorderSide(
            //         width: 1.0,
            //         color:
            //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //     ),
            //     child: Text(
            //       'Pick day',
            //       style: TextStyle(
            //         color:
            //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            //       ),
            //     ),
            //     onPressed: () {
            //       animateToPage();
            //     }),
          ),
        ],
      );

  static const values = <String>[
    "Festival",
    "Award",
    "Tour",
    "Album_Launch",
    "Others",
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor: Colors.white,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected ? Colors.blue : Colors.white;

          return RadioListTile<String>(
              value: value,
              groupValue: selectedValue,
              title: Text(
                value,
                style: TextStyle(color: color, fontSize: 14),
              ),
              activeColor: Colors.blue,
              onChanged: (value) {
                Provider.of<UserData>(context, listen: false)
                    .setPost6(this.selectedValue = value!);
                animateToPage();
              }

              // setState(
              //   () {
              //     _type = (this.selectedValue = value!);
              //     Provider.of<UserData>(context, listen: false).setPost6(_type);
              //   },
              // ),
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
              buildRadios(),
            ],
          ),
          SizedBox(height: 70),
          Container(
            width: 250,
            child: AlwaysWhiteButton(
                onPressed: () {
                  animateToPage();
                },
                buttonText: "Pick event type"),

            //  OutlinedButton(
            //     style: OutlinedButton.styleFrom(
            //       primary: Colors.blue,
            //       side: BorderSide(
            //         width: 1.0,
            //         color:
            //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            //       ),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20.0),
            //       ),
            //     ),
            //     child: Text(
            //       'Pick Event Type',
            //       style: TextStyle(
            //         color:
            //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            //       ),
            //     ),
            //     onPressed: () {
            //       animateToPage();
            //     }),
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
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: minTime.isBefore(dayTime) ? 0.0 : null,
            curve: Curves.bounceInOut,
            child: Container(
              width: 250,
              child: AlwaysWhiteButton(
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
                  buttonText: "Pick time"),

              //  OutlinedButton(
              //     style: OutlinedButton.styleFrom(
              //       primary: Colors.blue,
              //       side: BorderSide(
              //         width: 1.0,
              //         color:
              //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //     ),
              //     child: Text(
              //       'Pick Time',
              //       style: TextStyle(
              //         color:
              //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              //       ),
              //     ),
              //     onPressed: () {
              //       Provider.of<UserData>(context, listen: false)
              //           .setPost7(dayTime.toString());
              //       setState(() {
              //         widget.time = dayTime.toString();
              //       });
              //       animateToPage();
              //       print(
              //         widget.time,
              //       );
              //     }),
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
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height:
                minDateTime.add(Duration(days: 1)).isAtSameMomentAs(dateTime) ||
                        minDateTime.isAfter(dateTime) ||
                        minDateTime.add(Duration(days: 1)).isAfter(dateTime)
                    ? 0.0
                    : null,
            curve: Curves.bounceInOut,
            child: Container(
              width: 250,
              child: AlwaysWhiteButton(
                  onPressed: () {
                    Provider.of<UserData>(context, listen: false)
                        .setPost8(dateTime.toString());
                    setState(() {
                      widget.date = dateTime.toString();
                    });
                    animateToPage();
                  },
                  buttonText: "Pick date"),

              // OutlinedButton(
              //     style: OutlinedButton.styleFrom(
              //       primary: Colors.blue,
              //       side: BorderSide(
              //         width: 1.0,
              //         color:
              //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              //       ),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(20.0),
              //       ),
              //     ),
              //     child: Text(
              //       'Pick Date',
              //       style: TextStyle(
              //         color:
              //             ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              //       ),
              //     ),
              //     onPressed: () {
              //       Provider.of<UserData>(context, listen: false)
              //           .setPost8(dateTime.toString());
              //       setState(() {
              //         widget.date = dateTime.toString();
              //       });
              //       animateToPage();
              //     }),
            ),
          ),
        ],
      );

  animateBack() {
    _pageController.animateToPage(
      Provider.of<UserData>(context, listen: false).int1 - 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateBack2() {
    _pageController.animateToPage(
      Provider.of<UserData>(context, listen: false).int1 - 2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToPage() {
    _pageController.animateToPage(
      // _indexx + 1,
      Provider.of<UserData>(context, listen: false).int1 + 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
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
      // _indexx + 2,
      Provider.of<UserData>(context, listen: false).int1 + 2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  // _displayPostImage() {
  //   final width = Responsive.isDesktop(context)
  //       ? 600.0
  //       : MediaQuery.of(context).size.width;
  //   if (widget.imageUrl.isNotEmpty) {
  //     return Container(
  //         height: width / 2,
  //         width: width / 2,
  //         decoration: BoxDecoration(
  //             image: DecorationImage(
  //           image: CachedNetworkImageProvider(widget.imageUrl),
  //           fit: BoxFit.cover,
  //         )),
  //         child: Container(
  //           decoration: BoxDecoration(
  //               gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
  //             Colors.black.withOpacity(.5),
  //             Colors.black.withOpacity(.5),
  //           ])),
  //         ));
  //   } else {
  //     return GestureDetector(
  //       onTap: _handleImage,
  //       child: Container(
  //         child: Provider.of<UserData>(context).postImage == null
  //             ? Center(
  //                 child: InkBoxColumn(
  //                   size: 3,
  //                   onPressed: _handleImage,
  //                   icon: Icon(
  //                     Icons.add_a_photo,
  //                     size: 150,
  //                     color:
  //                         ConfigBloc().darkModeOn ? Colors.black : Colors.white,
  //                   ),
  //                   text: '',
  //                 ),
  //               )
  //             : Image(
  //                 height: width,
  //                 width: width,
  //                 image: FileImage(
  //                     File(Provider.of<UserData>(context).postImage!.path)),
  //                 fit: BoxFit.cover,
  //               ),
  //       ),
  //     );
  //   }
  // }

  _displayPostImage() {
    if (widget.imageUrl.isNotEmpty) {
      return Container(
          height: double.infinity,
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
      return Container(
          height: double.infinity,
          width: double.infinity,
          color:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Color(0xFFf2f2f2),
          child: _display());
    }
  }

  _display() {
    return Container(
      child: Provider.of<UserData>(context).postImage == null
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black,
            )
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: FileImage(
                    File(Provider.of<UserData>(context).postImage!.path)),
                fit: BoxFit.cover,
              )),
              child: Container(
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(begin: Alignment.bottomRight, colors: [
                  Colors.black.withOpacity(.5),
                  Colors.black.withOpacity(.5),
                ])),
              )),
    );
  }

  setNull() {
    Provider.of<UserData>(context, listen: false).setPostImage(null);
    Provider.of<UserData>(context, listen: false).setInt1(0);
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
    Provider.of<UserData>(context, listen: false).setPost11('');
    Provider.of<UserData>(context, listen: false).setPost12('');
    Provider.of<UserData>(context, listen: false).setPost13('');

    Provider.of<UserData>(context, listen: false).setPost14('');
    Provider.of<UserData>(context, listen: false).setBool1(false);
    Provider.of<UserData>(context, listen: false).setBool2(false);
    Provider.of<UserData>(context, listen: false).setBool3(false);
    Provider.of<UserData>(context, listen: false).setBool4(false);
    Provider.of<UserData>(context, listen: false).setBool5(false);
    Provider.of<UserData>(context, listen: false).setBool6(false);
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  _pop() {
    Provider.of<UserData>(context, listen: false).setInt1(0);
    setNull();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(
      context,
    )
        ? 600.0
        : MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return ResponsiveScaffold(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      // backgroundColor: _indexx == 10
      //     ? Color(0xFFFF2D55)
      //     : ConfigBloc().darkModeOn
      //         ? Color(0xFF1a1a1a)
      //         : Color(0xFFf2f2f2),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        leading: Provider.of<UserData>(context, listen: false).int1 == 10
            ? const SizedBox.shrink()
            : widget.isEditting
                ? IconButton(
                    icon: Icon(Platform.isIOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back),
                    onPressed: () {
                      Provider.of<UserData>(context, listen: false).int1 == 5
                          ? Navigator.pop(context)
                          : Provider.of<UserData>(context, listen: false)
                                      .int1 ==
                                  2
                              ? animateBack2()
                              : animateBack();
                    })
                : IconButton(
                    icon: Icon(Platform.isIOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back),
                    onPressed: () {
                      Provider.of<UserData>(context, listen: false).int1 == 2 &&
                              Provider.of<UserData>(context, listen: false)
                                  .bool3
                          ? animateBack2()
                          : Provider.of<UserData>(context, listen: false)
                                      .int1 !=
                                  0
                              ? animateBack()
                              : _pop();
                    }),
        elevation: 0,
        backgroundColor: Colors.transparent,

        // _indexx == 10
        //     ? Color(0xFFFF2D55)
        //     : ConfigBloc().darkModeOn
        //         ? Color(0xFF1a1a1a)
        //         : Color(0xFFf2f2f2),
        title: Material(
          color: Colors.transparent,
          child: Provider.of<UserData>(context, listen: false).isLoading
              ? Text(
                  '',
                )
              : Text(
                  Provider.of<UserData>(context, listen: false).int1 == 10
                      ? ''
                      : widget.isEditting
                          ? 'Edit Event'
                          : 'Create Event',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Stack(
                alignment: FractionalOffset.center,
                children: <Widget>[
                  Stack(alignment: FractionalOffset.center, children: <Widget>[
                    _displayPostImage(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 120.0, left: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Container(
                              height: height,
                              width: width,
                              child: Provider.of<UserData>(context,
                                                  listen: false)
                                              .postImage ==
                                          null &&
                                      widget.imageUrl.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AvatarGlow(
                                            animate: true,
                                            showTwoGlows: true,
                                            shape: BoxShape.circle,
                                            glowColor: Colors.blue,
                                            endRadius: 100,
                                            duration: const Duration(
                                                milliseconds: 2000),
                                            repeatPauseDuration: const Duration(
                                                milliseconds: 3000),
                                            child: Container(
                                                width: 100,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    border: Border.all(
                                                      width: 2,
                                                      color: Colors.white,
                                                    )),
                                                child: IconButton(
                                                  icon: Icon(
                                                    MdiIcons.image,
                                                    color: Colors.white,
                                                    size: 80,
                                                  ),
                                                  onPressed: () =>
                                                      _handleImage(),
                                                )),
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => FeatureInfo(
                                                          feature: 'Punch',
                                                        ))),
                                            child: RichText(
                                                textScaleFactor:
                                                    MediaQuery.of(context)
                                                        .textScaleFactor
                                                        .clamp(0.5, 1.5),
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: widget.user!.name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\nSelect a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event. We advise you to select a great background image. ',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '...more',
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        '\n\nCreate an event where people can attend, have fun, create memories, and have unforgettable experiences. You can create a virtual event that can be hosted on a live stream of other platforms, or you can create an event with a physical venue that people can attend.You can create two types of events. A private and a public event. A public event can be attended by anybody. But a private event can only be attended by specific people.',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ]),
                                                textAlign: TextAlign.center),
                                          )
                                        ],
                                      ),
                                    )
                                  : PageView(
                                      controller: _pageController,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      onPageChanged: (int index) {
                                        Provider.of<UserData>(context,
                                                listen: false)
                                            .setInt1(index);

                                        // setState(() {
                                        //   _indexx = index;
                                        // });
                                      },
                                      children: [
                                          SingleChildScrollView(
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '1. ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Event\nsettings.',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(30.0),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 30),
                                                              SettingSwitch(
                                                                  title:
                                                                      'Private event',
                                                                  subTitle:
                                                                      'You can create a private event and invite only specific people, or you can create a general event where anybody can attend.',
                                                                  value: Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool1,
                                                                  onChanged: (value) => Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setBool1(
                                                                          value)),
                                                              !Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool1
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10.0,
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Divider(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                              !Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool1
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : SettingSwitch(
                                                                      title:
                                                                          'Show on explore page',
                                                                      subTitle:
                                                                          'Should your private event be shown on the explore page?',
                                                                      value: Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .bool5,
                                                                      onChanged: (value) => Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setBool5(
                                                                              value)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10),
                                                                child: Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              SettingSwitch(
                                                                  title:
                                                                      'Virtual event',
                                                                  subTitle:
                                                                      'You can create an event that people can attend, or you can also create a virtual event that can be hosted on virtual platforms, where people can interact with you. ',
                                                                  value: Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool2,
                                                                  onChanged: (value) => Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setBool2(
                                                                          value)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10),
                                                                child: Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                              ),
                                                              Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool4
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : SettingSwitch(
                                                                      title:
                                                                          'Free event',
                                                                      subTitle:
                                                                          'A free event without a ticket or gate fee (rate free).',
                                                                      value: Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .bool3,
                                                                      onChanged: (value) => Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .setBool3(
                                                                              value)),
                                                              Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool4
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10.0,
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Divider(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                              Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool3
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : Container(
                                                                      child: SettingSwitch(
                                                                          title:
                                                                              'Cash payment',
                                                                          subTitle:
                                                                              'Cash in hand mode of payment for ticket or gate fee?',
                                                                          value: Provider.of<UserData>(context, listen: false)
                                                                              .bool4,
                                                                          onChanged: (value) =>
                                                                              Provider.of<UserData>(context, listen: false).setBool4(value)),
                                                                    ),
                                                              Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .bool3
                                                                  ? const SizedBox
                                                                      .shrink()
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10.0,
                                                                          bottom:
                                                                              10),
                                                                      child:
                                                                          Divider(
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 70.0,
                                                                  top: 50),
                                                          child:
                                                              AlwaysWhiteButton(
                                                                  onPressed: Provider.of<UserData>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .bool3
                                                                      ? animateToPage2
                                                                      : () {
                                                                          showCurrencyPicker(
                                                                            context:
                                                                                context,
                                                                            showFlag:
                                                                                true,
                                                                            showSearchField:
                                                                                true,
                                                                            showCurrencyName:
                                                                                true,
                                                                            showCurrencyCode:
                                                                                true,
                                                                            onSelect:
                                                                                (Currency currency) {
                                                                              // print(
                                                                              //     'Select currency: ${currency.code}');
                                                                              Provider.of<UserData>(context, listen: false).setPost14('${currency.name}, ${currency.code} ');
                                                                              animateToPage();
                                                                            },
                                                                            favorite: [
                                                                              'USD'
                                                                            ],
                                                                          );
                                                                          // animateToPage();
                                                                        },
                                                                  buttonText:
                                                                      "Continue"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // AnimatedContainer(
                                                //   margin: EdgeInsets.symmetric(
                                                //       horizontal: 10),
                                                //   duration: Duration(
                                                //       milliseconds: 500),
                                                //   curve: Curves.linearToEaseOut,
                                                //   height: _showSheet
                                                //       ? height - 100
                                                //       : 0.0,
                                                //   width: width,
                                                //   decoration: BoxDecoration(
                                                //     color: Colors.grey[300],
                                                //     borderRadius:
                                                //         BorderRadius.only(
                                                //       topLeft:
                                                //           Radius.circular(20.0),
                                                //       topRight:
                                                //           Radius.circular(20.0),
                                                //     ),
                                                //   ),
                                                //   child: Padding(
                                                //     padding:
                                                //         const EdgeInsets.all(
                                                //             30.0),
                                                //     child: Column(
                                                //       mainAxisAlignment:
                                                //           MainAxisAlignment
                                                //               .start,
                                                //       crossAxisAlignment:
                                                //           CrossAxisAlignment
                                                //               .start,
                                                //       children: [
                                                //         DirectionWidget(
                                                //           fontSize: null,
                                                //           text:
                                                //               'Enter the rate of your event. Example 10.00.',
                                                //         ),
                                                //         Text(
                                                //           Provider.of<UserData>(
                                                //                       context,
                                                //                       listen:
                                                //                           false)
                                                //                   .post3
                                                //                   .isEmpty
                                                //               ? Provider.of<
                                                //                           UserData>(
                                                //                       context,
                                                //                       listen:
                                                //                           false)
                                                //                   .post13
                                                //               : Provider.of<
                                                //                           UserData>(
                                                //                       context,
                                                //                       listen:
                                                //                           false)
                                                //                   .post3,
                                                //           style: TextStyle(
                                                //             color: Colors.blue,
                                                //             fontSize: 30,
                                                //           ),
                                                //         ),
                                                //         const SizedBox(
                                                //           height: 5,
                                                //         ),
                                                //         ContentField(
                                                //           labelText: 'Rate',
                                                //           hintText:
                                                //               "currency - amount: example (\$: 00.0) ",
                                                //           initialValue:
                                                //               Provider.of<UserData>(
                                                //                       context,
                                                //                       listen:
                                                //                           false)
                                                //                   .post3
                                                //                   .toString(),
                                                //           onSavedText: (input) => Provider.of<
                                                //                       UserData>(
                                                //                   context,
                                                //                   listen: false)
                                                //               .setPost3(Provider.of<
                                                //                               UserData>(
                                                //                           context,
                                                //                           listen:
                                                //                               false)
                                                //                       .post13 +
                                                //                   input),
                                                //           onValidateText:
                                                //               (input) => input
                                                //                           .trim()
                                                //                           .length <
                                                //                       1
                                                //                   ? "The price rate cannot be empty (input free)"
                                                //                   : null,
                                                //         ),
                                                //         const SizedBox(
                                                //           height: 70,
                                                //         ),
                                                //         AnimatedContainer(
                                                //           margin: EdgeInsets
                                                //               .symmetric(
                                                //                   horizontal:
                                                //                       10),
                                                //           duration: Duration(
                                                //               milliseconds:
                                                //                   500),
                                                //           curve: Curves
                                                //               .linearToEaseOut,
                                                //           height: Provider.of<
                                                //                           UserData>(
                                                //                       context,
                                                //                       listen:
                                                //                           false)
                                                //                   .post3
                                                //                   .isEmpty
                                                //               ? 0
                                                //               : 40,
                                                //           child: Center(
                                                //             child: Container(
                                                //               width: 200,
                                                //               child:
                                                //                   OutlinedButton(
                                                //                       style: OutlinedButton
                                                //                           .styleFrom(
                                                //                         primary:
                                                //                             Colors.blue,
                                                //                         side:
                                                //                             BorderSide(
                                                //                           width:
                                                //                               1.0,
                                                //                           color: ConfigBloc().darkModeOn
                                                //                               ? Colors.white
                                                //                               : Colors.black,
                                                //                         ),
                                                //                         shape:
                                                //                             RoundedRectangleBorder(
                                                //                           borderRadius:
                                                //                               BorderRadius.circular(20.0),
                                                //                         ),
                                                //                       ),
                                                //                       child:
                                                //                           Text(
                                                //                         'Continue',
                                                //                         style:
                                                //                             TextStyle(
                                                //                           color: ConfigBloc().darkModeOn
                                                //                               ? Colors.white
                                                //                               : Colors.black,
                                                //                         ),
                                                //                       ),
                                                //                       onPressed:
                                                //                           () {
                                                //                         FocusScope.of(context)
                                                //                             .unfocus();
                                                //                         animateToPage();
                                                //                       }),
                                                //             ),
                                                //           ),

                                                //           // AlwaysWhiteButton(
                                                //           //     onPressed: () {
                                                //           //       animateToPage();
                                                //           //     },
                                                //           //     buttonText: "Continue"),
                                                //         ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '1. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Rate.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
                                                    fontSize: null,
                                                    text:
                                                        'Enter the rate of your event. Example 10.00.',
                                                  ),
                                                  Text(
                                                    Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .post14,
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText: 'Rate',
                                                    hintText:
                                                        "currency - amount: example (\$: 00.0) ",
                                                    initialValue:
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .post3
                                                            .toString(),
                                                    onSavedText: (input) => Provider
                                                            .of<UserData>(
                                                                context,
                                                                listen: false)
                                                        .setPost3(Provider.of<
                                                                        UserData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .post14 +
                                                            input),
                                                    onValidateText: (input) =>
                                                        input.trim().length < 1
                                                            ? "The price rate cannot be empty (input free)"
                                                            : null,
                                                  ),
                                                  const SizedBox(
                                                    height: 70,
                                                  ),
                                                  AnimatedContainer(
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve:
                                                        Curves.linearToEaseOut,
                                                    height:
                                                        Provider.of<UserData>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .post3
                                                                .isEmpty
                                                            ? 0
                                                            : 40,
                                                    child: Center(
                                                      child: Container(
                                                          width: 250,
                                                          child: Center(
                                                            child:
                                                                AlwaysWhiteButton(
                                                                    onPressed:
                                                                        () {
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                      animateToPage();
                                                                    },
                                                                    buttonText:
                                                                        "Continue"),
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '2. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Category.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
                                                    fontSize: null,
                                                    text:
                                                        'Select an event category that matches the event you are creating. ',
                                                  ),
                                                  Text(
                                                    Provider.of<UserData>(
                                                            context,
                                                            listen: false)
                                                        .post6,
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  buildEventTypePicker(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '3. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Time',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '4. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Date.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
                                                    fontSize: null,
                                                    text:
                                                        'Select the exact date of your event. ',
                                                  ),
                                                  SizedBox(height: 20),
                                                  buildDatePicker(),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          widget.isEditting
                                                              ? ''
                                                              : '5. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          widget.isEditting
                                                              ? ''
                                                              : 'Closing day.',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  widget.isEditting
                                                      ? DirectionWidgetWhite(
                                                          fontSize: null,
                                                          text:
                                                              'Certiain information of an event cannot be modified once an event is created. Information such as date, time, category, flyer background, and event settings cannot be changed. ',
                                                        )
                                                      : DirectionWidgetWhite(
                                                          fontSize: null,
                                                          text:
                                                              'Choose a closing day for your event. This indicates the closing period of your event. For instance, if you pick three days, your event dashboard and flyer would be disabled three days after your event date specified previously. ',
                                                        ),
                                                  widget.isEditting
                                                      ? const SizedBox.shrink()
                                                      : Text(
                                                          Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .post13,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 30,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                  const SizedBox(height: 20),
                                                  widget.isEditting
                                                      ? Center(
                                                          child: AlwaysWhiteButton(
                                                              onPressed:
                                                                  _validate,
                                                              buttonText:
                                                                  "Start editing"),
                                                        )
                                                      : buildClosingDayPicker(),
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
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '6. ',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 30,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Venue.',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .isLoading
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10.0),
                                                              child: SizedBox(
                                                                height: 2.0,
                                                                child:
                                                                    LinearProgressIndicator(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .transparent,
                                                                  valueColor:
                                                                      AlwaysStoppedAnimation(
                                                                          Colors
                                                                              .blue),
                                                                ),
                                                              ),
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                      Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .post5
                                                              .isNotEmpty
                                                          ? AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              height: Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .post5
                                                                      .isEmpty
                                                                  ? 0.0
                                                                  : null,
                                                              curve: Curves
                                                                  .easeInOut,
                                                              child: Text(
                                                                Provider.of<UserData>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .post5
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .blue,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            )
                                                          : _isfetchingAddress
                                                              ? const SizedBox
                                                                  .shrink()
                                                              : DirectionWidgetWhite(
                                                                  fontSize:
                                                                      null,
                                                                  text: Provider.of<UserData>(
                                                                              context,
                                                                              listen: false)
                                                                          .bool2
                                                                      ? 'Enter the host link of the event. It will help other users virtually join the event if they are interested. '
                                                                      : 'Enter the address venue of the event. Make sure you select the correct address from the list suggested below. It will help other users navigate to the venue if they are interested. ',
                                                                ),
                                                      Text(
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .post10
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: Colors.blue,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(height: 10),
                                                      Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .bool2
                                                          ? ContentFieldWhite(
                                                              labelText:
                                                                  "Virtual venue",
                                                              hintText:
                                                                  "Link to virtual event venue",
                                                              initialValue: widget
                                                                  .virtualVenue,
                                                              onSavedText: (input) =>
                                                                  Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setPost5(
                                                                          input),
                                                              onValidateText:
                                                                  (_) {},
                                                            )
                                                          : TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              maxLines: null,
                                                              controller:
                                                                  _controller,
                                                              textCapitalization:
                                                                  TextCapitalization
                                                                      .sentences,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .always,
                                                              onChanged:
                                                                  (value) => {
                                                                Provider.of<UserData>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .searchAddress(
                                                                        value),
                                                                setState(() {
                                                                  _isfetchingAddress =
                                                                      true;
                                                                })
                                                              },
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              initialValue:
                                                                  widget.venue,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:
                                                                          "Event venue address",
                                                                      hintStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      labelText:
                                                                          'Venue',
                                                                      labelStyle:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      enabledBorder:
                                                                          new UnderlineInputBorder(
                                                                              borderSide: new BorderSide(color: Colors.grey))),
                                                            ),
                                                      if (Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .addressSearchResults !=
                                                          null)
                                                        const SizedBox(
                                                          height: 30,
                                                        ),
                                                      Provider.of<UserData>(
                                                                  context,
                                                                  listen: false)
                                                              .bool2
                                                          ? const SizedBox
                                                              .shrink()
                                                          : Container(
                                                              color: ConfigBloc()
                                                                      .darkModeOn
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    'Tap below to select the venue\'s address',
                                                                    style:
                                                                        TextStyle(
                                                                      color: ConfigBloc().darkModeOn
                                                                          ? Colors
                                                                              .black
                                                                          : Colors
                                                                              .white,
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
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0),
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Provider.of<
                                                                            UserData>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .bool2
                                                                ? const SizedBox
                                                                    .shrink()
                                                                : Column(
                                                                    children: [
                                                                      _isfetchingAddress
                                                                          ? Padding(
                                                                              padding: const EdgeInsets.only(bottom: 5.0, top: 10),
                                                                              child: SizedBox(
                                                                                height: 1.0,
                                                                                child: LinearProgressIndicator(
                                                                                  backgroundColor: Colors.transparent,
                                                                                  valueColor: AlwaysStoppedAnimation(Colors.grey),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : const SizedBox
                                                                              .shrink(),
                                                                      Container(
                                                                        height: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        width: double
                                                                            .infinity,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          shape:
                                                                              BoxShape.rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                        ),
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount: Provider.of<UserData>(context, listen: false)
                                                                              .addressSearchResults!
                                                                              .length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return ListTile(
                                                                                title: Text(
                                                                                  Provider.of<UserData>(context, listen: false).addressSearchResults![index].description,
                                                                                  style: TextStyle(
                                                                                    color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                                                                                  ),
                                                                                ),
                                                                                onTap: () {
                                                                                  Provider.of<UserData>(context, listen: false).setPost5(Provider.of<UserData>(context, listen: false).addressSearchResults![index].description);
                                                                                  setState(() {
                                                                                    _isfetchingAddress = false;

                                                                                    widget.venue = Provider.of<UserData>(context, listen: false).addressSearchResults![index].description;
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
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              height: null,
                                                              curve: Curves
                                                                  .easeInOut,
                                                              child: Center(
                                                                child: AlwaysWhiteButton(
                                                                    onPressed:
                                                                        _validate,
                                                                    buttonText:
                                                                        'Next'),
                                                              ),
                                                            )
                                                          : AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              height: Provider.of<
                                                                              UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .post5
                                                                      .isEmpty
                                                                  ? 0.0
                                                                  : null,
                                                              curve: Curves
                                                                  .easeInOut,
                                                              child: Center(
                                                                child: AlwaysWhiteButton(
                                                                    onPressed:
                                                                        _validate,
                                                                    buttonText: widget
                                                                            .isEditting
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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '7. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'People (Optional)',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
                                                    fontSize: null,
                                                    text:
                                                        'Enter the name of people participating in this event. Separate each name with a comma(,).\nExmaple: James,Edith',
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText:
                                                        "Name(s) of guests",
                                                    hintText:
                                                        'Special Guests (optional)',
                                                    initialValue:
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .post11,
                                                    onSavedText: (input) =>
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .setPost11(input),
                                                    onValidateText: (_) {},
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText:
                                                        "Name(s) of artists",
                                                    hintText:
                                                        'Artist Performing (optional)',
                                                    initialValue:
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .post12,
                                                    onSavedText: (input) =>
                                                        Provider.of<UserData>(
                                                                context,
                                                                listen: false)
                                                            .setPost12(input),
                                                    onValidateText: (_) {},
                                                  ),
                                                  SizedBox(height: 70),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50),
                                                    child: AlwaysWhiteButton(
                                                        onPressed: _validate,
                                                        buttonText:
                                                            widget.isEditting
                                                                ? 'Next'
                                                                : "Continue"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Container(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            '8. ',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Flyer\nInformation.',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    DirectionWidgetWhite(
                                                      fontSize: null,
                                                      text:
                                                          'Provide the required information below correctly. The fields on this page cannot be empty. ',
                                                    ),
                                                    Container(
                                                      color: Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 10.0,
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            ContentField(
                                                              labelText:
                                                                  'Title',
                                                              hintText:
                                                                  "Enter the title of your event",
                                                              initialValue: Provider.of<
                                                                          UserData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .post1
                                                                  .toString(),
                                                              onSavedText: (input) =>
                                                                  Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setPost1(
                                                                          input),
                                                              onValidateText: (input) => input
                                                                          .trim()
                                                                          .length <
                                                                      1
                                                                  ? "The title cannot be empty"
                                                                  : null,
                                                            ),
                                                            ContentField(
                                                              labelText:
                                                                  'Theme',
                                                              hintText:
                                                                  "Enter a theme for the event",
                                                              initialValue: Provider.of<
                                                                          UserData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .post2
                                                                  .toString(),
                                                              onSavedText: (input) =>
                                                                  Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setPost2(
                                                                          input),
                                                              onValidateText: (input) => input
                                                                          .trim()
                                                                          .length <
                                                                      10
                                                                  ? "The theme is too short( > 10 characters)"
                                                                  : null,
                                                            ),
                                                            ContentField(
                                                              labelText: 'Host',
                                                              hintText:
                                                                  "Name of event host",
                                                              initialValue: Provider.of<
                                                                          UserData>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .post4
                                                                  .toString(),
                                                              onSavedText: (input) =>
                                                                  Provider.of<UserData>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .setPost4(
                                                                          input),
                                                              onValidateText: (input) => input
                                                                          .trim()
                                                                          .length <
                                                                      1
                                                                  ? "The host cannot be empty"
                                                                  : null,
                                                            ),
                                                            Provider.of<UserData>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .post10
                                                                    .isEmpty
                                                                ? Provider.of<UserData>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .bool2
                                                                    ? const SizedBox
                                                                        .shrink()
                                                                    : ContentField(
                                                                        labelText:
                                                                            'Country',
                                                                        hintText:
                                                                            "Country of event",
                                                                        initialValue: Provider.of<UserData>(context,
                                                                                listen: false)
                                                                            .post10
                                                                            .toString(),
                                                                        onSavedText:
                                                                            (input) =>
                                                                                Provider.of<UserData>(context, listen: false).setPost10(input),
                                                                        onValidateText: (input) => input.trim().length <
                                                                                1
                                                                            ? "Enter the country of event"
                                                                            : null,
                                                                      )
                                                                : const SizedBox
                                                                    .shrink(),
                                                            const SizedBox(
                                                              height: 50,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 70),
                                                    AlwaysWhiteButton(
                                                        onPressed: _validate,
                                                        buttonText:
                                                            widget.isEditting
                                                                ? 'Next'
                                                                : "Continue"),
                                                    const SizedBox(height: 70),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '9. ',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 30,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Flyer\nInformation.(optional)',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  DirectionWidgetWhite(
                                                    fontSize: null,
                                                    text:
                                                        'You can provide the following information if available for your event. The information required on this page is optional. ',
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText: "Name of Dj",
                                                    hintText: 'Dj',
                                                    initialValue: widget.dj,
                                                    onSavedText: (input) =>
                                                        widget.dj = input,
                                                    onValidateText: (_) {},
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText:
                                                        "Dress code for the event",
                                                    hintText: 'Dress code',
                                                    initialValue:
                                                        widget.dressCode,
                                                    onSavedText: (input) =>
                                                        widget.dressCode =
                                                            input,
                                                    onValidateText: (_) {},
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText: "Ticket site",
                                                    hintText:
                                                        'Website to purchase ticket',
                                                    initialValue:
                                                        widget.ticketSite,
                                                    onSavedText: (input) =>
                                                        widget.ticketSite =
                                                            input,
                                                    onValidateText: (_) {},
                                                  ),
                                                  ContentFieldWhite(
                                                    labelText: "Previous event",
                                                    hintText:
                                                        'A Video link of the previous events',
                                                    initialValue:
                                                        widget.previousEvent,
                                                    onSavedText: (input) =>
                                                        widget.previousEvent =
                                                            input,
                                                    onValidateText: (input) =>
                                                        !musicVideoLink.hasMatch(
                                                                    input) &&
                                                                input
                                                                        .trim()
                                                                        .length >
                                                                    1
                                                            ? "Enter a valid video link"
                                                            : null,
                                                  ),
                                                  SizedBox(height: 70),
                                                  Provider.of<UserData>(context,
                                                              listen: false)
                                                          .isLoading
                                                      ? const SizedBox.shrink()
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 50),
                                                          child: Container(
                                                            width: 250,
                                                            child:
                                                                ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary:
                                                                    Colors.blue,
                                                                elevation: 20.0,
                                                                onPrimary:
                                                                    Colors.blue,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20.0),
                                                                ),
                                                              ),
                                                              onPressed: () => widget
                                                                      .isEditting
                                                                  ? _submitEdit()
                                                                  : _showSelectImageDialog(
                                                                      'create'),
                                                              child: Text(
                                                                widget.isEditting
                                                                    ? 'Save'
                                                                    : "Create",
                                                                style:
                                                                    TextStyle(
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // AvatarCircularButton(
                                                          //     buttonText: widget
                                                          //             .isEditting
                                                          //         ? 'Save'
                                                          //         : "Create",
                                                          // onPressed: () => widget
                                                          //         .isEditting
                                                          //     ? _submitEdit()
                                                          //     : _showSelectImageDialog(
                                                          //         'create')),
                                                        ),
                                                  widget.isEditting
                                                      ? Column(
                                                          children: [
                                                            Container(
                                                              width: 50,
                                                              height: 50,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color:
                                                                    Colors.blue,
                                                              ),
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                onTap: () =>
                                                                    () {},
                                                                child: Ink(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .blue,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    width: 40,
                                                                    child: IconButton(
                                                                        icon: Icon(Icons.delete_forever),
                                                                        iconSize: 25,
                                                                        color: Colors.white,
                                                                        onPressed: () {
                                                                          _showSelectImageDialog(
                                                                              '');
                                                                        }),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30.0,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          50.0,
                                                                      right:
                                                                          50),
                                                              child: Text(
                                                                " Provide accurate information.\nRefresh your page to see the effect of your event edited or deleted",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        12.0),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 50.0,
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox.shrink()
                                                ],
                                              ),
                                            ),
                                          ),
                                          SingleChildScrollView(
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    200,
                                                child: Center(
                                                    child: Loading(
                                                  title: 'Publishing event',
                                                  icon: (Icons.event),
                                                ))),
                                          )
                                        ])),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),

      // SingleChildScrollView(
      //   child: Center(
      //     child: Padding(
      //       padding: const EdgeInsets.all(20.0),
      //       child: Column(
      //         children: [
      //           SizedBox(height: 10),
      //           Align(
      //             alignment: Alignment.centerLeft,
      //             child: Row(
      //               children: [
      //                 Text(
      //                   '1. ',
      //                   style: TextStyle(
      //                     color: Colors.blue,
      //                     fontSize: 30,
      //                   ),
      //                 ),
      //                 Text(
      //                   'Background\nImage.',
      //                   style: TextStyle(
      //                     color: Colors.blue,
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Provider.of<UserData>(context, listen: false)
      //                       .postImage ==
      //                   null
      //               ? DirectionWidgetWhite(
      //                   text:
      //                       'Select a background image for your event. The image selected should not contain any text and should be of good pixel quality. The image selected should align with the context of your event. We advise you to select a great background image. ',
      //                   fontSize: null,
      //                 )
      //               : const SizedBox.shrink(),
      //           const SizedBox(
      //             height: 20,
      //           ),
      //           _displayPostImage(),
      //           widget.imageUrl.isNotEmpty && widget.isEditting
      //               ? Padding(
      //                   padding: const EdgeInsets.only(top: 50.0),
      //                   child: AlwaysWhiteButton(
      //                       onPressed: _validate2,
      //                       buttonText: "Next"),
      //                 )
      //               : Provider.of<UserData>(context, listen: false)
      //                           .postImage ==
      //                       null
      //                   ? const SizedBox.shrink()
      //                   : Padding(
      //                       padding: const EdgeInsets.only(top: 50.0),
      //                       child: AlwaysWhiteButton(
      //                           onPressed: _validate,
      //                           buttonText: "Continue"),
      //                     ),
      //           GestureDetector(
      //             onTap: () => Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (_) => FeatureInfo(
      //                           feature: 'Event',
      //                         ))),
      //             child: PageHint(
      //               more: 'tap to read',
      //               body: "Event documentation.",
      //               title: ".",
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Stack(
      //     children: [
      //       Center(
      //         child: Padding(
      //           padding: const EdgeInsets.all(20.0),
      //           child: Column(
      //             children: [
      //               Align(
      //                 alignment: Alignment.centerLeft,
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       '2. ',
      //                       style: TextStyle(
      //                         color: Colors.blue,
      //                         fontSize: 30,
      //                       ),
      //                     ),
      //                     Text(
      //                       'Event\nsettings.',
      //                       style: TextStyle(
      //                         color: Colors.blue,
      //                         fontSize: 12,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               SizedBox(height: 30),
      //               SettingSwitch(
      //                   title: 'Private event',
      //                   subTitle:
      //                       'You can create a private event and invite only specific people, or you can create a general event where anybody can attend.',
      //                   value: Provider.of<UserData>(context,
      //                           listen: false)
      //                       .bool1,
      //                   onChanged: (value) => Provider.of<UserData>(
      //                           context,
      //                           listen: false)
      //                       .setBool1(value)),
      //               !Provider.of<UserData>(context, listen: false)
      //                       .bool1
      //                   ? const SizedBox.shrink()
      //                   : Padding(
      //                       padding: const EdgeInsets.only(
      //                           top: 10.0, bottom: 10),
      //                       child: Divider(
      //                         color: Colors.grey,
      //                       ),
      //                     ),
      //               !Provider.of<UserData>(context, listen: false)
      //                       .bool1
      //                   ? const SizedBox.shrink()
      //                   : SettingSwitch(
      //                       title: 'Show on explore page',
      //                       subTitle:
      //                           'Should your private event be shown on the explore page?',
      //                       value: Provider.of<UserData>(context,
      //                               listen: false)
      //                           .bool5,
      //                       onChanged: (value) =>
      //                           Provider.of<UserData>(context,
      //                                   listen: false)
      //                               .setBool5(value)),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                     top: 10.0, bottom: 10),
      //                 child: Divider(
      //                   color: Colors.grey,
      //                 ),
      //               ),
      //               SettingSwitch(
      //                   title: 'Virtual event',
      //                   subTitle:
      //                       'You can create an event that people can attend, or you can also create a virtual event that can be hosted on virtual platforms, where people can interact with you. ',
      //                   value: Provider.of<UserData>(context,
      //                           listen: false)
      //                       .bool2,
      //                   onChanged: (value) => Provider.of<UserData>(
      //                           context,
      //                           listen: false)
      //                       .setBool2(value)),
      //               Padding(
      //                 padding: const EdgeInsets.only(
      //                     top: 10.0, bottom: 10),
      //                 child: Divider(
      //                   color: Colors.grey,
      //                 ),
      //               ),
      //               Provider.of<UserData>(context, listen: false)
      //                       .bool4
      //                   ? const SizedBox.shrink()
      //                   : SettingSwitch(
      //                       title: 'Free event',
      //                       subTitle:
      //                           'A free event without a ticket or gate fee (rate free).',
      //                       value: Provider.of<UserData>(context,
      //                               listen: false)
      //                           .bool3,
      //                       onChanged: (value) =>
      //                           Provider.of<UserData>(context,
      //                                   listen: false)
      //                               .setBool3(value)),
      //               Provider.of<UserData>(context, listen: false)
      //                       .bool4
      //                   ? const SizedBox.shrink()
      //                   : Padding(
      //                       padding: const EdgeInsets.only(
      //                           top: 10.0, bottom: 10),
      //                       child: Divider(
      //                         color: Colors.grey,
      //                       ),
      //                     ),
      //               Provider.of<UserData>(context, listen: false)
      //                       .bool3
      //                   ? const SizedBox.shrink()
      //                   : Container(
      //                       child: SettingSwitch(
      //                           title: 'Cash payment',
      //                           subTitle:
      //                               'Cash in hand mode of payment for ticket or gate fee?',
      //                           value: Provider.of<UserData>(context,
      //                                   listen: false)
      //                               .bool4,
      //                           onChanged: (value) =>
      //                               Provider.of<UserData>(context,
      //                                       listen: false)
      //                                   .setBool4(value)),
      //                     ),
      //               Provider.of<UserData>(context, listen: false)
      //                       .bool3
      //                   ? const SizedBox.shrink()
      //                   : Padding(
      //                       padding: const EdgeInsets.only(
      //                           top: 10.0, bottom: 10),
      //                       child: Divider(
      //                         color: Colors.grey,
      //                       ),
      //                     ),
      //               Center(
      //                 child: Padding(
      //                   padding: const EdgeInsets.only(
      //                       bottom: 70.0, top: 50),
      //                   child: AlwaysWhiteButton(
      //                       onPressed: () {
      //                         Provider.of<UserData>(context,
      //                                     listen: false)
      //                                 .bool3
      //                             ? animateToPage()
      //                             : showCurrencyPicker(
      //                                 context: context,
      //                                 showFlag: true,
      //                                 showSearchField: true,
      //                                 showCurrencyName: true,
      //                                 showCurrencyCode: true,
      //                                 onSelect: (Currency currency) {
      //                                   // print(
      //                                   //     'Select currency: ${currency.code}');
      //                                   Provider.of<UserData>(context,
      //                                           listen: false)
      //                                       .setPost13(
      //                                           '${currency.name}, ${currency.code} ');
      //                                   setState(() {
      //                                     _showSheet = true;
      //                                   });
      //                                 },
      //                                 favorite: ['USD'],
      //                               );
      //                         // animateToPage();
      //                       },
      //                       buttonText: "Continue"),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       AnimatedContainer(
      //         margin: EdgeInsets.symmetric(horizontal: 10),
      //         duration: Duration(milliseconds: 500),
      //         curve: Curves.linearToEaseOut,
      //         height: _showSheet ? height - 100 : 0.0,
      //         width: width,
      //         decoration: BoxDecoration(
      //           color: Colors.grey[300],
      //           borderRadius: BorderRadius.only(
      //             topLeft: Radius.circular(20.0),
      //             topRight: Radius.circular(20.0),
      //           ),
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.all(30.0),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               DirectionWidgetWhite(
      //                 fontSize: null,
      //                 text:
      //                     'Enter the rate of your event. Example 10.00.',
      //               ),
      //               Text(
      //                 Provider.of<UserData>(context, listen: false)
      //                         .post3
      //                         .isEmpty
      //                     ? Provider.of<UserData>(context,
      //                             listen: false)
      //                         .post13
      //                     : Provider.of<UserData>(context,
      //                             listen: false)
      //                         .post3,
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 5,
      //               ),
      //               ContentField(
      //                 labelText: 'Rate',
      //                 hintText:
      //                     "currency - amount: example (\$: 00.0) ",
      //                 initialValue: Provider.of<UserData>(context,
      //                         listen: false)
      //                     .post3
      //                     .toString(),
      //                 onSavedText: (input) => Provider.of<UserData>(
      //                         context,
      //                         listen: false)
      //                     .setPost3(Provider.of<UserData>(context,
      //                                 listen: false)
      //                             .post13 +
      //                         input),
      //                 onValidateText: (input) => input.trim().length <
      //                         1
      //                     ? "The price rate cannot be empty (input free)"
      //                     : null,
      //               ),
      //               const SizedBox(
      //                 height: 70,
      //               ),
      //               AnimatedContainer(
      //                 margin: EdgeInsets.symmetric(horizontal: 10),
      //                 duration: Duration(milliseconds: 500),
      //                 curve: Curves.linearToEaseOut,
      //                 height: Provider.of<UserData>(context,
      //                             listen: false)
      //                         .post3
      //                         .isEmpty
      //                     ? 0
      //                     : 40,
      //                 child: Center(
      //                   child: Container(
      //                     width: 200,
      //                     child: OutlinedButton(
      //                         style: OutlinedButton.styleFrom(
      //                           primary: Colors.blue,
      //                           side: BorderSide(
      //                             width: 1.0,
      //                             color: ConfigBloc().darkModeOn
      //                                 ? Colors.white
      //                                 : Colors.black,
      //                           ),
      //                           shape: RoundedRectangleBorder(
      //                             borderRadius:
      //                                 BorderRadius.circular(20.0),
      //                           ),
      //                         ),
      //                         child: Text(
      //                           'Continue',
      //                           style: TextStyle(
      //                             color: ConfigBloc().darkModeOn
      //                                 ? Colors.white
      //                                 : Colors.black,
      //                           ),
      //                         ),
      //                         onPressed: () {
      //                           FocusScope.of(context).unfocus();
      //                           animateToPage();
      //                         }),
      //                   ),
      //                 ),

      //                 // AlwaysWhiteButton(
      //                 //     onPressed: () {
      //                 //       animateToPage();
      //                 //     },
      //                 //     buttonText: "Continue"),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     ],
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 '3. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 'Category.',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         DirectionWidgetWhite(
      //           fontSize: null,
      //           text:
      //               'Select an event category that matches the event you are creating. ',
      //         ),
      //         buildEventTypePicker(),
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 30.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 '4. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 'Time',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         DirectionWidgetWhite(
      //           fontSize: null,
      //           text:
      //               'Select the exact time your event would begin. ',
      //         ),
      //         SizedBox(height: 20),
      //         buildTImePicker(),
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 '5. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 'Date.',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         DirectionWidgetWhite(
      //           fontSize: null,
      //           text: 'Select the exact date of your event. ',
      //         ),
      //         SizedBox(height: 20),
      //         buildDatePicker(),
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 widget.isEditting ? '' : '6. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 widget.isEditting ? '' : 'Closeing day.',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         widget.isEditting
      //             ? DirectionWidgetWhite(
      //                 fontSize: null,
      //                 text:
      //                     'Certiain information of an event cannot be modified once an event is created. Information such as date, time, category, flyer background, and event settings cannot be changed. ',
      //               )
      //             : DirectionWidgetWhite(
      //                 fontSize: null,
      //                 text:
      //                     'Choose a closing day for your event. This indicates the closing period of your event. For instance, if you pick three days, your event dashboard and flyer would be disabled three days after your event date specified previously. ',
      //               ),
      //         SizedBox(height: 20),
      //         widget.isEditting
      //             ? Center(
      //                 child: AlwaysWhiteButton(
      //                     onPressed: _validate,
      //                     buttonText: "Start editing"),
      //               )
      //             : buildClosingDayPicker(),
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.only(
      //       bottom: 30,
      //     ),
      //     child: Container(
      //       child: Padding(
      //         padding: const EdgeInsets.all(20.0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: <Widget>[
      //             Align(
      //               alignment: Alignment.centerLeft,
      //               child: Row(
      //                 children: [
      //                   Text(
      //                     '7. ',
      //                     style: TextStyle(
      //                       color: Colors.blue,
      //                       fontSize: 30,
      //                     ),
      //                   ),
      //                   Text(
      //                     'Venue.',
      //                     style: TextStyle(
      //                       color: Colors.blue,
      //                       fontSize: 12,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             Provider.of<UserData>(context, listen: false)
      //                     .isLoading
      //                 ? Padding(
      //                     padding:
      //                         const EdgeInsets.only(bottom: 10.0),
      //                     child: SizedBox(
      //                       height: 2.0,
      //                       child: LinearProgressIndicator(
      //                         backgroundColor: Colors.transparent,
      //                         valueColor:
      //                             AlwaysStoppedAnimation(Colors.blue),
      //                       ),
      //                     ),
      //                   )
      //                 : const SizedBox.shrink(),
      //             Provider.of<UserData>(context, listen: false)
      //                     .post5
      //                     .isNotEmpty
      //                 ? AnimatedContainer(
      //                     duration: Duration(milliseconds: 500),
      //                     height: Provider.of<UserData>(context,
      //                                 listen: false)
      //                             .post5
      //                             .isEmpty
      //                         ? 0.0
      //                         : null,
      //                     curve: Curves.easeInOut,
      //                     child: Text(
      //                       Provider.of<UserData>(context,
      //                               listen: false)
      //                           .post5
      //                           .toString(),
      //                       style: TextStyle(
      //                           color: Colors.blue,
      //                           fontSize: 20,
      //                           fontWeight: FontWeight.bold),
      //                     ),
      //                   )
      //                 : _isfetchingAddress
      //                     ? const SizedBox.shrink()
      //                     : DirectionWidgetWhite(
      //                         fontSize: null,
      //                         text: Provider.of<UserData>(context,
      //                                     listen: false)
      //                                 .bool2
      //                             ? 'Enter the host link of the event. It will help other users virtually join the event if they are interested. '
      //                             : 'Enter the address venue of the event. Make sure you select the correct address from the list suggested below. It will help other users navigate to the venue if they are interested. ',
      //                       ),
      //             Text(
      //               Provider.of<UserData>(context, listen: false)
      //                   .post10
      //                   .toString(),
      //               style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 20,
      //                   fontWeight: FontWeight.bold),
      //             ),
      //             SizedBox(height: 10),
      //             Provider.of<UserData>(context, listen: false).bool2
      //                 ? ContentField(
      //                     labelText: "Virtual venue",
      //                     hintText: "Link to virtual event venue",
      //                     initialValue: widget.virtualVenue,
      //                     onSavedText: (input) =>
      //                         Provider.of<UserData>(context,
      //                                 listen: false)
      //                             .setPost5(input),
      //                     onValidateText: (_) {},
      //                   )
      //                 : TextFormField(
      //                     keyboardType: TextInputType.multiline,
      //                     maxLines: null,
      //                     controller: _controller,
      //                     textCapitalization:
      //                         TextCapitalization.sentences,
      //                     autovalidateMode: AutovalidateMode.always,
      //                     onChanged: (value) => {
      //                       Provider.of<UserData>(context,
      //                               listen: false)
      //                           .searchAddress(value),
      //                       setState(() {
      //                         _isfetchingAddress = true;
      //                       })
      //                     },
      //                     style: TextStyle(
      //                       fontSize: 16,
      //                       color: ConfigBloc().darkModeOn
      //                           ? Colors.white
      //                           : Colors.black,
      //                     ),
      //                     initialValue: widget.venue,
      //                     decoration: InputDecoration(
      //                         hintText: "Event venue address",
      //                         hintStyle: TextStyle(
      //                           fontSize: 12.0,
      //                           color: Colors.grey,
      //                         ),
      //                         labelText: 'Venue',
      //                         labelStyle: TextStyle(
      //                           fontSize: 16.0,
      //                           fontWeight: FontWeight.bold,
      //                           color: Colors.grey,
      //                         ),
      //                         enabledBorder: new UnderlineInputBorder(
      //                             borderSide: new BorderSide(
      //                                 color: Colors.grey))),
      //                   ),
      //             if (Provider.of<UserData>(context, listen: false)
      //                     .addressSearchResults !=
      //                 null)
      //               const SizedBox(
      //                 height: 30,
      //               ),
      //             Provider.of<UserData>(context, listen: false).bool2
      //                 ? const SizedBox.shrink()
      //                 : Container(
      //                     color: ConfigBloc().darkModeOn
      //                         ? Colors.white
      //                         : Colors.black,
      //                     child: Padding(
      //                       padding: const EdgeInsets.all(10.0),
      //                       child: Align(
      //                         alignment: Alignment.topLeft,
      //                         child: Text(
      //                           'Tap below to select the venue\'s address',
      //                           style: TextStyle(
      //                             color: ConfigBloc().darkModeOn
      //                                 ? Colors.black
      //                                 : Colors.white,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //             if (Provider.of<UserData>(
      //                   context,
      //                 ).addressSearchResults !=
      //                 null)
      //               Padding(
      //                 padding: const EdgeInsets.only(top: 10.0),
      //                 child: SingleChildScrollView(
      //                   child: Provider.of<UserData>(context,
      //                               listen: false)
      //                           .bool2
      //                       ? const SizedBox.shrink()
      //                       : Column(
      //                           children: [
      //                             _isfetchingAddress
      //                                 ? Padding(
      //                                     padding:
      //                                         const EdgeInsets.only(
      //                                             bottom: 5.0,
      //                                             top: 10),
      //                                     child: SizedBox(
      //                                       height: 2.0,
      //                                       child:
      //                                           LinearProgressIndicator(
      //                                         backgroundColor:
      //                                             Colors.transparent,
      //                                         valueColor:
      //                                             AlwaysStoppedAnimation(
      //                                                 Colors.grey),
      //                                       ),
      //                                     ),
      //                                   )
      //                                 : const SizedBox.shrink(),
      //                             Container(
      //                               height: MediaQuery.of(context)
      //                                       .size
      //                                       .width -
      //                                   100,
      //                               width: double.infinity,
      //                               decoration: BoxDecoration(
      //                                 color: Colors.transparent,
      //                                 shape: BoxShape.rectangle,
      //                                 borderRadius:
      //                                     BorderRadius.circular(10),
      //                               ),
      //                               child: ListView.builder(
      //                                 itemCount:
      //                                     Provider.of<UserData>(
      //                                             context,
      //                                             listen: false)
      //                                         .addressSearchResults!
      //                                         .length,
      //                                 itemBuilder: (context, index) {
      //                                   return ListTile(
      //                                       title: Text(
      //                                         Provider.of<UserData>(
      //                                                 context,
      //                                                 listen: false)
      //                                             .addressSearchResults![
      //                                                 index]
      //                                             .description,
      //                                         style: TextStyle(
      //                                           color: ConfigBloc()
      //                                                   .darkModeOn
      //                                               ? Colors.white
      //                                               : Colors.black,
      //                                         ),
      //                                       ),
      //                                       onTap: () {
      //                                         Provider.of<UserData>(
      //                                                 context,
      //                                                 listen: false)
      //                                             .setPost5(Provider.of<
      //                                                         UserData>(
      //                                                     context,
      //                                                     listen:
      //                                                         false)
      //                                                 .addressSearchResults![
      //                                                     index]
      //                                                 .description);
      //                                         setState(() {
      //                                           _isfetchingAddress =
      //                                               false;

      //                                           widget
      //                                               .venue = Provider
      //                                                   .of<UserData>(
      //                                                       context,
      //                                                       listen:
      //                                                           false)
      //                                               .addressSearchResults![
      //                                                   index]
      //                                               .description;
      //                                         });
      //                                         _reverseGeocoding();
      //                                       });
      //                                 },
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                 ),
      //               ),
      //             SizedBox(height: 20),
      //             widget.isEditting
      //                 ? AnimatedContainer(
      //                     duration: Duration(milliseconds: 500),
      //                     height: null,
      //                     curve: Curves.easeInOut,
      //                     child: Center(
      //                       child: AlwaysWhiteButton(
      //                           onPressed: _validate,
      //                           buttonText: 'Next'),
      //                     ),
      //                   )
      //                 : AnimatedContainer(
      //                     duration: Duration(milliseconds: 500),
      //                     height: Provider.of<UserData>(context,
      //                                 listen: false)
      //                             .post5
      //                             .isEmpty
      //                         ? 0.0
      //                         : null,
      //                     curve: Curves.easeInOut,
      //                     child: Center(
      //                       child: AlwaysWhiteButton(
      //                           onPressed: _validate,
      //                           buttonText: widget.isEditting
      //                               ? 'Next'
      //                               : "Continue"),
      //                     ),
      //                   ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 '8. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 'People (Optional)',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         DirectionWidgetWhite(
      //           fontSize: null,
      //           text:
      //               'Enter the name of people participating in this event. Separate each name with a comma(,).\nExmaple: James,Edith',
      //         ),
      //         ContentField(
      //           labelText: "Name(s) of guests",
      //           hintText: 'Special Guests (optional)',
      //           initialValue:
      //               Provider.of<UserData>(context, listen: false)
      //                   .post11,
      //           onSavedText: (input) =>
      //               Provider.of<UserData>(context, listen: false)
      //                   .setPost11(input),
      //           onValidateText: (_) {},
      //         ),
      //         ContentField(
      //           labelText: "Name(s) of artists",
      //           hintText: 'Artist Performing (optional)',
      //           initialValue:
      //               Provider.of<UserData>(context, listen: false)
      //                   .post12,
      //           onSavedText: (input) =>
      //               Provider.of<UserData>(context, listen: false)
      //                   .setPost12(input),
      //           onValidateText: (_) {},
      //         ),
      //         SizedBox(height: 70),
      //         Padding(
      //           padding: const EdgeInsets.only(bottom: 50),
      //           child: AlwaysWhiteButton(
      //               onPressed: _validate,
      //               buttonText:
      //                   widget.isEditting ? 'Next' : "Continue"),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Container(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: <Widget>[
      //           Align(
      //             alignment: Alignment.centerLeft,
      //             child: Row(
      //               children: [
      //                 Text(
      //                   '8. ',
      //                   style: TextStyle(
      //                     color: Colors.blue,
      //                     fontSize: 30,
      //                   ),
      //                 ),
      //                 Text(
      //                   'Flyer\nInformation.',
      //                   style: TextStyle(
      //                     color: Colors.blue,
      //                     fontSize: 12,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           DirectionWidgetWhite(
      //             fontSize: null,
      //             text:
      //                 'Provide the required information below correctly. The fields on this page cannot be empty. ',
      //           ),
      //           ContentField(
      //             labelText: 'Title',
      //             hintText: "Enter the title of your event",
      //             initialValue:
      //                 Provider.of<UserData>(context, listen: false)
      //                     .post1
      //                     .toString(),
      //             onSavedText: (input) =>
      //                 Provider.of<UserData>(context, listen: false)
      //                     .setPost1(input),
      //             onValidateText: (input) => input.trim().length < 1
      //                 ? "The title cannot be empty"
      //                 : null,
      //           ),
      //           ContentField(
      //             labelText: 'Theme',
      //             hintText: "Enter a theme for the event",
      //             initialValue:
      //                 Provider.of<UserData>(context, listen: false)
      //                     .post2
      //                     .toString(),
      //             onSavedText: (input) =>
      //                 Provider.of<UserData>(context, listen: false)
      //                     .setPost2(input),
      //             onValidateText: (input) => input.trim().length < 10
      //                 ? "The theme is too short( > 10 characters)"
      //                 : null,
      //           ),
      //           ContentField(
      //             labelText: 'Host',
      //             hintText: "Name of event host",
      //             initialValue:
      //                 Provider.of<UserData>(context, listen: false)
      //                     .post4
      //                     .toString(),
      //             onSavedText: (input) =>
      //                 Provider.of<UserData>(context, listen: false)
      //                     .setPost4(input),
      //             onValidateText: (input) => input.trim().length < 1
      //                 ? "The host cannot be empty"
      //                 : null,
      //           ),
      //           Provider.of<UserData>(context, listen: false)
      //                   .post10
      //                   .isEmpty
      //               ? Provider.of<UserData>(context, listen: false)
      //                       .bool2
      //                   ? const SizedBox.shrink()
      //                   : ContentField(
      //                       labelText: 'Country',
      //                       hintText: "Country of event",
      //                       initialValue: Provider.of<UserData>(
      //                               context,
      //                               listen: false)
      //                           .post10
      //                           .toString(),
      //                       onSavedText: (input) =>
      //                           Provider.of<UserData>(context,
      //                                   listen: false)
      //                               .setPost10(input),
      //                       onValidateText: (input) =>
      //                           input.trim().length < 1
      //                               ? "Enter the country of event"
      //                               : null,
      //                     )
      //               : const SizedBox.shrink(),
      //           const SizedBox(height: 70),
      //           AlwaysWhiteButton(
      //               onPressed: _validate,
      //               buttonText:
      //                   widget.isEditting ? 'Next' : "Continue"),
      //           const SizedBox(height: 70),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Padding(
      //     padding: const EdgeInsets.all(20.0),
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Align(
      //           alignment: Alignment.centerLeft,
      //           child: Row(
      //             children: [
      //               Text(
      //                 '9. ',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 30,
      //                 ),
      //               ),
      //               Text(
      //                 'Flyer\nInformation.(optional)',
      //                 style: TextStyle(
      //                   color: Colors.blue,
      //                   fontSize: 12,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         DirectionWidgetWhite(
      //           fontSize: null,
      //           text:
      //               'You can provide the following information if available for your event. The information required on this page is optional. ',
      //         ),
      //         ContentField(
      //           labelText: "Name of Dj",
      //           hintText: 'Dj',
      //           initialValue: widget.dj,
      //           onSavedText: (input) => widget.dj = input,
      //           onValidateText: (_) {},
      //         ),
      //         ContentField(
      //           labelText: "Dress code for the event",
      //           hintText: 'Dress code',
      //           initialValue: widget.dressCode,
      //           onSavedText: (input) => widget.dressCode = input,
      //           onValidateText: (_) {},
      //         ),
      //         ContentField(
      //           labelText: "Ticket site",
      //           hintText: 'Website to purchase ticket',
      //           initialValue: widget.ticketSite,
      //           onSavedText: (input) => widget.ticketSite = input,
      //           onValidateText: (_) {},
      //         ),
      //         ContentField(
      //           labelText: "Previous event",
      //           hintText: 'A Video link of the previous events',
      //           initialValue: widget.previousEvent,
      //           onSavedText: (input) => widget.previousEvent = input,
      //           onValidateText: (input) =>
      //               !musicVideoLink.hasMatch(input) &&
      //                       input.trim().length > 1
      //                   ? "Enter a valid video link"
      //                   : null,
      //         ),
      //         SizedBox(height: 70),
      //         Provider.of<UserData>(context, listen: false).isLoading
      //             ? const SizedBox.shrink()
      //             : Padding(
      //                 padding: const EdgeInsets.only(bottom: 50),
      //                 child: AvatarCircularButton(
      //                     buttonText:
      //                         widget.isEditting ? 'Save' : "Create",
      //                     onPressed: () => widget.isEditting
      //                         ? _submitEdit()
      //                         : _showSelectImageDialog('create')),
      //               ),
      //         widget.isEditting
      //             ? Column(
      //                 children: [
      //                   InkWell(
      //                     borderRadius: BorderRadius.circular(10),
      //                     onTap: () => () {},
      //                     child: Ink(
      //                       decoration: BoxDecoration(
      //                         color: ConfigBloc().darkModeOn
      //                             ? Colors.white
      //                             : Colors.black,
      //                         borderRadius: BorderRadius.circular(8),
      //                       ),
      //                       child: Container(
      //                         height: 40,
      //                         width: 40,
      //                         child: IconButton(
      //                             icon: Icon(Icons.delete_forever),
      //                             iconSize: 25,
      //                             color: ConfigBloc().darkModeOn
      //                                 ? Colors.black
      //                                 : Colors.white,
      //                             onPressed: () {
      //                               _showSelectImageDialog('');
      //                             }),
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 30.0,
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.only(
      //                         left: 50.0, right: 50),
      //                     child: Text(
      //                       " Provide accurate information.\nRefresh your page to see the effect of your event edited or deleted",
      //                       style: TextStyle(
      //                           color: Colors.grey, fontSize: 12.0),
      //                       textAlign: TextAlign.center,
      //                     ),
      //                   ),
      //                   SizedBox(
      //                     height: 50.0,
      //                   ),
      //                 ],
      //               )
      //             : const SizedBox.shrink()
      //       ],
      //     ),
      //   ),
      // ),
      // SingleChildScrollView(
      //   child: Container(
      //       color: Color(0xFFFF2D55),
      //       height: MediaQuery.of(context).size.height - 200,
      //       child: Center(
      //           child: Loading(
      //         title: 'Publishing event',
      //         icon: (Icons.event),
      //       ))),
      // )
    ));
  }
}
