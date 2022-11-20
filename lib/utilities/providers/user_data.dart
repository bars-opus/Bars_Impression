import 'package:bars/services/address_service.dart';
import 'package:bars/services/auth_create_user_credentials.dart';
import 'package:bars/services/places_service.dart';
import 'package:bars/utilities/exports.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserData extends ChangeNotifier {
  String? currentUserId;
  late String _navigationBar;
  late String _post1;
  late String _post2;
  late String _post3;
  late String? _post4;
  late String _post5;
  late String _post6;
  late String _post7;
  late String _post8;
  late String _post9;
  late String _post10;
  late String _post11;
  late String _post12;
  late String _post13;
  late String _post14;
  late int _int1;

  late String _post15;
  late AccountHolder? _user;

  late AccountHolder? _author;
  late int _messageCount;
  late int _chatCount;
  late int _notificaitonTab;
  late int _usersTab;
  late int _eventTab;
  late bool _showEventTab;
  late bool _showUsersTab;
  late bool _bool1;
  late bool _bool2;
  late bool _bool3;
  late bool _bool4;
  late bool _bool5;
  late bool _bool6;
  late bool _isLoading;
  late File? _postImage;
  late File? _image;
  late List? _message;
  late List? _event;

  late PendingDynamicLinkData? _dynamicLink;
  late String _availableDynamicLink;

  final placesService = PlacesService();
  final addressService = AddressService();

  List<PlaceSearch>? searchResults;

  List<AddressSearch>? addressSearchResults;

  UserData() {
    _navigationBar = 'true';
    _post1 = ' ';
    _post2 = ' ';
    _post3 = ' ';
    _post4 = ' ';
    _post5 = ' ';
    _post6 = ' ';
    _post7 = ' ';
    _post8 = ' ';
    _post9 = ' ';
    _post10 = ' ';
    _post11 = ' ';
    _post12 = ' ';
    _post13 = ' ';
    _post14 = ' ';
    _post15 = ' ';
    _int1 = 0;
    _availableDynamicLink = ' ';
    _author = null;
    _user = null;
    _messageCount = 0;
    _showEventTab = true;
    _showUsersTab = true;
    _bool1 = false;
    _bool2 = false;
    _bool3 = false;
    _bool4 = false;
    _bool5 = false;
    _bool6 = false;
    _isLoading = false;
    _isLoading = false;
    _chatCount = 0;
    _notificaitonTab = 0;
    _usersTab = 0;
    _eventTab = 0;
    _postImage = null;
    _image = null;
    _message = [];
    _event = [];

    _dynamicLink = null;
  }
  String get navigationBar => _navigationBar;
  String get post1 => _post1;
  String get post2 => _post2;
  String get post3 => _post3;
  String? get post4 => _post4;
  String get post5 => _post5;
  String get post6 => _post6;
  String get post7 => _post7;
  String get post8 => _post8;
  String get post9 => _post9;
  String get post10 => _post10;
  String get post11 => _post11;
  String get post12 => _post12;
  String get post13 => _post13;
  String get post14 => _post14;
  String get post15 => _post15;

  int get int1 => _int1;
  String get availableDynamicLink => _availableDynamicLink;
  int get chatCount => _chatCount;
  int get notificaitonTab => _notificaitonTab;
  int get usersTab => _usersTab;
  int get eventTab => _eventTab;
  bool get showEventTab => _showEventTab;
  bool get showUsersTab => _showUsersTab;
  bool get bool1 => _bool1;
  bool get bool2 => _bool2;
  bool get bool3 => _bool3;
  bool get bool4 => _bool4;
  bool get bool5 => _bool5;
  bool get bool6 => _bool6;
  bool get isLoading => _isLoading;
  File? get postImage => _postImage;
  File? get image => _image;
  AccountHolder? get user => _user;

  AccountHolder? get author => _author;
  int get messageCount => _messageCount;
  List? get message => _message;

  List? get event => _event;
  PendingDynamicLinkData? get dynamicLink => _dynamicLink;

  void setnavigationBar(String navigationBar) {
    _navigationBar = navigationBar;
    notifyListeners();
  }

  void setPost1(String post1) {
    _post1 = post1;
    notifyListeners();
  }

  void setPost2(String post2) {
    _post2 = post2;
    notifyListeners();
  }

  void setPost3(String post3) {
    _post3 = post3;
    notifyListeners();
  }

  void setPost4(String post4) {
    _post4 = post4;
    notifyListeners();
  }

  void setPost5(String post5) {
    _post5 = post5;
    notifyListeners();
  }

  void setPost6(String post6) {
    _post6 = post6;
    notifyListeners();
  }

  void setPost7(String post7) {
    _post7 = post7;
    notifyListeners();
  }

  void setPost8(String post8) {
    _post8 = post8;
    notifyListeners();
  }

  void setPost9(String post9) {
    _post9 = post9;
    notifyListeners();
  }

  void setPost10(String post10) {
    _post10 = post10;
    notifyListeners();
  }

  void setPost11(String post11) {
    _post11 = post11;
    notifyListeners();
  }

  void setPost12(String post12) {
    _post12 = post12;
    notifyListeners();
  }

  void setPost13(String post13) {
    _post13 = post13;
    notifyListeners();
  }

  void setPost14(String post14) {
    _post14 = post14;
    notifyListeners();
  }

  void setPost15(String post15) {
    _post15 = post15;
    notifyListeners();
  }

  void setInt1(int int1) {
    _int1 = int1;
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

  void setUser(AccountHolder user) {
    _user = user;
    notifyListeners();
  }

  void setAuthor(AccountHolder author) {
    _author = author;
    notifyListeners();
  }

  void setPostImage(File? postImage) {
    _postImage = postImage;
    notifyListeners();
  }

  void setImage(File? image) {
    _image = image;
    notifyListeners();
  }

  void setNotificaitonTab(int notificaitonTab) {
    _notificaitonTab = notificaitonTab;
    notifyListeners();
  }

  void setEventTab(int eventTab) {
    _eventTab = eventTab;
    notifyListeners();
  }

  void setUsersTab(int usersTab) {
    _usersTab = usersTab;
    notifyListeners();
  }

  void setBool1(bool bool1) {
    _bool1 = bool1;
    notifyListeners();
  }

  void setBool2(bool bool2) {
    _bool2 = bool2;
    notifyListeners();
  }

  void setBool3(bool bool3) {
    _bool3 = bool3;
    notifyListeners();
  }

  void setBool4(bool bool4) {
    _bool4 = bool4;
    notifyListeners();
  }

  void setBool5(bool bool5) {
    _bool5 = bool5;
    notifyListeners();
  }

  void setBool6(bool bool6) {
    _bool6 = bool6;
    notifyListeners();
  }

  void setIsLoading(bool isLoading) {
    _isLoading = isLoading;
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

  void chatMessage(List message) async {
    _message = message;
    notifyListeners();
  }

  void eventList(List event) async {
    _event = event;
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
    } kpiStatisticsRef
            .doc('0SuQxtu52SyYjhOKiLsj')
            .update({'totalGoogleSignIn': FieldValue.increment(1)});
  }

  notifyListeners();
}
