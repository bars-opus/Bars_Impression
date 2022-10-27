import 'package:bars/utilities/exports.dart';
import 'package:geocoding/geocoding.dart';

class FetchingLocation extends StatefulWidget {
  final String currentUserId;
  final String type;
  final AccountHolder user;
  FetchingLocation({
    required this.user,
    required this.type,
    required this.currentUserId,
  });

  @override
  _FetchingLocationState createState() => _FetchingLocationState();
}

class _FetchingLocationState extends State<FetchingLocation> {
  String _city = '';
  String _userCountry = '';
  double? userLatitude;
  double? userLongitude;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    await Future.delayed(Duration(seconds: 2));
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Center(
          child: NoContents(
            icon: (Icons.location_off),
            title: 'Permission Denied',
            subTitle: widget.type.startsWith('Users')
                ? 'Allow location permission to see users in your live location'
                : 'Allow location permission to see events in your live location',
          ),
        );
      } else if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return _fetichingLocation();
      }
    } else {
      _fetichingLocation();
    }
  }

  _fetichingLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      userLatitude = geoposition.latitude;
      userLongitude = geoposition.longitude;
    });

    List<Placemark> placemarks =
        await placemarkFromCoordinates(userLatitude!, userLongitude!);
    setState(() {
      _city = (placemarks[0].locality == null ? '' : placemarks[0].locality)!;
      _userCountry =
          (placemarks[0].country == null ? '' : placemarks[0].country)!;
      widget.type.startsWith('Users')
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => UserLive(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
              ),
            )
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventPageLive(
                  currentUserId: widget.currentUserId,
                  user: widget.user,
                  liveCity: _city,
                  liveCountry: _userCountry,
                ),
              ),
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Center(
              child: Column(
                children: [
                  AvatarGlow(
                    animate: true,
                    showTwoGlows: true,
                    shape: BoxShape.circle,
                    glowColor: Colors.green,
                    endRadius: MediaQuery.of(context).size.width,
                    duration: const Duration(milliseconds: 2000),
                    repeatPauseDuration: const Duration(milliseconds: 1000),
                    child: NoContents(
                      icon: (Icons.location_on),
                      title: '\nFetching Live Location',
                      subTitle: 'Just a moment...',
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 1.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
