import 'package:bars/utilities/exports.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';

class EditProfileSelectLocation extends StatefulWidget {
  final AccountHolder user;

  EditProfileSelectLocation({
    required this.user,
  });

  @override
  _EditProfileSelectLocationState createState() =>
      _EditProfileSelectLocationState();
}

class _EditProfileSelectLocationState extends State<EditProfileSelectLocation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
  int _index = 0;
  String? _city = '';
  String _country = '';
  String _continent = '';
  String selectedValue = '';
  late double userLatitude;
  late double userLongitude;
  bool _isLoading = false;
  bool _isfetchingCity = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.user.continent!;
    _pageController = PageController(
      initialPage: 1,
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserData>(context, listen: false).setPost4(widget.user.city!);
    });
    _country = widget.user.country!;
    _continent = widget.user.continent!;
  }

  _getCurrentLocation() async {}

  animateToPage() {
    _pageController.animateToPage(
      _index = 0,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToPage2() {
    _pageController.animateToPage(
      _index = 2,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  animateToBack() {
    _pageController.animateToPage(
      _index = 1,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  _submit2() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _city = Provider.of<UserData>(context, listen: false)
          .post4
          // ignore: unnecessary_brace_in_string_interps
          ?.replaceAll(', ${_country}', '');
      _getCurrentLocation();
      try {
        usersRef
            .doc(
          widget.user.id,
        )
            .update({
          'country': _country,
          'city': _city,
        });
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            e.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.error_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }
  }

  _submit1() async {
    if (_formKey.currentState!.validate() & !_isLoading) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      _getCurrentLocation();
      try {
        usersRef
            .doc(
          widget.user.id,
        )
            .update({
          'continent': _continent,
        });
      } catch (e) {
        final double width = Responsive.isDesktop(context)
            ? 600.0
            : MediaQuery.of(context).size.width;
        String error = e.toString();
        String result = error.contains(']')
            ? error.substring(error.lastIndexOf(']') + 1)
            : error;
        Flushbar(
          margin: EdgeInsets.all(8),
          boxShadows: [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            )
          ],
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          titleText: Text(
            'Error',
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 22 : 14,
            ),
          ),
          messageText: Text(
            result.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: width > 800 ? 20 : 12,
            ),
          ),
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue,
          ),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Colors.blue,
        )..show(context);
      }
    }
    setState(() {
      _isLoading = false;
    });
    animateToBack();
  }

  _reverseGeocoding() async {
    setState(() {
      _isLoading = true;
    });
    List<Location> locations = await locationFromAddress(
        Provider.of<UserData>(context, listen: false).post4!);
    List<Placemark> placemarks = await placemarkFromCoordinates(
        locations[0].latitude, locations[0].longitude);
    placemarks[0].toString();
    setState(() {
      _index = 0;
      _country = (placemarks[0].country == null ? '' : placemarks[0].country)!;
    });

    await _submit2();
    setState(() {
      _isLoading = false;
    });
    animateToBack();
  }

  static const values = <String>[
    'Africa',
    'Antarctica',
    'Asia',
    'Europe	',
    'North America',
    'South America',
    'Australia',
  ];

  Widget buildRadios() => Theme(
        data: Theme.of(context).copyWith(
          unselectedWidgetColor:
              ConfigBloc().darkModeOn ? Colors.white : Colors.black,
        ),
        child: Column(
            children: values.map((value) {
          final selected = this.selectedValue == value;
          final color = selected
              ? Colors.blue
              : ConfigBloc().darkModeOn
                  ? Colors.white
                  : Colors.black;

          return RadioListTile<String>(
            value: value,
            groupValue: selectedValue,
            title: Text(
              value,
              style: TextStyle(
                color: color,
              ),
            ),
            activeColor: Colors.blue,
            onChanged: (value) => setState(
              () {
                _continent = this.selectedValue = value!;
                _submit1();
              },
            ),
          );
        }).toList()),
      );

  Widget buildContinentPicker() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildRadios(),
        ],
      );

  Widget buildCityForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              Provider.of<UserData>(context, listen: false).post4!,
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _isfetchingCity ? SizedBox(height: 10) : SizedBox(height: 40),
          Padding(
            padding:
                const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autovalidateMode: AutovalidateMode.always,
              onChanged: (value) => {
                Provider.of<UserData>(context, listen: false)
                    .searchPlaces(value),
                setState(() {
                  _isfetchingCity = true;
                })
              },
              style: TextStyle(
                fontSize: 16,
                color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              ),
              initialValue: widget.user.city,
              decoration: InputDecoration(
                  hintText: "Your current city",
                  hintStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                  labelText: 'City',
                  labelStyle: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey))),
              validator: (input) =>
                  input!.trim().length < 1 ? 'Choose city of residence' : null,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _isfetchingCity
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: SizedBox(
                    height: 2.0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(Colors.grey),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          // ignore: unnecessary_null_comparison
          if (Provider.of<UserData>(context, listen: false).searchResults !=
              null)
            Container(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Tap below to select your city',
                    style: TextStyle(
                      color:
                          ConfigBloc().darkModeOn ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(
            height: 10,
          ),
          // ignore: unnecessary_null_comparison
          if (Provider.of<UserData>(context).searchResults != null)
            SingleChildScrollView(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    itemCount:
                        Provider.of<UserData>(context).searchResults!.length,
                    itemBuilder: (context, _index) {
                      return ListTile(
                          title: Text(
                            Provider.of<UserData>(context, listen: false)
                                .searchResults![_index]
                                .description,
                            style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _isfetchingCity = false;
                            });
                            Provider.of<UserData>(context, listen: false)
                                .setPost4(Provider.of<UserData>(context,
                                        listen: false)
                                    .searchResults![_index]
                                    .description);
                            _reverseGeocoding();
                          });
                    },
                  ),
                ),
              ),
            ),
        ],
      );

  _pop() {
    Navigator.pop(context);
    Provider.of<UserData>(context, listen: false).searchResults = [];
    Provider.of<UserData>(context, listen: false).setPost4('');
  }

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            ),
            automaticallyImplyLeading: true,
            leading: IconButton(
                icon: Icon(
                    Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                onPressed: () {
                  _index == 1 ? _pop() : animateToBack();
                }),
            elevation: 0,
            backgroundColor:
                ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
            title: Text(
              'Edit Profile',
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
              child: Form(
                  key: _formKey,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int _index) {
                      setState(() {
                        _index = _index;
                      });
                    },
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _isLoading
                                    ? SizedBox(
                                        height: 2.0,
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.blue),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                _isfetchingCity
                                    ? const SizedBox.shrink()
                                    : SizedBox(height: 20.0),
                                _isfetchingCity
                                    ? const SizedBox.shrink()
                                    : Text(
                                        'Enter your city in the field below. Tap on your correct city in the list below. ',
                                        style: TextStyle(
                                          color: ConfigBloc().darkModeOn
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                _isfetchingCity
                                    ? const SizedBox.shrink()
                                    : SizedBox(
                                        height: 20.0,
                                      ),
                                _isfetchingCity
                                    ? const SizedBox.shrink()
                                    : Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          height: 2,
                                          color: Colors.blue,
                                          width: width / 3,
                                        ),
                                      ),
                                _isfetchingCity
                                    ? const SizedBox.shrink()
                                    : SizedBox(height: 50),
                                buildCityForm()
                              ],
                            )),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            _isLoading
                                ? SizedBox(
                                    height: 2.0,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey[100],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 10.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20.0),
                                    EditProfileInfo(
                                      editTitle: 'Choose \nLocation',
                                      info:
                                          'Choosing a location helps us suggest users with similar interests living close to you. For instance, when you enter your city, we propose other users in your city for you on the discover page so you can connect with them for business.',
                                      icon: Icons.location_on,
                                    ),
                                    Text(
                                      Provider.of<UserData>(context,
                                              listen: false)
                                          .post4!,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () {
                                        animateToPage();
                                      },
                                      child: Text(
                                        'Choose your City',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Provider.of<UserData>(context,
                                                listen: false)
                                            .post4!
                                            .isEmpty
                                        ? const SizedBox.shrink()
                                        : SizedBox(height: 30),
                                    Divider(color: Colors.grey),
                                    Provider.of<UserData>(context,
                                                listen: false)
                                            .post4!
                                            .isEmpty
                                        ? const SizedBox.shrink()
                                        : SizedBox(height: 30),
                                    Text(
                                      _continent,
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: ConfigBloc().darkModeOn
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    GestureDetector(
                                      onTap: () {
                                        animateToPage2();
                                      },
                                      child: Text(
                                        'Choose your Continent',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 50),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70.0,
                            ),
                            _isLoading
                                ? SizedBox(
                                    height: 2.0,
                                    child: LinearProgressIndicator(
                                      backgroundColor: Colors.grey[100],
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.blue),
                                    ),
                                  )
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.0),
                              Text(
                                'Select your continent in the list below.',
                                style: TextStyle(
                                  color: ConfigBloc().darkModeOn
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  height: 2,
                                  color: Colors.blue,
                                  width: width / 3,
                                ),
                              ),
                              SizedBox(height: 50),
                              buildContinentPicker(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          )),
    );
  }
}
