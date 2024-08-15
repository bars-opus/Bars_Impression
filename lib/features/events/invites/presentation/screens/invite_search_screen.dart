import 'package:bars/utilities/exports.dart';

//  The _InviteSearchScreenState class is where the main functionality of the feature is implemented.
//  It maintains several pieces of state, including the current search query,
//  a list of users matching the query, and a map representing the selected users.

class InviteSearchScreen extends StatefulWidget {
  static final id = 'InviteSearchScreen';
  final String currentUserId;
  final Event event;
  final String inviteMessage;
  final Color paletteColor;

  InviteSearchScreen({
    required this.currentUserId,
    required this.event,
    required this.inviteMessage,
    required this.paletteColor,
  });

  @override
  _InviteSearchScreenState createState() => _InviteSearchScreenState();
}

class _InviteSearchScreenState extends State<InviteSearchScreen>
    with AutomaticKeepAliveClientMixin {
  int limit = 10;
  late ScrollController _hideButtonController;
  String query = "";
  final _controller = new TextEditingController();
  bool _isTicketPass = false;
  final FocusNode _focusNode = FocusNode();
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List<AccountHolderAuthor>> _users =
      ValueNotifier<List<AccountHolderAuthor>>([]);
  Map<String, bool> userSelection = {};
  List<AccountHolderAuthor> selectedUsersList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _hideButtonController = ScrollController();
  }

// The dispose method is properly implemented to clean up resources when they are no longer needed.
// This can help prevent memory leaks and improve the overall performance of the app.
  @override
  void dispose() {
    _hideButtonController.dispose();
    _searchController.dispose();
    _focusNode.dispose();
    searchTimer?.cancel();
    super.dispose();
  }

  // The _sendInvite method sends invites to all selected users.
  // It uses a retry function to retry failed attempts at sending invites.
  // It also displays a loading modal while the invites are being sent and a success or error message when done.
  // The use of a retry function for sending invites can help prevent temporary issues from causing failures.
  // Also, the use of bottom sheets to display error messages can give the user valuable feedback when something goes wrong.
  _sendInvite() async {
    var _user = Provider.of<UserData>(context, listen: false).user;
    String date = MyDateFormat.toDate(widget.event.startDate.toDate());

    if (_isLoading) {
      return;
    }

    _showBottomSheetLoading();
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

    Future<void> sendInvites() => DatabaseService.sendEventInvite(
        event: widget.event,
        users: selectedUsersList,
        message: widget.inviteMessage,
        currentUser: Provider.of<UserData>(context, listen: false).user!,
        isTicketPass: _isTicketPass,
        generatedMessage:
            'You have been invited by ${_user!.userName} to attend ${widget.event.title} on $date at ${widget.event.venue}');

    try {
      await retry(() => sendInvites(), retries: 3);
      mySnackBar(context, "Invite sent successfully");
    } catch (e) {
      _showBottomSheetErrorMessage('', e);
    } finally {
      _endLoading();
    }
  }

// This method shows a bottom sheet with an error message.
// It uses the showModalBottomSheet function to display a DisplayErrorHandler widget, which shows
// the message "Request failed" along with a button for dismissing the bottom sheet.
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

// This method sets _isLoadingSubmit to false.
// This indicates that the loading process is finished.
  void _endLoading() {
    if (_isModalShown) {
      Navigator.pop(context);
    }
    _clearSearch();
    selectedUsersList.clear();
    _isLoading = false;
  }

// The _showBottomSheetLoading and _showBottomSheetErrorMessage methods are used to display
// a loading modal and error messages, respectively. The loading modal is displayed
// while invites are being sent, and the error message modal is displayed if an error occurs.
  bool _isModalShown = false;
  _showBottomSheetLoading() {
    _isModalShown = true;
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.blue,
                  ),
                  strokeWidth: 2,
                ),
              ),
              RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Please ',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: 'Wait\n',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: 'Sending invitation',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: '...',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 18.0),
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ])),
            ],
          ),
        );
      },
    ).then((value) {
      _isModalShown = false;
    });
  }

//The _clearSearch method clears the list of current users called and make way for new set of users to be clled.
//The users selection map value is also cleared so the check list can mark new values.

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    setState(() {
      _users.value = []; // clear the list of users
      userSelection.clear(); // clear the selection map
    });
  }

  // The _searchContainer method builds a search bar where the user can enter a username.
  // As the user types, the onChanged callback queries the database for matching usernames
  // and updates the _users value notifier.

  Timer? searchTimer;
  _searchContainer() {
    return SearchContentField(
      showCancelButton: true,
      fromEventDashBoard: true,
      autoFocus: true,
      cancelSearch: () {
        selectedUsersList.clear();
        _clearSearch();
        Navigator.pop(context);
      },
      controller: _searchController,
      focusNode: _focusNode,
      hintText: 'Enter username..',
      onClearText: () {
        _clearSearch();
      },
      onTap: () {},
      onChanged: (input) {
        // Cancel any existing timer
        searchTimer?.cancel();
        // Start a new timer
        searchTimer = Timer(Duration(milliseconds: 500), () {
          // Timer has completed, send the search request
          if (input.trim().isNotEmpty) {
            DatabaseService.searchUsers(input.trim().toUpperCase())
                .then((querySnapshot) {
              final newList = querySnapshot.docs.map((doc) {
                return AccountHolderAuthor.fromFirestore(
                    doc); // assuming you have a fromFirestore method
              }).toList();

              setState(() {
                _users.value = newList;

                // Updating userSelection map as before
                final idsInNewList = newList.map((user) => user.userId).toSet();
                userSelection
                    .removeWhere((key, value) => !idsInNewList.contains(key));
                for (var user in newList) {
                  userSelection.putIfAbsent(user.userId!, () => false);
                }
              });
            });
          }
        });
      },
    );
  }

  void _confirmInvitation() {
    final width = MediaQuery.of(context).size.width;
    var _size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: _size.height.toDouble() / 1.2,
              decoration: BoxDecoration(
                  color: widget.paletteColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: EdgeInsets.all(10),
                  child: ListView(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ShakeTransition(
                      child: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Confirm Invite to\n${selectedUsersList.length.toString()} people',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 20.0),
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        height: 2,
                        width: 100,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 700),
                      height: selectedUsersList.isEmpty ? 0 : 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedUsersList.length,
                        itemBuilder: (context, index) {
                          String imageUrl =
                              selectedUsersList[index].profileImageUrl!;
                          return Column(
                            children: [
                              imageUrl.isEmpty
                                  ? Icon(
                                      Icons.account_circle,
                                      size: 45.0,
                                      color: Colors.white,
                                    )
                                  : CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      backgroundImage: NetworkImage(
                                          imageUrl), // replace with your user avatar url
                                    ),
                              Container(
                                width: 70,
                                child: Center(
                                  child: Text(
                                    selectedUsersList[index].userName!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 12.0),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (!widget.event.isFree)
                      SettingSwitch(
                        isAlwaysWhite: true,
                        title: 'Enable Free entry',
                        subTitle: '',
                        value: _isTicketPass,
                        onChanged: (value) => setState(
                          () {
                            _isTicketPass = value;
                          },
                        ),
                      ),
                    if (!widget.event.isFree)
                      Text(
                        'Enabling free entry would allow this invited attendees to attend this event without a purchasig a ticket. A free ticket would be generated for each person once they accept this invitation.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'The invitation sent must be accepted by the invitees before they can attend this event. Invities are not obliged to accept your invitation.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Container(
                        width: width.toDouble(),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0.0,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: Text(
                            'Send invite',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 14.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onPressed: () {
                            Navigator.pop(context);

                            _sendInvite();
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          });
        });
  }

// The _userList method builds a list of users that match the search query.
// Each user can be selected or deselected by tapping on their ListTile,
//  which updates the selectedUsersList and userSelection map.

  _userList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          selectedUsersList.isEmpty
              ? SizedBox.shrink()
              : Text(
                  '${selectedUsersList.length.toString()} selected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                  ),
                ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            height: selectedUsersList.isEmpty ? 0 : 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedUsersList.length,
              itemBuilder: (context, index) {
                String imageUrl = selectedUsersList[index].profileImageUrl!;
                return Stack(
                  alignment: FractionalOffset.center,
                  children: [
                    imageUrl.isEmpty
                        ? Icon(
                            Icons.account_circle,
                            size: 45.0,
                            color: Colors.white,
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                    Positioned(
                      top: 3,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            String userId = selectedUsersList[index].userId!;
                            selectedUsersList
                                .removeWhere((user) => user.userId == userId);
                            userSelection[userId] = false;
                          });
                        },
                        child: Container(
                            height: 8,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  offset: Offset(0, 5),
                                  blurRadius: 8.0,
                                  spreadRadius: 2.0,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Container(
                                height: 3,
                                width: 20,
                                color: Colors.red,
                              ),
                            )),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _messageContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: widget.inviteMessage.isEmpty
          ? selectedUsersList.isEmpty
              ? null
              : Align(
                  alignment: Alignment.centerRight,
                  child: ShakeTransition(
                    curve: Curves.easeOutBack,
                    child: CircularButton(
                        color: Colors.white,
                        icon: Icon(Icons.send, color: widget.paletteColor),
                        onPressed: () {
                          _confirmInvitation();
                        }),
                  ),
                )
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: EdgeInsets.all(
                  ResponsiveHelper.responsiveHeight(context, 8.0),
                ),
                child: ListTile(
                  trailing: selectedUsersList.isEmpty
                      ? null
                      : ShakeTransition(
                          curve: Curves.easeOutBack,
                          child: CircularButton(
                              color: widget.paletteColor,
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: ResponsiveHelper.responsiveHeight(
                                    context, 25.0),
                              ),
                              onPressed: () {
                                _confirmInvitation();
                              }),
                        ),
                  title: RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Invitation message\n",
                          style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.inviteMessage,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
    );
  }

  _noContentNow(String title, String subTitle, IconData icon) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: ResponsiveHelper.responsiveHeight(context, 50.0),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 16.0),
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text(
              subTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // The use of ValueNotifier and ValueListenableBuilder allows for efficient rebuilding of widgets.
  // This means that only the widgets that need to change (the user list) get
  // rebuilt when the state changes, rather than the whole widget tree.

  _buildResults() {
    return ValueListenableBuilder<List<AccountHolderAuthor>>(
      valueListenable: _users,
      builder: (BuildContext context, List<AccountHolderAuthor> userList,
          Widget? child) {
        if (userList.isEmpty) {
          return Center(
              child: Center(
                  child: _noContentNow(
            'No user fiund',
            'Please check username and try again.',
            Icons.person_add_alt,
          )));
        }

        return Padding(
          padding: EdgeInsets.all(
            ResponsiveHelper.responsiveHeight(context, 8.0),
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: EdgeInsets.only(
                top: ResponsiveHelper.responsiveHeight(context, 30.0),
              ),
              child: Scrollbar(
                child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            AccountHolderAuthor user = userList[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.responsiveHeight(
                                    context, 8.0),
                              ),
                              child: Container(
                                color: userSelection[user.userId]!
                                    ? widget.paletteColor.withOpacity(.1)
                                    : null,
                                child: CheckboxListTile(
                                  activeColor: widget.paletteColor,
                                  selectedTileColor: userSelection[user.userId]!
                                      ? Colors.blue
                                      : null,
                                  title: Row(
                                    children: [
                                      user.profileImageUrl!.isEmpty
                                          ? Icon(
                                              Icons.account_circle,
                                              size: 40.0,
                                              color: Colors.grey,
                                            )
                                          : CircleAvatar(
                                              radius: 18.0,
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      user.profileImageUrl!,
                                                      errorListener: (_) {
                                                return;
                                              }),
                                            ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: RichText(
                                            textScaleFactor:
                                                MediaQuery.of(context)
                                                    .textScaleFactor,
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: user.userName,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              TextSpan(
                                                text: "\n${user.profileHandle}",
                                                style: TextStyle(
                                                  fontSize: ResponsiveHelper
                                                      .responsiveFontSize(
                                                          context, 12.0),
                                                  color: Colors.blue,
                                                ),
                                              )
                                            ])),
                                      ),
                                    ],
                                  ),
                                  value: userSelection[user.userId],
                                  onChanged: (bool? value) {
                                    HapticFeedback.lightImpact();
                                    setState(() {
                                      userSelection[user.userId!] = value!;
                                      if (value == true) {
                                        selectedUsersList.add(
                                            user); // add user to list if selected
                                      } else {
                                        selectedUsersList.remove(
                                            user); // remove user from list if unselected
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          childCount: userList.length,
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

// The build method of the _InviteSearchScreenState class returns a Scaffold widget that contains the search
// bar and the list of users. An AppBar is also included with a send button that triggers the sending of invitations.
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: widget.paletteColor,
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          backgroundColor: widget.paletteColor,
          title: _searchContainer()),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            _messageContainer(),
            _userList(),
            Expanded(
              child: Container(
                child: _users.value.isEmpty
                    ? Center(
                        child: _noContentNow(
                        'Seach invitee',
                        'Enter the name of the user you would like to invite to this event',
                        Icons.person_add_alt,
                      ))
                    : _buildResults(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
