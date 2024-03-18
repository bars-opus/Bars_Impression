import 'package:bars/utilities/exports.dart';

class InviteContainerWidget extends StatefulWidget {
  final InviteModel invite;
  const InviteContainerWidget({
    Key? key,
    required this.invite,
  }) : super(key: key);

  @override
  _InviteContainerWidgetState createState() => _InviteContainerWidgetState();
}

class _InviteContainerWidgetState extends State<InviteContainerWidget> {
  bool _isLoading = false;

  // This method shows a bottom sheet with an error message.
// It uses the showModalBottomSheet function to display a DisplayErrorHandler widget, which shows
// the message "Request failed" along with a button for dismissing the bottom sheet.
  void _showBottomSheetErrorMessage(String title) {
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
          title: title,
          subTitle: 'Please check your internet connection and try again.',
        );
      },
    );
  }

  // This method navigates to a new page. It takes the BuildContext and the Widget for the new page as parameters
  // and uses the Navigator.push function to navigate to the new page.
  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () async {
          if (_isLoading) return;
          _isLoading = true;
          try {
            Event? event = await DatabaseService.getUserEventWithId(
                widget.invite.eventId, widget.invite.inviterId);

            TicketOrderModel? _ticket = await DatabaseService.getTicketWithId(
                widget.invite.eventId, _provider.currentUserId!);

            if (event != null) {
              PaletteGenerator _paletteGenerator =
                  await PaletteGenerator.fromImageProvider(
                CachedNetworkImageProvider(event.imageUrl),
                size: Size(1110, 150),
                maximumColorCount: 20,
              );
              _navigateToPage(EventInviteScreen(
                currentUserId: _provider.currentUserId!,
                event: event,
                invite: widget.invite,
                palette: _paletteGenerator,
                ticketOrder: _ticket,
              ));
            } else {
              _showBottomSheetErrorMessage('Failed to fetch event.');
            }
          } catch (e) {
            // print('Failed to fetch user data: $e');
            _showBottomSheetErrorMessage('Failed to fetch event.');
          } finally {
            _isLoading = false;
          }
        },
        child: Container(
          width: width,
          height: ResponsiveHelper.responsiveHeight(context, 100.0),
          decoration: BoxDecoration(
              color: widget.invite.answer.isEmpty
                  ? Theme.of(context).primaryColorLight
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: widget.invite.answer.isEmpty
                      ? Colors.black26
                      : Colors.transparent,
                  offset: Offset(10, 10),
                  blurRadius: 10.0,
                  spreadRadius: 4.0,
                )
              ]),
          child: Center(
            child: ListTile(
              leading: _isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      widget.invite.answer.startsWith('Accepted')
                          ? MdiIcons.carOutline
                          : widget.invite.answer.startsWith('Rejected')
                              ? MdiIcons.cancel
                              : Icons.mail_outline_rounded,
                      color: Theme.of(context).secondaryHeaderColor,
                      size: ResponsiveHelper.responsiveHeight(context, 25.0),
                    ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.invite.eventTitle!.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CORDIALLY INVITED  ',
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            color: Colors.blue,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        widget.invite.answer,
                        style: TextStyle(
                            fontSize: ResponsiveHelper.responsiveFontSize(
                                context, 12.0),
                            color: widget.invite.answer.startsWith('Accepted')
                                ? Colors.blue
                                : Colors.red),
                      ),
                    ],
                  ),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        // TextSpan(
                        //   text: 'CORDIALLY INVITED  ',
                        //   style: TextStyle(
                        //       fontSize: ResponsiveHelper.responsiveFontSize(
                        //           context, 12.0),
                        //       color: Colors.blue),
                        // ),
                        // TextSpan(
                        //   text: widget.invite.answer,
                        //   style: TextStyle(
                        //       fontSize: ResponsiveHelper.responsiveFontSize(
                        //           context, 12.0),
                        //       color: widget.invite.answer.startsWith('Accepted')
                        //           ? Colors.blue
                        //           : Colors.red),
                        // ),
                        TextSpan(
                          text: '${widget.invite.generatedMessage}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
              // subtitle: Text(
              //   MyDateFormat.toDate(
              //     widget.invite.eventTimestamp!.toDate(),
              //   ),
              //   style: Theme.of(context).textTheme.bodyMedium,
              // ),
            ),
          ),
        ),
      ),
    );
  }
}
