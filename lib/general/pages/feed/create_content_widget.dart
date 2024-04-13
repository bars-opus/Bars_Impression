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

  void _showBottomEditLocation(
    BuildContext context,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _userLocation = _provider.userLocationPreference;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 400,
          buttonText: 'set up city',
          onPressed: () async {
            Navigator.pop(context);
            _navigateToPage(
                context,
                EditProfileSelectLocation(
                  user: _userLocation!,
                  notFromEditProfile: true,
                ));
          },
          title: 'Set up your city',
          subTitle:
              'In order to create an event, it is necessary to set up your city information. This enables us to provide targeted public event suggestions to individuals residing in close proximity to you, as well as recommend local public events that may be of interest to you. Please note that providing your precise location or community details is not required; specifying your city is sufficient.',
        );
      },
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
                        _userLocation.city!.isEmpty
                            ? _showBottomEditLocation(context)
                            : _navigateToPage(
                                context,
                                CreateEventScreen(
                                  isEditting: false,
                                  event: null,
                                  isCompleted: false,
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
