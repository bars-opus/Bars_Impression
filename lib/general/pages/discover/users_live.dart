import 'package:bars/utilities/exports.dart';
import 'package:geocoding/geocoding.dart';

class UserLive extends StatefulWidget {
  final String currentUserId;
  final AccountHolder user;
  static final id = 'UserLive';

  UserLive({
  required  this.currentUserId,
   required  this.user,
  });

  @override
  _UserLiveState createState() => _UserLiveState();
}

class _UserLiveState extends State<UserLive> {
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

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.3)),
      child: DefaultTabController(
        length: 15,
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
              title: Column(children: [
                // ignore: unnecessary_null_comparison
                (userLatitude == null || userLongitude == null)
                    ? Material(
                        color: Colors.transparent,
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Shimmer.fromColors(
                                  period: Duration(milliseconds: 1000),
                                  baseColor: Colors.grey,
                                  highlightColor: Colors.blue,
                                  child: RichText(
                                      text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: 'Fetching current location...'),
                                    ],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.blue),
                                  )),
                                ),
                                const SizedBox(height: 3),
                                SizedBox(
                                    height: 1.0,
                                    child: LinearProgressIndicator(
                                      backgroundColor: ConfigBloc().darkModeOn
                                          ? Color(0xFF1a1a1a)
                                          : Colors.grey[100],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                    ))
                              ]),
                        ),
                      )
                    : Text(
                        'People In ${_city}',
                        style: TextStyle(
                            color: ConfigBloc().darkModeOn
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                const SizedBox(height: 20)
              ]),
              bottom: TabBar(
                  labelColor:
                      ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.blue,
                  onTap: (int index) {
                    Provider.of<UserData>(context, listen: false)
                        .setUsersTab(index);
                  },
                  unselectedLabelColor: Colors.grey,
                  labelPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                  indicatorWeight: 2.0,
                  isScrollable: true,
                  tabs: <Widget>[
                    const Text(
                      'Artists',
                    ),
                    const Text(
                      'Producers',
                    ),
                    const Text(
                      'Designers',
                    ),
                    const Text(
                      'Video Directors',
                    ),
                    const Text(
                      'Djs',
                    ),
                    const Text(
                      'Battle Rappers',
                    ),
                    const Text(
                      'Photographers',
                    ),
                    const Text(
                      'Dancers',
                    ),
                    const Text(
                      'Video Vixens',
                    ),
                    const Text(
                      'Makeup Artist',
                    ),
                    const Text(
                      'Record Labels',
                    ),
                    const Text(
                      'Brand Influncers',
                    ),
                    const Text(
                      'Bloggers',
                    ),
                    const Text(
                      'MC(Host)',
                    ),
                    const Text(
                      'Fans',
                    ),
                  ]),
            ),
            body: TabBarView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                ArtistsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                ProducersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                DesignersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                VideoDirectorsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                DjsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                BattleRappersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                PhotographersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                DancersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                VideoVixensLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                MakeUpArtistsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                RecordLabelsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                BrandInfluencersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                BloggersLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                MCHostsLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
                FansLive(
                  currentUserId: widget.currentUserId,
                  liveCity: _city,
                  liveCountry: _userCountry,
                  exploreLocation: 'Live',
                ),
              ],
            )),
      ),
    );
  }
}
