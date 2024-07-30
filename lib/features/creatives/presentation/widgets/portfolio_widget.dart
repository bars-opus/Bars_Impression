import 'package:bars/utilities/exports.dart';

class PortfolioWidget extends StatelessWidget {
  final List<PortfolioModel> portfolios;
  final bool seeMore;
  final bool edit;

  PortfolioWidget({
    required this.portfolios,
    required this.seeMore,
    required this.edit,
  });

  _removePortfolio(PortfolioModel potfolio) {
    portfolios.removeWhere((schedule) =>
        schedule.name == potfolio.name && schedule.link == potfolio.link);
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildDisplayPortfolioGrid(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<Widget> tiles = [];
    portfolios.forEach((portfolio) =>
        tiles.add(_buildTilePost(context, width, portfolio, false)));

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 100.0),
      color: Theme.of(context).primaryColorLight,
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2, // Items down the screen
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio:
            0.2, // Adjust this to change the vertical size, smaller number means smaller height
        children: tiles,
      ),
    );
  }

  _buildDisplayPortfolioGrid2(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<Widget> tiles = [];
    portfolios.forEach((portfolio) =>
        tiles.add(_buildTilePost(context, width, portfolio, false)));

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 100.0),
      color: Theme.of(context).primaryColorLight,
      child: GridView.count(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 2, // Items down the screen
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio:
            0.2, // Adjust this to change the vertical size, smaller number means smaller height
        children: tiles,
      ),
    );
  }

  _buildTilePost(BuildContext context, double width, PortfolioModel portfolio,
      bool fullWidth) {
    return Padding(
      padding: fullWidth
          ? EdgeInsets.only(top: 5.0, left: 10, right: 10)
          : EdgeInsets.all(0),
      child: Container(
        color: Theme.of(context).cardColor,
        width: fullWidth ? width : width / 2,
        child: Padding(
          padding:
              fullWidth ? EdgeInsets.all(10.0) : EdgeInsets.only(bottom: 2.0),
          child: ListTile(
            onTap: edit
                ? () {}
                : () {
                    _showBottomSheetWork(
                        context, portfolio.name, portfolio.link);
                  },
            title: Text(
              portfolio.name,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: fullWidth ? null : 2,
              overflow: fullWidth ? null : TextOverflow.ellipsis,
            ),
            trailing: edit
                ? IconButton(
                    onPressed: () => _removePortfolio(portfolio),
                    icon: Icon(
                      Icons.remove,
                      color: Colors.red,
                      size: ResponsiveHelper.responsiveHeight(context, 25.0),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    List<Widget> forumViews = [];
    portfolios.forEach((portfolio) {
      forumViews.add(_buildTilePost(context, width, portfolio, true));
    });
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(children: forumViews),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    portfolios.sort((a, b) => a.name.compareTo(b.name));
    return portfolios.length < 1
        ? SizedBox.shrink()
        : seeMore
            ? _buildDisplayPortfolioList(context)
            : edit
                ? _buildDisplayPortfolioGrid(context)
                : _buildDisplayPortfolioGrid2(context);
  }
}
