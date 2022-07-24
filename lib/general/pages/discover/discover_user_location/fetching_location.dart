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
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Center(
          child: NoContents(
            icon: (Icons.location_off),
            title: 'Permission Denied',
            subTitle:
                'Allow location permission to see users in your live location',
          ),
        );
      }
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      child: Scaffold(
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
              '',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                period: Duration(milliseconds: 1000),
                baseColor: Colors.grey,
                highlightColor: Colors.blue,
                child: NoContents(
                  icon: (Icons.location_on),
                  title: 'Fetching Live Location',
                  subTitle: 'Just a moment, please wait',
                ),
              ),
              const SizedBox(height: 3),
              SizedBox(
                  height: 1.0,
                  child: LinearProgressIndicator(
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
