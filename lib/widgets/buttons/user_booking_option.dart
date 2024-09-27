import 'package:bars/utilities/exports.dart';

class UserBookingOption extends StatelessWidget {
  final UserStoreModel bookingUser;

  UserBookingOption({required this.bookingUser});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.horizontal_rule,
          color: Theme.of(context).secondaryHeaderColor,
          size: ResponsiveHelper.responsiveHeight(context, 30.0),
        ),
        Container(
          width: width.toDouble(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DisclaimerWidget(
                  title: 'Booking Contact',
                  subTitle:
                      'These are the contacts provided by ${bookingUser.userName}. While we make efforts to gather the contact information for ${bookingUser.userName}, we cannot guarantee that these are the exact and correct contacts. Therefore, we advise you to conduct additional research and verify the management contact details for ${bookingUser.userName} independently.',
                  icon: Icons.call,
                ),
                const SizedBox(height: 40),
                PortfolioContactWidget(
                  portfolios: bookingUser.contacts,
                  edit: false,
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
