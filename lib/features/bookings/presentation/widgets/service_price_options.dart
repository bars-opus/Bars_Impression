import 'package:bars/utilities/exports.dart';

class ServicePriceOptions extends StatefulWidget {
  final UserStoreModel bookingUser;
      final bool fromPrice;


  const ServicePriceOptions({super.key, required this.bookingUser,
   required this.fromPrice,
  });

  @override
  State<ServicePriceOptions> createState() => _ServicePriceOptionsState();
}

class _ServicePriceOptionsState extends State<ServicePriceOptions> {
  void _showBottomSheetBookMe() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30)),
          child: UserBookingOption(
            
            bookingUser: widget.bookingUser,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _blueSyle = TextStyle(
      color: Colors.blue,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
    );

    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 700),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(30)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TicketPurchasingIcon(
              title: '',
            ),
            DonationHeaderWidget(
              title: 'select service',
              iconColor: Colors.grey,
              icon: FontAwesomeIcons.scissors,
              disableBottomPadding: true,
            ),
            const SizedBox(height: 20),
            TicketGroup(
               fromPrice: widget.fromPrice,
              openingHours: widget.bookingUser.openingHours,
              appointmentSlots: widget.bookingUser.appointmentSlots,
              bookingShop: widget.bookingUser,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                _showBottomSheetBookMe();
              },
              child: RichText(
                textScaler: MediaQuery.of(context).textScaler,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Carefully review the available price options and select the one that best fits your service needs. Please note that you can only select a single price option per booking request. If you have any further inquiries, you can ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: ' contact the creative ',
                      style: _blueSyle,
                    ),
                    TextSpan(
                      text: 'directly using the provided contact information.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
