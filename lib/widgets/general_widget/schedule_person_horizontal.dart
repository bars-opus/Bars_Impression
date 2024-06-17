import 'package:bars/utilities/exports.dart';

class ShedulePeopleHorizontal extends StatelessWidget {
  final bool edit;
  final String from;
  final List schedulepeople;
  final String currentUserId;

  const ShedulePeopleHorizontal(
      {super.key,
      required this.edit,
      required this.from,
      required this.schedulepeople,
      required this.currentUserId});

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

  _buildDisplayPortfolioGrid(
    BuildContext context,
  ) {
    // List<SchedulePeopleModel> people = shedule.people;

    final width = MediaQuery.of(context).size.width;
    List<Widget> tiles = [];
    schedulepeople.forEach(
        (people) => tiles.add(_buildPeople(context, width, people, false)));

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 120),
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2, // Items down the screen
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio:
            0.3, // Adjust this to change the vertical size, smaller number means smaller height
        children: tiles,
      ),
    );
  }

  _buildPeople(BuildContext context, double width, var person, bool fullWidth) {
    // var _currentUserId =
    //     Provider.of<UserData>(context, listen: false).currentUserId;

    return Padding(
      padding: fullWidth
          ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
          : EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(.3),
            // from.isEmpty
            //     ? Theme.of(context).primaryColorLight
            // : Theme.of(context).primaryColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(5)),
        width: fullWidth ? width : width / 2,
        child: Padding(
          padding:
              fullWidth ? EdgeInsets.all(10.0) : EdgeInsets.only(bottom: 2.0),
          child: GestureDetector(
            onTap: edit || from == 'Calendar'
                ? () {}
                : () {
                    person.externalProfileLink!.isEmpty
                        ? _navigateToPage(
                            context,
                            ProfileScreen(
                              currentUserId: currentUserId,
                              userId: person.internalProfileLink!,
                              user: null,
                            ))
                        : _showBottomSheetWork(
                            context, person.name, person.externalProfileLink!);
                  },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.responsiveHeight(
                  context,
                  5,
                ),
              ),
              child: Row(
                children: [
                  //    person.name.isEmpty
                  // ?
                  Icon(
                    Icons.account_circle,
                    size: ResponsiveHelper.responsiveHeight(context, 30.0),
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  // : CircleAvatar(
                  //     radius: isreplyWidget
                  //         ? ResponsiveHelper.responsiveHeight(context, 15.0)
                  //         : ResponsiveHelper.responsiveHeight(context, 18.0),
                  //     backgroundColor: Colors.blue,
                  //     backgroundImage:
                  //         CachedNetworkImageProvider(profileImageUrl),
                  //   ),
                  Expanded(
                    child: Text(
                      person.name,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: fullWidth ? null : 2,
                      overflow: fullWidth ? null : TextOverflow.ellipsis,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (person.verifiedTag)
                          Icon(
                            Icons.verified,
                            size: ResponsiveHelper.responsiveHeight(
                              context,
                              10,
                            ),
                            color: Colors.blue,
                          ),
                        Icon(
                          person.internalProfileLink!.isNotEmpty
                              ? Icons.arrow_forward_ios
                              : Icons.link,
                          size: ResponsiveHelper.responsiveHeight(
                            context,
                            15,
                          ),
                          color: Colors.blue,
                        )
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

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDisplayPortfolioGrid(
      context,
    );
  }
}
