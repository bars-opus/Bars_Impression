import 'package:bars/utilities/exports.dart';

class CreateEvent extends StatefulWidget {
  final AccountHolder? user;
  static final id = 'Create_posts';

  CreateEvent({required this.user});

  @override
  _CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  //  File _image;
  int index = 0;
  String _type = '';
  int showDatePicker = 0;
  int showTimePicker = 0;
  DateTime dateTime = DateTime.now();
  DateTime dayTime = DateTime.now();
  String _title = '';
  String _rate = '';
  String _venue = '';
  String _time = '';
  String _dj = '';
  String _guess = '';
  String _host = '';
  String _artist = '';
  String _theme = '';
  String _dressCode = '';
  String _date = '';
  String _previousEvent = '';
  String _triller = '';
  String _city = '';
  String _country = '';
  String _virtualVenue = '';
  String _ticketSite = '';
  String _clossingDay = '';
  bool _isVirtual = false;
  bool _isPrivate = false;
  bool _isFree = false;
  bool _isCashPayment = false;
  bool _showOnExplorePage = false;
  bool _showToFollowers = false;

  @override
  Widget build(BuildContext context) {
    return CreateEventWidget(
      artist: _artist,
      date: _date,
      dj: _dj,
      dressCode: _dressCode,
      image: null,
      host: _host,
      imageUrl: '',
      theme: _theme,
      isEditting: false,
      guess: _guess,
      previousEvent: _previousEvent,
      ticketSite: _ticketSite,
      rate: _rate,
      title: _title,
      time: _time,
      venue: _venue,
      user: widget.user,
      type: _type,
      city: _city,
      country: _country,
      virtualVenue: _virtualVenue,
      triller: _triller,
      event: null,
      isVirtual: _isVirtual,
      isPrivate: _isPrivate,
      isFree: _isFree,
      isCashPayment: _isCashPayment,
      showOnExplorePage: _showOnExplorePage,
      showToFollowers: _showToFollowers,
      clossingDay: _clossingDay,
    );
  }
}
