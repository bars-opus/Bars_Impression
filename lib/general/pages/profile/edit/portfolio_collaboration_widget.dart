import 'package:bars/utilities/exports.dart';

class PortfolioCollaborationWidget extends StatelessWidget {
  List<PortfolioCollaborationModel> collaborations;
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
              person.name + 'ppp',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: fullWidth ? null : 2,
              overflow: fullWidth ? null : TextOverflow.ellipsis,
            ),
            subtitle: Text(
              person.role,
              style: TextStyle(
                color: Colors.blue,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
              ),
              maxLines: fullWidth ? null : 2,
              overflow: fullWidth ? null : TextOverflow.ellipsis,
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

  _collaborationWidget(
      BuildContext context, PortfolioCollaborationModel collaboration) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
              onTap: edit
                  ? () {}
                  : () {
                      _showBottomSheetWork(
                          context, collaboration.name, collaboration.link);
                    },
              title: ListTile(
                trailing: edit
                    ? IconButton(
                        onPressed: () => _removePortfolio(collaboration),
                        icon: Icon(
                          Icons.remove,
                          color: Colors.red,
                        ),
                      )
                    : null,
                title: Text(
                  collaboration.name,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 16),
                    color: Colors.blue,
                  ),
                ),
              ),
              subtitle: _buildDisplayPortfolioGrid(context, collaboration)),
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
    return Column(children: forumViews);
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    collaborations.sort((a, b) => a.name.compareTo(b.name));
    return collaborations.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
