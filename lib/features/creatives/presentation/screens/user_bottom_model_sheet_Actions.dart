import 'package:bars/utilities/exports.dart';

class UserBottomModalSheetActions extends StatefulWidget {
  final UserProfessionalModel user;
  final String currentUserId;

  UserBottomModalSheetActions(
      {required this.user, required this.currentUserId});

  @override
  State<UserBottomModalSheetActions> createState() =>
      _UserBottomModalSheetActionsState();
}

class _UserBottomModalSheetActionsState
    extends State<UserBottomModalSheetActions> {
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
            bookingUser: widget.user,
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
              user: null,
              userAuthor: null,
              chatLoaded: chat,
              userPortfolio: widget.user,
              userId: widget.user.userId,
              showAppbar: false,
            ),
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

  void _showBottomSheetCantMessage() {
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
          title: 'You cannot send a message to yourself',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetAdvice(
    BuildContext context,
  ) async {
    // var _provider = Provider.of<UserData>(context, listen: false);

    // final width =
    //      MediaQuery.of(context).size.width;
    await showModalBottomSheet(
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
              updateBlockStatus: () {
                setState(() {});
              },
              userId: widget.user.userId,
              userName: widget.user.userName,
              currentUserId: widget.currentUserId,
              disableAdvice: widget.user.disableAdvice,
              hideAdvice: widget.user.hideAdvice,
              // user: widget.user,
            ),
          ),
        );
      },
    );
  }

  // _goToChurch(BuildContext context) async {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 520.0),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
        child: MyBottomModelSheetAction(
          actions: [
            Icon(
              Icons.horizontal_rule,
              color: Theme.of(context).secondaryHeaderColor,
              size: ResponsiveHelper.responsiveHeight(context, 30.0),
            ),
            const SizedBox(
              height: 30,
            ),
            UserHeaderListTileWidget(
              onPressed: () {
                _navigateToPage(
                    context,
                    ProfileScreen(
                      currentUserId: widget.currentUserId,
                      userId: widget.user.userId,
                      user: null,
                    ));
              },
              user: widget.user,
              trailing: GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                  _showBottomSheetBookMe(context);
                },
                child: Icon(
                  Icons.call_outlined,
                  color: Colors.blue,
                  size: ResponsiveHelper.responsiveHeight(context, 30.0),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: Icons.send_outlined,
                  onPressed: () {
                    _navigateToPage(
                        context,
                        SendToChats(
                          sendContentId: widget.user.userId,
                          currentUserId:
                              Provider.of<UserData>(context, listen: false)
                                  .currentUserId!,
                          sendContentType: 'User',
                          sendImageUrl: widget.user.profileImageUrl,
                          sendTitle: widget.user.userName,
                        ));
                  },
                  text: 'Send',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.share_outlined,
                  onPressed: () async {
                    Share.share(widget.user.dynamicLink);
                  },
                  text: 'Share',
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  icon: MdiIcons.thoughtBubbleOutline,
                  onPressed: () {
                    _showBottomSheetAdvice(context);
                  },
                  text: 'Advice',
                ),
                BottomModelSheetIconActionWidget(
                  dontPop: true,
                  icon: Icons.message_outlined,
                  onPressed: widget.currentUserId == widget.user.userId
                      ? () {
                          _showBottomSheetCantMessage();
                        }
                      : () async {
                          try {
                            Chat? _chat =
                                await DatabaseService.getUserChatWithId(
                              widget.currentUserId,
                              widget.user.userId,
                            );

                            _bottomModalSheetMessage(
                              context,
                              _chat,
                            );
                          } catch (e) {}
                        },
                  text: 'Message',
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: '',
              icon: Icons.person_outline,
              onPressed: () {
                _navigateToPage(
                    context,
                    ProfileScreen(
                      currentUserId: widget.currentUserId,
                      userId: widget.user.userId,
                      user: null,
                    ));
              },
              text: 'Go to profile',
            ),
            BottomModelSheetListTileActionWidget(
              colorCode: '',
              icon: Icons.qr_code,
              onPressed: () {
                _navigateToPage(
                    context,
                    UserBarcode(
                      userDynamicLink: widget.user.dynamicLink,
                      bio: widget.user.overview,
                      userName: widget.user.userName,
                      userId: widget.user.userId,
                      profileImageUrl: widget.user.profileImageUrl,
                    ));
              },
              text: 'Bar code',
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomModelSheetIconActionWidget(
                  textcolor: Colors.red,
                  icon: Icons.flag_outlined,
                  onPressed: () {
                    _navigateToPage(
                        context,
                        ReportContentPage(
                          contentId: widget.user.userId,
                          contentType: widget.user.userName,
                          parentContentId: widget.user.userId,
                          repotedAuthorId: widget.user.userId,
                        ));
                  },
                  text: 'Report',
                ),
                BottomModelSheetIconActionWidget(
                  icon: Icons.feedback_outlined,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SuggestionBox()));
                  },
                  text: 'Suggestion',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
