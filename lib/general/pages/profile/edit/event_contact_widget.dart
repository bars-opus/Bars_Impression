import 'package:bars/utilities/exports.dart';

class EventOrganizerContactWidget extends StatelessWidget {
  final List<String> portfolios;
  final bool edit;

  EventOrganizerContactWidget({
    required this.portfolios,
    required this.edit,
  });

  _removePortfolio(String potfolio) {
    portfolios.removeWhere((schedule) => schedule == potfolio);
  }

  Future<void> _sendMail(String email, BuildContext context) async {
    String url = 'mailto:$email';
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not launch mail');
    }
  }

  Future<void> _makePhoneCall(String phoneNumber, BuildContext context) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrl(
      Uri.parse(url),
    )) {
      await (launchUrl(
        Uri.parse(url),
      ));
    } else {
      mySnackBar(context, 'Could not make call');
    }
  }

  _buildTilePost(
    BuildContext context,
    double width,
    String portfolio,
  ) {
    bool isEmail = portfolio.isEmpty ? false : true;
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: edit
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(0),
          ),
          child: ListTile(
            onTap: () {
              Navigator.pop(context);
              HapticFeedback.lightImpact();
              _makePhoneCall(portfolio.toString(), context);
            },
            leading: Icon(
              size: ResponsiveHelper.responsiveHeight(context, 25.0),
              Icons.phone,
              color: Colors.blue,
            ),
            title: Text(
              portfolio,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            trailing: edit
                ? IconButton(
                    onPressed: () => _removePortfolio(portfolio),
                    icon: Icon(
                      size: ResponsiveHelper.responsiveHeight(context, 25.0),
                      Icons.remove,
                      color: Colors.red,
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
      forumViews.add(_buildTilePost(
        context,
        width,
        portfolio,
      ));
    });

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, edit ? 400 : 250.0),
      child: ListView(
          physics: edit
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          children: forumViews),
    );
  }

  @override
  Widget build(BuildContext context) {
    return portfolios.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
