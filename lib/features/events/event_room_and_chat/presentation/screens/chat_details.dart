import 'package:bars/utilities/exports.dart';
import 'package:timeago/timeago.dart' as timeago;

//display
class ChatDetails extends StatefulWidget {
   var user;
  final Chat chat;
  final String currentUserId;
  final bool isBlockingUser;
  final bool restrict;
  final Function(bool) restrictFunction;

  ChatDetails({
    required this.user,
    required this.currentUserId,
    required this.chat,
    required this.isBlockingUser,
    required this.restrictFunction,
    required this.restrict,
  });

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {

  _blockOrUnBlock() {
    HapticFeedback.heavyImpact();
    if (widget.isBlockingUser) {
      _unBlockser();
    } else {
      _blockser();
    }
  }

  _unBlockser() {
    DatabaseService.unBlockUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.userId,
    );

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'unBlocked ' + widget.user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  _blockser() async {
    AccountHolderAuthor? fromUser =
        await DatabaseService.getUserWithId(widget.currentUserId);

    bool isAFollower = await DatabaseService.isAFollowerUser(
      currentUserId: widget.currentUserId,
      userId: widget.user.userId,
    );
    if (fromUser != null) {
      DatabaseService.blockUser(
        currentUserId: widget.currentUserId,
        userId: widget.user.userId,
        user: fromUser,
      );
    } else {
      mySnackBar(context, 'Could not block this person');
    }

    if (isAFollower) {
      DatabaseService.unfollowUser(
        currentUserId: widget.user.userId,
        userId: widget.currentUserId,
      );
    }
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Color(0xFFD38B41),
      content: Text(
        'Blocked ' + widget.user.userName!,
        overflow: TextOverflow.ellipsis,
      ),
    ));
  }

  void _showBottomSheetClearActivity(BuildContext context) {
    String text = widget.isBlockingUser
        ? 'un block ${widget.user.userName}'
        : 'block ${widget.user.userName}';

    String text2 = widget.isBlockingUser
        ? "${widget.user.userName} would see and react to any of your content."
        : "This action would stop ${widget.user.userName} from seeing and reacting to any of your content.";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: text,
          onPressed: () {
            _blockOrUnBlock();
            Navigator.pop(context);
          },
          title: 'Are you sure you $text',
          subTitle: text2,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 30,
          ),
          ListTile(
            trailing: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Colors.grey,
              size: 20,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                            currentUserId: widget.currentUserId,
                            userId: widget.user.userId,
                            user: null,
                          )));
            },
            leading: widget.user.profileImageUrl!.isEmpty
                ? Icon(
                    Icons.account_circle,
                    color: Theme.of(context).secondaryHeaderColor,
                    size: ResponsiveHelper.responsiveHeight(context, 40),
                  )
                : CircleAvatar(
                    radius: 20.0,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: CachedNetworkImageProvider(
                        widget.user.profileImageUrl!)),
            title: NameText(
              name: widget.user.userName!.toUpperCase(),
              verified: widget.user!.verified! ? true : false,
            ),
            subtitle: Text(
              widget.user.profileHandle!,
              style: TextStyle(color: Colors.blue, fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12),),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Divider(color: Colors.blue, thickness: .2,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SettingSwitch(
              color: Colors.blue,
              title: 'Restrict messages',
              subTitle:
                  'Restrict messaging between you and ${widget.user.userName}.',
              value: widget.restrict,
              onChanged: (value) {
                widget.restrictFunction(value);
              },
            ),
          ),
          Divider(color: Colors.blue,  thickness: .2,),
          GestureDetector(
            onTap: () {
              _showBottomSheetClearActivity(context);
            },
            child: IntroInfo(
              title: widget.isBlockingUser
                  ? 'unBlock ${widget.user.userName}'
                  : 'Block ${widget.user.userName}',
              onPressed: () {
                _showBottomSheetClearActivity(context);
              },
              subTitle: widget.isBlockingUser
                  ? "${widget.user.userName} would see and react to any of your content."
                  : "This action would stop ${widget.user.userName} from seeing and reacting to any of your content.",
              icon: Icons.block,
            ),
          ),
          Divider(color: Colors.blue,  thickness: .2,),
          const SizedBox(height: 30),
          Text(
            '     Details',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          Table(
            border: TableBorder.all(
              color: Colors.blue,
              width: 0.5,
            ),
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Chat initiator',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    widget.chat.messageInitiator == widget.currentUserId
                        ? 'Me'
                        : widget.user.userName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'First message',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    widget.chat.firstMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'First message date',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: MyDateFormat.toDate(
                                widget.chat.timestamp!.toDate()),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 16),
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                            text: '\n' +
                                timeago.format(
                                  widget.chat.timestamp!.toDate(),
                                ),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 16),
                              color: Colors.grey,
                            )),
                      ],
                    ), textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Last message',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    widget.chat.lastMessage,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ]),
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: Text(
                    'Last message date',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: MyDateFormat.toDate(
                              widget.chat.newMessageTimestamp!.toDate(),
                            ),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 16),
                              color: Theme.of(context).secondaryHeaderColor,
                            )),
                        TextSpan(
                            text: '\n' +
                                timeago.format(
                                  widget.chat.newMessageTimestamp!.toDate(),
                                ),
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 16),
                              color: Colors.grey,
                            )),
                      ],
                    ), textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
                  ),
                ),
              ]),
            ],
          ),
        ]);
  }
}
