import 'package:bars/utilities/exports.dart';
import 'package:geocoding/geocoding.dart';

class EventPageLive extends StatefulWidget {
  static final id = 'EventPageLive';
  final String currentUserId;
  final AccountHolder user;
  EventPageLive({required this.currentUserId, required this.user});

  @override
  _EventPageLiveState createState() => _EventPageLiveState();
}

class _EventPageLiveState extends State<EventPageLive>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  String _city = '';
  String _userCountry = '';
  late double userLatitude;
  late double userLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = geoposition.latitude;
      userLongitude = geoposition.longitude;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(userLatitude, userLongitude);
    setState(() {
      _city = (placemarks[0].locality == null ? '' : placemarks[0].locality)!;
      _userCountry = (placemarks[0].country == null ? '' : placemarks[0].country)!;
    });
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: 6,
        child: Scaffold(
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              iconTheme: new IconThemeData(
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
              backgroundColor:
                  ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
              centerTitle: true,
              title: Text(
                'Events In ${widget.user.city}',
                style: TextStyle(
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              bottom: TabBar(
                  labelColor:
                      ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.blue,
                  onTap: (int index) {
                    Provider.of<UserData>(context, listen: false)
                        .setEventTab(index);
                  },
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                  indicatorWeight: 2.0,
                  tabs: <Widget>[
                    const Text(
                      'All',
                    ),
                    const Text(
                      'Festival',
                    ),
                    const Text(
                      'Award',
                    ),
                    const Text('Tour'),
                    const Text(
                      'Album Launch',
                    ),
                    const Text(
                      'Others',
                    ),
                  ]),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                EventsAllLiveCity(             
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
                FestivalEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
                AwardEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
                ToursEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
                AlbumLaunchesLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
                OtherEventsLiveCity(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
              ],
            )),
      ),
    );
  }
}
