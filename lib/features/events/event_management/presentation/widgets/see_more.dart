import 'package:bars/utilities/exports.dart';

class SeeMore extends StatelessWidget {
  final String currentUserId;
  final String types;
  final int pageIndex;
  final UserSettingsLoadingPreferenceModel userLocationSettings;
  final String liveCity;
  final String liveCountry;
  final bool isEvent;
  final String isFrom;
  final int sortNumberOfDays;

  SeeMore({
    required this.userLocationSettings,
    required this.currentUserId,
    required this.types,
    required this.pageIndex,
    required this.liveCity,
    required this.liveCountry,
    required this.isEvent,
    required this.isFrom,
    required this.sortNumberOfDays,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColorLight,
      ),
      body: Container(
        child:

            //  isEvent
            //     ? EventTypes(
            //         currentUserId: currentUserId,
            //         types: types.startsWith('All') ? '' : types,
            //         pageIndex: types.startsWith('All') ? 0 : pageIndex,
            //         userLocationSettings: userLocationSettings,
            //         liveCity: liveCity,
            //         liveCountry: liveCountry,
            //         seeMoreFrom: isFrom,
            //         sortNumberOfDays: sortNumberOfDays,
            //         isFrom: isFrom,
            //       )
            //     :

            CreativesScreen(
          currentUserId: currentUserId,
          shopType: types,
          // exploreLocation: '',
          pageIndex: pageIndex,
          userLocationSettings: userLocationSettings,
          liveCity: liveCity,
          liveCountry: liveCountry,
          seeMoreFrom: isFrom, isFrom: isFrom,
        ),
      ),
    );
  }
}
