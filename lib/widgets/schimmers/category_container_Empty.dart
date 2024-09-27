import 'package:bars/utilities/exports.dart';

class CategoryContainerEmpty extends StatelessWidget {
  final String containerTitle;
  final String containerSubTitle;
  final bool noLocation;
  final String liveLocation;
  final bool isEvent;

  final double height;
  final int liveLocationIntialPage;

  final String storeType;

  CategoryContainerEmpty({
    required this.containerTitle,
    required this.containerSubTitle,
    required this.height,
    required this.noLocation,
    required this.liveLocation,
    required this.liveLocationIntialPage,
    required this.isEvent,
    required this.storeType,
  });

  void _showBottomSheetFetchLiveLocation(
      BuildContext context,
      UserSettingsLoadingPreferenceModel userLocationSettings,
      String currentUserId) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      isScrollControlled: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 350),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: FetchingLocation(
              userLocationSettings: userLocationSettings,
              currentUserId: currentUserId,
              isEvent: isEvent,
              liveLocationIntialPage: liveLocationIntialPage,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    final UserSettingsLoadingPreferenceModel _user =
        _provider.userLocationPreference!;
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: ListTile(
              trailing: liveLocation.startsWith('Location') ||
                      liveLocation.startsWith('Images')
                  ? Icon(
                      liveLocation.startsWith('Images')
                          ? Icons.image
                          : Icons.location_on,
                      size: 25.0,
                      color: Colors.grey)
                  : null,
              onTap: liveLocation.startsWith('Location')
                  ? () {
                      HapticFeedback.lightImpact();
                      _showBottomSheetFetchLiveLocation(
                          context, _user, _provider.currentUserId!);
                    }
                  : liveLocation.startsWith('Images')
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AllPosts(
                                  currentUserId: _provider.currentUserId!,
                                  storeType: storeType,
                                  pageIndex: 0,
                                  // userLocationSettings: null,
                                  liveCity: '',
                                  liveCountry: '',
                                ),
                              ));
                        }
                      : () {
                          noLocation
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfileSelectLocation(
                                      user: _user,
                                      notFromEditProfile: true,
                                    ),
                                  ))
                              : () {};
                        },
              title: liveLocation.startsWith('Location') ||
                      liveLocation.startsWith('Images')
                  ? Text(
                      "$containerTitle\n",
                      style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    )
                  : RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "$containerTitle\n",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          TextSpan(
                            text: "$containerSubTitle",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextSpan(
                            text: noLocation ? "Tap to enter location " : '',
                            style: TextStyle(
                              fontSize: noLocation
                                  ? ResponsiveHelper.responsiveFontSize(
                                      context, 12.0)
                                  : 0,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
