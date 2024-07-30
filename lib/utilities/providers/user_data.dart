import 'package:bars/services/location_services/places_service.dart';
import 'package:bars/utilities/exports.dart';

class UserData extends ChangeNotifier {
  String? currentUserId;
  late String _artist;
  late String _caption;
  late String _musicLink;
  late String _punchline;
  late String hashTagg;
  late String _storeSearchTerm;
  late String _title;
  late String _theme;
  late String _host;
  late String _venue;
  late String _address;
  late String _type;
  late String _category;
  late String _subCategory;
  late String _dj;
  late Timestamp _startDate;
  late Timestamp _sheduleDateTemp;
  late Timestamp _clossingDay;
  late String _startDateString;
  late String _clossingDayString;
  late String _city;
  late String _country;
  late String _continent;
  late String _rate;
  late String _currency;
  late String _ticketNames;
  late String _clossingDate;
  late String _imageUrl;
  late String _eventTermsAndConditions;
  late String _dressingCode;
  late String _ticketSite;
  late bool _isPrivate;
  late bool _isAffiliateEnabled;
  late bool _isAffiliateExclusive;
  late String _marketedAffiliateId;
  late bool _showToFollowers;
  late bool _isVirtual;
  late bool _isFree;
  late bool _isCashPayment;

  late bool _isExternalTicketPayment;

  late Timestamp _sheduleTimestamp;
  late bool _couldntDecodeCity;
  List<Schedule> _schedule = [];
  List<TicketModel> _ticket = [];
  late bool _startDateSelected;
  late bool _endDateSelected;
  late bool _startTimeSelected;
  late bool _endTimeSelected;
  late AccountHolderAuthor? _user;
  late UserSettingsLoadingPreferenceModel? _userLocationPreference;
  late UserSettingsGeneralModel? _userGeneraSentence;
  late String _bio;
  late String _name;
  late String _password;
  late bool _noBooking;
  late String _overview;
  late String _termAndConditions;
  late String _email;
  late String _profrilehandle;
  late String _dressCode;
  late String _previousEvent;
  late ChatMessage? _replyChatMessage;
  late EventRoomMessageModel? _replyEventRoomMessage;
  late String _messageAuthorId;
  late bool _bool5;
  late bool _bool6;
  late bool _isSendigChat;
  late bool _isChatRoomScrollVisible;
  late String _chatMessageId;
  List<PortfolioModel> _performances = [];
  List<PortfolioModel> _awards = [];
  List<PortfolioModel> _linksToWork = [];
  List<PortfolioModel> _skills = [];
  List<PortfolioModel> _genreTages = [];
  List<PortfolioCompanyModel> _company = [];
  List<String> _professionalImages = [];
  List<String> _eventOrganizerContacts = [];
  late String _workRequestoverView;
  late String _changeNewUserName;
  late bool _workRequestisEvent;
  late double _workRequestPrice;
  late int _affiliatecommission;
  List<String> _workRequestGenre = [];
  List<String> _workRequesttype = [];
  List<String> _workRequestAvailableLocations = [];
  List<PortfolioContactModel> _bookingContacts = [];
  List<PortfolioCollaborationModel> _collaborations = [];
  List<CollaboratedPeople> _collaboratedPeople = [];
  List<PriceModel> _priceRate = [];
  late int _messageCount;
  late int _chatCount;
  Future<QuerySnapshot>? _userStoreSearchSnapShot;
  Future<QuerySnapshot>? _eventStoreSearchSnapShot;
  Future<QuerySnapshot>? _postStoreSearchSnapShot;
  late String _searchInput;
  final placesService = PlacesService();
  final addressService = AddressService();
  List<PlaceSearch>? searchResults;
  List<AddressSearch>? addressSearchResults;
  late String _latLng;
  late int _int1;
  late int _creatIconIndex;
  late bool _creatIconIsSelected;
  List<TaggedEventPeopleModel> _taggedEventPeople = [];
  List<SchedulePeopleModel> _schedulePerson = [];
  List<TicketModel> _ticketList = [];
  late int _notificaitonTab;
  late bool _showEventTab;
  late bool _showUsersTab;
  late bool _shortcutBool;
  late bool _isLoading;
  late bool _enlargeStartBarcode;
  late bool _enlargeEndBarcode;
  late File? _postImage;
  late File? _eventImage;
  late File? _messageImage;
  late PriceModel? _bookingPriceRate;
  late File? _image;
  late List? _message;
  late List? _event;
  late int _activityCount;
  late PickedFile? _videoFile1;
  late PendingDynamicLinkData? _dynamicLink;
  late String _availableDynamicLink;
  late bool _loadingThisWeekEvent;
  late File? _professionalImageFile1;
  late File? _professionalImageFile2;
  late File? _professionalImageFile3;

  UserData() {
    _title = '';
    _storeSearchTerm = '';
    _artist = '';
    _caption = '';
    _theme = '';
    _musicLink = '';
    hashTagg = '';
    _punchline = '';
    _host = '';
    _venue = '';
    _address = '';
    _type = '';
    _category = '';
    _subCategory = '';
    _eventTermsAndConditions = '';
    _dressCode = '';
    _previousEvent = '';
    _dj = '';
    _city = '';
    _country = '';
    _continent = '';
    _rate = '';
    _currency = '';
    _marketedAffiliateId = '';
    _clossingDate = '';
    _imageUrl = '';
    _dressingCode = '';
    _overview = '';
    _ticketSite = '';
    _password = '';
    _bio = '';
    _name = '';
    _company = [];
    _noBooking = false;
    _termAndConditions = '';
    _email = '';
    _profrilehandle = '';
    _ticketNames = '';
    _startDate = Timestamp.fromDate(DateTime.now());
    _sheduleDateTemp = Timestamp.fromDate(DateTime.now());
    _clossingDay = Timestamp.fromDate(DateTime.now());
    _startDateString = '';
    _clossingDayString = '';
    _replyChatMessage = null;
    _replyEventRoomMessage = null;
    _chatMessageId = '';
    _messageAuthorId = '';
    _searchInput = '';
    _int1 = 0;
    _activityCount = 0;
    _availableDynamicLink = '';
    _user = null;
    _userGeneraSentence = null;
    _userLocationPreference = null;
    _messageCount = 0;
    _showEventTab = true;
    _showUsersTab = true;
    _isPrivate = false;
    _isAffiliateEnabled = false;
    _isAffiliateExclusive = false;
    _showToFollowers = true;
    _isVirtual = false;
    _isFree = false;
    _couldntDecodeCity = false;
    _isCashPayment = false;
    _isExternalTicketPayment = false;
    _sheduleTimestamp = Timestamp.now();
    _bool5 = false;
    _isChatRoomScrollVisible = false;
    _bool6 = false;
    _isSendigChat = false;
    _startDateSelected = false;
    _endDateSelected = false;
    _startTimeSelected = false;
    _endTimeSelected = false;
    _creatIconIsSelected = false;
    _shortcutBool = false;
    _loadingThisWeekEvent = true;
    _isLoading = false;
    _chatCount = 0;
    _workRequestoverView = '';
    _changeNewUserName = '';
    _latLng = '';
    _workRequestPrice = 0.0;
    _affiliatecommission = 0;
    _notificaitonTab = 0;
    _creatIconIndex = 0;
    _workRequestisEvent = false;
    _postImage = null;
    _eventImage = null;
    _messageImage = null;
    _bookingPriceRate = null;
    _image = null;
    _professionalImageFile1 = null;
    _professionalImageFile2 = null;
    _professionalImageFile3 = null;
    _videoFile1 = null;
    _message = [];
    _schedule = [];
    _ticket = [];
    _taggedEventPeople = [];
    _schedulePerson = [];
    _ticketList = [];
    _performances = [];
    _collaborations = [];
    _priceRate = [];
    _awards = [];
    _bookingContacts = [];
    _collaboratedPeople = [];
    _linksToWork = [];
    _skills = [];
    _genreTages = [];
    _professionalImages = [];
    _eventOrganizerContacts = [];
    _workRequestGenre = [];
    _workRequesttype = [];
    _workRequestAvailableLocations = [];
    _userStoreSearchSnapShot = null;
    _eventStoreSearchSnapShot = null;
    _postStoreSearchSnapShot = null;
    _enlargeStartBarcode = false;
    _enlargeEndBarcode = false;

    _event = [];
    _dynamicLink = null;
  }

  String get title => _title;
  String get storeSearchTerm => _storeSearchTerm;
  String get artist => _artist;
  String get caption => _caption;
  String get theme => _theme;
  String get musicLink => _musicLink;
  String get hashTagTagg => hashTagg;
  String get punchline => _punchline;
  String get host => _host;
  String get venue => _venue;
  String get address => _address;
  String get type => _type;
  String get category => _category;
  String get subCategory => _subCategory;
  String get eventTermsAndConditions => _eventTermsAndConditions;
  String get currency => _currency;
  String get marketedAffiliateId => _marketedAffiliateId;
  String get latLng => _latLng;
  String get city => _city;
  String get country => _country;
  String get continent => _continent;
  String get rate => _rate;
  String get clossingDate => _clossingDate;
  String get ticketNames => _ticketNames;
  String get dressCode => _dressCode;
  String get previousEvent => _previousEvent;
  String get dj => _dj;
  Timestamp get startDate => _startDate;
  Timestamp get sheduleDateTemp => _sheduleDateTemp;
  Timestamp get clossingDay => _clossingDay;
  String get startDateString => _startDateString;
  String get clossingDayString => _clossingDayString;
  String get bio => _bio;
  String get name => _name;
  String get password => _password;
  bool get noBooking => _noBooking;
  String get termAndConditions => _termAndConditions;
  String get email => _email;
  String get profrilehandle => _profrilehandle;
  String get overview => _overview;
  String get imageUrl => _imageUrl;
  String get dressingCode => _dressingCode;
  String get ticketSite => _ticketSite;
  EventRoomMessageModel? get replyEventRoomMessage => _replyEventRoomMessage;
  ChatMessage? get replyChatMessage => _replyChatMessage;
  String get chatMessageId => _chatMessageId;
  String get messageAuthorId => _messageAuthorId;
  String get searchInput => _searchInput;
  int get int1 => _int1;
  int get activityCount => _activityCount;
  String get availableDynamicLink => _availableDynamicLink;
  double get workRequestPrice => _workRequestPrice;
  int get affiliatecommission => _affiliatecommission;
  int get notificaitonTab => _notificaitonTab;
  int get creatIconIndex => _creatIconIndex;
  bool get workRequestisEvent => _workRequestisEvent;
  bool get showEventTab => _showEventTab;
  bool get showUsersTab => _showUsersTab;
  bool get isPrivate => _isPrivate;
  bool get isAffiliateEnabled => _isAffiliateEnabled;
  bool get isAffiliateExclusive => _isAffiliateExclusive;
  bool get showToFollowers => _showToFollowers;
  String get workRequestoverView => _workRequestoverView;
  String get changeNewUserName => _changeNewUserName;
  bool get isVirtual => _isVirtual;
  bool get isFree => _isFree;
  bool get couldntDecodeCity => _couldntDecodeCity;
  bool get isCashPayment => _isCashPayment;
  bool get isExternalTicketPayment => _isExternalTicketPayment;
  bool get startDateSelected => _startDateSelected;
  bool get endDateSelected => _endDateSelected;
  bool get startTimeSelected => _startTimeSelected;
  bool get endTimeSelected => _endTimeSelected;
  Timestamp get sheduleTimeStamp => _sheduleTimestamp;
  bool get bool5 => _bool5;
  bool get isChatRoomScrollVisible => _isChatRoomScrollVisible;
  bool get bool6 => _bool6;
  bool get isSendigChat => _isSendigChat;
  bool get creatIconIsSelected => _creatIconIsSelected;
  bool get shortcutBool => _shortcutBool;
  bool get loadingThisWeekEvent => _loadingThisWeekEvent;
  bool get isLoading => _isLoading;
  bool get enlargeStartBarcode => _enlargeStartBarcode;
  bool get enlargeEndBarcode => _enlargeEndBarcode;

  File? get postImage => _postImage;
  File? get messageImage => _messageImage;
  PriceModel? get bookingPriceRate => _bookingPriceRate;
  File? get eventImage => _eventImage;
  File? get professionalImageFile1 => _professionalImageFile1;
  File? get professionalImageFile2 => _professionalImageFile2;
  File? get professionalImageFile3 => _professionalImageFile3;
  File? get image => _image;
  PickedFile? get videoFile1 => _videoFile1;
  AccountHolderAuthor? get user => _user;
  UserSettingsGeneralModel? get userGeneraSentenceser => _userGeneraSentence;
  UserSettingsLoadingPreferenceModel? get userLocationPreference =>
      _userLocationPreference;
  int get messageCount => _messageCount;
  List? get message => _message;
  List<Schedule> get schedule => _schedule;
  List<TicketModel> get ticket => _ticket;
  List<TaggedEventPeopleModel> get taggedEventPeople => _taggedEventPeople;
  List<SchedulePeopleModel> get schedulePerson => _schedulePerson;
  List<TicketModel> get ticketList => _ticketList;
  List<PortfolioModel> get performances => _performances;
  List<PortfolioCollaborationModel> get collaborations => _collaborations;
  List<PriceModel> get priceRate => _priceRate;
  List<PortfolioModel> get awards => _awards;
  List<PortfolioModel> get linksToWork => _linksToWork;
  List<PortfolioModel> get skills => _skills;
  List<PortfolioModel> get genreTages => _genreTages;
  List<PortfolioCompanyModel> get company => _company;
  List<PortfolioContactModel> get bookingContacts => _bookingContacts;
  List<CollaboratedPeople> get collaboratedPeople => _collaboratedPeople;
  List<String> get professionalImages => _professionalImages;
  List<String> get eventOrganizerContacts => _eventOrganizerContacts;
  List<String> get workRequestGenre => _workRequestGenre;
  List<String> get workRequesttype => _workRequesttype;
  List<String> get workRequestAvailableLocations =>
      _workRequestAvailableLocations;
  Future<QuerySnapshot>? get userStoreSearchSnapShot =>
      _userStoreSearchSnapShot;
  Future<QuerySnapshot>? get eventStoreSearchSnapShot =>
      _eventStoreSearchSnapShot;
  Future<QuerySnapshot>? get postStoreSearchSnapShot =>
      _postStoreSearchSnapShot;
  List? get event => _event;
  PendingDynamicLinkData? get dynamicLink => _dynamicLink;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setStoreSearchTerm(String storeSearchTerm) {
    _storeSearchTerm = storeSearchTerm;
    notifyListeners();
  }

  void setArtist(String artist) {
    _artist = artist;
    notifyListeners();
  }

  void setCaption(String caption) {
    _caption = caption;
    notifyListeners();
  }

  void setTheme(String theme) {
    _theme = theme;
    notifyListeners();
  }

  void setMusicLink(String musicLinkPreviodVideo) {
    _musicLink = musicLinkPreviodVideo;
    notifyListeners();
  }

  void setHashTagg(String hashTagTagg) {
    hashTagg = hashTagTagg;
    notifyListeners();
  }

  void setPunchline(String punchline) {
    _punchline = punchline;
    notifyListeners();
  }

  void setHost(String host) {
    _host = host;
    notifyListeners();
  }

  void setVenue(String venue) {
    _venue = venue;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  void setCategory(String category) {
    _category = category;
    notifyListeners();
  }

  void setSubCategory(String subCategory) {
    _subCategory = subCategory;
    notifyListeners();
  }

  void setEventTermsAndConditions(String eventTermsAndConditions) {
    _eventTermsAndConditions = eventTermsAndConditions;
    notifyListeners();
  }

  void setPreviousEvent(String previousEvent) {
    _previousEvent = previousEvent;
    notifyListeners();
  }

  void setDressCode(String dressCode) {
    _dressCode = dressCode;
    notifyListeners();
  }

  void setDj(String dj) {
    _dj = dj;
    notifyListeners();
  }

  void setStartDate(Timestamp startDate) {
    _startDate = startDate;
    notifyListeners();
  }

  void setSheduleDateTemp(Timestamp sheduleDateTemp) {
    _sheduleDateTemp = sheduleDateTemp;
    notifyListeners();
  }

  void setStartDateString(String startDateString) {
    _startDateString = startDateString;
    notifyListeners();
  }

  void setClossingDay(Timestamp clossingDay) {
    _clossingDay = clossingDay;
    notifyListeners();
  }

  void setClossingDayString(String clossingDayString) {
    _clossingDayString = clossingDayString;
    notifyListeners();
  }

  void setCity(String city) {
    _city = city;
    notifyListeners();
  }

  void setCountry(String country) {
    _country = country;
    notifyListeners();
  }

  void setContinent(String continent) {
    _continent = continent;
    notifyListeners();
  }

  void setRate(String rate) {
    _rate = rate;
    notifyListeners();
  }

  void setCurrency(String currency) {
    _currency = currency;
    notifyListeners();
  }

  void setMarketedAffiliateId(String marketedAffiliateId) {
    _marketedAffiliateId = marketedAffiliateId;
    notifyListeners();
  }

  void setClossingDate(String clossingDate) {
    _clossingDate = clossingDate;
    notifyListeners();
  }

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void setTicketSite(String ticketSite) {
    _ticketSite = ticketSite;
    notifyListeners();
  }

  void setDressingCide(String dressingCode) {
    _dressingCode = dressingCode;
    notifyListeners();
  }

  void setTicketNames(String ticketNames) {
    _ticketNames = ticketNames;
    notifyListeners();
  }

  void setBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void setOverview(String overview) {
    _overview = overview;
    notifyListeners();
  }

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setNoBooking(bool noBooking) {
    _noBooking = noBooking;
    notifyListeners();
  }

  void setTermsAndConditions(String termAndConditions) {
    _termAndConditions = termAndConditions;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setProfileHandle(String profrilehandle) {
    _profrilehandle = profrilehandle;
    notifyListeners();
  }

  void setReplyEventRoomMessage(EventRoomMessageModel? replyEventRoomMessage) {
    _replyEventRoomMessage = replyEventRoomMessage;
    notifyListeners();
  }

  void setReplyChatMessage(ChatMessage? replyChatMessage) {
    _replyChatMessage = replyChatMessage;
    notifyListeners();
  }

  void setChatMessageId(String chatMessageId) {
    _chatMessageId = chatMessageId;
    notifyListeners();
  }

  void setMessageAuthorId(String messageAuthorId) {
    _messageAuthorId = messageAuthorId;
    notifyListeners();
  }

  void setCreatIconIsSelected(bool creatIconIsSelected) {
    _creatIconIsSelected = creatIconIsSelected;
    notifyListeners();
  }

  void setCreatIconIndex(int creatIconIndex) {
    _creatIconIndex = creatIconIndex;
    notifyListeners();
  }

  void setSearchInput(String searchInput) {
    _searchInput = searchInput;
    notifyListeners();
  }

  void setInt1(int int1) {
    _int1 = int1;
    notifyListeners();
  }

  void setActivityCount(int activityCount) {
    _activityCount = activityCount;
    notifyListeners();
  }

  void setAvailableDynamicLink(String availableDynamicLink) {
    _availableDynamicLink = availableDynamicLink;
    notifyListeners();
  }

  void setChatCount(int chatCount) {
    _chatCount = chatCount;
    notifyListeners();
  }

  void setWorkRequestoverView(String workRequestoverView) {
    _workRequestoverView = workRequestoverView;
    notifyListeners();
  }

  void setChangeUserName(String changeNewUserName) {
    _changeNewUserName = changeNewUserName;
    notifyListeners();
  }

  void setWorkRequestisEvent(bool workRequestisEvent) {
    _workRequestisEvent = workRequestisEvent;
    notifyListeners();
  }

  void setWorkRequestPrice(double workRequestPrice) {
    _workRequestPrice = workRequestPrice;
    notifyListeners();
  }

  void setAffiliateComission(int affiliatecommission) {
    _affiliatecommission = affiliatecommission;
    notifyListeners();
  }

  void setUser(AccountHolderAuthor? user) {
    _user = user;
    notifyListeners();
  }

  void setUserGeneralSettings(UserSettingsGeneralModel? userGeneraSentence) {
    _userGeneraSentence = userGeneraSentence;
    notifyListeners();
  }

  void setUserLocationPreference(
      UserSettingsLoadingPreferenceModel? userLocationPreference) {
    _userLocationPreference = userLocationPreference;
    notifyListeners();
  }

  void setPostImage(File? postImage) {
    _postImage = postImage;
    notifyListeners();
  }

  void setMessageImage(File? messageImage) {
    _messageImage = messageImage;
    notifyListeners();
  }

  void setBookingPriceRate(PriceModel? bookingPriceRate) {
    _bookingPriceRate = bookingPriceRate;
    notifyListeners();
  }

  void setEventImage(File? eventImage) {
    _eventImage = eventImage;
    notifyListeners();
  }

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }

  void setProfessionalImageFile1(File? professionalImageFile1) {
    _professionalImageFile1 = professionalImageFile1;
    notifyListeners();
  }

  void setProfessionalImageFile2(File? professionalImageFile2) {
    _professionalImageFile2 = professionalImageFile2;
    notifyListeners();
  }

  void setProfessionalImageFile3(File? professionalImageFile3) {
    _professionalImageFile3 = professionalImageFile3;
    notifyListeners();
  }

  void setVideoFile1(PickedFile? videoFile1) {
    _videoFile1 = videoFile1;
    notifyListeners();
  }

  void setNotificaitonTab(int notificaitonTab) {
    _notificaitonTab = notificaitonTab;
    notifyListeners();
  }

  void setTicket(TicketModel ticket) {
    _ticket.add(ticket);
    notifyListeners();
  }

  void setTaggedEventPeopel(TaggedEventPeopleModel taggedEventPeople) {
    _taggedEventPeople.add(taggedEventPeople);
    notifyListeners();
  }

  void setSchedulePeople(SchedulePeopleModel schedulePerson) {
    _schedulePerson.add(schedulePerson);
    notifyListeners();
  }

  void addTicketToList(TicketModel ticket) {
    if (!_ticketList.contains(ticket)) {
      _ticketList.add(ticket);
      notifyListeners();
    }
  }

  void removeTicketFromList(TicketModel ticket) {
    _ticketList.remove(ticket);
    notifyListeners();
  }

  void setPerformances(PortfolioModel performances) {
    _performances.add(performances);
    notifyListeners();
  }

  void setCollaborations(PortfolioCollaborationModel collaborations) {
    _collaborations.add(collaborations);
    notifyListeners();
  }

  void setPriceRate(PriceModel priceRate) {
    _priceRate.add(priceRate);
    notifyListeners();
  }

  void setAwards(PortfolioModel awards) {
    _awards.add(awards);
    notifyListeners();
  }

  void setLinksToWork(PortfolioModel linksToWork) {
    _linksToWork.add(linksToWork);
    notifyListeners();
  }

  void setSkills(PortfolioModel skills) {
    _skills.add(skills);
    notifyListeners();
  }

  void setGenereTags(PortfolioModel genreTages) {
    _genreTages.add(genreTages);
    notifyListeners();
  }

  void setCompanies(PortfolioCompanyModel company) {
    _company.add(company);
    notifyListeners();
  }

  void setBookingContacts(PortfolioContactModel bookingContacts) {
    _bookingContacts.add(bookingContacts);
    notifyListeners();
  }

  void setCollaboratedPeople(CollaboratedPeople collaboratedPeople) {
    _collaboratedPeople.add(collaboratedPeople);
    notifyListeners();
  }

  void setProfessionalImages(List<String> professionalImages) {
    _professionalImages = professionalImages;
    notifyListeners();
  }

  void setEventOrganizerContacts(String eventOrganizerContacts) {
    _eventOrganizerContacts.add(eventOrganizerContacts);
    notifyListeners();
  }

  void setWorkRequestGenre(String workRequestGenre) {
    _workRequestGenre.add(workRequestGenre);
    notifyListeners();
  }

  void setWorkRequestType(List<String> workRequestType) {
    _workRequesttype.addAll(workRequestType);
    notifyListeners();
  }

  void setWorkRequestAvailableLocations(String workRequestAvailableLocations) {
    _workRequestAvailableLocations.add(workRequestAvailableLocations);
    notifyListeners();
  }

  void setUserStoreSearchSnapShot(
      Future<QuerySnapshot>? userStoreSearchSnapShot) {
    _userStoreSearchSnapShot = userStoreSearchSnapShot;
    notifyListeners();
  }

  void setEventStoreSearchSnapShot(
      Future<QuerySnapshot>? eventStoreSearchSnapShot) {
    _eventStoreSearchSnapShot = eventStoreSearchSnapShot;
    notifyListeners();
  }

  void setPostStoreSearchSnapShot(
      Future<QuerySnapshot>? postStoreSearchSnapShot) {
    _postStoreSearchSnapShot = postStoreSearchSnapShot;
    notifyListeners();
  }

  void setSchedule(Schedule schedules) {
    _schedule.add(schedules);
    notifyListeners();
  }

  void setIsPrivate(bool isPrivate) {
    _isPrivate = isPrivate;
    notifyListeners();
  }

  void setIsAffiliateEnabled(bool isAffiliateEnabled) {
    _isAffiliateEnabled = isAffiliateEnabled;
    notifyListeners();
  }

  void setisAffiliateExclusive(bool isAffiliateExclusive) {
    _isAffiliateExclusive = isAffiliateExclusive;
    notifyListeners();
  }

  void setshowToFollowers(bool showToFollowers) {
    _showToFollowers = showToFollowers;
    notifyListeners();
  }

  void setIsVirtual(bool isVirtual) {
    _isVirtual = isVirtual;
    notifyListeners();
  }

  void setIsFree(bool isFree) {
    _isFree = isFree;
    notifyListeners();
  }

  void setCouldntDecodeCity(bool couldntDecodeCity) {
    _couldntDecodeCity = couldntDecodeCity;
    notifyListeners();
  }

  void setIsCashPayment(bool isCashPayment) {
    _isCashPayment = isCashPayment;
    notifyListeners();
  }

  void setIsExternalTicketPayment(bool isExternalTicketPayment) {
    _isExternalTicketPayment = isExternalTicketPayment;
    notifyListeners();
  }

  void setSheduleTimestamp(Timestamp scheduleTimestamp) {
    _sheduleTimestamp = scheduleTimestamp;
    notifyListeners();
  }

  void setBool5(bool bool5) {
    _bool5 = bool5;
    notifyListeners();
  }

  void setChatRoomScrollVisibl(bool isChatRoomScrollVisible) {
    _isChatRoomScrollVisible = isChatRoomScrollVisible;
    notifyListeners();
  }

  void setBool6(bool bool6) {
    _bool6 = bool6;
    notifyListeners();
  }

  void setIsSendigChat(bool isSendigChat) {
    _isSendigChat = isSendigChat;
    notifyListeners();
  }

  void setShortcutBool(bool shortcutBool) {
    _shortcutBool = shortcutBool;
    notifyListeners();
  }

  void setLoadingThisWeekEvent(bool loadingThisWeekEvent) {
    _loadingThisWeekEvent = loadingThisWeekEvent;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void setEnlargeEndBarcode(bool enlargeEndBarcode) {
    _enlargeEndBarcode = enlargeEndBarcode;
    notifyListeners();
  }

  void setEnlargeStartBarcode(bool enlargeStartBarcode) {
    _enlargeStartBarcode = enlargeStartBarcode;
    notifyListeners();
  }

  void setIsStartDateSelected(bool startDateSelected) {
    _startDateSelected = startDateSelected;
    notifyListeners();
  }

  void setIsEndDateSelected(bool endDateSelected) {
    _endDateSelected = endDateSelected;
    notifyListeners();
  }

  void setIsStartTimeSelected(bool startTimeSelected) {
    _startTimeSelected = startTimeSelected;
    notifyListeners();
  }

  void setIsEndTimeSelected(bool endTimeSelected) {
    _endTimeSelected = endTimeSelected;
    notifyListeners();
  }

  void setShowEventTab(bool showEventTab) {
    _showEventTab = showEventTab;
    notifyListeners();
  }

  void setMessageCount(int messageCount) {
    _messageCount = messageCount;
    notifyListeners();
  }

  void setShowUsersTab(bool showUsersTab) {
    _showUsersTab = showUsersTab;
    notifyListeners();
  }

  void setchatMessage(List message) async {
    _message = message;
    notifyListeners();
  }

  void eventList(List event) async {
    _event = event;
    notifyListeners();
  }

  void setLatLng(String latLng) {
    _latLng = latLng;
    notifyListeners();
  }

  void setDynamicLink(PendingDynamicLinkData dynamicLink) async {
    _dynamicLink = dynamicLink;
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  searchAddress(String searchTerm) async {
    addressSearchResults = await addressService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _googleUser;
  GoogleSignInAccount get googelUser => _googleUser!;
  Future googleLogin() async {
    try {
      final signedGoogleUser = await googleSignIn.signIn();
      if (signedGoogleUser == null) return;
      _googleUser = signedGoogleUser;

      final googleAuth = await signedGoogleUser.authentication;
      final newUserCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(newUserCredential);

      if (userCredential.additionalUserInfo!.isNewUser) {
        return AuthCreateUserCredentials();
      } else {
        await kpiStatisticsRef
            .doc('0SuQxtu52SyYjhOKiLsj')
            .update({'totalGoogleSignIn': FieldValue.increment(1)});
      }
    } catch (e) {
    } finally {
      notifyListeners();
    }
  }
}
