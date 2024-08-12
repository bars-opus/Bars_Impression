import 'package:bars/utilities/exports.dart';

class PortfolioCollaborationWidget extends StatelessWidget {
  final List<PortfolioCollaborationModel> collaborations;
  final bool seeMore;
  final bool edit;

  PortfolioCollaborationWidget({
    required this.collaborations,
    required this.seeMore,
    required this.edit,
  });

  _removePortfolio(PortfolioCollaborationModel potfolio) {
    collaborations.removeWhere((schedule) =>
        schedule.name == potfolio.name && schedule.id == potfolio.id);
  }

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
          height: ResponsiveHelper.responsiveHeight(context, 430),
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
                  buttonText: 'Continue',
                  onPressed: () async {
                    Navigator.pop(context);
                    if (!await launchUrl(Uri.parse(link))) {
                      throw 'Could not launch link';
                    }
                    //             Navigator.push(
                    //                 context,
                    //                 MaterialPageRoute(
                    //                     builder: (_) => MyWebView(
                    //                           url: link, title: '',
                    //                         )));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  _buildPeople(BuildContext context, double width, CollaboratedPeople person,
      bool fullWidth) {
    var _currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    return Padding(
      padding: fullWidth
          ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
          : EdgeInsets.all(0),
      child: Container(
        color: Theme.of(context).primaryColorLight.withOpacity(.6),
        width: fullWidth ? width : width / 2,
        child: Padding(
          padding:
              fullWidth ? EdgeInsets.all(10.0) : EdgeInsets.only(bottom: 2.0),
          child: ListTile(
            onTap: edit
                ? () {}
                : () {
                    person.externalProfileLink!.isEmpty
                        ? _navigateToPage(
                            context,
                            ProfileScreen(
                              currentUserId: _currentUserId!,
                              userId: person.internalProfileLink!,
                              user: null,
                            ))
                        : _showBottomSheetWork(
                            context, person.name, person.externalProfileLink!);
                  },
            title: Text(
              person.name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: fullWidth ? null : 2,
              overflow: fullWidth ? null : TextOverflow.ellipsis,
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  person.role,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                  ),
                  maxLines: fullWidth ? null : 2,
                  overflow: fullWidth ? null : TextOverflow.ellipsis,
                ),
                Icon(
                  person.externalProfileLink!.isEmpty
                      ? Icons.arrow_forward_ios
                      : Icons.link,
                  color: Colors.blue,
                  size: ResponsiveHelper.responsiveHeight(
                      context, person.externalProfileLink!.isEmpty ? 15 : 25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildDisplayPortfolioGrid(
      BuildContext context, PortfolioCollaborationModel collaboration) {
    List<CollaboratedPeople> people = collaboration.people;

    final width = MediaQuery.of(context).size.width;
    List<Widget> tiles = [];
    people.forEach(
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

  _scheduleTitle(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ));
  }

  _peopleMini(BuildContext context, PortfolioCollaborationModel collaboration) {
    int maxDisplayCount = 9;
    int displayCount = collaboration.people.length > maxDisplayCount
        ? maxDisplayCount
        : collaboration.people.length;
    int remainingCount = collaboration.people.length > maxDisplayCount
        ? collaboration.people.length - maxDisplayCount
        : 0;

    double overlapOffset = 25.0;

    final width = MediaQuery.of(context).size.width;
    var _currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;
    List<CollaboratedPeople> people = collaboration.people;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Stack(
                children: [
                  Container(
                    height: ResponsiveHelper.responsiveHeight(context, 800),
                    width: ResponsiveHelper.responsiveHeight(context, 400),
                    padding: EdgeInsets.only(
                        top: ResponsiveHelper.responsiveFontSize(context, 120)),
                    color: Colors.transparent,
                    child: ListView.builder(
                      itemCount: people.length,
                      itemBuilder: (context, index) {
                        var person = people[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5),
                          child: ScheduleBuildPeople(
                            currentUserId: _currentUserId!,
                            edit: edit,
                            from: 'list',
                            width: width,
                            fullWidth: false,
                            person: person,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 70,
                    left: 20,
                    child: _scheduleTitle(context),
                  ),
                ],
              );
            });
      },
      child: ShakeTransition(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          height: ResponsiveHelper.responsiveWidth(context, 50),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              ...List.generate(displayCount, (index) {
                String imageUrl =
                    collaboration.people[index].profileImageUrl ?? '';

                return Positioned(
                  left: index * overlapOffset,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: imageUrl.isEmpty
                        ? Icon(
                            Icons.account_circle,
                            size: 36.0,
                            color: Colors.grey,
                          )
                        : CircleAvatar(
                            radius: 17, // Adjust the radius as needed
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(imageUrl),
                          ),
                  ),
                );
              }),
              if (remainingCount > 0)
                Positioned(
                  left: displayCount * overlapOffset,
                  child: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '+$remainingCount',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12),
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ListView.builder(
          //   scrollDirection: Axis.horizontal,
          //   itemCount: people.length,
          //   itemBuilder: (context, index) {
          //     String imageUrl = '';
          //     //  people[index].profileImageUrl == null
          //     //     ? ''
          //     //     : people[index].profileImageUrl!;
          //     return imageUrl.isEmpty
          //         ? Icon(
          //             Icons.account_circle,
          //             size: ResponsiveHelper.responsiveHeight(context, 30.0),
          //             color: Colors.grey,
          //           )
          //         : CircleAvatar(
          //             radius: ResponsiveHelper.responsiveWidth(context, 12),
          //             backgroundColor: Colors.blue,
          //             backgroundImage: NetworkImage(
          //                 imageUrl), // replace with your user avatar url
          //           );
          //   },
          // ),
        ),
      ),
    );
  }

  _collaborationWidget(
      BuildContext context, PortfolioCollaborationModel collaboration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ListTile(
            onTap: edit
                ? () {}
                : () {
                    _showBottomSheetWork(
                        context, collaboration.name, collaboration.link);
                  },
            trailing: edit
                ? IconButton(
                    onPressed: () => _removePortfolio(collaboration),
                    icon: Icon(
                      Icons.remove,
                      color: Colors.red,
                    ),
                  )
                : null,
            title: _peopleMini(context, collaboration),
            subtitle: Text(
              collaboration.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          //_buildDisplayPortfolioGrid(context, collaboration)
        ),
      ),
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    List<Widget> forumViews = [];
    collaborations.forEach((portfolio) {
      forumViews.add(_collaborationWidget(
        context,
        portfolio,
      ));
    });
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 200),
      color: Theme.of(context).primaryColorLight,
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2, // Items down the screen
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 0.3,
        children: forumViews,
      ),
    );
  }

  _buildDisplayPortfolioList2(BuildContext context) {
    List<Widget> forumViews = [];
    collaborations.forEach((portfolio) {
      forumViews.add(_collaborationWidget(
        context,
        portfolio,
      ));
    });
    return Column(children: forumViews);
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    collaborations.sort((a, b) => a.name.compareTo(b.name));
    return collaborations.length < 1
        ? SizedBox.shrink()
        : seeMore
            ? _buildDisplayPortfolioList2(context)
            : _buildDisplayPortfolioList(context);
  }
}
