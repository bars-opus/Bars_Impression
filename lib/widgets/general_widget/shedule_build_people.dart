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
    return GestureDetector(
      onTap: () {
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
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(20)),
        width: widget.fullWidth ? widget.width : widget.width / 2,
        height: ResponsiveHelper.responsiveHeight(context, 60),
        margin: EdgeInsets.all(1.0),
        padding: EdgeInsets.only(left: 10.0),
        child: Row(
          children: [
            profileImageUrl.isEmpty
                ? Icon(
                    Icons.account_circle,
                    size: ResponsiveHelper.responsiveHeight(context, 40.0),
                    color: Colors.grey,
                  )
                : CircleAvatar(
                    radius: ResponsiveHelper.responsiveHeight(context, 18.0),
                    backgroundColor: Colors.blue,
                    backgroundImage: CachedNetworkImageProvider(profileImageUrl,
                        errorListener: (_) {
                      return;
                    }),
                  ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
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
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12)),
                            ),
                  ],
                ),
                maxLines: widget.fullWidth ? null : 2,
                overflow: widget.fullWidth
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
              ),
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
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Icon(
                  widget.person.externalProfileLink!.isEmpty
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.link,
                  size: ResponsiveHelper.responsiveHeight(
                    context,
                    20,
                  ),
                  color: Colors.blue,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
