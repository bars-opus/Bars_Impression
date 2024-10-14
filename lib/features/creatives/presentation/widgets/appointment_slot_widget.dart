import 'package:bars/utilities/exports.dart';

class AppointmentSlotWidget extends StatefulWidget {
  final List<AppointmentSlotModel> appointmentSlots;
  final bool edit;

  AppointmentSlotWidget({
    required this.appointmentSlots,
    required this.edit,
  });

  @override
  State<AppointmentSlotWidget> createState() => _AppointmentSlotWidgetState();
}

class _AppointmentSlotWidgetState extends State<AppointmentSlotWidget> {
  int _selectedIndex = 0;

  _removePortfolio(AppointmentSlotModel appointment) {
    widget.appointmentSlots.removeWhere((newPrice) =>
        newPrice.id == appointment.id && newPrice.price == appointment.price);
  }

  void selectItem(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _example(AppointmentSlotModel appointment) {
    var divider = Divider(
      color: Colors.grey,
      thickness: .2,
    );
    return Column(
      children: [
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Service',
          value: appointment.service,
        ),
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Duration',
          value: appointment.duruation,
        ),
        divider,
        PayoutDataWidget(
          inMini: true,
          label: 'Wokrers',
          value: appointment.duruation,
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
              itemCount: widget.appointmentSlots.length,
              itemBuilder: (context, index) {
                bool isSelected = _selectedIndex == index;
                var appointments = widget.appointmentSlots[index];

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    // _provider.setBookingPriceRate(price);
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
                            onPressed: () => _removePortfolio(appointments),
                            icon: Icon(
                              size: ResponsiveHelper.responsiveHeight(
                                  context, 25.0),
                              Icons.remove,
                              color: Colors.red,
                            ),
                          ),
                        Center(
                          child: Text(
                            '${_provider.currency} ${appointments.price}',
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
                        _example(appointments),
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
              children: List.generate(widget.appointmentSlots.length, (index) {
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
    widget.appointmentSlots.sort((a, b) => a.service.compareTo(b.service));

    return widget.appointmentSlots.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}
