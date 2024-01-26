import 'package:bars/utilities/exports.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:uuid/uuid.dart';

class CreateWork extends StatefulWidget {
  final String currentUserId;
  final UserProfessionalModel? userPortfolio;

  const CreateWork(
      {super.key, required this.currentUserId, required this.userPortfolio});

  @override
  State<CreateWork> createState() => _CreateWorkState();
}

class _CreateWorkState extends State<CreateWork> {
  final _textController = TextEditingController();
  bool _isLoading = true;
  final _priceFormKey = GlobalKey<FormState>();
  final _typeFormKey = GlobalKey<FormState>();
  final _locationFormKey = GlobalKey<FormState>();
  final _overViewFormKey = GlobalKey<FormState>();
  final _genreFormKey = GlobalKey<FormState>();
  final _overViewController = TextEditingController();
  final _addressSearchController = TextEditingController();
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);

  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  List<String> selectedTypes = [];
  UserProfessionalModel? _userPortfolio;

  @override
  void initState() {
    _textController.addListener(_onAskTextChanged);
    _overViewController.addListener(_onAskTextChanged);
    widget.userPortfolio == null ? _setUpPortfoilio() : _setWidgetPortfolio();
    _userPortfolio = widget.userPortfolio ?? _userPortfolio;

    super.initState();
  }

  @override
  void dispose() {
    _overViewController.dispose();
    _addressSearchController.dispose();
    _addressSearchfocusNode.dispose();
    _isTypingNotifier.dispose();
    _debouncer.cancel();
    // _pageController2.dispose();

    super.dispose();
  }

  _setWidgetPortfolio() {
    setState(() {
      _userPortfolio = widget.userPortfolio;
      _isLoading = false;
    });
  }

  _setUpPortfoilio() async {
    try {
      UserProfessionalModel? _user =
          await DatabaseService.getUserProfessionalWithId(
        widget.currentUserId,
      );

      if (_user != null) {
        setState(() {
          _userPortfolio = _user;
          _isLoading = false;
        });
      } else {}
    } catch (e) {
      _showBottomSheetErrorMessage2(e);
    } finally {
      _isLoading = false;
    }
  }

  void _showBottomSheetErrorMessage2(Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          title: 'Failed to load booking portfolio.',
          subTitle: result,
        );
      },
    );
  }

  void _onAskTextChanged() {
    if (_textController.text.isNotEmpty &&
        _overViewController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  static const values = <String>[
    "Parties",
    "Music_concerts",
    "Festivals",
    "Club_nights",
    "Pub_events",
    "Games/Sports",
    "Religious",
    "Business",
    "Others",
  ];
  Map<String, bool> checkboxes = {
    for (var value in values) value: false,
  };

  void _add(String from, GlobalKey<FormState> _formKey) {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.workRequesttype.cast();
    if (_formKey.currentState!.validate()) {
      switch (from.split(' ')[0]) {
        case 'types':
          _provider.setWorkRequestType(selectedTypes);
          Navigator.pop(context);
          break;
        case 'location':
          _provider.setWorkRequestAvailableLocations(_textController.text);
          break;
        case 'genre':
          _provider.setWorkRequestGenre(_textController.text);
          break;

        case 'price':
          _provider.setWorkRequestPrice(double.parse(_textController.text));
          break;

        default:
      }

      selectedTypes.clear();
      _textController.clear();
    }
  }

  _submit() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      var _provider = context.read<UserData>();
      Future<T> retry<T>(Future<T> Function() function,
          {int retries = 3}) async {
        for (int i = 0; i < retries; i++) {
          try {
            if (i > 0) {
              await Future.delayed(Duration(
                  seconds: i * 2)); // The delay increases with each retry
            }
            return await function();
          } catch (e) {
            // print('Attempt $i failed with error: $e, retrying...');
          }
        }
        throw Exception('Failed after $retries attempts');
      }
      // other parts remain the same...

      final timestamp = Timestamp.fromDate(DateTime.now());
      String commonId = Uuid().v4();

      final newUserWorkRequestRef = userWorkRequestRef
          .doc(widget.currentUserId)
          .collection('workRequests')
          .doc(commonId);

      final allNewWorkRequestRef = allWorkRequestRef.doc();

      final batch = FirebaseFirestore.instance.batch();

      batch.set(newUserWorkRequestRef, {
        'id': commonId,
        'userId': widget.currentUserId,
        'isEvent': true,
        'overView': _overViewController.text,
        'genre': _provider.workRequestGenre,
        'type': _provider.workRequesttype,
        'availableLocations': _provider.workRequestAvailableLocations,
        'price': _provider.workRequestPrice,
        'currency': widget.userPortfolio == null
            ? _provider.currency
            : widget.userPortfolio!.currency,
        'timestamp': timestamp,
      });

      batch.set(allNewWorkRequestRef, {
        'id': commonId,
        'userId': widget.currentUserId,
        'isEvent': true,
        'overView': _overViewController.text,
        'genre': _provider.workRequestGenre,
        'type': _provider.workRequesttype,
        'availableLocations': _provider.workRequestAvailableLocations,
        'price': _provider.workRequestPrice,
        'currency': widget.userPortfolio == null
            ? _provider.currency
            : widget.userPortfolio!.currency,
        'timestamp': timestamp,
      });

      try {
        await retry(() => Future.delayed(Duration(seconds: 1), batch.commit));
        Navigator.pop(context);
        mySnackBar(context, "created succesfully");
        _clearCreateWork();
      } catch (e) {
        _showBottomSheetErrorMessage('', e);
      } finally {
        _isLoading = false;
      }
    }
  }

  void _showBottomSheetErrorMessage(String from, Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
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
          title: error.isEmpty
              ? 'You can add up to four $from'
              : '\n$result.toString(),',
          subTitle: '',
        );
      },
    );
  }

  _clearCreateWork() {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.workRequestAvailableLocations.clear();
    _provider.workRequestGenre.clear();
    _provider.workRequesttype.clear();
    _provider.setWorkRequestPrice(0.0);
    _provider.setWorkRequestoverView('');
    _provider.setCurrency('');

    _provider.setWorkRequestisEvent(false);
  }

  void _showCurrencyPicker() {
    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        backgroundColor: Theme.of(context).primaryColor,
        flagSize: 25,
        titleTextStyle: TextStyle(
          fontSize: ResponsiveHelper.responsiveFontSize(context, 17.0),
        ),
        subtitleTextStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 15.0),
            color: Colors.blue),
        bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
      ),
      context: context,
      showFlag: true,
      showSearchField: true,
      showCurrencyName: true,
      showCurrencyCode: true,
      onSelect: (Currency currency) {
        Provider.of<UserData>(context, listen: false)
            .setCurrency('${currency.name} | ${currency.code}');
      },
      favorite: ['USD'],
    );
  }

  _textField(
    String labelText,
    String hintText,
    bool autofocus,
    final TextEditingController controller,
    Function(String) onChanged,
    bool isNumber,
  ) {
    return TextFormField(
        controller: controller,
        style: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
            color: Theme.of(context).secondaryHeaderColor,
            fontWeight: FontWeight.normal),
        keyboardType: isNumber
            ? TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        maxLines: null,
        autofocus: autofocus,
        keyboardAppearance: MediaQuery.of(context).platformBrightness,
        textCapitalization: TextCapitalization.sentences,
        onChanged: onChanged,
        validator: isNumber
            ? (value) {
                String pattern = r'^\d+(\.\d{1,2})?$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value!))
                  return 'Enter a valid price';
                else
                  return null;
              }
            : (input) =>
                input!.trim().length < 1 ? 'This field cannot be empty' : null,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 3.0),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.grey),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
            color: Colors.grey,
          ),
        ));
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _addressSearchController.clear());
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  void _showBottomVenue() {
    var _provider = Provider.of<UserData>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: ResponsiveHelper.responsiveHeight(context, 750),
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
                      showCancelButton: true,
                      cancelSearch: _cancelSearch,
                      controller: _addressSearchController,
                      focusNode: _addressSearchfocusNode,
                      hintText: 'Type to search...',
                      onClearText: () {
                        _clearSearch();
                      },
                      onTap: () {},
                      onChanged: (value) {
                        _debouncer.run(() {
                          _provider.searchPlaces(value);
                        });
                      }),
                ),
                Text(
                  '        Select your address from the list below',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
                if (Provider.of<UserData>(
                      context,
                    ).addressSearchResults !=
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
                                        onTap: () {
                                          Navigator.pop(context);
                                          _provider.setCity('');
                                          _provider.setCountry('');
                                          _provider
                                              .setWorkRequestAvailableLocations(
                                                  _provider
                                                      .searchResults![index]
                                                      .description);
                                          // _provider.setAddress(_provider
                                          //     .addressSearchResults![index]
                                          //     .description);
                                        }),
                                    Divider(),
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
      },
    );
  }

  void _showBottomSheetWorkRequest(
    String type,
    bool main,
  ) {
    TextEditingController _controller;
    GlobalKey<FormState> _formkey;
    switch (type.split(' ')[0]) {
      case 'types':
        _controller = _textController;
        _formkey = _typeFormKey;

        break;
      case 'location':
        _controller = _textController;
        _formkey = _locationFormKey;
        break;

      case 'genre':
        _controller = _textController;
        _formkey = _genreFormKey;
        break;

      case 'currency':
        _controller = _textController;
        _formkey = _genreFormKey;
        break;

      case 'price':
        _controller = _textController;
        _formkey = _priceFormKey;

        break;

      case 'overview':
        _controller = _overViewController;
        _formkey = _overViewFormKey;

        break;

      default:
        _controller = _overViewController;
        _formkey = _overViewFormKey;
    }

    double height = MediaQuery.of(context).size.height.toDouble();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return ValueListenableBuilder(
              valueListenable: _isTypingNotifier,
              builder: (BuildContext context, bool isTyping, Widget? child) {
                var _provider = Provider.of<UserData>(context);

                bool _isFilled = _overViewController.text.isNotEmpty &&
                    _provider.workRequesttype.isNotEmpty &&
                    _provider.workRequestGenre.isNotEmpty &&
                    _provider.currency.isNotEmpty &&
                    _provider.workRequestPrice != 0.0 &&
                    _provider.workRequestAvailableLocations.isNotEmpty;

                Widget _widgetStringListTypes =
                    StringListWidget(stringValues: _provider.workRequesttype);
                Widget _widgetStringListGenre =
                    StringListWidget(stringValues: _provider.workRequestGenre);
                Widget _widgetStringListLocations = StringListWidget(
                    stringValues: _provider.workRequestAvailableLocations);
                Widget _widgetStringListCurrency = Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _provider.currency.toString(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
                Widget _widgetStringListPrice = Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _provider.workRequestPrice.toString(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );

                Widget buildCheckboxes() {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.grey,
                    ),
                    child: Column(
                      children: checkboxes.entries.map((entry) {
                        final color = entry.value ? Colors.blue : Colors.grey;

                        return CheckboxListTile(
                          title: Text(
                            entry.key,
                            style: TextStyle(
                              color: color,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                            ),
                          ),
                          value: entry.value,
                          activeColor: Colors.blue,
                          onChanged: (bool? newValue) {
                            if (mounted) {
                              setState(() {
                                checkboxes[entry.key] = newValue!;
                              });
                            }
                            if (newValue == true) {
                              if (!selectedTypes.contains(entry.key)) {
                                selectedTypes.add(entry.key);
                              }
                            } else {
                              selectedTypes.remove(entry.key);
                              _provider.workRequesttype.remove(entry.key);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Form(
                    key: _formkey,
                    child: Container(
                      height: main ? height / 1.2 : height / 1.2 - 20,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView(
                          children: [
                            // if (main)
                            ListTile(
                              leading: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: ResponsiveHelper.responsiveHeight(
                                      context, 25),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                              trailing: !main
                                  ? _controller.text.isNotEmpty ||
                                          selectedTypes.isNotEmpty
                                      ? MiniCircularProgressButton(
                                          onPressed: () {
                                            _add(type, _formkey);
                                          },
                                          text: "Add",
                                          color: Colors.blue,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Done',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                  : _isFilled
                                      ? MiniCircularProgressButton(
                                          onPressed: _submit,
                                          text: 'Create request',
                                          color: Colors.blue,
                                        )
                                      : null,
                            ),

                            type.startsWith('types')
                                ? buildCheckboxes()
                                : type.startsWith('location')
                                    ? _textField(
                                        'location',
                                        'location',
                                        true,
                                        _textController,
                                        (value) {
                                          if (mounted) {
                                            setState(() {});
                                          }
                                        },
                                        false,
                                      )
                                    : type.startsWith('genre')
                                        ? _textField(
                                            'genre',
                                            'genre',
                                            true,
                                            _textController,
                                            (value) {
                                              if (mounted) {
                                                setState(() {});
                                              }
                                            },
                                            false,
                                          )
                                        : type.startsWith('currency')
                                            ? _textField(
                                                'currency',
                                                'currency',
                                                true,
                                                _textController,
                                                (value) {
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                },
                                                false,
                                              )
                                            : type.startsWith('price')
                                                ? _textField(
                                                    'price',
                                                    'price',
                                                    true,
                                                    _textController,
                                                    (value) {
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    true,
                                                  )
                                                : _textField(
                                                    'Overview',
                                                    'Overview',
                                                    false,
                                                    _overViewController,
                                                    (value) {
                                                      if (mounted) {
                                                        setState(() {});
                                                      }
                                                    },
                                                    false,
                                                  ),

                            const SizedBox(
                              height: 30,
                            ),
                            if (main)
                              Column(
                                children: [
                                  PickOptionWidget(
                                      title: 'types',
                                      onPressed: () {
                                        _showBottomSheetWorkRequest(
                                          'types',
                                          false,
                                        );
                                      },
                                      dropDown: true),
                                  _widgetStringListTypes,
                                  PickOptionWidget(
                                      title: 'genre',
                                      onPressed: () {
                                        _showBottomSheetWorkRequest(
                                          'genre',
                                          false,
                                        );
                                      },
                                      dropDown: true),
                                  _widgetStringListGenre,
                                  PickOptionWidget(
                                      title: 'location',
                                      onPressed: () {
                                        _showBottomSheetWorkRequest(
                                          'location',
                                          false,
                                        );
                                      },
                                      dropDown: true),
                                  _widgetStringListLocations,
                                  PickOptionWidget(
                                      title: 'currency',
                                      onPressed: () {
                                        _showCurrencyPicker();
                                      },
                                      dropDown: true),
                                  _widgetStringListCurrency,
                                  PickOptionWidget(
                                      title: 'price',
                                      onPressed: () {
                                        _showBottomSheetWorkRequest(
                                          'price',
                                          false,
                                        );
                                      },
                                      dropDown: true),
                                  _widgetStringListPrice,
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),

                            // Text(
                            //   "Each creatives discography exhibit the neccesssary information to connect and collaborate with that creatives. This information provided are freely given out by this user to the creative world of Bars Impression. Creatives are grouped based on their skilss and expertise as provided by them and you can browse throguth creatives by tapping on the floating action button to go to the next creative of simmilar expertise or you can scroll left or right horizontally to change the expertise category you are browsing creatives in. ",
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
      },
    );
  }

  _noPortfolio() {
    return Container(
      height: ResponsiveHelper.screenWidth(context),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          NoContents(
              title: 'No Portfolio',
              subTitle:
                  'Set up your portfolio to easily connect with other creatives and event organizers for business purposes. Your portfolio displays your skills, collaborations, and other necessary information to attract business opportunities.',
              icon: Icons.work_off_outlined),
          SizedBox(
            height: ResponsiveHelper.responsiveHeight(context, 30),
          ),
          BlueOutlineButton(
            buttonText: 'Set up portfolio',
            onPressed: () {
              Navigator.pop(context);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => EditProfileProfessional(
                            user: _userPortfolio!,
                          )));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);

    bool _isFilled = _overViewController.text.isNotEmpty &&
        _provider.workRequesttype.isNotEmpty &&
        _provider.workRequestGenre.isNotEmpty &&
        _provider.currency.isNotEmpty &&
        _provider.workRequestPrice != 0.0 &&
        _provider.workRequestAvailableLocations.isNotEmpty;

    Widget _widgetStringListTypes =
        StringListWidget(stringValues: _provider.workRequesttype);
    Widget _widgetStringListGenre =
        StringListWidget(stringValues: _provider.workRequestGenre);
    Widget _widgetStringListLocations =
        StringListWidget(stringValues: _provider.workRequestAvailableLocations);
    Widget _widgetStringListCurrency = Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _provider.currency.toString(),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
    Widget _widgetStringListPrice = Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _provider.workRequestPrice.toString(),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );

    return EditProfileScaffold(
      title: 'Create Work request',
      widget: _isLoading
          ? Center(
              child: LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              minHeight: 2,
            ))
          : _userPortfolio != null
              ? Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _userPortfolio!.profileImageUrl.isEmpty ||
                          _userPortfolio!.skills.isEmpty
                      ? _noPortfolio()
                      : Column(
                          children: [
                            _isFilled
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 30.0),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: MiniCircularProgressButton(
                                        onPressed: _submit,
                                        text: 'Create',
                                        color: Colors.blue,
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),
                            _textField(
                              'Overview',
                              'Overview',
                              false,
                              _overViewController,
                              (value) {
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              false,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            PickOptionWidget(
                                title: 'types',
                                onPressed: () {
                                  _showBottomSheetWorkRequest(
                                    'types',
                                    false,
                                  );
                                },
                                dropDown: true),
                            _widgetStringListTypes,
                            PickOptionWidget(
                                title: 'genre',
                                onPressed: () {
                                  _showBottomSheetWorkRequest(
                                    'genre',
                                    false,
                                  );
                                },
                                dropDown: true),
                            _widgetStringListGenre,
                            PickOptionWidget(
                                title: 'location',
                                onPressed: () {
                                  _showBottomVenue();
                                },
                                dropDown: true),
                            _widgetStringListLocations,
                            if (widget.userPortfolio == null)
                              PickOptionWidget(
                                  title: 'currency',
                                  onPressed: () {
                                    _showCurrencyPicker();
                                  },
                                  dropDown: true),
                            if (widget.userPortfolio == null)
                              _widgetStringListCurrency,
                            PickOptionWidget(
                                title: 'price',
                                onPressed: () {
                                  _showBottomSheetWorkRequest(
                                    'price',
                                    false,
                                  );
                                },
                                dropDown: true),
                            _widgetStringListPrice,
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              "A work request is a formal communication initiated by a creative professional, indicating their availability to provide services based on the specific requirements and information they provide.  \n\n The submitted work request will be showcased on the event discovery page. The selected types will determine the primary categories in which the request will be displayed. Additionally, the request will appear in the chosen locations.. ",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                )
              : SizedBox.shrink(),
    );
  }
}
