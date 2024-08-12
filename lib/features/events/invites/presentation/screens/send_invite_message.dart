import 'package:bars/utilities/exports.dart';

class SendInviteMessage extends StatefulWidget {
  final Event event;
  final PaletteGenerator? palette;

  final String currentUserId;

  const SendInviteMessage(
      {super.key,
      required this.event,
      required this.currentUserId,
      this.palette});

  @override
  State<SendInviteMessage> createState() => _SendInviteMessageState();
}

class _SendInviteMessageState extends State<SendInviteMessage> {
  final _messageController = TextEditingController();
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    _messageController.addListener(_onAskTextChanged);
    super.initState();
  }

  void _onAskTextChanged() {
    if (_messageController.text.isNotEmpty) {
      _isTypingNotifier.value = true;
    } else {
      _isTypingNotifier.value = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color _paletteDark =
        Utils.getPaletteDarkMutedColor(widget.palette, Color(0xFF1a1a1a));
    return ValueListenableBuilder(
        valueListenable: _isTypingNotifier,
        builder: (BuildContext context, bool isTyping, Widget? child) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(children: [
                  _messageController.text.length > 0
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: MiniCircularProgressButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _navigateToPage(
                                  context,
                                  InviteSearchScreen(
                                    event: widget.event,
                                    currentUserId: widget.currentUserId,
                                    inviteMessage:
                                        _messageController.text.trim(),
                                    paletteColor: _paletteDark,
                                  ));
                            },
                            text: "Continue",
                            color: Colors.blue,
                          ),
                        )
                      : ListTile(
                          leading: _messageController.text.length > 0
                              ? SizedBox.shrink()
                              : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                          trailing: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              _navigateToPage(
                                  context,
                                  InviteSearchScreen(
                                    event: widget.event,
                                    paletteColor: _paletteDark,
                                    currentUserId: widget.currentUserId,
                                    inviteMessage:
                                        _messageController.text.trim(),
                                  ));
                            },
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                  const SizedBox(height: 40),
                  UnderlinedTextField(
                    labelText: 'Invitation message',
                    hintText: 'A special invitation message to your guests',
                    controler: _messageController,
                    onValidateText: () {},
                  ),
                  const SizedBox(height: 20),
                ]),
              ),
            ),
          );
        });
  }
}
