import 'package:bars/utilities/exports.dart';

class ProfileContentSettings extends StatefulWidget {
  final AccountHolder user;

  ProfileContentSettings({
    required this.user,
  });

  @override
  _ProfileContentSettingsState createState() => _ProfileContentSettingsState();
}

class _ProfileContentSettingsState extends State<ProfileContentSettings> {
  bool _disableMoodPunchReaction = false;
  bool _disableMoodPunchVibe = false;
  bool _disableContentSharing = false;

  @override
  void initState() {
    super.initState();
    _disableMoodPunchReaction = widget.user.disableChat!;
    _disableContentSharing = widget.user.disableAdvice!;

    _disableMoodPunchReaction = widget.user.disableMoodPunchReaction!;
    _disableMoodPunchVibe = widget.user.disableMoodPunchVibe!;
    _disableContentSharing = widget.user.disableContentSharing!;
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
            title: Text(
              'Content Settings',
              style: TextStyle(
                  color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SettingSwitch(
                                title: 'Disable Content sharing',
                                subTitle:
                                    'Other users can\'t share your content.',
                                value: _disableContentSharing,
                                onChanged: (value) => setState(
                                  () {
                                    _disableContentSharing =
                                        this._disableContentSharing = value;
                                    usersRef
                                        .doc(
                                      widget.user.id,
                                    )
                                        .update({
                                      'disableContentSharing':
                                          _disableContentSharing,
                                    });
                                  },
                                ),
                              ),
                              Divider(color: Colors.grey),
                              SettingSwitch(
                                title: 'Disable mood punch reaction',
                                subTitle:
                                    'Other users can\'t react (dope or ???) to your mood punched.',
                                value: _disableMoodPunchReaction,
                                onChanged: (value) => setState(
                                  () {
                                    _disableMoodPunchReaction =
                                        this._disableMoodPunchReaction = value;
                                    usersRef
                                        .doc(
                                      widget.user.id,
                                    )
                                        .update({
                                      'disableMoodPunchReaction':
                                          _disableMoodPunchReaction,
                                    });
                                  },
                                ),
                              ),
                              Divider(color: Colors.grey),
                              SettingSwitch(
                                title: 'Disable mood punch vibes',
                                subTitle:
                                    'Other users can\'t vibe with your mood punch.',
                                value: _disableMoodPunchVibe,
                                onChanged: (value) => setState(
                                  () {
                                    _disableMoodPunchVibe =
                                        this._disableMoodPunchVibe = value;
                                    usersRef
                                        .doc(
                                      widget.user.id,
                                    )
                                        .update({
                                      'disableMoodPunchVibe':
                                          _disableMoodPunchVibe,
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
