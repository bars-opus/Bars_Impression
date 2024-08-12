import 'package:bars/utilities/exports.dart';

class PriceRateWidget extends StatefulWidget {
  final List<PriceModel> prices;
  final bool edit;
  final bool seeMore;
  // final String currency;

  PriceRateWidget({
    required this.prices,
    required this.edit,
    required this.seeMore,
    // required this.currency,
  });

  @override
  State<PriceRateWidget> createState() => _PriceRateWidgetState();
}

class _PriceRateWidgetState extends State<PriceRateWidget> {
  int _selectedIndex = 0;



  _removePortfolio(PriceModel potfolio) {
    widget.prices.removeWhere((newPrice) =>
        newPrice.name == potfolio.name && newPrice.price == potfolio.price);
  }


  void selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _example(PriceModel price) {
    var divider = Divider(
      color: Colors.grey,
      thickness: .2,
    );
    return Column(
      children: [
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Package \nname',
          value: price.name,
        ),
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Value',
          value: price.value,
        ),
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Duration',
          value: price.duruation,
        ),
        divider
      ],
    );
  }

  _buildDisplayPortfolioList(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 400),
      color: Theme.of(context).cardColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.prices.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                var price = widget.prices[index];

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    _provider.setBookingPriceRate(price);
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 250,
                    height: isSelected ? 250 : 200,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Theme.of(context).primaryColorLight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: isSelected
                          ? Theme.of(context).primaryColorLight
                          : Theme.of(context).primaryColorLight.withOpacity(.5),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.edit)
                          IconButton(
                            onPressed: () => _removePortfolio(price),
                            icon: Icon(
                              size: ResponsiveHelper.responsiveHeight(
                                  context, 25.0),
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                        Center(
                          child: Text(
                            '${_provider.currency} ${price.price}',
                            style: TextStyle(
                              fontSize: isSelected ? 20 : 16,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? Colors.blue
                                  : Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                        _example(price),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.prices.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _selectedIndex == index ? 12 : 8,
                  height: _selectedIndex == index ? 12 : 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort the schedules by date in ascending order
    widget.prices.sort((a, b) => a.name.compareTo(b.name));

    return widget.prices.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
