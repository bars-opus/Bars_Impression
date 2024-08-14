import 'package:bars/features/events/services/paystack_ticket_payment_mobile_money.dart';
import 'package:bars/utilities/exports.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class DiscographyWidget extends StatefulWidget {
  final String currentUserId;
  final int userIndex;
  final UserProfessionalModel userPortfolio;

  const DiscographyWidget({
    super.key,
    required this.currentUserId,
    required this.userIndex,
    required this.userPortfolio,
  });

  @override
  State<DiscographyWidget> createState() => _DiscographyWidgetState();
}

class _DiscographyWidgetState extends State<DiscographyWidget> {
  bool _isLoading = false;
  // List<WorkRequestOrOfferModel> _userWorkRequest = [];
  List<ReviewModel> _reviewList = [];
  // DocumentSnapshot? _lastInviteDocument;
  List<String> selectedTypes = [];
  bool _isBlockedUser = false;
  bool _isBlockingUser = false;
  double page = 0.0;
  int limit = 2;
  int hours = 0;
  int minutes = 0;
  bool _isLoadingSubmit = false;
  bool _isFecthingRatings = true;
  RatingModel? _userRatings;
  String selectedValue = '';
  final _textController = TextEditingController();
  final _overViewController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  final _donateAmountController = TextEditingController();
  final _donateReasonController = TextEditingController();
  final _donateAmountFormKey = GlobalKey<FormState>();
  bool isPayOutSetUp = false;
  bool creativeIsGhanaOrCurrencyGHS = false;
  bool currentUserGhanaOrCurrencyGHS = false;

  PageController _pageController2 = PageController(
    initialPage: 0,
  );
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onAskTextChanged);
    _donateAmountController.addListener(_onDonateChanged);
    _overViewController.addListener(_onAskTextChanged);
    _setupIsBlockedUser();
    _setupIsBlocking();
    _setUpReviews();
    _fetchRating();
    var _provider = Provider.of<UserData>(context, listen: false);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _clear(_provider);
      _addLists(_provider);
      _setCurrency(_provider);
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

  _setUpReviews() async {
    // try {
    Query ticketOrderSnapShot = await newReviewReceivedRef
        .doc(widget.userPortfolio.userId)
        .collection('reviews')
        // .where('timestamp', isGreaterThanOrEqualTo: currentDate)
        .orderBy('timestamp', descending: true)
        .limit(10);

    QuerySnapshot quey = await ticketOrderSnapShot.get();

    List<ReviewModel> affiliate =
        quey.docs.map((doc) => ReviewModel.fromDoc(doc)).toList();
    if (quey.docs.isNotEmpty) {
      // _lastInviteDocument = quey.docs.last;
    }
    if (mounted) {
      setState(() {
        _reviewList = affiliate;
        _isLoading = false;
      });
    }
    if (quey.docs.length < 10) {
      // _hasNext = false; // No more documents to load
    }

    return affiliate;
  }

  _clear(UserData provider) {
    if (mounted) {
      provider.setOverview('');
      provider.setTermsAndConditions('');
      provider.setCurrency('');
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
      provider.setBookingPriceRate(null);
    }
  }

  Future<void> _fetchRating() async {
    // Fetch the user data using whatever method you need
    var userSnapshot =
        await usersRatingRef.doc(widget.userPortfolio.userId).get();

    // Check if the snapshot contains data and if the user has a private account
    if (userSnapshot.exists) {
      RatingModel userRatings = RatingModel.fromDoc(userSnapshot);

      // Set state with the new user data to update the UI
      if (mounted) {
        setState(() {
          _userRatings = userRatings;
          _isFecthingRatings = false;
        });
      }
    } else {
      // Handle the case where the user data does not exist
      if (mounted) {
        setState(() {
          _userRatings = null;
          _isFecthingRatings = false;
        });
      }
    }
  }

  _setupIsBlockedUser() async {
    bool isBlockedUser = await DatabaseService.isBlockedUser(
      currentUserId: widget.currentUserId,
      userId: widget.userPortfolio.userId,
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
      userId: widget.userPortfolio.userId,
    );
    if (mounted) {
      setState(() {
        _isBlockingUser = isBlockingUser;
      });
    }
  }

  _setCurrency(UserData _provider) {
    UserSettingsLoadingPreferenceModel currentUserPayoutInfo =
        _provider.userLocationPreference!;

    bool _isPayOutSetUp = widget.userPortfolio.transferRecepientId.isNotEmpty;

    bool _creativeIsGhanaOrCurrencyGHS = IsGhanain.isGhanaOrCurrencyGHS(
        widget.userPortfolio.country, widget.userPortfolio.currency);

    bool _currentUserGhanaOrCurrencyGHS = IsGhanain.isGhanaOrCurrencyGHS(
        currentUserPayoutInfo.country!, currentUserPayoutInfo.currency!);
    setState(() {
      isPayOutSetUp = _isPayOutSetUp;
      creativeIsGhanaOrCurrencyGHS = _creativeIsGhanaOrCurrencyGHS;
      currentUserGhanaOrCurrencyGHS = _currentUserGhanaOrCurrencyGHS;
    });
  }

  _addLists(UserData provider) {
    processCurrency(provider);
    // var _provider = Provider.of<UserData>(context, listen: false);
    provider.setOverview(widget.userPortfolio.overview);
    provider.setTermsAndConditions(widget.userPortfolio.terms);
    provider.setNoBooking(widget.userPortfolio.noBooking);

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

  void processCurrency(UserData provider) {
    // Check if widget.userPortfolio.currency is null or empty
    if (widget.userPortfolio.currency == null ||
        widget.userPortfolio.currency.trim().isEmpty) {
      // Handle the case where currency is null or empty
      provider.setCurrency('');
      return;
    }

    // Proceed with normal processing if currency is not null or empty
    final List<String> currencyPartition =
        widget.userPortfolio.currency.trim().replaceAll('\n', ' ').split("|");

    String _currency = currencyPartition.length > 1 ? currencyPartition[1] : '';

    // Check if _currency has at least 3 characters before accessing _currency[2]
    if (_currency.length >= 2) {
      provider.setCurrency(_currency);
      // print(_currency);
    } else {
      // Handle the case where _currency does not have enough characters
      provider.setCurrency('');
    }
  }

  void _onAskTextChanged() {
    if (_textController.text.isNotEmpty &&
        _overViewController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  void _onDonateChanged() {
    if (_donateAmountController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  _setupWorkRequest() async {
    QuerySnapshot postFeedSnapShot = await userWorkRequestRef
        .doc(widget.userPortfolio.userId)
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
        // _userWorkRequest = posts;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _donateAmountController.dispose();
    _donateReasonController.dispose();
    _overViewController.dispose();
    _pageController2.removeListener(_listenScroll);
    _pageController2.dispose();
  }

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
    // _provider.setCurrency('');

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
          height: ResponsiveHelper.responsiveHeight(context, 700),
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
            image: CachedNetworkImageProvider(
              imageUrl,
              errorListener: (_) {
                return;
              },
            ),
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
              userId: widget.userPortfolio.userId,
              userName: widget.userPortfolio.userName,
              isBlocked: _isBlockedUser,
              isBlocking: _isBlockingUser,
              updateBlockStatus: () {
                setState(() {});
              },
              // user: widget.userPortfolio,
              disableAdvice: widget.userPortfolio.disableAdvice,
              hideAdvice: widget.userPortfolio.hideAdvice,
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
                userId: widget.userPortfolio.userId,
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
                  textScaler: MediaQuery.of(context).textScaler,
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

  _generateDonationData(
    String purchaseReferenceId,
    String transactionId,
  ) async {
    // var _user = Provider.of<UserData>(context, listen: false).user;
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

    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      double _amount = double.tryParse(_donateAmountController.text) ?? 0;
      DonationModel _donation = DonationModel(
        id: commonId,
        timestamp: Timestamp.fromDate(DateTime.now()),
        donerId: widget.currentUserId,
        receiverId: widget.userPortfolio.userId,
        reason: _donateReasonController.text.trim(),
        amount: _amount,
        userName: widget.userPortfolio.userName,
      );
      try {
        await retry(
            () => _createTicketOrder(
                  _donation,
                  batch,
                ),
            retries: 3);

        _donateAmountController.clear();
        _donateReasonController.clear();

        _showBottomSheetPayoutSuccessful(_amount);
      } catch (e) {}

      await batch.commit();
    } catch (e) {
      _showBottomSheetErrorMessage('', e);
    } finally {
      _endLoading();
    }
  }

  Future<DonationModel> _createTicketOrder(
    DonationModel donation,
    WriteBatch batch,
  ) async {
    var _user = Provider.of<UserData>(context, listen: false).user;

    DatabaseService.createDonationBatch(
        donation: donation, batch: batch, user: _user!);

    return donation;
  }

  void _endLoading() {
    if (mounted) {
      setState(() {
        _isLoadingSubmit = false; // Set isLoading to false
      });
    }
  }

  void _showBottomSheetPayoutSuccessful(double amount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return PayoutSuccessWidget(
            payout: false,
            amount: amount.toInt(),
          );
        });
      },
    );
  }

  void _initiatePayment() async {
    var _provider = Provider.of<UserData>(context, listen: false);
    // UserSettingsLoadingPreferenceModel? creative =
    //     await DatabaseService.getUserLocationSettingWithId(
    //         widget.userPortfolio.userId);

    UserSettingsLoadingPreferenceModel? creative =
        _provider.userLocationPreference;

    if (creative == null) {
      return _showBottomSheetErrorMessage('', 'Failed to initiate payment');
    }
    final inputText = _donateAmountController.text;

    double totalPrice = double.tryParse(inputText) ?? 0;
    ;
    String email = FirebaseAuth.instance.currentUser!.email!;
    int amount = totalPrice.toInt(); // Amount in kobo

    final HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('initiatePaystackMobileMoneyPayment');

    // Call the function to initiate the payment
    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'email': email,
      'amount': amount * 100, // Assuming this is the correct amount in kobo
      'subaccount': creative.subaccountId,
      'bearer': 'split',
      'callback_url': widget.userPortfolio.dynamicLink,
      'reference': _getReference(),
    });

    // Extract the authorization URL from the results
    final String authorizationUrl = result.data['authorizationUrl'];
    final bool success = result.data['success'];
    final String reference = result.data['reference'];

    // Navigate to the payment screen with the authorization URL
    if (success) {
      await navigateToPaymentScreen(
          context, authorizationUrl, reference, amount);
    } else {
      // Handle error
      _showBottomSheetErrorMessage(
          '', 'Failed to initiate payment\n${result.toString()}');
    }
  }

  String _getReference() {
    String commonId = Uuid().v4();
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_$commonId';
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

  Future<void> navigateToPaymentScreen(BuildContext context,
      String authorizationUrl, String reference, int totalPrice) async {
    PaymentResult? paymentResult = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PaystackPaymentScreen(authorizationUrl: authorizationUrl),
      ),
    );

    if (paymentResult == null) {
      Navigator.pop(context);
      _showBottomSheetErrorMessage(
          '', "Payment was not completed.\nPlease try again.");
      return; // Early return to stop further processing
    }

    // If the initial Paystack payment is successful, verify it server-side
    if (paymentResult.success) {
      // _provider.setIsLoading(true); // Start the loading indicator
      Navigator.pop(context);
      _showBottomSheetLoading('Verifying payment');
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('verifyPaystackPayment');
      try {
        final verificationResult = await callable.call(<String, dynamic>{
          'reference': reference,
          'eventId': widget.userPortfolio.userId,
          'isEvent': false,
          'amount': totalPrice.toInt() * 100,
        });

        // If server-side verification is successful, generate tickets
        if (verificationResult.data['success']) {
          var transactionId =
              verificationResult.data['transactionData']['id'].toString();
          Navigator.pop(context);
          Navigator.pop(context);
          _showBottomSheetLoading('Initializing payment');

          await _generateDonationData(
            paymentResult.reference,
            transactionId.toString(),
          );
        } else {
          Navigator.pop(context);

          _showBottomSheetErrorMessage('', 'Couldn\'t verify your donation');
        }
      } catch (e) {
        Navigator.pop(context);
        _showBottomSheetErrorMessage('', 'Couldn\'t verify your donation');
      }
    } else {
      _showBottomSheetErrorMessage('', 'Couldn\'t verify your donation');
    }
  }

  void _showBottomConfirmDonation() {
    String amount = _donateAmountController.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          height: 300,
          buttonText: 'Donate',
          onPressed: () async {
            Navigator.pop(context);
            _showBottomSheetLoading('initializing payment');
            Navigator.pop(context);
            _initiatePayment();
          },
          title: 'Confirm amount',
          subTitle:
              'You are about to donate GHC $amount to support ${widget.userPortfolio.userName}',
        );
      },
    );
  }

  void _showBottomSheetManagerDonationDoc(
    bool isDonation,
    bool isCreating,
    VoidCallback onPressed,
  ) {
    final bool _isAuthor = widget.currentUserId == widget.userPortfolio.userId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
            valueListenable: _isTypingNotifier,
            builder: (BuildContext context, bool isTyping, Widget? child) {
              return Form(
                key: _donateAmountFormKey,
                child: Container(
                  height: ResponsiveHelper.responsiveHeight(context, 700),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(30)),
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ManagerDonationDoc(
                        isDonation: isDonation,
                        isCreating: isCreating,
                        isCurrentUser: _isAuthor,
                      )),
                ),
              );
            });
      },
    );
  }

  void _showBottomSheetDonate() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ValueListenableBuilder(
            valueListenable: _isTypingNotifier,
            builder: (BuildContext context, bool isTyping, Widget? child) {
              return Form(
                key: _donateAmountFormKey,
                child: Container(
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
                        _donateAmountController.text.isNotEmpty
                            ? Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 0.0),
                                  child: MiniCircularProgressButton(
                                      color: Colors.blue,
                                      text: 'Continue',
                                      onPressed: () {
                                        _showBottomConfirmDonation();
                                      }),
                                ),
                              )
                            : SizedBox(
                                height: 50,
                              ),

                        const SizedBox(height: 20),
                        DonationHeaderWidget(
                          title: 'Donate',
                          iconColor: Colors.green[800] ?? Colors.green,
                          icon: MdiIcons.giftOutline,
                        ),

                        UnderlinedTextField(
                          isNumber: true,
                          controler: _donateAmountController,
                          labelText: 'Amount',
                          hintText: 'Amount to donate',
                          onValidateText: () {},
                        ),
                        UnderlinedTextField(
                          autofocus: false,
                          controler: _donateReasonController,
                          labelText: 'Reason',
                          hintText: 'Reason for donation',
                          onValidateText: () {},
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        RichText(
                          textScaler: MediaQuery.of(context).textScaler,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    'Donations are a meaningful way to encourage and empower the creatives on our platform. When you make a donation, you are contributing to their growth and success, without any expectations of favors or gratifications in return.Creatives do not owe you any favors or special treatment when you make a donation. Donations are a free-willed act, and the creatives are not obligated to provide any additional services or benefits. Once you have made a donation, it is non-refundable. Please consider your donation carefully before proceeding. The minimum donation amount is 10 GHC. You can donate any amount above this minimum.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 300,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
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

  _messageButton(String text, VoidCallback onPressed, bool isBooking) {
    final width = MediaQuery.of(context).size.width;
    bool isCurrentUser =
        widget.currentUserId == widget.userPortfolio.userId && isBooking;
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
    final bool _isAuthor = widget.currentUserId == widget.userPortfolio.userId;

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
                                              ),
                                            )
                                          : from.startsWith('collaborations')
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30.0),
                                                  child:
                                                      PortfolioCollaborationWidget(
                                                    edit: false,
                                                    seeMore: true,
                                                    collaborations: _provider
                                                        .collaborations,
                                                  ),
                                                )
                                              : from.startsWith('review')
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 30.0),
                                                      child:
                                                          _buildDisplayReviewList(
                                                              context),
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
        Divider(
          thickness: .2,
        ),
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

  _navigateToProfile() {
    return _navigateToPage(
        context,
        ProfileScreen(
          currentUserId: widget.currentUserId,
          userId: widget.userPortfolio.userId,
          user: null,
        ));
  }

  _authorWidget() {
    final width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        width: ResponsiveHelper.responsiveWidth(context, width),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            widget.userPortfolio.profileImageUrl.isEmpty
                ? GestureDetector(
                    onTap: () {
                      _navigateToProfile();
                    },
                    child: Icon(
                      Icons.account_circle,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      _navigateToProfile();
                    },
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Colors.blue,
                      backgroundImage: CachedNetworkImageProvider(
                          widget.userPortfolio.profileImageUrl),
                    ),
                  ),
            SizedBox(width: 10),
            Expanded(
              // Add this
              child: GestureDetector(
                onTap: () {
                  _navigateToProfile();
                },
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
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // Adjust as necessary
                      overflow: TextOverflow.ellipsis, // Add this
                    ),
                  ],
                ),
              ),
            ),
            if (!_isBlockingUser && !_isBlockedUser)
              IconButton(
                onPressed: () {
                  _showBottomSheet();
                },
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: ResponsiveHelper.responsiveHeight(context, 20),
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheetBookingCalendar(bool fromPrice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookingCalendar(
          currentUserId: widget.currentUserId,
          bookingUser: widget.userPortfolio,
          prices: widget.userPortfolio.priceTags,
          fromPrice: fromPrice,
        );
      },
    );
  }

  _buildReview(BuildContext context, ReviewModel review, bool fullWidth) {
    // var _currentUserId =
    //     Provider.of<UserData>(context, listen: false).currentUserId;

    return ReviewWidget(
      review: review,
      fullWidth: fullWidth,
    );
  }

  _buildDisplayReviewList(BuildContext context) {
    List<Widget> forumViews = [];
    _reviewList.forEach((portfolio) {
      forumViews.add(_buildReview(context, portfolio, true));
    });
    return Column(children: forumViews);
  }

  _buildDisplayReviewGrid(
    BuildContext context,
  ) {
    List<Widget> tiles = [];
    _reviewList
        .forEach((people) => tiles.add(_buildReview(context, people, false)));

    return _reviewList.isEmpty
        ? Center(
            child: Text(
              'No reviews yet',
              style: TextStyle(
                color: Colors.grey,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
                fontWeight: FontWeight.bold,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : Container(
            color: Theme.of(context).primaryColorLight,
            height: ResponsiveHelper.responsiveHeight(context, 140),
            child: GridView.count(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              crossAxisCount: 1, // Items down the screen
              mainAxisSpacing: 2.0,
              crossAxisSpacing: 2.0,
              childAspectRatio:
                  0.4, // Adjust this to change the vertical size, smaller number means smaller height
              children: tiles,
            ),
          );
  }

  _donationButton(
    String buttonText,
    IconData icon,
    Color color,
    VoidCallback onPressed,
    bool small,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            child: Icon(
              icon,
              size: ResponsiveHelper.responsiveHeight(context, 25),
              color: color,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            buttonText,
            style: TextStyle(
              color: color,
              fontSize:
                  ResponsiveHelper.responsiveFontSize(context, small ? 12 : 14),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showCurrencyPicker() {
    UserData _provider = Provider.of<UserData>(context, listen: false);

    final UserSettingsLoadingPreferenceModel _user =
        _provider.userLocationPreference!;

    showCurrencyPicker(
      theme: CurrencyPickerThemeData(
        backgroundColor: Theme.of(context).primaryColorLight,
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
        _provider.setCurrency('${currency.name} | ${currency.code}');
        WriteBatch batch = FirebaseFirestore.instance.batch();

        batch.update(
          usersLocationSettingsRef.doc(_user.userId),
          {
            'currency': _provider.currency,
          },
        );
        batch.update(
          userProfessionalRef.doc(_user.userId),
          {
            'currency': _provider.currency,
          },
        );
        try {
          batch.commit();
          _updateAuthorHive();
        } catch (error) {
          _showBottomSheetErrorMessage('', 'Failed to update currency');
        }
      },
      favorite: _provider.userLocationPreference!.country == 'Ghana'
          ? ['GHS']
          : ['USD'],
    );
  }

  _updateAuthorHive() async {
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
      city: _provider.userLocationPreference!.city,
      continent: _provider.userLocationPreference!.continent,
      country: _provider.userLocationPreference!.country,
      currency: _provider.currency,
      timestamp: _provider.userLocationPreference!.timestamp,
      subaccountId: _provider.userLocationPreference!.subaccountId,
      transferRecepientId:
          _provider.userLocationPreference!.transferRecepientId,
    );

    // Put the new object back into the box with the same key
    locationPreferenceBox.put(
        updatedLocationPreference.userId, updatedLocationPreference);
  }

  void _showBottomSheetNoCurrency(bool isCurrency) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    UserSettingsLoadingPreferenceModel currentUserPayoutInfo =
        _provider.userLocationPreference!;

    bool _isCurrentUser = widget.currentUserId == widget.userPortfolio.userId;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NoContents(
                      title: isCurrency ? 'No currency' : 'Enter your city',
                      subTitle: isCurrency
                          ? _isCurrentUser
                              ? 'Please enter your currency to be able to receive donations and to use the booking manager to handel your booking requests. Please note that the Booking Manager is only supported for GHC at this time. '
                              : 'To book ${widget.userPortfolio.userName}\' services using the Booking Manager, please enter your currency. Please note that the Booking Manager is only supported for GHC at this time. '
                          : 'Enter your location to setup your booking portfolio. When you enter your city, we can suggest local events taking place in that area, as well as connect you with other creatives who are also based in the same location. This facilitates meaningful connections and creates opportunities for potential business collaborations and networking.',
                      icon: isCurrency
                          ? Icons.attach_money_outlined
                          : Icons.location_on_outlined),
                  SizedBox(
                    height: ResponsiveHelper.responsiveHeight(context, 30),
                  ),
                  BlueOutlineButton(
                    buttonText:
                        isCurrency ? 'Select currency' : 'Enter country',
                    onPressed: () {
                      Navigator.pop(context);
                      isCurrency
                          ? _showCurrencyPicker()
                          : _navigateToPage(
                              context,
                              EditProfileSelectLocation(
                                notFromEditProfile: true,
                                user: currentUserPayoutInfo,
                              ),
                            );
                    },
                  ),
                  const SizedBox(height: 10),
                  if (isCurrency && !_isCurrentUser)
                    BlueOutlineButton(
                      buttonText: 'Contact creative directly',
                      onPressed: () {
                        Navigator.pop(context);
                        _showBottomSheetBookMe();
                      },
                    ),
                ],
              )),
        );
      },
    );
  }

  _bookingAndDonateButtons() {
    var _provider = Provider.of<UserData>(context, listen: false);

    bool _isCurrentUser = widget.currentUserId == widget.userPortfolio.userId;
    UserSettingsLoadingPreferenceModel currentUserPayoutInfo =
        _provider.userLocationPreference!;

    // print(currentUserPayoutInfo.currency! + 'currency');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
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
                          Chat? _chat = await DatabaseService.getUserChatWithId(
                            widget.currentUserId,
                            widget.userPortfolio.userId,
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
                          color: Colors.blue,
                        ),
                      )
                    : _isCurrentUser
                        ? Icon(
                            MdiIcons.thoughtBubbleOutline,
                            color: Theme.of(context).secondaryHeaderColor,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 25),
                          )
                        : Icon(
                            Icons.message_outlined,
                            color: Theme.of(context).secondaryHeaderColor,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 25),
                          ),
              ),
            ),
          const SizedBox(
            height: 10,
          ),
          if (!_isBlockingUser && !_isBlockedUser)
            _messageButton(
              _isCurrentUser
                  ? currentUserGhanaOrCurrencyGHS
                      ? 'Booking manager'
                      : 'Booking contact'
                  : 'Book ${widget.userPortfolio.userName}',
              () {
                _showBottomSheetBookMe();
              },
              // _isCurrentUser
              //     ? () {
              //         currentUserGhanaOrCurrencyGHS
              //             ? isPayOutSetUp
              //                 ? _showBottomSheetBookingCalendar(false)
              //                 : _showBottomSheetManagerDonationDoc(
              //                     false, true, () {})
              //             : currentUserPayoutInfo.country!.isEmpty
              //                 ? _showBottomSheetNoCurrency(false)
              //                 : currentUserPayoutInfo.country == 'Ghana' &&
              //                         currentUserPayoutInfo.currency!.isEmpty
              //                     ? _showBottomSheetNoCurrency(true)
              //                     : _showBottomSheetBookMe();
              //       }
              //     : () {
              //         creativeIsGhanaOrCurrencyGHS &&
              //                 currentUserGhanaOrCurrencyGHS &&
              //                 currentUserPayoutInfo.currency!.isNotEmpty
              //             ? _showBottomSheetBookingCalendar(false)
              //             : currentUserPayoutInfo.country == 'Ghana' &&
              //                     currentUserPayoutInfo.currency!.isEmpty
              //                 ? _showBottomSheetNoCurrency(true)
              //                 : _showBottomSheetBookMe();

              //         ;
              //       },
              true,
            ),
          // const SizedBox(
          //   height: 20,
          // ),
          // if (creativeIsGhanaOrCurrencyGHS)
          //   if (currentUserPayoutInfo.country == 'Ghana')
          //     _isCurrentUser
          //         ? _donationButton(
          //             "See donations",
          //             Icons.payment,
          //             Colors.green[800] ?? Colors.green,
          //             () {
          //               isPayOutSetUp
          //                   ? _navigateToPage(
          //                       context,
          //                       UserDonations(
          //                         currentUserId: widget.currentUserId,
          //                       ),
          //                     )
          //                   : currentUserPayoutInfo.currency!.isEmpty
          //                       ? _showBottomSheetNoCurrency(true)
          //                       : _showBottomSheetManagerDonationDoc(
          //                           true, true, () {});
          //             },
          //             false,
          //           )
          //         : _donationButton(
          //             'Donate',
          //             Icons.payment,
          //             Colors.green[800] ?? Colors.green,
          //             () {
          //               currentUserPayoutInfo.currency!.isEmpty
          //                   ? _showCurrencyPicker()
          //                   : _showBottomSheetDonate();
          //             },
          //             false,
          //           ),
          if (currentUserPayoutInfo.city!.isEmpty)
            _donationButton(
              'To be discoverd, enter you city',
              Icons.location_on_outlined,
              Colors.blue,
              () {
                _navigateToPage(
                  context,
                  EditProfileSelectLocation(
                    notFromEditProfile: true,
                    user: currentUserPayoutInfo,
                  ),
                );
              },
              true,
            ),
          // if (creativePayoutInfo.country == 'Ghana')
          //   if (creativePayoutInfo.currency!.isEmpty)
          //     _donationButton(
          //       'Enter your currency',
          //       Icons.location_on_outlined,
          //       Colors.blue,
          //       () {},
          //       true,
          //     ),
          if (_provider.overview.isNotEmpty)
            Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                GestureDetector(
                    onTap: () {
                      _showBottomSheetReadMore('Overview', _provider.overview);
                    },
                    child: Text(
                      _provider.overview,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    )),
                Divider(
                  thickness: .2,
                  height: 50,
                ),
              ],
            )
        ],
      ),
    );
  }

  _termsAndBelow() {
    var _provider = Provider.of<UserData>(
      context,
    );
    bool _isCurrentUser = widget.currentUserId == widget.userPortfolio.userId;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          _divider('Terms and conditions', '', false),
          GestureDetector(
              onTap: () {
                _showBottomSheetReadMore(
                    'Terms and Conditions', _provider.termAndConditions);
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
                  ? 'Your contacts '
                  : 'Contact ${widget.userPortfolio.userName} directly ',
              () {
                HapticFeedback.mediumImpact();
                _showBottomSheetBookMe();
              },
              false,
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
                    widget.userPortfolio.userId,
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
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              _navigateToPage(
                  context,
                  UserBarcode(
                    profileImageUrl: widget.userPortfolio.profileImageUrl,
                    userDynamicLink: widget.userPortfolio.dynamicLink,
                    bio: widget.userPortfolio.overview,
                    userName: widget.userPortfolio.userName,
                    userId: widget.userPortfolio.userId,
                  ));
            },
            child: Hero(
                tag: widget.userPortfolio.userId,
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
                      parentContentId: widget.userPortfolio.userId,
                      repotedAuthorId: widget.userPortfolio.userId,
                      contentId: widget.userPortfolio.userId,
                      contentType: widget.userPortfolio.userName,
                    ));
              },
              child: Material(
                  color: Colors.transparent,
                  child: Text('Report  ',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
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
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
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
    );
  }

  _basicInfo() {
    var _provider = Provider.of<UserData>(
      context,
    );
    bool _isCurrentUser = widget.currentUserId == widget.userPortfolio.userId;

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Container(
        // decoration: BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              _bookingAndDonateButtons(),
              // Container(
              //   color: Theme.of(context).cardColor,
              //   height: ResponsiveHelper.responsiveHeight(context, 150),
              //   width: double.infinity,
              //   child: Center(
              //     child: SingleChildScrollView(
              //       physics: const NeverScrollableScrollPhysics(),
              //       child: RatingAggregateWidget(
              //         isCurrentUser: _isCurrentUser,
              //         starCounts: _userRatings == null
              //             ? {
              //                 5: 0,
              //                 4: 0,
              //                 3: 0,
              //                 2: 0,
              //                 1: 0,
              //               }
              //             : {
              //                 5: _userRatings!.fiveStar,
              //                 4: _userRatings!.fourStar,
              //                 3: _userRatings!.threeStar,
              //                 2: _userRatings!.twoStar,
              //                 1: _userRatings!.oneStar,
              //               },
              //       ),
              //     ),
              //   ),
              // ),
              // _divider('Reviews', 'review',
              //     _provider.company.length >= 4 ? true : false),
              // if (!_isFecthingRatings) _buildDisplayReviewGrid(context),
              _divider('Price list', 'price',
                  _provider.priceRate.length >= 2 ? false : false),
              if (_provider.bookingPriceRate != null && !_isCurrentUser)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_provider.currency} ${_provider.bookingPriceRate!.price.toString()}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30.0, right: 10),
                        child: MiniCircularProgressButton(
                            color: Colors.blue,
                            text: 'Book',
                            onPressed: () {
                              _showBottomSheetBookingCalendar(true);
                            }),
                      ),
                    ),
                  ],
                ),
              PriceRateWidget(
                edit: false,
                prices: _provider.priceRate,
                seeMore: true,
                // currency: _provider,
              ),
              _divider('Company', 'company',
                  _provider.company.length >= 4 ? true : false),
              PortfolioCompanyWidget(
                portfolios: _provider.company,
                seeMore: false,
                edit: false,
              ),
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
              _divider('Collaborations', 'collaborations',
                  _provider.collaborations.length >= 4 ? true : false),
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
              _termsAndBelow(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: Colors.black,
              expandedHeight: ResponsiveHelper.responsiveHeight(context, 350),
              flexibleSpace: Container(
                width: double.infinity,
                child: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                      bottom: ResponsiveHelper.responsiveFontSize(context, 20)),
                  title: _authorWidget(),
                  centerTitle: false,
                  expandedTitleScale: 1,
                  background: PageView(
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
        body: _basicInfo(),
      ),
    );
  }
}
