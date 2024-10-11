import 'package:bars/features/creatives/presentation/screens/profile/profile_screen.dart';
import 'package:bars/utilities/exports.dart';

class TagWidget extends StatefulWidget {
  final TaggedNotificationModel currentTag;
  final String currentUserId;

  const TagWidget(
      {super.key, required this.currentTag, required this.currentUserId});

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  bool _isLoading = false;
  bool _isConfirmed = false;

  _deleteOrConfirm(BuildContext context, bool isDeleting) async {
    var _provider = Provider.of<UserData>(context, listen: false);

    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // Capture necessary data before async operation

    try {
      if (isDeleting) {
        await DatabaseService.deleteUserTagData(widget.currentTag);
      } else {
        await DatabaseService.confirmUserTag(
          widget.currentTag,
          _provider.user!.shopType,
          _provider.user!.verified,
          _provider.user!.userName,
        );
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isConfirmed = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showBottomSheetErrorMessage(
          isDeleting ? 'Error deleting tag' : 'Error confirming tag',
        );
      }
    }
  }

  void _showBottomSheetConfirmDelete(BuildContext context, bool isDeleting) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Delete',
          onPressed: () async {
            Navigator.pop(context);
            await _deleteOrConfirm(context, isDeleting);
          },
          title: isDeleting
              ? 'Are you sure you want to delete this refund data?'
              : 'Are you sure you want to verify this tag?',
          subTitle: '',
        );
      },
    );
  }

  void _showBottomSheetErrorMessage(String errorTitle) {
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
          title: errorTitle,
          subTitle: 'Check your internet connection and try again.',
        );
      },
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.currentTag.isEvent
          ? () async {
              _isLoading = true;
              try {
                Event? event = await DatabaseService.getUserEventWithId(
                  widget.currentTag.taggedParentId!,
                  widget.currentTag.taggedParentAuthorId!,
                );

                // if (event != null) {
                //   _navigateToPage(EventEnlargedScreen(
                //     currentUserId: widget.currentUserId,
                //     event: event,
                //     type: event.type,
                //     showPrivateEvent: true,
                //   ));
                // } else {
                //   _showBottomSheetErrorMessage('Failed to fetch event.');
                // }
              } catch (e) {
                _showBottomSheetErrorMessage('Failed to fetch event');
              } finally {
                _isLoading = false;
              }
            }
          : () {
              _navigateToPage(ProfileScreen(
                currentUserId: widget.currentUserId,
                userId: widget.currentTag.taggedParentAuthorId!,
                user: null,
                accountType: '',
              ));
            },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
        child: Column(
          children: [
            ListTile(
              leading: widget.currentTag.isEvent
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.currentTag.taggedParentImageUrl,
                              errorListener: (_) {
                            return;
                          }),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : widget.currentTag.taggedParentImageUrl.isEmpty
                      ? const Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: Colors.grey,
                        )
                      : CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.blue,
                          backgroundImage: CachedNetworkImageProvider(
                              widget.currentTag.taggedParentImageUrl,
                              errorListener: (_) {
                            return;
                          }),
                        ),
              title: Text(
                widget.currentTag.taggedParentTitle
                    .replaceAll('\n', ' ')
                    .toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: widget.currentTag.verifiedTag || _isConfirmed
                  ? Text(
                      'Verified',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 12),
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    )
                  : _isLoading
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: SizedBox(
                              height: ResponsiveHelper.responsiveFontSize(
                                  context, 15.0),
                              width: ResponsiveHelper.responsiveFontSize(
                                  context, 15.0),
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.transparent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                                strokeWidth:
                                    ResponsiveHelper.responsiveFontSize(
                                        context, 2.0),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: ResponsiveHelper.responsiveHeight(
                                  context, 40),
                              child: BottomModelSheetIconActionWidget(
                                minor: true,
                                dontPop: true,
                                buttoncolor: Colors.blue,
                                textcolor: Colors.white,
                                icon: Icons.edit,
                                onPressed: () {
                                  _showBottomSheetConfirmDelete(context, false);
                                },
                                text: 'Verify',
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  _showBottomSheetConfirmDelete(context, true);
                                },
                                icon: Icon(
                                  Icons.delete_forever_outlined,
                                  color: Colors.red,
                                )),
                          ],
                        ),
            ),
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom: 20.0, top: 10),
            //     child: Icon(
            //       Icons.check_circle_outline_outlined,
            //       size: ResponsiveHelper.responsiveHeight(context, 50.0),
            //       color: Colors.green,
            //     ),
            //   ),
            // ),
            // _payoutWidget(
            //   'For',
            //   widget.currentTag.taggedParentTitle,
            // ),
            // Divider(
            //   thickness: .2,
            // ),
            // _payoutWidget(
            //   'Amount',
            //   widget.currentTag.,
            // ),
            // Divider(
            //   thickness: .2,
            // ),
            // _payoutWidget(
            //   'Request \ntime',
            //   MyDateFormat.toTime(
            //       widget.currentTag.approvedTimestamp.toDate()),
            // ),
            // Divider(
            //   thickness: .2,
            // ),
            // _payoutWidget(
            //   'Request \ndate',
            //   MyDateFormat.toDate(
            //       widget.currentTag.approvedTimestamp.toDate()),
            // ),
            // if (widget.currentTag.expectedDate.isNotEmpty) Divider(),
            // if (widget.currentTag.expectedDate.isNotEmpty)
            //   _payoutWidget(
            //     'Expected \ndate',
            //     MyDateFormat.toDate(DateTime.parse(
            //       widget.currentTag.expectedDate,
            //     )),
            //   ),
            // Divider(
            //   thickness: .2,
            // ),
            // _payoutWidget(
            //   'Request\nReason',
            //   widget.currentTag.reason,
            // ),
            // Divider(
            //   thickness: .2,
            // ),
            // const SizedBox(
            //   height: 10,
            // ),

            Divider(
              thickness: .2,
            ),
          ],
        ),
      ),
    );
  }
}
