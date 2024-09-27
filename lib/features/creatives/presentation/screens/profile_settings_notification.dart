import 'package:bars/utilities/exports.dart';

class ProfileSettingsNotification extends StatefulWidget {
  final UserSettingsGeneralModel userGeneralSettings;

  ProfileSettingsNotification({
    required this.userGeneralSettings,
  });

  @override
  _ProfileSettingsNotificationState createState() =>
      _ProfileSettingsNotificationState();
}

class _ProfileSettingsNotificationState
    extends State<ProfileSettingsNotification> {
  bool _disableChat = false;
  bool _disableAdvice = false;
  bool _hideAdvice = false;
  bool _disableBooking = false;
  bool _disabledAccount = false;
  bool _isShop = false;
  bool _disableEventSuggestionNotification = false;
  bool _muteEventSuggestionNotification = false;
  // bool _disableNewCreativeNotifications = false;
  // bool _disableWorkVacancyNotifications = false;
  // bool _muteWorkVacancyNotifications = false;

  @override
  void initState() {
    super.initState();
    _disableChat = widget.userGeneralSettings.disableChat!;
    // _disableAdvice = widget.userGeneralSettings.disableAdvice!;
    // _hideAdvice = widget.userGeneralSettings.hideAdvice!;
    _disableBooking = widget.userGeneralSettings.disableBooking!;
    _disabledAccount = widget.userGeneralSettings.disabledAccount!;
    // _isShop = widget.userGeneralSettings.isShop!;
    // _disableEventSuggestionNotification =
    //     widget.userGeneralSettings.disableEventSuggestionNotification!;
    // _muteEventSuggestionNotification =
    //     widget.userGeneralSettings.muteEventSuggestionNotification!;
    // _disableNewCreativeNotifications =
    //     widget.userGeneralSettings.disableNewCreativeNotifications;
    // _disableWorkVacancyNotifications =
    //     widget.userGeneralSettings.disableWorkVacancyNotifications;
    // _muteWorkVacancyNotifications =
    //     widget.userGeneralSettings.muteWorkVacancyNotifications;
  }

  _divider() {
    return Container(
      color: Colors.grey,
      height: 0.5,
    );
  }

  _settingCategoryColumn(Widget widget) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                right: 10.0, top: 10, bottom: 10, left: 30),
            child: widget,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
      title: 'Notification Settings',
      widget: Column(children: [
        const SizedBox(
          height: 20,
        ),
        _divider(),
        _settingCategoryColumn(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SettingSwitch(
                  title: 'Private account',
                  subTitle:
                      'Provides you with more control over who can see your content and engage with you on the app.',
                  value: _isShop,
                  onChanged: (value) => setState(() {
                        _isShop = value;
                        WriteBatch batch = FirebaseFirestore.instance.batch();
                        batch.update(
                          usersGeneralSettingsRef
                              .doc(widget.userGeneralSettings.userId),
                          {'isShop': _isShop},
                        );

                        batch.update(
                          usersAuthorRef.doc(widget.userGeneralSettings.userId),
                          {'isShop': _isShop},
                        );

                        try {
                          batch.commit();
                        } catch (error) {}
                      })),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                  title: 'Disable messaging',
                  subTitle:
                      'This prevents other users from sending you direct messages or initiating conversations with you.',
                  value: _disableChat,
                  onChanged: (value) => setState(() {
                        _disableChat = value;

                        WriteBatch batch = FirebaseFirestore.instance.batch();

                        batch.update(
                          usersGeneralSettingsRef
                              .doc(widget.userGeneralSettings.userId),
                          {'disableChat': _disableChat},
                        );

                        try {
                          batch.commit();
                        } catch (error) {
                          // Handle the error appropriately
                        }
                      })),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                title: 'Disable advicing',
                subTitle:
                    'This prevents other users from sending you insights aimed at inspiring and guiding your Salonic craft.',
                value: _disableAdvice,
                onChanged: (value) => setState(
                  () {
                    _disableAdvice = value;
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    batch.update(
                      usersGeneralSettingsRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'disableAdvice': _disableAdvice,
                      },
                    );

                    batch.update(
                      userProfessionalRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'disableAdvice': _disableAdvice,
                      },
                    );

                    try {
                      batch.commit();
                    } catch (error) {
                      // Handle the error appropriately
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                title: 'Hide advices',
                subTitle:
                    'When you disable chats, other users will not be able to initiate conversations with you.',
                value: _hideAdvice,
                onChanged: (value) => setState(
                  () {
                    _hideAdvice = value;

                    WriteBatch batch = FirebaseFirestore.instance.batch();

                    batch.update(
                      usersGeneralSettingsRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'hideAdvice': _hideAdvice,
                      },
                    );

                    batch.update(
                      userProfessionalRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'hideAdvice': _hideAdvice,
                      },
                    );

                    try {
                      batch.commit();
                    } catch (error) {
                      // Handle the error appropriately
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                title: 'Disable booking',
                subTitle:
                    'Restricts other users from booking appointments or services with you through the app.',
                value: _disableBooking,
                onChanged: (value) => setState(
                  () {
                    _disableBooking = value;
                    WriteBatch batch = FirebaseFirestore.instance.batch();

                    batch.update(
                      usersGeneralSettingsRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'disableBooking': _disableBooking,
                      },
                    );

                    batch.update(
                      userProfessionalRef
                          .doc(widget.userGeneralSettings.userId),
                      {
                        'noBooking': _disableBooking,
                      },
                    );
                    try {
                      batch.commit();
                    } catch (error) {
                      // Handle the error appropriately
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                title: 'Disable event suggestion notification',
                subTitle:
                    'Turn off suggestion notifications from events nearby.',
                value: _disableEventSuggestionNotification,
                onChanged: (value) => setState(
                  () {
                    _disableEventSuggestionNotification = value;

                    usersGeneralSettingsRef
                        .doc(
                      widget.userGeneralSettings.userId,
                    )
                        .update({
                      'disableEventSuggestionNotification':
                          _disableEventSuggestionNotification,
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                title: 'Mute event suggestion notifications',
                subTitle:
                    'Silence suggestion notifications from events nearby.',
                value: _muteEventSuggestionNotification,
                onChanged: (value) => setState(
                  () {
                    _muteEventSuggestionNotification = value;

                    usersGeneralSettingsRef
                        .doc(
                      widget.userGeneralSettings.userId,
                    )
                        .update({
                      'muteEventSuggestionNotification':
                          _muteEventSuggestionNotification,
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: _divider(),
              ),
              SettingSwitch(
                  title: 'Disable account',
                  subTitle:
                      'Your profile, events, and any associated information will no longer be visible to other users',
                  value: _disabledAccount,
                  onChanged: (value) => setState(() {
                        _disabledAccount = value;

                        WriteBatch batch = FirebaseFirestore.instance.batch();

                        batch.update(
                          usersGeneralSettingsRef
                              .doc(widget.userGeneralSettings.userId),
                          {'disabledAccount': _disabledAccount},
                        );

                        batch.update(
                          usersAuthorRef.doc(widget.userGeneralSettings.userId),
                          {'disabledAccount': _disabledAccount},
                        );

                        try {
                          batch.commit();
                        } catch (error) {}
                      })),
            ],
          ),
        ),
        _divider(),
        const SizedBox(
          height: 10,
        ),
      ]),
    );
  }
}
