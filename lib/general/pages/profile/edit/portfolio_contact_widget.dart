import 'package:bars/utilities/exports.dart';

class PortfolioContactWidget extends StatelessWidget {
  final List<PortfolioContactModel> portfolios;
  final bool edit;

  PortfolioContactWidget({
    required this.portfolios,
    required this.edit,
  });

  _removePortfolio(PortfolioContactModel potfolio) {
    portfolios.removeWhere((schedule) =>
        schedule.email == potfolio.email && schedule.number == potfolio.number);
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
    PortfolioContactModel portfolio,
  ) {
    bool isEmail = portfolio.email.isEmpty ? false : true;
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
            onTap: isEmail
                ? () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    _sendMail(portfolio.email, context);
                  }
                : () {
                    Navigator.pop(context);
                    HapticFeedback.lightImpact();
                    _makePhoneCall(portfolio.number.toString(), context);
                  },
            leading: Icon(
              size: ResponsiveHelper.responsiveHeight(context, 25.0),
              !isEmail ? Icons.phone : Icons.mail_outlined,
              color: Colors.blue,
            ),
            title: Text(
              !isEmail ? portfolio.number.toString() : portfolio.email,
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
      height: ResponsiveHelper.responsiveHeight(context, 250.0),
      child: ListView(
          physics: const AlwaysScrollableScrollPhysics(), children: forumViews),
    );
  }

  @override
  Widget build(BuildContext context) {
    return portfolios.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
