import 'package:bars/utilities/exports.dart';

class CreateContent extends StatelessWidget {
  const CreateContent({
    super.key,
  });

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _user = Provider.of<UserData>(context, listen: false).user;
    var _userLocation =
        Provider.of<UserData>(context, listen: false).userLocationPreference;
    return Container(
        height: ResponsiveHelper.responsiveHeight(
            context, _user!.profileHandle!.startsWith('Fans') ? 170 : 230),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 2),
            child: MyBottomModelSheetAction(actions: [
              const SizedBox(
                height: 40,
              ),
              BottomModelSheetListTileActionWidget(
                colorCode: '',
                icon: Icons.event,
                onPressed: _userLocation != null
                    ? () {
                        HapticFeedback.mediumImpact();
                        _userLocation.country!.isEmpty
                            ? _navigateToPage(
                                context,
                                EditProfileSelectLocation(
                                  user: _userLocation,
                                ))
                            :  _navigateToPage(
                                    context,
                                    CreateEventScreen(
                                      isEditting: false,
                                      event: null,
                                    ));
                      }
                    : () {},
                text: 'Create event',
              ),
              if (!_user.profileHandle!.startsWith('Fans'))
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.work_outline_sharp,
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _navigateToPage(
                        context,
                        CreateWork(
                          currentUserId: _user.userId ?? '',
                          userPortfolio: null,
                        ));
                  },
                  text: 'Create work request',
                ),
            ])));
  }
}
