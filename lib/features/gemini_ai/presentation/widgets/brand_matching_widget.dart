// This widget displays brand matching information for a user.
// It includes insights, messaging, and booking options.

import 'package:bars/utilities/exports.dart';

class BrandMatchingWidget extends StatefulWidget {
  final BrandMatchingModel brandMatching;
  final String currentUserId;
  final String tab;
  // final String tabValue;

  const BrandMatchingWidget({
    super.key,
    required this.brandMatching,
    required this.currentUserId,
    required this.tab,
    // required this.tabValue,
  });

  @override
  State<BrandMatchingWidget> createState() => _BrandMatchingWidgetState();
}

class _BrandMatchingWidgetState extends State<BrandMatchingWidget> {
  bool _loadingMatching = false;

  // Navigates to a new page
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  // Creates a text widget with title and body
  _matchingWidget(String title, String body, bool isDetails) {
    return RichText(
      textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
      text: TextSpan(
        children: [
          TextSpan(
              text: "\n${title.trim()}\n",
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                color: Colors.grey,
              )),
          TextSpan(
            text: body.trim(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      maxLines: isDetails ? 200 : 6,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }

  // Builds a button group with two buttons
  _buttons(
    String buttonText1,
    VoidCallback onPressed1,
    String buttonText2,
    VoidCallback onPressed2,
  ) {
    Color _color = Theme.of(context).secondaryHeaderColor.withOpacity(.6);
    TextStyle _textStyle = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Theme.of(context).primaryColorLight,
    );
    return Container(
      height: ResponsiveHelper.responsiveWidth(context, 30),
      decoration:
          BoxDecoration(color: _color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onPressed1,
            child: Container(
              height: ResponsiveHelper.responsiveWidth(context, 30),
              width: ResponsiveHelper.responsiveWidth(context, 150),
              child: Center(
                child: Text(
                  buttonText1,
                  style: _textStyle,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey,
          ),
          GestureDetector(
            onTap: onPressed2,
            child: Container(
              height: ResponsiveHelper.responsiveWidth(context, 30),
              width: ResponsiveHelper.responsiveWidth(context, 150),
              child: Center(
                child: Text(
                  buttonText2,
                  style: _textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Shows brand insight in a bottom sheet
  void _showBottomSheetBrandInsight() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 700),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            padding: const EdgeInsets.only(top: 50.0),
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView(children: [
                  TicketPurchasingIcon(
                    title: '',
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: AnimatedCircle(
                      size: 50,
                      stroke: 3,
                      animateSize: true,
                    ),
                  ),
                  const SizedBox(height: 40),
                  MarkdownBody(
                    data: widget.brandMatching.matchReason,
                    styleSheet: MarkdownStyleSheet(
                      h1: Theme.of(context).textTheme.titleLarge,
                      h2: Theme.of(context).textTheme.titleMedium,
                      p: Theme.of(context).textTheme.bodyMedium,
                      listBullet: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ])),
          );
        });
      },
    );
  }

  // Determines the insight type based on the tab
  _insight() {
    String insightType = '';
    switch (widget.tab) {
      case 'skills':
        insightType = widget.brandMatching.skills;
        break;
      case 'shortTermGoals':
        insightType = widget.brandMatching.shortTermGoals;
        break;
      case 'longTermGoals':
        insightType = widget.brandMatching.longTermGoals;
        break;
      case 'creativeStyle':
        insightType = widget.brandMatching.creativeStyle;
        break;
      case 'inspiration':
        insightType = widget.brandMatching.inspiration;
        break;
    }
    return GestureDetector(
      onTap: () async {
        _showBottomSheetBrandInsight();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            _loadingMatching ? 'generating...' : 'Insight',
            style: TextStyle(
              fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              color: Colors.blue,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          _loadingMatching
              ? SizedBox(
                  height: ResponsiveHelper.responsiveFontSize(context, 15.0),
                  width: ResponsiveHelper.responsiveFontSize(context, 15.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                    strokeWidth:
                        ResponsiveHelper.responsiveFontSize(context, 2.0),
                  ),
                )
              : AnimatedCircle(
                  animateShape: true,
                  animateSize: true,
                  size: 25,
                  stroke: 3,
                ),
        ],
      ),
    );
  }

  // Displays detailed information in a modal sheet
  void _bottomModalSheetDetails() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(30),
          height: ResponsiveHelper.responsiveHeight(context, 650),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: SingleChildScrollView(child: _display(true)),
        );
      },
    );
  }

  // Displays message options in a modal sheet
  void _bottomModalSheetMessage(BuildContext context, Chat? chat,
      UserProfessionalModel? userProfessional) {
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
              userPortfolio: userProfessional,
              userId: widget.brandMatching.userId,
              showAppbar: false,
            ),
          ),
        );
      },
    );
  }

  // Shows booking options in a modal sheet
  void _showBottomSheetBookMe(
      BuildContext context, UserProfessionalModel userProfessional) {
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
          child: UserBookingOption(
            bookingUser: userProfessional,
          ),
        );
      },
    );
  }

  // Builds the button group for messaging and contact
  _buttongroup() {
    var _provider = Provider.of<UserData>(
      context,
    );

    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      Divider(
        thickness: .2,
        color: Colors.grey,
      ),
      const SizedBox(
        height: 20,
      ),
      _buttons(
          _provider.isLoading ? 'loading..' : 'Message',
          _provider.isLoading
              ? () {}
              : () async {
                  _provider.setIsLoading(true);
                  try {
                    UserProfessionalModel? _userProfessional =
                        await DatabaseService.getUserProfessionalWithId(
                      widget.brandMatching.userId,
                    );

                    Chat? _chat = await DatabaseService.getUserChatWithId(
                      widget.currentUserId,
                      widget.brandMatching.userId,
                    );

                    _bottomModalSheetMessage(
                      context,
                      _chat,
                      _userProfessional,
                    );
                  } catch (e) {}
                  _provider.setIsLoading(false);
                },
          _provider.isLoading ? 'loading..' : 'Contact',
          _provider.isLoading
              ? () {}
              : () async {
                  _provider.setIsLoading(true);
                  try {
                    UserProfessionalModel? _userProfessional =
                        await DatabaseService.getUserProfessionalWithId(
                      widget.brandMatching.userId,
                    );
                    if (_userProfessional != null)
                      _showBottomSheetBookMe(
                        context,
                        _userProfessional,
                      );
                  } catch (e) {}
                  _provider.setIsLoading(false);
                }),
      const SizedBox(
        height: 30,
      ),
    ]);
  }

  // Displays the tab values based on the context
  _tabValues() {
    String tabValue = '';
    String tab = '';
    switch (widget.tab) {
      case 'skills':
        tabValue = widget.brandMatching.skills;
        tab = 'skills';
        break;
      case 'shortTermGoals':
        tabValue = widget.brandMatching.shortTermGoals;
        tab = 'Short Term Goals';
        break;
      case 'longTermGoals':
        tabValue = widget.brandMatching.longTermGoals;
        tab = 'Long Term Goals';
        break;
      case 'creativeStyle':
        tabValue = widget.brandMatching.creativeStyle;
        tab = 'Creative Style';
        break;
      case 'inspirations':
        tabValue = widget.brandMatching.inspiration;
        tab = 'Inspiration';
        break;
    }
    return Column(children: [
      _matchingWidget(tab, tabValue, false),
    ]);
  }

  // Displays all the values related to the brand matching
  _values() {
    return Column(children: [
      _matchingWidget('Skill', widget.brandMatching.skills, true),
      _matchingWidget('Short Term Goals', widget.brandMatching.skills, true),
      _matchingWidget('Long Term Goals', widget.brandMatching.skills, true),
      _matchingWidget('Creative Style', widget.brandMatching.skills, true),
      _matchingWidget('Inspirations', widget.brandMatching.skills, true),
    ]);
  }

  // Main display function for the widget
  _display(bool isDetails) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return GestureDetector(
      onTap: isDetails
          ? () {}
          : () {
              _bottomModalSheetDetails();
            },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isDetails
              ? TicketPurchasingIcon(
                  title: '',
                )
              : _insight(),
          GestureDetector(
            onTap: () async {
              _provider.setIsLoading(true);
              try {
                UserProfessionalModel? _userProfessional =
                    await DatabaseService.getUserProfessionalWithId(
                  widget.brandMatching.userId,
                );
                if (_userProfessional != null)
                  _navigateToPage(
                    DiscographyWidget(
                      currentUserId: widget.currentUserId,
                      userIndex: 0,
                      userPortfolio: _userProfessional,
                    ),
                  );
              } catch (e) {}
              _provider.setIsLoading(false);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.brandMatching.profileImageUrl.isEmpty
                      ? const Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.blue,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.brandMatching.profileImageUrl),
                        ),
                  SizedBox(
                    width: ResponsiveHelper.responsiveWidth(context, 10.0),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NameText(
                        color: Theme.of(context).secondaryHeaderColor,
                        name: widget.brandMatching.userName
                            .toUpperCase()
                            .trim()
                            .replaceAll('\n', ' '),
                        verified: widget.brandMatching.verified,
                      ),
                      Text(widget.brandMatching.profileHandle,
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 11.0),
                            color: Colors.blue,
                          ))
                    ],
                  ),
                ]),
          ),
          isDetails ? _values() : _tabValues(),
          isDetails
              ? _buttongroup()
              : const SizedBox(
                  height: 30,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).primaryColorLight,
      ),
      child: _display(false),
    );
  }
}

