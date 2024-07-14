import 'package:bars/utilities/exports.dart';

class ScheduleBuildPeople extends StatefulWidget {
  final double width;
  final bool fullWidth;
  final String currentUserId;
  final bool edit;
  final String from;
  var person;

  ScheduleBuildPeople({
    super.key,
    required this.width,
    required this.fullWidth,
    required this.person,
    required this.edit,
    required this.from,
    required this.currentUserId,
  });

  @override
  State<ScheduleBuildPeople> createState() => _ScheduleBuildPeopleState();
}

class _ScheduleBuildPeopleState extends State<ScheduleBuildPeople> {
  void _showBottomSheetWork(
    BuildContext context,
    String type,
    String link,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height.toDouble() / 2,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                DisclaimerWidget(
                  title: type,
                  subTitle:
                      'You will be redirected to wibesite, where you can read, listen or watch $type. Please note that Bars Impression assumes no liability or responsibility for the information, views, or opinions presented on that platform.',
                  icon: Icons.link,
                ),
                const SizedBox(
                  height: 30,
                ),
                BottomModalSheetButtonBlue(
                  buttonText: type,
                  onPressed: () async {
                    if (!await launchUrl(Uri.parse(link))) {
                      throw 'Could not launch link';
                    }
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => MyWebView(
                    //               url: link,
                    //               title: '',
                    //             )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void _navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    String profileImageUrl = widget.person.profileImageUrl == null
        ? ''
        : widget.person.profileImageUrl;
    // var _currentUserId =
    //     Provider.of<UserData>(context, listen: false).currentUserId;

    return Padding(
      padding: widget.fullWidth
          ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
          : EdgeInsets.all(0),
      child: GestureDetector(
        onTap:

            // widget.edit || widget.from == 'Calendar'
            //     ? () {}
            //     :
            () {
          widget.person.externalProfileLink!.isEmpty
              ? _navigateToPage(
                  context,
                  ProfileScreen(
                    currentUserId: widget.currentUserId,
                    userId: widget.person.internalProfileLink!,
                    user: null,
                  ))
              : _showBottomSheetWork(context, widget.person.name,
                  widget.person.externalProfileLink!);
        },
        child: Container(
          decoration: BoxDecoration(
              color: widget.from.startsWith('list')
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor.withOpacity(.3),
              // from.isEmpty
              //     ? Theme.of(context).primaryColorLight
              // : Theme.of(context).primaryColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(20)),
          width: widget.fullWidth ? widget.width : widget.width / 2,
          height: widget.from == 'list' ? 80 : null,
          child: Padding(
            padding: widget.fullWidth
                ? EdgeInsets.all(10.0)
                : EdgeInsets.only(bottom: 2.0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveHeight(
                  context,
                  5,
                ),
              ),
              child: Row(
                children: [
                  // if (l)
                  profileImageUrl.isEmpty
                      ? Icon(
                          Icons.account_circle,
                          size:
                              ResponsiveHelper.responsiveHeight(context, 40.0),
                          color: Colors.grey,
                        )
                      : CircleAvatar(
                          radius:
                              ResponsiveHelper.responsiveHeight(context, 18.0),
                          backgroundColor: Colors.blue,
                          backgroundImage:
                              CachedNetworkImageProvider(profileImageUrl),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RichText(
                      textScaleFactor: MediaQuery.of(context).textScaleFactor,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.person.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (widget.from != 'Calendar')
                            if (widget.from != 'list')
                              if (!widget.edit)
                                if (widget.person.role != null)
                                  TextSpan(
                                    text: "\n${widget.person.role}",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 12)),
                                  ),
                        ],
                      ),
                      maxLines: widget.fullWidth ? null : 2,
                      overflow: widget.fullWidth
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),

                    //  Text(
                    //   person.name,
                    //   style: Theme.of(context).textTheme.bodySmall,
                    //   maxLines: fullWidth ? null : 2,
                    //   overflow: fullWidth ? null : TextOverflow.ellipsis,
                    // ),
                  ),
                  Container(
                    height: ResponsiveHelper.responsiveHeight(
                      context,
                      40,
                    ),
                    width: ResponsiveHelper.responsiveHeight(
                      context,
                      30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.person.verifiedTag)
                          Icon(
                            Icons.verified,
                            size: ResponsiveHelper.responsiveHeight(
                              context,
                              10,
                            ),
                            color: Colors.blue,
                          ),
                        // Icon(
                        //   person.internalProfileLink!.isNotEmpty
                        //       ? Icons.arrow_forward_ios
                        //       : Icons.link,
                        //   size: ResponsiveHelper.responsiveHeight(
                        //     context,
                        //     15,
                        //   ),
                        //   color: Colors.blue,
                        // )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
