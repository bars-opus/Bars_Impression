import 'package:bars/features/creatives/presentation/screens/discography/discography_pageview.dart';
import 'package:bars/utilities/exports.dart';

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
          prices: widget.userProfessional.priceTags,
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
    return FocusedMenuAction(
      onPressedReport: () {
        _navigateToPage(
            context,
            ReportContentPage(
              contentId: widget.userProfessional.userId,
              contentType: widget.userProfessional.userName,
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
            sendImageUrl: widget.userProfessional.storeLogomageUrl,
            sendTitle: widget.userProfessional.userName,
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
                        types: widget.userProfessional.storeType,
                        pageIndex: widget.pageIndex,
                        userList: widget.userList,
                        userSnapshot: widget.userSnapshot,
                        liveCity: widget.liveCity,
                        liveCountry: widget.liveCountry,
                        isFrom: widget.isFrom,
                      )));
        },
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          height: ResponsiveHelper.responsiveHeight(context, 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.userProfessional.storeLogomageUrl.isEmpty
                    ? const Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: Colors.grey,
                      )
                    : CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.blue,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.userProfessional.storeLogomageUrl,
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
                        widget.userProfessional.userName.replaceAll('\n', ' '),
                        style: Theme.of(context).textTheme.bodyLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.userProfessional.storeType.replaceAll('\n', ' '),
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 10.0),
                          color: Colors.blue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      // RichText(
                      //   textScaler: MediaQuery.of(context).textScaler,
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(text: "Skills: ", style: textStyle),
                      //       TextSpan(
                      //         text: widget.userProfessional.skills
                      //             .map((skills) => skills.name)
                      //             .join(', '),
                      //         style: Theme.of(context).textTheme.bodySmall,
                      //       )
                      //     ],
                      //   ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // RichText(
                      //   textScaler: MediaQuery.of(context).textScaler,
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //           text: "Collaborations: ", style: textStyle),
                      //       TextSpan(
                      //         text: widget.userProfessional.collaborations
                      //             .map((collaborations) => collaborations.name)
                      //             .join(', '),
                      //         style: Theme.of(context).textTheme.bodySmall,
                      //       )
                      //     ],
                      //   ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      // RichText(
                      //   textScaler: MediaQuery.of(context).textScaler,
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(text: "Performance: ", style: textStyle),
                      //       TextSpan(
                      //         text: widget.userProfessional.performances
                      //             .map((performances) => performances.name)
                      //             .join(', '),
                      //         style: Theme.of(context).textTheme.bodySmall,
                      //       )
                      //     ],
                      //   ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      RichText(
                        textScaler: MediaQuery.of(context).textScaler,
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Location: ", style: textStyle),
                            if (widget.userProfessional.city.isNotEmpty)
                              TextSpan(
                                text: widget.userProfessional.city,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if (widget.userProfessional.city.isNotEmpty &&
                                widget.userProfessional.country.isNotEmpty)
                              TextSpan(
                                text: ', ',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            if (widget.userProfessional.country.isNotEmpty)
                              TextSpan(
                                text: widget.userProfessional.country,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            // if (widget.userProfessional.continent.isNotEmpty &&
                            //     widget.userProfessional.country.isNotEmpty)
                            //   TextSpan(
                            //     text: ', ',
                            //     style: Theme.of(context).textTheme.bodySmall,
                            //   ),
                            // TextSpan(
                            //   text: widget.userProfessional.continent,
                            //   style: Theme.of(context).textTheme.bodySmall,
                            // ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Divider(
                        thickness: .3,
                        color: Theme.of(context).primaryColor,
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
                            size:
                                ResponsiveHelper.responsiveHeight(context, 20),
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            _showBottomSheetBookMe(context);
                            // _showBottomSheetBookingCalendar();
                          },
                          child: Icon(
                            Icons.call_outlined,
                            // Icons.calendar_month,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 25),
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _userOthers();
  }
}
