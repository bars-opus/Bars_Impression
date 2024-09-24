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

  void _showBottomDraft(BuildContext context, List<Event> eventsList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventDrafts(eventsList: eventsList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _provide2 = Provider.of<UserData>(
      context,
    );
    var _user = _provider.user;
    var _userLocation = _provider.userLocationPreference;
    return Container(
        height: ResponsiveHelper.responsiveHeight(
            context,

            //  _user!.storeType!.startsWith('Fans') ? 170 :

            230),
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
                icon: Icons.add,
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
                                  isDraft: false,
                                ));
                      }
                    : () {},
                text: 'Create new event',
              ),
              // if (!_user.storeType!.startsWith('Fans'))
              BottomModelSheetListTileActionWidget(
                isLoading: _provide2.isLoading,
                dontPop: true,
                colorCode: '',
                icon: Icons.event,
                onPressed: () async {
                  if (!_provide2.isLoading) _provider.setIsLoading(true);
                  try {
                    Query eventQuery = await eventsDraftRef
                        .doc(_user!.userId)
                        .collection('events')
                        .orderBy('timestamp', descending: true);
                    QuerySnapshot postFeedSnapShot = await eventQuery.get();

                    List<Event> events = await postFeedSnapShot.docs
                        .map((doc) => Event.fromDoc(doc))
                        .toList();
                    _provider.setIsLoading(false);
                    Navigator.pop(context);
                    _showBottomDraft(context, events);
                  } catch (e) {
                    _provider.setIsLoading(false);
                    EventDatabase.showBottomSheetErrorMessage(
                        context, 'Could\'nt load draft');
                  }
                },
                text: _provide2.isLoading ? 'Loading...' : 'Choose from draft',
                //  'Create work request',
              ),
            ])));
  }
}
