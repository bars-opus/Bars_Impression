import 'package:bars/services/address_service.dart';
import 'package:bars/services/places_service.dart';
import 'package:bars/utilities/exports.dart';

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
  late AccountHolder? _user;
  late int _messageCount;
  late int _chatCount;
  late int _notificaitonTab;
  late int _usersTab;
  late int _eventTab;
  late bool _showEventTab;
  late bool _showUsersTab;
  late File? _postImage;
  late File? _image;
  late List? _message;

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
    _user = null;
    _messageCount = 0;
    _showEventTab = true;
    _showUsersTab = true;
    _chatCount = 0;
    _notificaitonTab = 0;
    _usersTab = 0;
    _eventTab = 0;
    _postImage = null;
    _image = null;
    _message = [];
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
  int get chatCount => _chatCount;
  int get notificaitonTab => _notificaitonTab;
  int get usersTab => _usersTab;
  int get eventTab => _eventTab;
  bool get showEventTab => _showEventTab;
  bool get showUsersTab => _showUsersTab;
  File? get postImage => _postImage;
  File? get image => _image;
  AccountHolder? get user => _user;
  int get messageCount => _messageCount;
  List? get message => _message;

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

  void setChatCount(int chatCount) {
    _chatCount = chatCount;
    notifyListeners();
  }

  void setUser(AccountHolder user) {
    _user = user;
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

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  searchAddress(String searchTerm) async {
    addressSearchResults = await addressService.getAutocomplete(searchTerm);
    notifyListeners();
  }
}
