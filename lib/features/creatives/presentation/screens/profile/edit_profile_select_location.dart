import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';

class EditProfileSelectLocation extends StatefulWidget {
  final UserSettingsLoadingPreferenceModel user;
  final bool notFromEditProfile;

  EditProfileSelectLocation({
    required this.user,
    this.notFromEditProfile = false,
  });

  @override
  _EditProfileSelectLocationState createState() =>
      _EditProfileSelectLocationState();
}

class _EditProfileSelectLocationState extends State<EditProfileSelectLocation> {
  String _continent = '';
  String selectedValue = '';
  late double userLatitude;
  late double userLongitude;
  final _addressSearchController = TextEditingController();
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    selectedValue = widget.user.continent!;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false)
          .setAddress(widget.user.city!);

      _continent = Provider.of<UserData>(context, listen: false)
          .userLocationPreference!
          .continent!;
    });
  }

  _submit2() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    // try {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersLocationSettingsRef.doc(widget.user.userId),
      {
        'country': _provider.country,
        'city': _provider.city,
      },
    );
    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {
        'country': _provider.country,
        'city': _provider.city,
      },
    );

    try {
      batch.commit();
      _provider.setIsLoading(false);
      _updateAuthorHive(
          _provider.city, _provider.country, _provider.continent, false);
    } catch (error) {
      _provider.setIsLoading(false);
      _showBottomSheetErrorMessage('Failed to update city and country');
    }
    setState(() {});
    // } catch (e) {
    // }
  }

  _updateAuthorHive(
      String city, String country, String continent, bool isContinent) async {
    Box<UserSettingsLoadingPreferenceModel> locationPreferenceBox;

    if (Hive.isBoxOpen('accountLocationPreference')) {
      locationPreferenceBox = Hive.box('accountLocationPreference');
    } else {
      locationPreferenceBox = await Hive.openBox('accountLocationPreference');
    }

    var _provider = Provider.of<UserData>(context, listen: false);

    // Create a new instance of UserSettingsLoadingPreferenceModel with the updated values
    var updatedLocationPreference = UserSettingsLoadingPreferenceModel(
      userId: _provider.userLocationPreference!.userId,
      city: isContinent ? _provider.userLocationPreference!.city : city,
      continent:
          isContinent ? continent : _provider.userLocationPreference!.continent,
      country:
          isContinent ? _provider.userLocationPreference!.country : country,
      currency: _provider.userLocationPreference!.currency,
      timestamp: _provider.userLocationPreference!.timestamp,
      subaccountId: _provider.userLocationPreference!.subaccountId,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId,
    );

    // Put the new object back into the box with the same key
    locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
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
          title: errorTitle,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _submit1() {
    var _provider = Provider.of<UserData>(context, listen: false);
    // try {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    batch.update(
      usersLocationSettingsRef.doc(widget.user.userId),
      {'continent': _continent},
    );
    batch.update(
      userProfessionalRef.doc(widget.user.userId),
      {'continent': _continent},
    );

    try {
      batch.commit();
      _updateAuthorHive(_provider.city, _provider.country, _continent, true);
    } catch (error) {
      _showBottomSheetErrorMessage(error.toString());
    }
    // } catch (e) {

    // }
  }

  static const values = <String>[
    'Africa',
    'Antarctica',
    'Asia',
    'Australia',
    'Europe	',
    'North America',
    'South America',
  ];

  Widget buildRadios() => Column(
          children: values.map((value) {
        final selected = this.selectedValue == value;
        final color =
            selected ? Colors.blue : Theme.of(context).secondaryHeaderColor;

        return RadioTheme(
          data: RadioThemeData(
              fillColor: MaterialStateProperty.all(
                  Theme.of(context).secondaryHeaderColor)),
          child: RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: this.selectedValue == value
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _continent = this.selectedValue = value!;
                _submit1();
              },
            ),
          ),
        );
      }).toList());

  Widget buildContinentPicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildRadios(),
        ],
      );

  @override
  void dispose() {
    _addressSearchController.dispose();
    _addressSearchfocusNode.dispose();
    _debouncer.cancel();

    super.dispose();
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _addressSearchController.clear());
    Provider.of<UserData>(context, listen: false).searchResults = [];
  }

  _addressValue(String name, String value) {
    return GestureDetector(
      onTap: () {
        _showBottomSheetCountry(context, 'userName');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
              color: Theme.of(context).secondaryHeaderColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _addressValueProcessing() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '...',
          style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: ResponsiveHelper.responsiveHeight(context, 10.0),
          width: ResponsiveHelper.responsiveHeight(context, 10.0),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  void _showBottomSheetCountry(BuildContext context, String from) {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              height: MediaQuery.of(context).size.height.toDouble() / 1.1,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(30)),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SearchContentField(
                        autoFocus: true,
                        showCancelButton: true,
                        cancelSearch: _cancelSearch,
                        controller: _addressSearchController,
                        focusNode: _addressSearchfocusNode,
                        hintText: 'Enter city name...',
                        onClearText: () {
                          _clearSearch();
                        },
                        onTap: () {},
                        onChanged: (value) async {
                          if (_addressSearchController.text.trim().isNotEmpty)
                            await _debouncer.run(() {
                              _provider.searchPlaces(value);
                            });
                        }),
                  ),
                  Text('        Select your city from the list below'),
                  if (Provider.of<UserData>(
                        context,
                      ).searchResults !=
                      null)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: _provider.searchResults!.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                          title: Text(
                                            _provider.searchResults![index]
                                                .description,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          onTap: () async {
                                            Navigator.pop(context);
                                            _provider.setCity('');
                                            _provider.setCountry('');
                                            _provider.searchPlaces(_provider
                                                .searchResults![index]
                                                .description);
                                            _provider.setIsLoading(true);
                                            await reverseGeocoding(
                                                _provider,
                                                _provider.searchResults![index]
                                                    .description);
                                            _submit2();
                                            // _provider.setIsLoading(false);
                                          }),
                                      Divider(
                                        thickness: .2,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _provider2 = Provider.of<UserData>(
      context,
    );

    return EditProfileScaffold(
      title: '',
      widget: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.notFromEditProfile)
                    if (_provider.country.isNotEmpty &&
                        _provider.city.isNotEmpty &&
                        _continent.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: MiniCircularProgressButton(
                          color: Colors.blue,
                          onPressed: () {
                            Navigator.pop(context);
                            mySnackBar(context,
                                'You can now continue with your process');
                            //  _submitCreate();
                          },
                          text: 'Done',
                        ),
                      ),
                  const SizedBox(height: 20.0),
                  EditProfileInfo(
                    editTitle: _provider.userLocationPreference!.continent!,

                    //  'Choose \nLocation',
                    info:
                        'By selecting a location, we can offer personalized recommendations based on your interests and proximity. When you enter your city, we can suggest local events taking place in that area, as well as connect you with other users who are also based in the same location. This facilitates meaningful connections and creates opportunities for potential business collaborations and networking.',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  _provider2.isLoading
                      ? _addressValueProcessing()
                      : _addressValue(
                          'City',
                          _provider2.city.isEmpty
                              ? widget.user.city!
                              : _provider.city),
                  _provider.isLoading
                      ? _addressValueProcessing()
                      : _addressValue(
                          'Country',
                          _provider.country.isEmpty
                              ? widget.user.country!
                              : _provider.country),
                  _addressValue('Continent',
                      _continent.isEmpty ? widget.user.continent! : _continent),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'City',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 8.8,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        padding:
                            const EdgeInsets.only(left: 10, top: 3, bottom: 3),
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor.withOpacity(.6),
                            borderRadius: BorderRadius.circular(5)),
                        child: DummyTextField(
                          icon: Icons.edit_outlined,
                          onPressed: () {
                            _showBottomSheetCountry(context, 'userName');
                          },
                          text: _provider.city.isEmpty
                              ? widget.user.city!.isEmpty
                                  ? 'Enter  your city here...'
                                  : widget.user.city!
                              : _provider.city,
                        ),
                      ),
                    ],  
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  buildContinentPicker(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 70.0,
          ),
          if (_provider.isLoading) LinearProgress(),
        ],
      ),
    );
  }
}
