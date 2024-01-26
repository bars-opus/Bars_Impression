import 'package:bars/utilities/exports.dart';

class PriceRateWidget extends StatelessWidget {
  final List<PriceModel> prices;
  final bool edit;
  final bool seeMore;
  final String currency;

  PriceRateWidget({
    required this.prices,
    required this.edit,
    required this.seeMore,
    required this.currency,
  });

  _removePortfolio(PriceModel potfolio) {
    prices.removeWhere((newPrice) =>
        newPrice.name == potfolio.name && newPrice.price == potfolio.price);
  }

  _rateWidget(BuildContext context, PriceModel price) {
    final List<String> currencyPartition =
        currency.trim().replaceAll('\n', ' ').split("|");
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            trailing: edit
                ? IconButton(
                    onPressed: () => _removePortfolio(price),
                    icon: Icon(
                      size: ResponsiveHelper.responsiveHeight(context, 25.0),
                      Icons.remove,
                      color: Colors.red,
                    ),
                  )
                : null,
            title: RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(children: [
                  TextSpan(
                    text:
                        '${currencyPartition.isEmpty ? '' : currencyPartition.length > 0 ? currencyPartition[1] : ''} ${price.price.toString()}',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 18.0),
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "\n${price.name}",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Colors.blue,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "\n${price.value}",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Theme.of(context).secondaryHeaderColor,
                      // fontWeight: FontWeight.bold,
                    ),
                  )
                ])),
          ),
        ),
      ),
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    List<Widget> forumViews = [];
    seeMore
        ? prices.forEach((portfolio) {
            forumViews.add(_rateWidget(
              context,
              portfolio,
            ));
          })
        : prices.take(3).forEach((portfolio) {
            forumViews.add(_rateWidget(
              context,
              portfolio,
            ));
          });
    return Column(children: forumViews);
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    prices.sort((a, b) => a.name.compareTo(b.name));

    return prices.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
