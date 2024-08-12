import 'package:bars/utilities/exports.dart';

class FetchingLocation extends StatefulWidget {
  final String currentUserId;
  final bool isEvent;
  final UserSettingsLoadingPreferenceModel userLocationSettings;
  final int liveLocationIntialPage;

  FetchingLocation({
    required this.userLocationSettings,
    required this.isEvent,
    required this.currentUserId,
    required this.liveLocationIntialPage,
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
    getLocationAndDecode();
    // _getCurrentLocation();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<bool> checkAndRequestLocationPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // If permissions are permanently denied return false
        return false;
      }
      if (permission == LocationPermission.denied) {
        // If permissions are denied return false
        return false;
      }
    }
    // If permissions are granted or limited return true
    return true;
  }

  void getLocationAndDecode() async {
    try {
      bool hasLocationPermission = await checkAndRequestLocationPermissions();
      if (!hasLocationPermission) {
        Navigator.pop(context);
        showPermissionExplanationDialog();
        return;
      } else {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.length > 0) {
          Placemark firstPlacemark = placemarks.first;

          _city = firstPlacemark.locality ?? '';
          _userCountry = firstPlacemark.country ?? '';

          Navigator.pop(context);
          widget.isEvent
              ? _navigateToPage(
                  context,
                  DiscoverEventScreen(
                    currentUserId: widget.currentUserId,
                    userLocationSettings: widget.userLocationSettings,
                    isLiveLocation: true,
                    liveCity: _city,
                    liveCountry: _userCountry,
                    liveLocationIntialPage: widget.liveLocationIntialPage,
                    sortNumberOfDays: 0,
                  ),
                )
              : _navigateToPage(
                  context,
                  DiscoverUser(
                    currentUserId: widget.currentUserId,
                    isLiveLocation: true,
                    liveCity: _city,
                    liveCountry: _userCountry,
                    liveLocationIntialPage: 0,
                    isWelcome: false,
                  ),
                );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage();
    }
  }

  void showPermissionExplanationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title:
              ' This app needs location permissions to function. Please grant location permission in the app settings.',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetErrorMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Coulnd\'nt get your live location. ',
          subTitle:
              'Make sure you have an active internet connection and try again.',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      animate: true,
      showTwoGlows: true,
      shape: BoxShape.circle,
      glowColor: Colors.green,
      endRadius: 300,
      duration: const Duration(milliseconds: 2000),
      repeatPauseDuration: const Duration(milliseconds: 1000),
      child: NoContents(
        icon: (Icons.location_on),
        title: '\nFetching Live Location',
        subTitle: 'Just a moment...',
        color: Colors.green,
      ),
    );
  }
}
