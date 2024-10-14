import 'dart:math';

import 'package:bars/utilities/exports.dart';

//These code has been tested for  better performance and potential bug prevention:
//14th August 2023
//Author: Harold Enam Kwaku Fianu (CEO BARS OPUS LTD)

class DiscographyPages extends StatefulWidget {
  final String currentUserId;
  final String types;
  final UserStoreModel user;
  final int userIndex;
  final int pageIndex;
  final List<UserStoreModel> userList;
  final List<DocumentSnapshot> userSnapshot;
  final String liveCity;
  final String liveCountry;
  final String isFrom;

  DiscographyPages({
    required this.userList,
    required this.userSnapshot,
    required this.currentUserId,
    required this.user,
    required this.userIndex,
    required this.pageIndex,
    required this.types,
    required this.liveCity,
    required this.liveCountry,
    required this.isFrom,
  });

  @override
  _DiscographyPagesState createState() => _DiscographyPagesState();
}

class _DiscographyPagesState extends State<DiscographyPages> {
  late PageController _pageController2;
  List<UserStoreModel> userList = [];
  List<DocumentSnapshot> userSnapshot = [];
  int limit = 2;
  bool hasMoreUsers = true;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController2 = PageController(
      initialPage: widget.userIndex,
    );
    _currentPageIndex = widget.userIndex;
    userList = widget.userList;
    userSnapshot = List.from(widget.userSnapshot);
  }

  @override
  void dispose() {
    _pageController2.dispose();
    super.dispose();
  }

  Future<List<UserStoreModel>> _loadMoreUsers({
    // DocumentSnapshot? startAfterDocument,
    String? country,
    String? city,
  }) async {
    var query = userProfessionalRef
        .where('showOnExplorePage', isEqualTo: true)
        .where('shopType', isEqualTo: widget.types)
        .where('noBooking', isEqualTo: false);

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    final randomValue = Random().nextDouble();

    try {
      QuerySnapshot eventFeedSnapShot = await query
          .where('randomId', isGreaterThanOrEqualTo: randomValue)
          .orderBy('randomId')
          .startAfterDocument(userSnapshot.last)
          .limit(2)
          .get();

      if (eventFeedSnapShot.docs.length < 2) {
        int remainingLimit = 2 - eventFeedSnapShot.docs.length;
        QuerySnapshot additionalSnapshot = await query
            .startAfterDocument(userSnapshot.last)
            .where('randomId', isLessThan: randomValue)
            .orderBy('randomId')
            .limit(remainingLimit)
            .get();
        // Combine the two lists of users
        eventFeedSnapShot.docs.addAll(additionalSnapshot.docs);
      }

      List<UserStoreModel> users = eventFeedSnapShot.docs
          .map((doc) => UserStoreModel.fromDoc(doc))
          .toList();

// Add new user to existing list
      userList.addAll(users);

// Add new snapshots to existing list
      userSnapshot.addAll((eventFeedSnapShot.docs));

      if (mounted) {
        setState(() {});
      }
      return users;
    } catch (e) {
      // print('Error loading more events: $e');
      // Consider what you want to do in case of error. Here, we return an empty list
      return [];
    }
  }

  _arrowButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          size: 40,
          icon,
          color: Colors.black,
        ),
      ),
    );
  }

  _loadMoreCityCountry() {
    var _userLocationSettings =
        Provider.of<UserData>(context, listen: false).userLocationPreference;

    return widget.isFrom.startsWith('City')
        ? _loadMoreUsers(
            city: _userLocationSettings!.city,
            country: _userLocationSettings.country,
          )
        : _loadMoreUsers(
            country: _userLocationSettings!.country,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
            scrollDirection: Axis.vertical,
            controller: _pageController2,
            itemCount: hasMoreUsers ? userList.length + 1 : userList.length,
            onPageChanged: (i) async {
              HapticFeedback.lightImpact();
              // Update the current page index first
              _currentPageIndex = i;

              if (i == userList.length) {
                List<UserStoreModel> newUsers =
                    await (widget.liveCity.isNotEmpty
                        ? _loadMoreUsers(
                            city: widget.liveCity,
                            country: widget.liveCountry,
                          )
                        : widget.isFrom.isNotEmpty
                            ? _loadMoreCityCountry()
                            : _loadMoreUsers());
                // If no more events were loaded, navigate back to the previous page
                if (newUsers.isEmpty) {
                  _pageController2.animateToPage(
                    (_currentPageIndex - 1).clamp(0, userList.length - 1),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                  // Display a Snackbar
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'No more ${widget.types.toLowerCase()} to load')),
                  );
                }
              }
            },
            itemBuilder: (context, index) {
              if (index == userList.length) {
                // This is the additional empty page, display a loading spinner
                return CircularProgress(
                  isMini: false,
                );
              }

              final user = userList[index];

              return ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: user.userId,
                  user: null, accountType: 'Shop',);

              //  DiscographyWidget(
              //   currentUserId: widget.currentUserId,
              //   userPortfolio: user,
              //   userIndex: widget.userIndex,
              // );
            }),
        Positioned(
            bottom: 50,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _arrowButton(Icons.keyboard_arrow_up_rounded, () {
                    _pageController2.animateToPage(
                      (_currentPageIndex - 1).clamp(0, widget.userList.length),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }),
                  Container(
                    height: 1,
                    width: 40,
                    color: Colors.black,
                  ),
                  _arrowButton(Icons.keyboard_arrow_down_rounded, () {
                    if (_currentPageIndex < userList.length) {
                      _pageController2.animateToPage(
                        (_currentPageIndex + 1)
                            .clamp(0, widget.userList.length),
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  })
                ],
              ),
            ))
      ],
    );
  }
}
