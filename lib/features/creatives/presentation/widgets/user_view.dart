import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  final String currentUserId;
  final UserStoreModel userProfessional;
  List<UserStoreModel> userList;
  List<DocumentSnapshot> userSnapshot;
  final int pageIndex;
  final String liveCity;
  final String liveCountry;
  final String isFrom;

  UserView({
    required this.currentUserId,
    required this.userList,
    required this.userSnapshot,
    required this.userProfessional,
    required this.pageIndex,
    required this.liveCity,
    required this.liveCountry,
    required this.isFrom,
  });

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return UserBottomModalSheetActions(
          user: widget.userProfessional,
          currentUserId: widget.currentUserId,
        );
      },
    );
  }

  void _showBottomSheetBookMe(BuildContext context) {
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
            bookingUser: widget.userProfessional,
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetBookingCalendar() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BookingCalendar(
          currentUserId: widget.currentUserId,
          bookingUser: widget.userProfessional,
          // prices: widget.userProfessional.priceTags,
        );
      },
    );
  }

  _infoWidget(String label, String value) {
    return SalesReceiptWidget(
      maxLines: 2,
      text1Ccolor: null,
      inMini: true,
      text2Ccolor: Theme.of(context).secondaryHeaderColor,
      isRefunded: false,
      lable: label,
      value: value,
    );
  }

  _divider() {
    return Divider(
      thickness: .3,
      color: Theme.of(context).primaryColor,
    );
  }

  _card(Widget child) {
    return Card(
        color: Theme.of(context).primaryColorLight,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30.0), // Adjust the radius as needed
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: child));
  }

  _launchMap(String address) {
    return MapsLauncher.launchQuery(address);
  }

  _bookingServiceOptions(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.black.withOpacity(.6),
        builder: (BuildContext context) {
          return ServicePriceOptions(
            fromPrice: true,
            bookingUser: widget.userProfessional,
          );
        });
  }

  void _showBottomSheetOpeningHours() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 600),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              const SizedBox(
                height: 30,
              ),
              OpeninHoursWidget(
                openingHours: widget.userProfessional.openingHours,
              )
            ],
          ),
        );
      },
    );
  }

  _userOthers() {
    bool isAuthor = widget.currentUserId == widget.userProfessional.userId;
    var textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Colors.grey,
    );

    final services = widget.userProfessional.appointmentSlots
        .map((slot) => slot.service)
        .toSet() // Use a set to ensure uniqueness
        .toList();

    final workers = widget.userProfessional.appointmentSlots
        .expand((slot) => slot.workers)
        .toList();
    return FocusedMenuAction(
      onPressedReport: () {
        _navigateToPage(
            context,
            ReportContentPage(
              contentId: widget.userProfessional.userId,
              contentType: widget.userProfessional.shopName,
              parentContentId: widget.userProfessional.userId,
              repotedAuthorId: widget.userProfessional.userId,
            ));
      },
      onPressedSend: () {
        _navigateToPage(
          context,
          SendToChats(
            currentUserId: widget.currentUserId,
            sendContentType: 'User',
            sendContentId: widget.userProfessional.userId,
            sendImageUrl: widget.userProfessional.shopLogomageUrl,
            sendTitle: widget.userProfessional.shopName,
          ),
        );
      },
      onPressedShare: () async {
        Share.share(widget.userProfessional.dynamicLink);
      },
      isAuthor: isAuthor,
      child: GestureDetector(
        onTap: () async {
          int userIndex = widget.userList
              .indexWhere((p) => p.userId == widget.userProfessional.userId);
          await Future.delayed(Duration(milliseconds: 300));

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DiscographyPageView(
                        currentUserId:
                            Provider.of<UserData>(context).currentUserId!,
                        user: widget.userProfessional,
                        userIndex: userIndex,
                        types: widget.userProfessional.shopType,
                        pageIndex: widget.pageIndex,
                        userList: widget.userList,
                        userSnapshot: widget.userSnapshot,
                        liveCity: widget.liveCity,
                        liveCountry: widget.liveCountry,
                        isFrom: widget.isFrom,
                      )));
        },
        child: Column(
          children: [
            _card(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.userProfessional.shopLogomageUrl.isEmpty
                          ? const Icon(
                              Icons.account_circle,
                              size: 40.0,
                              color: Colors.grey,
                            )
                          : CircleAvatar(
                              radius: 20.0,
                              backgroundColor: Colors.blue,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.userProfessional.shopLogomageUrl,
                                  errorListener: (_) {
                                return;
                              }),
                            ),
                      SizedBox(
                        width: ResponsiveHelper.responsiveWidth(context, 10.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.userProfessional.shopName
                                  .replaceAll('\n', ' '),
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.userProfessional.shopType
                                  .replaceAll('\n', ' '),
                              style: TextStyle(
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 10.0),
                                color: Colors.blue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            StarRatingWidget(
                              isMini: true,
                              enableTap: false,
                              onRatingChanged: (_) {},
                              rating:
                                  widget.userProfessional.averageRating ?? 0,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: ResponsiveHelper.responsiveWidth(context, 50.0),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();

                            _showBottomSheet(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  _showBottomSheet(context);
                                },
                                child: Icon(
                                  Icons.more_vert_outlined,
                                  size: ResponsiveHelper.responsiveHeight(
                                      context, 20),
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  _divider(),
                  GestureDetector(
                      onTap: () {
                        _showBottomSheetOpeningHours();
                      },
                      child: ShopOpenStatus(shop: widget.userProfessional)),
                  _divider(),
                  GestureDetector(
                    onTap: () {
                      _launchMap(widget.userProfessional.address);
                    },
                    child: _infoWidget(
                      'Location',
                      widget.userProfessional.address,
                    ),
                  ),
                ],
              ),
            ),
            _card(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _divider(),
                  GestureDetector(
                    onTap: () {
                      _bookingServiceOptions(context);
                    },
                    child: SizedBox(
                      height: ResponsiveHelper.responsiveFontSize(context,
                          75), // Adjust height to fit two rows of chips
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Two rows
                          childAspectRatio: .3, // Adjust aspect ratio as needed
                        ),
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Container(
                              width: ResponsiveHelper.responsiveFontSize(
                                  context, 100),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10.0),
                                color: Colors.blue.shade50,
                              ),
                              child: Chip(
                                label: Text(
                                  services[index],
                                  style: Theme.of(context).textTheme.bodySmall,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                backgroundColor: Colors.blue.shade50,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.transparent,
                                    width: 0.0,
                                  ),
                                  // borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  _divider(),
                  Container(
                    padding: EdgeInsets.all(
                        ResponsiveHelper.responsiveWidth(context, 2)),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                      ),
                    ),
                    child: ShedulePeopleHorizontal(
                      small: true,
                      edit: false,
                      workers: workers,
                      currentUserId: widget.currentUserId,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userOthers();
  }
}
