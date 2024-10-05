import 'package:bars/utilities/date_picker.dart';
import 'package:bars/utilities/exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class BookingCalendar extends StatefulWidget {
  final String currentUserId;
  // final List<PriceModel> prices;
  final UserStoreModel bookingUser;
  final bool fromPrice;

  BookingCalendar({
    required this.currentUserId,
    // required this.prices,
    required this.bookingUser,
    this.fromPrice = false,
  });

  @override
  State<BookingCalendar> createState() => _BookingCalendarState();
}

class _BookingCalendarState extends State<BookingCalendar> {
  List<BookingModel> _allbookings = [];
  bool _isLoadingSubmit = false;
  int selectedIndex = 0;
  final _allbookingSnapshot = <DocumentSnapshot>[];
  DateTime _focusedDay = DateTime.now();
  DateTime _currentDate = DateTime.now();
  DateTime _firstDayOfNextMonth =
      DateTime(DateTime.now().year, DateTime.now().month + 2, 1);
  bool loading = true;
  final now = DateTime.now();

  final _descriptionController = TextEditingController();
  final _specialRequirementsController = TextEditingController();

  final _termsController = TextEditingController();
  final _addressSearchController = TextEditingController();
  final _debouncer = Debouncer(milliseconds: 500);
  final FocusNode _addressSearchfocusNode = FocusNode();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  final _donateAmountFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _setupBookings(false);
    _descriptionController.addListener(_onDonateChanged);
    _termsController.addListener(_onDonateChanged);
    var _provider = Provider.of<UserData>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clearCurency(_provider);
      processCurrency(_provider);
    });
  }

  _clearCurency(UserData provider) {
    provider.setCurrency('');
  }

  void processCurrency(UserData provider) {
    // Check if widget.userPortfolio.currency is null or empty
    if (widget.bookingUser.currency == null ||
        widget.bookingUser.currency.trim().isEmpty) {
      // Handle the case where currency is null or empty
      provider.setCurrency('');
      return;
    }

    // Proceed with normal processing if currency is not null or empty
    final List<String> currencyPartition =
        widget.bookingUser.currency.trim().replaceAll('\n', ' ').split("|");

    String _currency = currencyPartition.length > 1 ? currencyPartition[1] : '';

    // Check if _currency has at least 3 characters before accessing _currency[2]
    if (_currency.length >= 3) {
      provider.setCurrency(_currency);
    } else {
      // Handle the case where _currency does not have enough characters
      provider.setCurrency('');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _termsController.dispose();
    _debouncer.cancel();
    _addressSearchController.dispose();
    _addressSearchfocusNode.dispose();
  }

  void _onDonateChanged() {
    if (_descriptionController.text.isNotEmpty &&
        _termsController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  Future<List<BookingModel>> _setupBookings(bool fetchMore) async {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    String country = _userLocationSettings!.country!;
    String city = _userLocationSettings.city!;

    int remainingLimit = 50;
    List<BookingModel> bookings = [];

    // Fetch events from the city
    bookings += fetchMore
        ? await _fetchMoreBookings(
            limit: 25,
            country: country,
            city: city,
            currentDate: _currentDate,
            firstDayOfNextMonth: _firstDayOfNextMonth)
        : await _fetchBookings(
            limit: 25,
            country: country,
            city: city,
            currentDate: _currentDate,
            firstDayOfNextMonth: _firstDayOfNextMonth);
    remainingLimit -= bookings.length;

    if (remainingLimit > 0) {
      // Fetch events from the country
      bookings += fetchMore
          ? await _fetchMoreBookings(
              limit: remainingLimit + 15,
              country: country,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth)
          : await _fetchBookings(
              limit: remainingLimit + 15,
              country: country,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth);
      remainingLimit = 50 - bookings.length;
    }

    if (remainingLimit > 0) {
      // Fetch events from anywhere
      bookings += fetchMore
          ? await _fetchMoreBookings(
              limit: remainingLimit,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth)
          : await _fetchBookings(
              limit: remainingLimit,
              currentDate: _currentDate,
              firstDayOfNextMonth: _firstDayOfNextMonth);
    }

    if (mounted) {
      setState(() {
        _allbookings = bookings;
        loading = false;
      });
    }

    return bookings;
  }

  Set<String> addedEventIds = Set<String>();

  Future<List<BookingModel>> _fetchBookings({
    required int limit,
    String? country,
    String? city,
    required DateTime currentDate,
    required DateTime firstDayOfNextMonth,
  }) async {
    Query<Map<String, dynamic>> query = newBookingsReceivedRef
        .doc(widget.bookingUser.userId)
        .collection('bookings');

    // if (country != null) {
    //   query = query.where('country', isEqualTo: country);
    // }
    // if (city != null) {
    //   query = query.where('city', isEqualTo: city);
    // }

    // try {
    QuerySnapshot eventFeedSnapShot = await query
        // .where('clossingDay', isGreaterThanOrEqualTo: currentDate)
        // .orderBy('clossingDay')
        // .orderBy(FieldPath.documentId)
        .limit(limit)
        .get();

    List<BookingModel> uniqueBookings = [];

    for (var doc in eventFeedSnapShot.docs) {
      BookingModel event = BookingModel.fromDoc(doc);
      if (!addedEventIds.contains(event.id)) {
        uniqueBookings.add(event);
        addedEventIds.add(event.id);
      }
    }

    if (_allbookingSnapshot.isEmpty) {
      _allbookingSnapshot.addAll(eventFeedSnapShot.docs);
    }

    return uniqueBookings;
    // } catch (e) {
    //   print('Failed to fetch events: $e');
    //   return [];
    // }
  }

  Future<List<BookingModel>> _fetchMoreBookings({
    required int limit,
    String? country,
    String? city,
    required DateTime currentDate,
    required DateTime firstDayOfNextMonth,
  }) async {
    Query<Map<String, dynamic>> query = newBookingsReceivedRef
        .doc(widget.bookingUser.userId)
        .collection('bookings');

    // if (country != null) {
    //   query = query.where('country', isEqualTo: country);
    // }
    // if (city != null) {
    //   query = query.where('city', isEqualTo: city);
    // }

    // query = query.where('startDate', isLessThanOrEqualTo: firstDayOfNextMonth);

    if (_allbookingSnapshot.isNotEmpty) {
      query = query.startAfterDocument(_allbookingSnapshot.last);
    }

    try {
      QuerySnapshot eventFeedSnapShot =
          await query.orderBy(FieldPath.documentId).limit(limit).get();

      List<BookingModel> uniqueBookings = [];

      for (var doc in eventFeedSnapShot.docs) {
        BookingModel event = BookingModel.fromDoc(doc);
        if (!addedEventIds.contains(event.id)) {
          uniqueBookings.add(event);
          addedEventIds.add(event.id);
        }
      }

      _allbookingSnapshot.addAll(eventFeedSnapShot.docs);

      return uniqueBookings;
    } catch (e) {
      print('Failed to fetch events: $e');
      return [];
    }
  }

  Map<DateTime, List<BookingModel>> convertToMap(List<BookingModel> events) {
    Map<DateTime, List<BookingModel>> eventMap = {};
    for (BookingModel event in events) {
      DateTime date = event.bookingDate.toDate();
      DateTime normalizedDate = DateTime(date.year, date.month,
          date.day); // normalize the date to midnight time.
      if (eventMap[normalizedDate] == null) {
        eventMap[normalizedDate] = [];
      }
      eventMap[normalizedDate]?.add(event);
    }
    return eventMap;
  }

  void _showBottomSheetErrorMessage(BuildContext context, String error) {
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
          title: error,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  _keyWidget(Color color, String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Container(
          child: Text(
            name,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  void _showBottomSheetLoading(String text) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomModalLoading(
          title: text,
        );
      },
    );
  }

  _sendBookingRequest() async {
    var _provider = Provider.of<UserData>(context, listen: false);

    _showBottomSheetLoading('Sending booking request');
    var _user = Provider.of<UserData>(context, listen: false).user;
    String commonId = Uuid().v4();

    if (_isLoadingSubmit) {
      return;
    }
    if (mounted) {
      setState(() {
        _isLoadingSubmit = true;
      });
    }

    Future<T> retry<T>(Future<T> Function() function, {int retries = 3}) async {
      Duration delay =
          const Duration(milliseconds: 100); // Start with a short delay
      for (int i = 0; i < retries; i++) {
        try {
          return await function();
        } catch (e) {
          if (i == retries - 1) {
            // Don't delay after the last attempt
            rethrow;
          }
          await Future.delayed(delay);
          delay *= 2; // Double the delay for the next attempt
        }
      }
      throw Exception('Failed after $retries attempts');
    }

    BookingModel _booking = BookingModel(
      id: commonId,
      creativeId: widget.bookingUser.userId,
      clientId: widget.currentUserId,
      isEvent: _provider.isVirtual,
      bookingDate: _provider.startDate,
      location: _provider.address,
      description: _descriptionController.text.trim(),
      answer: '',
      priceRate: null,
      // messages: [],
      isFinalPaymentMade: false,
      // reason: _bookingReasonController.text.trim(),
      termsAndConditions: _termsController.text.trim(),
      timestamp: Timestamp.fromDate(DateTime.now()),
      cancellationReason: '',
      startTime: _provider.sheduleDateTemp,
      endTime: _provider.clossingDay, rating: 0, reviewComment: '',
      // serviceStatus: '',
      specialRequirements: _specialRequirementsController.text.trim(),
      isdownPaymentMade: false,
      arrivalScanTimestamp: null,
      departureScanTimestamp: null, reNogotiate: false,
    );

    Future<void> sendInvites() => DatabaseService.createBookingRequest(
          currentUser: _user!,
          booking: _booking,
        );

    try {
      await retry(() => sendInvites(), retries: 3);
      _clear();
      mySnackBar(context, "Booking request successfully sent");

      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage(context, 'Could not send booking request');
    } finally {
      _endLoading();
    }
  }

  _clear() {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.setAddress('');

    _termsController.clear();
    _descriptionController.clear();
    // _bookingReasonController.clear();
    _specialRequirementsController.clear();
    _provider.addressSearchResults = null;

    _provider.setIsVirtual(false);
    _provider.setIsEndTimeSelected(false);
    _provider.setIsStartTimeSelected(false);
    _provider.setBookingPriceRate(null);
  }

  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

  void _showBottomConfirmBooking() {
    // String amount = _bookingAmountController.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 350,
          buttonText: 'Book',
          onPressed: () async {
            // Navigator.pop(context);
            _sendBookingRequest();
          },
          title: 'Confirm booking',
          subTitle:
              'You are send booking request? This request must be accepted by this creative before the booking would be effective. Not that this creative is not oblige to respond or accept this request.',
        );
      },
    );
  }

  //section for people performain in an event
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

  void _showBottomVenue(String from) {
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
                        if (value.trim().isNotEmpty) {
                          _debouncer.run(() {
                            _provider.searchAddress(value);
                          });
                        }
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
                              itemCount: _provider.addressSearchResults!.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                        title: Text(
                                          _provider.addressSearchResults![index]
                                              .description,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);

                                          _provider.setAddress(_provider
                                              .addressSearchResults![index]
                                              .description);
                                        }),
                                    Divider(
                                      thickness: .3,
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
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: UserBookingOption(
            bookingUser: widget.bookingUser,
          ),
        );
      },
    );
  }

  void _showBottomSheetBook(BuildContext context) {
    var _blueStyle = TextStyle(
      color: Colors.blue,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        var _provider = Provider.of<UserData>(
          context,
        );
        return ValueListenableBuilder(
            valueListenable: _isTypingNotifier,
            builder: (BuildContext context, bool isTyping, Widget? child) {
              return Form(
                key: _donateAmountFormKey,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    height: ResponsiveHelper.responsiveHeight(context, 680),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          TicketPurchasingIcon(
                            title: '',
                          ),
                          _isTypingNotifier.value
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: MiniCircularProgressButton(
                                        color: Colors.blue,
                                        text: 'Continue',
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _showBottomConfirmBooking();
                                        }),
                                  ),
                                )
                              : SizedBox(
                                  height: 20,
                                ),
                          DonationHeaderWidget(
                            disableBottomPadding: true,
                            title: 'Book',
                            iconColor: Colors.blue,
                            icon: Icons.calendar_month,
                          ),
                          Center(
                            child: Text(
                              MyDateFormat.toDate(DateTime.parse(
                                  _provider.startDate.toDate().toString())),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          SettingSwitchBlack(
                            title: 'Booking for event?',
                            subTitle:
                                'Leave the toggle on when you are not booking a creative for an event.',
                            value: _provider.isVirtual,
                            onChanged: (bool value) =>
                                _provider.setIsVirtual(value),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(30)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PickOptionWidget(
                                  title: 'Booking location',
                                  onPressed: () {
                                    _showBottomVenue(
                                      'Adrress',
                                    );
                                  },
                                  dropDown: true,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showBottomVenue(
                                      'Adrress',
                                    );
                                  },
                                  child: Text(
                                    _provider.address,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                DatePicker(
                                  isMini: true,
                                  onlyWhite: false,
                                  onStartDateChanged: (DateTime newDate) {
                                    _provider.setSheduleTimestamp(
                                        Timestamp.fromDate(newDate));
                                  },
                                  onStartTimeChanged: (DateTime newDate) {
                                    _provider.setSheduleTimestamp(
                                        Timestamp.fromDate(newDate));
                                  },
                                  onEndDateChanged: (DateTime newDate) {
                                    _provider.setClossingDay(
                                        Timestamp.fromDate(newDate));
                                  },
                                  onEndTimeChanged: (DateTime newDate) {
                                    _provider.setClossingDay(
                                        Timestamp.fromDate(newDate));
                                  },
                                  date: false,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          UnderlinedTextField(
                            autofocus: false,
                            controler: _descriptionController,
                            labelText: 'Desciption',
                            hintText:
                                'Details about your booking service request.',
                            onValidateText: () {},
                          ),
                          UnderlinedTextField(
                            autofocus: false,
                            controler: _specialRequirementsController,
                            labelText: 'Special requirements (optional)',
                            hintText: 'Any special requirements needed',
                            onValidateText: () {},
                          ),
                          UnderlinedTextField(
                            autofocus: false,
                            controler: _termsController,
                            labelText: 'Terms and conditions',
                            hintText: 'To guide the booking',
                            onValidateText: () {},
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showBottomSheetManagerDonationDoc();
                            },
                            child: RichText(
                              textScaleFactor:
                                  MediaQuery.of(context).textScaleFactor,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Your booking request will sent to the selected creative and stored in a pending state, awaiting review.  You will be notified when the service creative has reviewed and responded to your booking request. If the creative accepts your request, you will be prompted to make an initial deposit payment of 30% of the service price. ',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  TextSpan(
                                    text: 'more',
                                    style: _blueStyle,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 300,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  void selectItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  _BookingNotSetUp() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.error_outline_outlined,
          color: Colors.grey,
          size: ResponsiveHelper.responsiveHeight(context, 50.0),
        ),
        const SizedBox(height: 40),
        ShakeTransition(
          child: Text(
            'Booking not available',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ),
        // Text(
        //   widget.bookingUser.contacts.isNotEmpty
        //       ? ' ${widget.bookingUser.userName} has not yet set up their booking details. You can directly contact ${widget.bookingUser.userName} by tapping the button below.'
        //       : '${widget.bookingUser.userName} has not setup his booking details.',
        //   style: Theme.of(context).textTheme.bodyMedium,
        //   textAlign: TextAlign.center,
        // ),
        const SizedBox(
          height: 20,
        ),
        // if (widget.bookingUser.contacts.isNotEmpty)
        //   EventBottomButton(
        //     buttonColor: Colors.blue,
        //     buttonText: 'Contact ${widget.bookingUser.userName} directly',
        //     onPressed: () {
        //       Navigator.pop(context);
        //       _showBottomSheetBookMe();
        //     },
        //   ),
      ],
    );
  }

  _userBookedInfoForNotAuthor(BuildContext context) {
    bool _isAuthor = widget.bookingUser.userId == widget.currentUserId;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.calendar_month_outlined,
          color: Colors.grey,
          size: ResponsiveHelper.responsiveHeight(context, 50.0),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ShakeTransition(
            child: Text(
              // _isAuthor
              //     ? 'You have not been booked on this date'
              //     :
              '${widget.bookingUser.userName} has been booked for this day. You can still create a booking request for this date or select another day.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 20),
        // if (!_isAuthor)
        EventBottomButton(
          buttonColor: Colors.blue,
          buttonText: 'Book',
          onPressed: () {
            Navigator.pop(context);
            _SelectPriceOptions(context);
          },
        ),
      ],
    );
  }

  _bookingPrice(BuildContext context) {
    var _blueSyle = TextStyle(
      color: Colors.blue,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
    );
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(.6),
        builder: (BuildContext context) {
          var _provider = Provider.of<UserData>(
            context,
          );
          return Container(
            height: ResponsiveHelper.responsiveHeight(
                context,  700),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  if (_provider.bookingPriceRate != null)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: MiniCircularProgressButton(
                            color: Colors.blue,
                            text: 'Continue',
                            onPressed: () {
                              _showBottomSheetBook(context);
                            }),
                      ),
                    ),
                  DonationHeaderWidget(
                    title: 'select service',
                    iconColor: Colors.grey,
                    icon: FontAwesomeIcons.scissors,
                    disableBottomPadding: true,
                  ),
                  if (_provider.bookingPriceRate != null)
                    Center(
                      child: Text(
                        "${_provider.currency} ${_provider.bookingPriceRate!.price.toString()}",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  const SizedBox(height: 20),
                  TicketGroup(
                    appointmentSlots: _provider.appointmentSlots,
                    // edit: true,
                  ),
                  // PriceRateWidget(
                  //   //  widget.bookingUser.currency,
                  //   prices: widget.bookingUser.priceTags,
                  //   edit: false,
                  //   seeMore: false,
                  // ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () {
                      _showBottomSheetBookMe();
                    },
                    child: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Carefully review the available price options and select the one that best fits your service needs. Please note that you can only select a single price option per booking request. If you have any further inquiries, you can ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: ' contact the creative ',
                            style: _blueSyle,
                          ),
                          TextSpan(
                            text:
                                'directly using the provided contact information.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          );
        });
  }

  _SelectPriceOptions(BuildContext context) {
    return 
    
    // widget.bookingUser.priceTags.isEmpty
    //     ? showModalBottomSheet(
    //         context: context,
    //         isScrollControlled: true,
    //         backgroundColor: Colors.black.withOpacity(.6),
    //         builder: (BuildContext context) {
    //           return Container(
    //               height: ResponsiveHelper.responsiveHeight(context, 350),
    //               width: double.infinity,
    //               decoration: BoxDecoration(
    //                   color: Theme.of(context).cardColor,
    //                   borderRadius: BorderRadius.circular(30)),
    //               child: Padding(
    //                   padding: const EdgeInsets.all(20.0),
    //                   child: _BookingNotSetUp()));
    //         })
    //     :
         widget.fromPrice
            ? _showBottomSheetBook(context)
            : _bookingPrice(context);
  }

  _notBookingForYou(BuildContext context, DateTime selectedDay) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black.withOpacity(.6),
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 300),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_userBookedInfoForNotAuthor(context)],
          ),
        );
      },
    );
  }

  _header(DateTime selectedDay) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: ResponsiveHelper.responsiveHeight(context, 40),
          width: ResponsiveHelper.responsiveHeight(context, 40),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: ResponsiveHelper.responsiveHeight(context, 30),
              )),
        ),
        Expanded(
          child: Text(
            MyDateFormat.toDate(selectedDay),
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
              color: Colors.white,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  _displaySelectedBooking(BuildContext context,
      List<BookingModel> selectedBookings, DateTime selectedDay) {
    bool _isAuthor = widget.bookingUser.userId == widget.currentUserId;

    return selectedBookings.isNotEmpty
        ? showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black.withOpacity(.6),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: selectedBookings.isNotEmpty ? 20.0 : 0),
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: ResponsiveHelper.responsiveHeight(context, 100),
                    ),
                    _header(selectedDay),
                    const SizedBox(
                      height: 10,
                    ),
                    _isAuthor
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: selectedBookings
                                .map((booking) => BookingWidget(
                                      booking: booking,
                                      currentUserId: widget.currentUserId,
                                    ))
                                .toList())
                        : Container(
                            height:
                                ResponsiveHelper.responsiveHeight(context, 300),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(30)),
                            child: _userBookedInfoForNotAuthor(context),
                          ),
                  ],
                ),
              );
            },
          )
        : _isAuthor
            ? _notBookingForYou(context, selectedDay)
            : _SelectPriceOptions(context);
  }

  void _showBottomSheetManagerDonationDoc() {
    final bool _isAuthor = widget.currentUserId == widget.bookingUser.userId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ManagerDonationDoc(
                isDonation: false,
                isCreating: false,
                isCurrentUser: _isAuthor,
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<BookingModel>> _bookings = convertToMap(_allbookings);
    var _provider = Provider.of<UserData>(context, listen: false);
    bool _isAuthor = widget.bookingUser.userId == widget.currentUserId;

    var _blueSyle = TextStyle(
      color: Colors.blue,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
    );
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 700),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 10,
          ),
          TicketPurchasingIcon(
            title: '',
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ShakeTransition(
                child: Text(
                  _isAuthor
                      ? 'Your \nbookings'
                      : "Book\n${widget.bookingUser.userName}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )),
          TableCalendar(
            daysOfWeekHeight: ResponsiveHelper.responsiveHeight(context, 50),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                DateTime now = DateTime.now();
                DateTime normalizedNow = DateTime(now.year, now.month, now.day);
                DateTime normalizedDate =
                    DateTime(date.year, date.month, date.day);

                if (!_isAuthor) if (normalizedDate.isBefore(normalizedNow)) {
                  return Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          color: Colors.grey), // Change this color as needed
                    ),
                  );
                } else {
                  return null; // Use default styling for other dates
                }
              },
              markerBuilder: (context, date, events) {
                return Positioned(
                  right: 1,
                  bottom: 1,
                  child: Wrap(
                    children: events.map((e) {
                      BookingModel bookings = e as BookingModel;

                      // Now you can access the isPrivate property
                      Color markerColor;
                      if (!_isAuthor) {
                        markerColor = Colors.grey;
                      } else if (bookings.isEvent) {
                        bookings.answer == ''
                            ? markerColor = Color.fromARGB(255, 255, 229, 152)
                            : bookings.answer == 'Rejected'
                                ? markerColor = Colors.grey
                                : markerColor =
                                    Color.fromARGB(255, 225, 169, 2);
                      } else if (!bookings.isEvent) {
                        bookings.answer == ''
                            ? markerColor = Colors.green.withOpacity(.4)
                            : bookings.answer == 'Rejected'
                                ? markerColor = Colors.grey
                                : markerColor = Colors.green;
                      } else {
                        markerColor = Theme.of(context).secondaryHeaderColor;
                      }
                      return Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: markerColor,
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            eventLoader: (day) {
              try {
                DateTime normalizedDay = DateTime(day.year, day.month, day.day);
                return _bookings[normalizedDay] ?? [];
              } catch (e) {
                _showBottomSheetErrorMessage(
                    context, 'Error loading events for day $day');
                return [];
              }
            },
            availableGestures: AvailableGestures.all,
            pageAnimationCurve: Curves.easeInOut,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              holidayTextStyle: TextStyle(color: Colors.red),
              outsideDaysVisible: true,
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
              ),
              headerMargin:
                  const EdgeInsets.only(top: 20, bottom: 10, left: 10),
              leftChevronVisible: false,
              rightChevronVisible: false,
              formatButtonVisible: false,
              formatButtonTextStyle: TextStyle(color: Colors.white),
              formatButtonShowsNext: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              DateTime now = DateTime.now();
              DateTime normalizedNow = DateTime(now.year, now.month, now.day);
              DateTime normalizedSelectedDay = DateTime(
                  selectedDay.year, selectedDay.month, selectedDay.day);

              if (!_isAuthor) if (normalizedSelectedDay
                  .isBefore(normalizedNow)) {
                // print('Invalid date');
                return;
              }

              List<BookingModel> selectedBookings =
                  _bookings[normalizedSelectedDay] ?? [];
              HapticFeedback.mediumImpact();

              _provider.setStartDate(Timestamp.fromDate(selectedDay));
              _displaySelectedBooking(context, selectedBookings, selectedDay);
            },
            firstDay: DateTime(2023),
            lastDay: DateTime(2028),
            focusedDay: _focusedDay,
          ),
          loading
              ? Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Center(
                    child: SizedBox(
                      height:
                          ResponsiveHelper.responsiveFontSize(context, 30.0),
                      width: ResponsiveHelper.responsiveFontSize(context, 30.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                        strokeWidth:
                            ResponsiveHelper.responsiveFontSize(context, 2.0),
                      ),
                    ),
                  ),
                )
              :
              // widget.bookingUser.contacts.isEmpty
              //     ? SizedBox.shrink()
              //     :

              EventBottomButton(
                  buttonColor: Colors.blue,
                  buttonText: 'Contact ${widget.bookingUser.userName} directly',
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    _showBottomSheetBookMe();
                  },
                ),
          if (!loading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: _isAuthor
                  ? RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '\n\nThis calendar helps manage your booking appointments. There are two main color-coded indicators to represent the status of bookings\n\n',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          // TextSpan(
                          //   text: ' red ',
                          //   style: TextStyle(
                          //       backgroundColor: Colors.red.withOpacity(.5),
                          //       color: Colors.black,
                          //       fontSize: ResponsiveHelper.responsiveFontSize(
                          //           context, 12)),
                          // ),
                          // TextSpan(
                          //   text:
                          //       ' indicates booking request that you have rejected, the ',
                          //   style: Theme.of(context).textTheme.bodySmall,
                          // ),
                          TextSpan(
                            text: 'Yellow   ',
                            style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.yellow.withOpacity(.5),
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12)),
                          ),
                          TextSpan(
                            text: ' indicates a booking for an event.\n',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: 'Green   ',
                            style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.green.withOpacity(.5),
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12)),
                          ),
                          TextSpan(
                            text:
                                ' indicates a booking by another creative for creative work.\n\nThe',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: '  yellow   ',
                            style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.yellow.withOpacity(.2),
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12)),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(
                            text: '   green   ',
                            style: TextStyle(
                                color: Colors.black,
                                backgroundColor: Colors.green.withOpacity(.2),
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12)),
                          ),
                          TextSpan(
                            text:
                                ' indicators will initially appear faint when the booking requests are unanswered. ',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        _showBottomSheetManagerDonationDoc();
                      },
                      child: RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "\To initiate a booking request, please tap on the desired date on the calendar. Dates without any visual indicator signify that the creative has not yet been booked.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            TextSpan(
                              text: '\nmore.',
                              style: _blueSyle,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
        ],
      ),
    );
  }
}
