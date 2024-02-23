import 'package:bars/utilities/exports.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class DiscographyWidget extends StatefulWidget {
  final String currentUserId;
  // final UserProfessionalModel user;
  final int userIndex;

  final UserProfessionalModel userPortfolio;
//  final  List<WorkRequestOrOfferModel> userWorkRequest;

  const DiscographyWidget({
    super.key,
    required this.currentUserId,
    // required this.user,
    required this.userIndex,
    required this.userPortfolio,
    // required this.userWorkRequest,
  });

  @override
  State<DiscographyWidget> createState() => _DiscographyWidgetState();
}

class _DiscographyWidgetState extends State<DiscographyWidget> {
  bool _isLoading = false;
  List<WorkRequestOrOfferModel> _userWorkRequest = [];
  List<String> selectedTypes = [];

  bool _isBlockedUser = false;
  bool _isBlockingUser = false;

  double page = 0.0;
  int limit = 2;

  int hours = 0;
  int minutes = 0;

  String selectedValue = '';

  final _textController = TextEditingController();

  final _overViewController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  // late Timer _timer;

//   Duration duration = Duration(hours: 2, minutes: 30);
// int totalMinutes = duration.inMinutes;

// int totalMinutes = 150;
// Duration duration = Duration(minutes: totalMinutes);

  // List<Page> map<Page>(List list, Function handler) {
  //   List<Page> result = [];
  //   for (var i = 0; i < list.length; i++) {
  //     result.add(handler(i, list[i]));
  //   }
  //   return result;
  // }

  PageController _pageController2 = PageController(
    initialPage: 0,
  );
  int _index = 0;

  // bool _noPrefessionalImage = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onAskTextChanged);
    _overViewController.addListener(_onAskTextChanged);
    // _noPrefessionalImage = widget.userPortfolio.professionalImageUrls.isEmpty;

    _setupIsBlockedUser();
    _setupIsBlocking();
    // _pageController2 = PageController(
    //   initialPage: 0,
    // );
    _setupWorkRequest();
    var _provider = Provider.of<UserData>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clear(_provider);
      _addLists(_provider);
    });
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_index < 2) {
        _index++;
        if (_pageController2.hasClients) {
          _pageController2.animateToPage(
            _index,
            duration: Duration(milliseconds: 2000),
            curve: Curves.easeInOut,
          );
        }
      } else {
        _index = 0;
        if (_pageController2.hasClients) {
          _pageController2.jumpToPage(
            _index,
          );
        }
      }
    });
  }

  _clear(UserData provider) {
    if (mounted) {
      provider.setOverview('');
      provider.setTermsAndConditions('');
      provider.awards.clear();
      provider.priceRate.clear();
      provider.company.clear();
      provider.bookingContacts.clear();
      provider.linksToWork.clear();
      provider.performances.clear();
      provider.skills.clear();
      provider.genreTages.clear();
      provider.collaborations.clear();
      provider.professionalImages.clear();
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userPortfolio.id,
    );
    if (mounted) {
      setState(() {
        _isBlockedUser = isBlockedUser;
      });
    }
  }

  _setupIsBlocking() async {
    bool isBlockingUser = await DatabaseService.isBlokingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userPortfolio.id,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  _addLists(UserData provider) {
    // var _provider = Provider.of<UserData>(context, listen: false);

    provider.setOverview(widget.userPortfolio.overview);
    provider.setTermsAndConditions(widget.userPortfolio.terms);
    provider.setNoBooking(widget.userPortfolio.noBooking);
    provider.setCurrency(widget.userPortfolio.currency);

    // Add user awards
    List<PortfolioModel> awards = widget.userPortfolio.awards;
    awards.forEach((award) => provider.setAwards(award));

    // Add userPortfolio companies
    List<PortfolioCompanyModel> companies = widget.userPortfolio.company;
    companies.forEach((company) => provider.setCompanies(company));

    // Add userPortfolio contact
    List<PortfolioContactModel> contacts = widget.userPortfolio.contacts;
    contacts.forEach((contact) => provider.setBookingContacts(contact));

    // Add links to work
    List<PortfolioModel> links = widget.userPortfolio.links;
    links.forEach((link) => provider.setLinksToWork(link));

    // Add performance
    List<PortfolioModel> performances = widget.userPortfolio.performances;
    performances
        .forEach((performance) => provider.setPerformances(performance));

    // Add skills
    List<PortfolioModel> skills = widget.userPortfolio.skills;
    skills.forEach((skill) => provider.setSkills(skill));

    // Add genre tags
    List<PortfolioModel> genreTags = widget.userPortfolio.genreTags;
    genreTags.forEach((genre) => provider.setGenereTags(genre));

    // Add collaborations
    List<PortfolioCollaborationModel> collaborations =
        widget.userPortfolio.collaborations;
    collaborations
        .forEach((collaboration) => provider.setCollaborations(collaboration));
    // Add price
    List<PriceModel> priceTags = widget.userPortfolio.priceTags;
    priceTags.forEach((priceTags) => provider.setPriceRate(priceTags));

    // Add professional image urls
    List<String> imageUrls = widget.userPortfolio.professionalImageUrls;
    provider.setProfessionalImages(imageUrls);
  }

  void _onAskTextChanged() {
    if (_textController.text.isNotEmpty &&
        _overViewController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _setupWorkRequest() async {
    QuerySnapshot postFeedSnapShot = await userWorkRequestRef
        .doc(widget.userPortfolio.id)
        .collection('workRequests')
        .orderBy('timestamp', descending: true)
        // .limit(4)
        .get();
    List<WorkRequestOrOfferModel> posts = postFeedSnapShot.docs
        .map((doc) => WorkRequestOrOfferModel.fromDoc(doc))
        .toList();
    // _postSnapshot.addAll((postFeedSnapShot.docs));
    if (mounted) {
      setState(() {
        // _hasNext = false;
        _userWorkRequest = posts;
      });
    }
  }

  // void _onAskTextChanged2() {
  //   if (_overViewController.text.isNotEmpty) {
  //     _isTypingNotifier.value = true;
  //   } else {
  //     _isTypingNotifier.value = false;
  //   }
  // }

  // void _showCurrencyPicker() {
  //   showCurrencyPicker(
  //     theme: CurrencyPickerThemeData(
  //       backgroundColor: Theme.of(context).primaryColor,
  //       flagSize: 25,
  //       titleTextStyle: TextStyle(
  //         fontSize: ResponsiveHelper.responsiveFontSize(context, 17.0),
  //       ),
  //       subtitleTextStyle: TextStyle(
  //           fontSize: ResponsiveHelper.responsiveFontSize(context, 15.0),
  //           color: Colors.blue),
  //       bottomSheetHeight: MediaQuery.of(context).size.height / 1.2,
  //     ),
  //     context: context,
  //     showFlag: true,
  //     showSearchField: true,
  //     showCurrencyName: true,
  //     showCurrencyCode: true,
  //     onSelect: (Currency currency) {
  //       Provider.of<UserData>(context, listen: false)
  //           .setCurrency('${currency.name}, ${currency.code} |');
  //       // animateToPage(1);
  //     },
  //     favorite: ['USD'],
  //   );
  // }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _overViewController.dispose();
    _pageController2.removeListener(_listenScroll);
    _pageController2.dispose();
  }

  // void _add(String from, GlobalKey<FormState> _formKey) {
  //   var _provider = Provider.of<UserData>(context, listen: false);
  //   _provider.workRequesttype.cast();
  //   if (_formKey.currentState!.validate()) {
  //     switch (from.split(' ')[0]) {
  //       case 'types':
  //         _provider.setWorkRequestType(selectedTypes);
  //         Navigator.pop(context);
  //         break;
  //       case 'location':
  //         _provider.setWorkRequestAvailableLocations(_textController.text);
  //         break;
  //       case 'genre':
  //         _provider.setWorkRequestGenre(_textController.text);
  //         break;

  //       case 'price':
  //         _provider.setWorkRequestPrice(double.parse(_textController.text));
  //         break;

  //       default:
  //     }

  //     selectedTypes.clear();
  //     _textController.clear();
  //   }
  // }

  // scrollToPost();

  void _listenScroll() {
    if (mounted) {
      setState(() {
        page = _pageController2.page!;
      });
    }
  }

  void scrollToPost() {
    _pageController2.animateToPage(
      widget.userIndex,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

// _submit() async{

// if ( !_isLoading) {
//       var _provider = Provider.of<UserData>(context, listen: false);
//       _isLoading = true;
//       // // _loadingModalFuture =

//       // Retry helper function
//       Future<T> retry<T>(Future<T> Function() function,
//           {int retries = 3}) async {
//         for (int i = 0; i < retries; i++) {
//           try {
//             return await function();
//           } catch (e) {
//             // print('Attempt $i failed with error: $e, retrying...');
//           }
//         }
//         throw Exception('Failed after $retries attempts');
//       }

  //    final user_WorkRequestRef =
  //     userWorkRequestRef.doc(widget.currentUserId).collection('workRequests').doc();

  //      final all_WorkRequestRef =
  //     allWorkRequestRef.doc(widget.currentUserId).collection('workRequests').doc();

  // final batch = FirebaseFirestore.instance.batch();
//     batch.set(user_WorkRequestRef, {
//       'userId': widget.currentUserId,
//       'isEvent': true,
//       'overView':_provider.workRequestoverView,
//       'genre': _provider.workRequestGenre,
//       'type': _provider.workRequesttype,
//       'availableLocations':_provider.workRequestAvailableLocations,
//       'timestamp': Timestamp.fromDate(DateTime.now()),
//       'price': _provider.workRequestPrice,
//       'currency': _provider.currency,
//     });

//     batch.set(all_WorkRequestRef, {
  // 'userId': widget.currentUserId,
  // 'isEvent': true,
  // 'overView':_provider.workRequestoverView,
  // 'genre': _provider.workRequestGenre,
  // 'type': _provider.workRequesttype,
  // 'availableLocations':_provider.workRequestAvailableLocations,
  // 'timestamp': Timestamp.fromDate(DateTime.now()),
  // 'price': _provider.workRequestPrice,
  // 'currency': _provider.currency,
//     });

//       try {
//         await retry(() => batch.commit()

//         );

//       Navigator.pop(context);    mySnackBar(context, "created succesfully");

//       } catch (e) {
//         _showBottomSheetErrorMessage('', e);
//       }
//       finally {
//     _isLoading = false;
//       }
//     }
// }

  _submit() async {
    if (!_isLoading) {
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

      final newUserWorkRequestRef = userWorkRequestRef
          .doc(widget.currentUserId)
          .collection('workRequests')
          .doc();

      final allNewWorkRequestRef = allWorkRequestRef.doc();

      final batch = FirebaseFirestore.instance.batch();

      String commonId = Uuid().v4();

      batch.set(newUserWorkRequestRef, {
        'id': commonId,
        'userId': widget.currentUserId,
        'isEvent': true,
        'overView': _overViewController.text,
        'genre': _provider.workRequestGenre,
        'type': _provider.workRequesttype,
        'availableLocations': _provider.workRequestAvailableLocations,
        'price': _provider.workRequestPrice,
        'currency': _provider.currency,
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
        'currency': _provider.currency,
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return UserBottomModalSheetActions(
          user: widget.userPortfolio,
          currentUserId: widget.currentUserId,
        );
      },
    );
  }

  void _showBottomSheetBookMe() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: UserBookingOption(
            bookingUser: widget.userPortfolio,
          ),
        );
      },
    );
  }

  _professionalImageContainer(String imageUrl, String from) {
    final width = MediaQuery.of(context).size.width;
    return ShakeTransition(
      axis: Axis.vertical,
      // curve: Curves.easeInOutBack,
      child: Container(
        width: from.startsWith('Mini') ? width / 1.5 : width.toDouble(),
        height: from.startsWith('Mini') ? width / 1.5 : width.toDouble(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(from.startsWith('Mini') ? 0 : 0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(.6),
                Colors.black.withOpacity(.2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheetAdvice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: UserAdviceScreen(
              currentUserId: widget.currentUserId,
              userId: widget.userPortfolio.id,
              userName: widget.userPortfolio.userName,
              isBlocked: _isBlockedUser,
              isBlocking: _isBlockingUser,
              updateBlockStatus: () {
                setState(() {});
              },
              user: widget.userPortfolio,
            ),
          ),
        );
      },
    );
  }

  void _bottomModalSheetMessage(
    BuildContext context,
    Chat? chat,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: BottomModalSheetMessage(
                currentUserId: widget.currentUserId,
                showAppbar: false,
                user: null,
                userAuthor: null,
                chatLoaded: chat,
                userPortfolio: widget.userPortfolio,
                userId: widget.userPortfolio.id,
              ),
            ));
      },
    );
  }

  void _showBottomSheetReadMore(
    String title,
    String body,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                // const SizedBox(
                //   height: 30,
                // ),
                TicketPurchasingIcon(
                  title: '',
                ),
                const SizedBox(height: 20),
                RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: "\n\n$body",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _selectDuration() {
  //   return
  // }

  _textField(
    String labelText,
    String hintText,
    bool autofocus,
    final TextEditingController controller,
    Function(String) onChanged,
    bool isNumber,
    // bool isLink,
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
          // enabledBorder: OutlineInputBorder(
          //     borderSide: new BorderSide(color: Colors.grey)),
        ));
  }

  // // Radio buttons to select the event vategory
  // static const values = <String>[
  //   "Parties",
  //   "Music_concerts",
  //   "Festivals",
  //   "Club_nights",
  //   "Pub_events",
  //   "Games/Sports",
  //   "Religious",
  //   "Business",
  //   "Others",
  // ];

  // Widget buildRadios() => Theme(
  //       data: Theme.of(context).copyWith(
  //         unselectedWidgetColor: Colors.grey,
  //       ),
  //       child: Column(
  //           children: values.map((value) {
  //         var _provider = Provider.of<UserData>(context, listen: false);

  //         final selected = this.selectedValue == value;
  //         final color = selected ? Colors.blue : Colors.grey;

  //         return RadioListTile<String>(
  //             value: value,
  //             groupValue: selectedValue,
  //             title: Text(
  //               value,
  //               style: TextStyle(color: color, fontSize: 14),
  //             ),
  //             activeColor: Colors.blue,
  //             onChanged: (value) {
  //               _provider.setCategory(this.selectedValue = value!);
  //             });
  //       }).toList()),
  //     );

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

  // void _showBottomSheetWorkRequest(
  //   String type,
  //   bool main,
  // ) {
  //   // genre

  //   TextEditingController _controller;
  //   GlobalKey<FormState> _formkey;
  //   switch (type.split(' ')[0]) {
  //     case 'types':
  //       _controller = _textController;
  //       _formkey = _typeFormKey;

  //       break;
  //     case 'location':
  //       _controller = _textController;
  //       _formkey = _locationFormKey;
  //       break;

  //     case 'genre':
  //       _controller = _textController;
  //       _formkey = _genreFormKey;
  //       break;

  //     case 'currency':
  //       _controller = _textController;
  //       _formkey = _genreFormKey;
  //       break;

  //     case 'price':
  //       _controller = _textController;
  //       _formkey = _priceFormKey;

  //       break;

  //     case 'overview':
  //       _controller = _overViewController;
  //       _formkey = _overViewFormKey;

  //       break;

  //     default:
  //       _controller = _overViewController;
  //       _formkey = _overViewFormKey;
  //   }

  //   double height = MediaQuery.of(context).size.height.toDouble();
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //         return ValueListenableBuilder(
  //             valueListenable: _isTypingNotifier,
  //             builder: (BuildContext context, bool isTyping, Widget? child) {
  //               var _provider = Provider.of<UserData>(context);

  //               bool _isFilled = _overViewController.text.isNotEmpty &&
  //                   _provider.workRequesttype.isNotEmpty &&
  //                   _provider.workRequestGenre.isNotEmpty &&
  //                   _provider.currency.isNotEmpty &&
  //                   _provider.workRequestPrice != 0.0 &&
  //                   _provider.workRequestAvailableLocations.isNotEmpty;

  //               Widget _widgetStringListTypes =
  //                   StringListWidget(stringValues: _provider.workRequesttype);
  //               Widget _widgetStringListGenre =
  //                   StringListWidget(stringValues: _provider.workRequestGenre);
  //               Widget _widgetStringListLocations = StringListWidget(
  //                   stringValues: _provider.workRequestAvailableLocations);
  //               Widget _widgetStringListCurrency = Padding(
  //                 padding: const EdgeInsets.only(bottom: 30.0),
  //                 child: Align(
  //                   alignment: Alignment.centerLeft,
  //                   child: Text(
  //                     _provider.currency.toString(),
  //                     style: Theme.of(context).textTheme.bodyLarge,
  //                   ),
  //                 ),
  //               );
  //               Widget _widgetStringListPrice = Align(
  //                 alignment: Alignment.centerLeft,
  //                 child: Text(
  //                   _provider.workRequestPrice.toString(),
  //                   style: Theme.of(context).textTheme.titleMedium,
  //                 ),
  //               );

  //               Widget buildCheckboxes() {
  //                 return Theme(
  //                   data: Theme.of(context).copyWith(
  //                     unselectedWidgetColor: Colors.grey,
  //                   ),
  //                   child: Column(
  //                     children: checkboxes.entries.map((entry) {
  //                       final color = entry.value ? Colors.blue : Colors.grey;

  //                       return CheckboxListTile(
  //                         title: Text(
  //                           entry.key,
  //                           style: TextStyle(
  //                             color: color,
  //                             fontSize: ResponsiveHelper.responsiveFontSize(
  //                                 context, 14.0),
  //                           ),
  //                         ),
  //                         value: entry.value,
  //                         activeColor: Colors.blue,
  //                         onChanged: (bool? newValue) {
  //                           if (mounted) {
  //                             setState(() {
  //                               checkboxes[entry.key] = newValue!;
  //                             });
  //                           }
  //                           if (newValue == true) {
  //                             if (!selectedTypes.contains(entry.key)) {
  //                               selectedTypes.add(entry.key);
  //                             }
  //                           } else {
  //                             selectedTypes.remove(entry.key);
  //                             _provider.workRequesttype.remove(entry.key);
  //                           }
  //                         },
  //                       );
  //                     }).toList(),
  //                   ),
  //                 );
  //               }

  //               return GestureDetector(
  //                 onTap: () => FocusScope.of(context).unfocus(),
  //                 child: Form(
  //                   key: _formkey,
  //                   child: Container(
  //                     height: main ? height / 1.2 : height / 1.2 - 20,
  //                     decoration: BoxDecoration(
  //                         color: Theme.of(context).primaryColorLight,
  //                         borderRadius: BorderRadius.circular(30)),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(20.0),
  //                       child: ListView(
  //                         children: [
  //                           // if (main)
  //                           ListTile(
  //                             leading: IconButton(
  //                               icon: Icon(
  //                                 Icons.close,
  //                                 size: ResponsiveHelper.responsiveHeight(
  //                                     context, 25),
  //                               ),
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               color: Theme.of(context).secondaryHeaderColor,
  //                             ),
  //                             trailing: !main
  //                                 ? _controller.text.isNotEmpty ||
  //                                         selectedTypes.isNotEmpty
  //                                     ? MiniCircularProgressButton(
  //                                         onPressed: () {
  //                                           _add(type, _formkey);
  //                                         },
  //                                         text: "Add",
  //                                         color: Colors.blue,
  //                                       )
  //                                     : GestureDetector(
  //                                         onTap: () {
  //                                           Navigator.pop(context);
  //                                         },
  //                                         child: Text(
  //                                           'Done',
  //                                           style: TextStyle(
  //                                               color: Colors.blue,
  //                                               fontWeight: FontWeight.bold),
  //                                         ),
  //                                       )
  //                                 : _isFilled
  //                                     ? MiniCircularProgressButton(
  //                                         onPressed: _submit,
  //                                         text: 'Create request',
  //                                         color: Colors.blue,
  //                                       )
  //                                     : null,
  //                           ),

  //                           // _widget,

  //                           type.startsWith('types')
  //                               ? buildCheckboxes()
  //                               : type.startsWith('location')
  //                                   ? _textField(
  //                                       'location',
  //                                       'location',
  //                                       true,
  //                                       _textController,
  //                                       (value) {
  //                                         if (mounted) {
  //                                           setState(() {});
  //                                         }
  //                                       },
  //                                       // !isEmail,
  //                                       false,
  //                                     )
  //                                   : type.startsWith('genre')
  //                                       ? _textField(
  //                                           'genre',
  //                                           'genre',
  //                                           true,
  //                                           _textController,
  //                                           (value) {
  //                                             if (mounted) {
  //                                               setState(() {});
  //                                             }
  //                                           },
  //                                           // !isEmail,
  //                                           false,
  //                                         )
  //                                       : type.startsWith('currency')
  //                                           ? _textField(
  //                                               'currency',
  //                                               'currency',
  //                                               true,
  //                                               _textController,
  //                                               (value) {
  //                                                 if (mounted) {
  //                                                   setState(() {});
  //                                                 }
  //                                               },
  //                                               // !isEmail,
  //                                               false,
  //                                             )
  //                                           : type.startsWith('price')
  //                                               ? _textField(
  //                                                   'price',
  //                                                   'price',
  //                                                   true,
  //                                                   _textController,
  //                                                   (value) {
  //                                                     if (mounted) {
  //                                                       setState(() {});
  //                                                     }
  //                                                   },
  //                                                   // !isEmail,
  //                                                   true,
  //                                                 )
  //                                               : _textField(
  //                                                   'Overview',
  //                                                   'Overview',
  //                                                   false,
  //                                                   _overViewController,
  //                                                   (value) {
  //                                                     if (mounted) {
  //                                                       setState(() {});
  //                                                     }
  //                                                   },
  //                                                   // !isEmail,
  //                                                   false,
  //                                                 ),

  //                           const SizedBox(
  //                             height: 30,
  //                           ),
  //                           if (main)
  //                             Column(
  //                               children: [
  //                                 PickOptionWidget(
  //                                     title: 'types',
  //                                     onPressed: () {
  //                                       _showBottomSheetWorkRequest(
  //                                         'types',
  //                                         false,
  //                                       );
  //                                     },
  //                                     dropDown: true),
  //                                 _widgetStringListTypes,
  //                                 PickOptionWidget(
  //                                     title: 'genre',
  //                                     onPressed: () {
  //                                       _showBottomSheetWorkRequest(
  //                                         'genre',
  //                                         false,
  //                                       );
  //                                     },
  //                                     dropDown: true),
  //                                 _widgetStringListGenre,
  //                                 PickOptionWidget(
  //                                     title: 'location',
  //                                     onPressed: () {
  //                                       _showBottomSheetWorkRequest(
  //                                         'location',
  //                                         false,
  //                                       );
  //                                     },
  //                                     dropDown: true),
  //                                 _widgetStringListLocations,
  //                                 PickOptionWidget(
  //                                     title: 'currency',
  //                                     onPressed: () {
  //                                       _showCurrencyPicker();
  //                                     },
  //                                     dropDown: true),
  //                                 _widgetStringListCurrency,
  //                                 PickOptionWidget(
  //                                     title: 'price',
  //                                     onPressed: () {
  //                                       _showBottomSheetWorkRequest(
  //                                         'price',
  //                                         false,
  //                                       );
  //                                     },
  //                                     dropDown: true),
  //                                 _widgetStringListPrice,
  //                                 const SizedBox(
  //                                   height: 30,
  //                                 ),
  //                               ],
  //                             ),

  //                           Text(
  //                             "Each creatives discography exhibit the neccesssary information to connect and collaborate with that creatives. This information provided are freely given out by this user to the creative world of Bars Impression. Creatives are grouped based on their skilss and expertise as provided by them and you can browse throguth creatives by tapping on the floating action button to go to the next creative of simmilar expertise or you can scroll left or right horizontally to change the expertise category you are browsing creatives in. ",
  //                             style: Theme.of(context).textTheme.bodySmall,
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //       });
  //     },
  //   );
  // }

  _messageButton(String text, VoidCallback onPressed, bool isBooking) {
    final width = MediaQuery.of(context).size.width;
    bool isCurrentUser =
        widget.currentUserId == widget.userPortfolio.id && isBooking;
    return Container(
      width: width.toDouble(),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isCurrentUser
                ? Colors.green[700]
                : isBooking
                    ? Colors.blue
                    : Theme.of(context).primaryColor,
            elevation: 0.0,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: ResponsiveHelper.responsiveHeight(context, 2),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isBooking
                    ? Colors.white
                    : Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: onPressed),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetMore(String from) {
    var _provider = Provider.of<UserData>(context, listen: false);
    // final double height = MediaQuery.of(context).size.height;
    final bool _isAuthor = widget.currentUserId == widget.userPortfolio.id;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListView(
            children: [
              const SizedBox(
                height: 10,
              ),
              TicketPurchasingIcon(
                title: from,
              ),
              from.startsWith('contacts')
                  ? PortfolioContactWidget(
                      portfolios: _provider.bookingContacts,
                      edit: _isAuthor,
                    )
                  : from.startsWith('company')
                      ? PortfolioCompanyWidget(
                          portfolios: _provider.company,
                          seeMore: true,
                          edit: false,
                        )
                      : from.startsWith('skills')
                          ? PortfolioWidget(
                              portfolios: _provider.skills,
                              seeMore: true,
                              edit: false,
                            )
                          : from.startsWith('performance')
                              ? PortfolioWidget(
                                  portfolios: _provider.performances,
                                  seeMore: true,
                                  edit: false,
                                )
                              : from.startsWith('awards')
                                  ? PortfolioWidget(
                                      portfolios: _provider.awards,
                                      seeMore: true,
                                      edit: false,
                                    )
                                  : from.startsWith('work')
                                      ? PortfolioWidgetWorkLink(
                                          portfolios: _provider.linksToWork,
                                          seeMore: true,
                                          edit: false,
                                        )
                                      : from.startsWith('price')
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30.0),
                                              child: PriceRateWidget(
                                                edit: false,
                                                prices: _provider.priceRate,
                                                seeMore: true,
                                                currency: _provider.currency,
                                              ),
                                            )
                                          : PortfolioWidget(
                                              portfolios: [],
                                              seeMore: true,
                                              edit: false,
                                            ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        );
      },
    );
  }

  _divider(
    String text,
    String from,
    bool shouldEpand,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Divider(),
        text.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 20),
        ListTile(
          title: Text(
            text,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          trailing: shouldEpand
              ? IconButton(
                  icon: Icon(
                    Icons.expand_more_outlined,
                    color: Colors.blue,
                    size: ResponsiveHelper.responsiveHeight(context, 25),
                  ),
                  onPressed: () {
                    _showBottomSheetMore(from);
                  },
                )
              : null,
        ),
      ],
    );
  }

  // _myWork(String text, VoidCallback onPressed) {
  //   final width = Responsive.isDesktop(context)
  //       ? 600.0
  //       : MediaQuery.of(context).size.width;
  //   return Container(
  //     height: 50,
  //     // color: Colors.blue,
  //     width: width / 2.2,
  //     child: ListTile(
  //       leading: Icon(
  //         Icons.link,
  //         // size: 20.0,
  //         color: Colors.blue,
  //       ),
  //       title: Text(
  //         text,
  //         style: Theme.of(context).textTheme.bodyMedium,
  //       ),
  //       onTap: onPressed,
  //     ),
  //   );
  // }

  // _workRow(
  //   String text1,
  //   String link1,
  //   String text2,
  //   String link2,
  // ) {
  //   return Row(
  //     children: [
  //       _myWork(
  //         text1,
  //         () {
  //           _showBottomSheetWork(text1, link1);
  //         },
  //       ),
  //       _myWork(
  //         text2,
  //         () {
  //           _showBottomSheetWork(text2, link2);
  //         },
  //       ),
  //     ],
  //   );
  // }

  _authorWidget() {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
          height: ResponsiveHelper.responsiveHeight(context, 60),
          width: width.toDouble(),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _navigateToPage(
                      context,
                      ProfileScreen(
                        currentUserId: widget.currentUserId,
                        userId: widget.userPortfolio.id,
                        user: null,
                      ));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    widget.userPortfolio.profileImageUrl.isEmpty
                        ? Icon(
                            Icons.account_circle,
                            size: 40.0,
                            color: Colors.grey,
                          )
                        : CircleAvatar(
                            radius: 18.0,
                            backgroundColor: Colors.blue,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.userPortfolio.profileImageUrl),
                          ),
                    SizedBox(width: 10),
                    Expanded(
                      // Add this
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  // And this
                                  child: Text(
                                widget.userPortfolio.userName,
                                style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 16.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,

                                  overflow: TextOverflow.ellipsis, // And this
                                ),
                                maxLines: 2,
                              )),
                              SizedBox(width: 5),
                              if (widget.userPortfolio.verified)
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 16,
                                ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.userPortfolio.profileHandle,
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2, // Adjust as necessary
                            overflow: TextOverflow.ellipsis, // Add this
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!_isBlockingUser && !_isBlockedUser)
                Positioned(
                  right: 1,
                  child: IconButton(
                    onPressed: () {
                      _showBottomSheet();
                    },
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: ResponsiveHelper.responsiveHeight(context, 20),
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          )),
    );
  }

  _workRequest() {
    return PortfolioWorkRequestWidget(
      edit: false,
      seeMore: true,
      workReQuests: _userWorkRequest,
      onTapToGoTODiscovery: false,
    );
  }

  // _noContent() {
  //   return Center(
  //       child: NoContents(
  //           title: 'No Info.',
  //           subTitle:
  //               'Each creative\'s discography showcases essential information to connect and collaborate with them. Explore their discography to find the necessary details and opportunities for connecting with these talented individuals',
  //           icon: Icons.work_off_outlined));
  // }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );

    final List<String> currencyPartition =
        widget.userPortfolio.currency.trim().replaceAll('\n', ' ').split("|");

    bool _isCurrentUser = widget.currentUserId == widget.userPortfolio.id;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.black,
              expandedHeight: ResponsiveHelper.responsiveHeight(context, 350),
              flexibleSpace: Container(
                width: double.infinity,
                child: FlexibleSpaceBar(
                  title: _authorWidget(),
                  expandedTitleScale: 1,
                  background:

                      //  widget.userPortfolio.professionalImageUrls.isEmpty
                      //     ? Center(
                      //         child: Text(
                      //           'No Image',
                      //           style: TextStyle(
                      //             color: Colors.grey,
                      //             fontSize: ResponsiveHelper.responsiveFontSize(
                      //                 context, 20.0),
                      //           ),
                      //           textAlign: TextAlign.center,
                      //         ),
                      //       )
                      //     :
                      PageView(
                    controller: _pageController2,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: _provider.professionalImages
                        .asMap()
                        .entries
                        .map<Widget>((entry) {
                      var image = entry.value;
                      return _professionalImageContainer(image, 'Max');
                    }).toList(),
                  ),
                ),
              ),
            ),
          ];
        },
        body:

            // _noPrefessionalImage
            //     ? _noContent()
            //     :
            MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Container(
            // decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  if (!_isBlockingUser && !_isBlockedUser)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: _isCurrentUser
                            ? () {
                                _showBottomSheetAdvice(context);
                              }
                            : () async {
                                if (_isLoading) return;

                                _isLoading = true;
                                try {
                                  Chat? _chat =
                                      await DatabaseService.getUserChatWithId(
                                    widget.currentUserId,
                                    widget.userPortfolio.id,
                                  );

                                  _bottomModalSheetMessage(
                                    context,
                                    _chat,
                                  );
                                } catch (e) {}
                                _isLoading = false;
                              },
                        child: _isLoading
                            ? SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                            : _isCurrentUser
                                ? Icon(
                                    MdiIcons.thoughtBubbleOutline,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size: ResponsiveHelper.responsiveHeight(
                                        context, 25),
                                  )
                                : Icon(
                                    Icons.message_outlined,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    size: ResponsiveHelper.responsiveHeight(
                                        context, 25),
                                  ),
                      ),
                    ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [

                  //   ],
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!_isBlockingUser && !_isBlockedUser)
                    _messageButton(
                      _isCurrentUser
                          ? 'Create Work request'
                          : 'Book ${widget.userPortfolio.userName}',
                      () {
                        _isCurrentUser
                            ? _navigateToPage(
                                context,
                                CreateWork(
                                  currentUserId: widget.currentUserId,
                                  userPortfolio: widget.userPortfolio,
                                ))
                            : _showBottomSheetBookMe();
                      },
                      true,
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        _showBottomSheetReadMore(
                            'Overview', _provider.overview);
                      },
                      child: Text(
                        _provider.overview,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      )),
                  _divider('Company', 'company',
                      _provider.company.length >= 4 ? true : false),
                  PortfolioCompanyWidget(
                    portfolios: _provider.company,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Price list', 'price',
                      _provider.priceRate.length >= 2 ? false : false),
                  PriceRateWidget(
                    edit: false,
                    prices: _provider.priceRate,
                    seeMore: true,
                    currency: _provider.currency,
                  ),
                  _divider('Work request', 'work', false),
                  _workRequest(),
                  _divider('Skills', 'skills',
                      _provider.skills.length >= 4 ? true : false),
                  PortfolioWidget(
                    portfolios: _provider.skills,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Performance', 'performance',
                      _provider.performances.length >= 4 ? true : false),
                  PortfolioWidget(
                    portfolios: _provider.performances,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Awards', 'awards',
                      _provider.awards.length >= 4 ? true : false),
                  PortfolioWidget(
                    portfolios: _provider.awards,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Collaborations', 'collaborations', false),
                  PortfolioCollaborationWidget(
                    collaborations: _provider.collaborations,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Works', 'works',
                      _provider.linksToWork.length >= 4 ? true : false),
                  PortfolioWidgetWorkLink(
                    portfolios: _provider.linksToWork,
                    seeMore: false,
                    edit: false,
                  ),
                  _divider('Terms and conditions', '', false),
                  GestureDetector(
                      onTap: () {
                        _showBottomSheetReadMore('Terms and Conditions',
                            _provider.termAndConditions);
                      },
                      child: Text(
                        _provider.termAndConditions,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      )),
                  _divider('', '', false),
                  if (!_isBlockingUser && !_isBlockedUser)
                    _messageButton(
                      _isCurrentUser
                          ? 'Your booking contact'
                          : 'Book ${widget.userPortfolio.userName}',
                      () {
                        HapticFeedback.mediumImpact();
                        _showBottomSheetBookMe();
                      },
                      true,
                    ),
                  if (!_isCurrentUser && !_isBlockingUser && !_isBlockedUser)
                    _messageButton(
                      _isLoading
                          ? 'Loading...'
                          : 'Message ${widget.userPortfolio.userName}',
                      () async {
                        if (_isLoading) return;
                        _isLoading = true;
                        try {
                          Chat? _chat = await DatabaseService.getUserChatWithId(
                            widget.currentUserId,
                            widget.userPortfolio.id,
                          );

                          _bottomModalSheetMessage(
                            context,
                            _chat,
                          );
                        } catch (e) {}
                        _isLoading = false;
                      },
                      false,
                    ),
                  if (!_isBlockingUser && !_isBlockedUser)
                    _messageButton(
                      _isCurrentUser
                          ? 'Advices for you'
                          : 'Advice ${widget.userPortfolio.userName}',
                      () {
                        _showBottomSheetAdvice(context);
                      },
                      false,
                    ),
                  GestureDetector(
                    onTap: () {
                      _navigateToPage(
                          context,
                          UserBarcode(
                            profileImageUrl:
                                widget.userPortfolio.profileImageUrl,
                            userDynamicLink: widget.userPortfolio.dynamicLink,
                            bio: widget.userPortfolio.overview,
                            userName: widget.userPortfolio.userName,
                            userId: widget.userPortfolio.id,
                          ));
                    },
                    child: Hero(
                        tag: widget.userPortfolio.id,
                        child: Icon(
                          Icons.qr_code,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: ResponsiveHelper.responsiveHeight(context, 40),
                        )),
                  ),
                  _divider('', '', false),
                  GestureDetector(
                      onTap: () {
                        _navigateToPage(
                            context,
                            ReportContentPage(
                              parentContentId: widget.userPortfolio.id,
                              repotedAuthorId: widget.userPortfolio.id,
                              contentId: widget.userPortfolio.id,
                              contentType: widget.userPortfolio.userName,
                            ));
                      },
                      child: Material(
                          color: Colors.transparent,
                          child: Text('Report  ',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14.0),
                              )))),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        _navigateToPage(context, SuggestionBox());
                      },
                      child: Material(
                          color: Colors.transparent,
                          child: Text('Suggestion Box  ',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 14.0),
                              )))),
                  _divider('', '', false),
                  Text(
                    "Each creative's discography showcases the necessary information to connect and collaborate with them. This valuable information is freely provided by the user to the creative world of Bars Impression. Creatives are grouped based on their skills and expertise, as provided by them. On the Book page, you can easily browse through creatives by tapping on the floating action button to move to the next creative with similar expertise. Alternatively, you can horizontally scroll left or right to change the expertise category you are browsing and discover more talented individuals.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
