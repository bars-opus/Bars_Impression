import 'package:bars/utilities/exports.dart';

class MoreIconWidget extends StatelessWidget {
  final bool isAuthor;
  // final UserStoreModel shop;
  // final AccountHolderAuthor client;
  // final ShopWorkerModel worker;
  final String dynamicLink;
  final String imageUrl;
  final String userId;
  final String userName;
  final String currentUserId;
  final String accountType;
  final String overview;

  const MoreIconWidget(
      {super.key,
      required this.isAuthor,
      // required this.shop,
      // required this.client,
      required this.imageUrl,
      required this.dynamicLink,
      // required this.worker,
      required this.userId,
      required this.userName,
      required this.currentUserId,
      required this.accountType,
      required this.overview});

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    _sortByWidget(
      VoidCallback onPressed,
      IconData icon,
      String title,
      Color? color,
      notFullLength,
    ) {
      return NewModalActionButton(
        onPressed: onPressed,
        icon: icon,
        color: color,
        title: title,
        fromModalSheet: notFullLength,
      );
    }

    void _showBottomSheet(
      BuildContext context,
    ) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return Container(
            height: ResponsiveHelper.responsiveHeight(context, 500),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
              child: MyBottomModelSheetAction(
                actions: [
                  Icon(
                    size: ResponsiveHelper.responsiveHeight(context, 25),
                    Icons.horizontal_rule,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    trailing: isAuthor
                        ? GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // _editProfile(user);
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                              size: ResponsiveHelper.responsiveHeight(
                                  context, 30.0),
                            ),
                          )
                        : null,
                    leading: imageUrl.isEmpty
                        ? Icon(
                            Icons.account_circle_outlined,
                            size: 60,
                            color: Colors.grey,
                          )
                        : Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(imageUrl,
                                    errorListener: (_) {
                                  return;
                                }),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    title: RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: userName.toUpperCase(),
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            text: "\n${accountType}",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: ResponsiveHelper.responsiveFontSize(
                                    context, 12)),
                          )
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _sortByWidget(
                    () {
                      isAuthor
                          ? _navigateToPage(
                              context,
                              CreateEventScreen(
                                isEditting: false,
                                post: null,
                                // isCompleted: false,
                                // isDraft: false,
                              ))
                          : _navigateToPage(
                              context,
                              SendToChats(
                                sendContentId: userId,
                                currentUserId: Provider.of<UserData>(context,
                                        listen: false)
                                    .currentUserId!,
                                sendContentType: 'User',
                                sendImageUrl: imageUrl,
                                sendTitle: userName,
                              ));
                    },
                    isAuthor ? Icons.add : Icons.send_outlined,
                    isAuthor ? 'Create' : 'Send',
                    null,
                    true,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),

                  _sortByWidget(
                    isAuthor
                        ? () async {
                            Share.share(dynamicLink);
                          }
                        : () {
                            // _blockOrUnBlock(widget.shop);
                          },
                    isAuthor
                        ? Icons.mail_outline_rounded
                        : Icons.block_outlined,
                    isAuthor ? 'Invite a friend' : 'Block',
                    null,
                    true,
                  ),
                  // BottomModelSheetListTileActionWidget(
                  //     colorCode: '',
                  //     icon: isAuthor
                  //         ? Icons.mail_outline_rounded
                  //         : Icons.block_outlined,
                  //     onPressed: isAuthor
                  //         ? () async {
                  //             Share.share(widget.shop.dynamicLink!);
                  //           }
                  //         : () {
                  //             _blockOrUnBlock(widget.shop);
                  //           },
                  // //     text: isAuthor ? 'Invite a friend' : 'Block'),
                  // _sortByWidget(
                  //   () {
                  //     navigateToPage(
                  //         context,
                  //         UserBarcode(
                  //           widget.shopDynamicLink: widget.shop.dynamicLink!,
                  //           bio: widget.shop.bio!,
                  //           widget.shopName: widget.shop.widget.shopName!,
                  //           widget.shopId: widget.shop.widget.shopId!,
                  //           profileImageUrl: widget.shop.profileImageUrl!,
                  //         ));
                  //   },
                  //   Icons.qr_code,
                  //   'Bar code',
                  //   null,
                  //   true,
                  // ),
                  // // BottomModelSheetListTileActionWidget(
                  //   colorCode: '',
                  //   icon: Icons.qr_code,
                  //   onPressed: () {
                  //     navigateToPage(
                  //         context,
                  //         UserBarcode(
                  //           widget.shopDynamicLink: user.dynamicLink!,
                  //           bio: user.bio!,
                  //           userName: user.userName!,
                  //           userId: user.userId!,
                  //           profileImageUrl: user.profileImageUrl!,
                  //         ));
                  //   },
                  //   text: 'Bar code',
                  // ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _sortByWidget(
                        () {
                          _navigateToPage(
                              context,
                              UserBarcode(
                                userDynamicLink: dynamicLink,
                                bio: overview,
                                userName: userId,
                                userId: userId,
                                profileImageUrl: imageUrl,
                              ));
                        },
                        Icons.qr_code,
                        'Barcode',
                        null,
                        false,
                      ),
                      _sortByWidget(
                        () async {
                          Share.share(dynamicLink);
                        },
                        Icons.share_outlined,
                        'Share',
                        null,
                        false,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _sortByWidget(
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SuggestionBox()));
                        },
                        Icons.feedback_outlined,
                        'Suggestion',
                        null,
                        false,
                      ),
                      _sortByWidget(
                        isAuthor
                            ? () async {
                                // navigateToPage(
                                //   context,
                                //   ProfileSettings(
                                //     user: user,
                                //   ),
                                // );
                              }
                            : () {
                                _navigateToPage(
                                    context,
                                    ReportContentPage(
                                      contentId: userId,
                                      contentType: userName,
                                      parentContentId: userId,
                                      repotedAuthorId: currentUserId,
                                    ));
                              },
                        isAuthor
                            ? Icons.settings_outlined
                            : Icons.flag_outlined,
                        isAuthor ? 'Settings' : 'Report',
                        isAuthor ? null : Colors.red,
                        false,
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // BottomModelSheetListTileActionWidget(
                  //     colorCode: '',
                  //     icon: isAuthor
                  //         ? Icons.settings_outlined
                  //         : Icons.flag_outlined,
                  //     onPressed: isAuthor
                  //         ? () async {
                  //             navigateToPage(
                  //               context,
                  //               ProfileSettings(
                  //                 user: user,
                  //               ),
                  //             );
                  //           }
                  //         : () {
                  //             navigateToPage(
                  //                 context,
                  //                 ReportContentPage(
                  //                   contentId: user.userId!,
                  //                   contentType: user.userName!,
                  //                   parentContentId: user.userId!,
                  //                   repotedAuthorId: user.userId!,
                  //                 ));
                  //           },
                  //     text: isAuthor ? 'Settings' : 'Report'),

                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                    child: GestureDetector(
                      onTap: () {
                        _navigateToPage(
                            context,
                            CompainAnIssue(
                              parentContentId: userId,
                              authorId: currentUserId,
                              complainContentId: userId,
                              complainType: 'Account',
                              parentContentAuthorId: userId,
                            ));
                      },
                      child: Text(
                        'Complain an issue.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 12.0),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return IconButton(
      icon: Icon(
        size: ResponsiveHelper.responsiveHeight(context, 25.0),
        Icons.more_vert_rounded,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      onPressed: () {
        _showBottomSheet(
          context,
        );
      },
    );
  }
}
