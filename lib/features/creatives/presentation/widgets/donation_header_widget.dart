import 'package:bars/utilities/exports.dart';

class DonationHeaderWidget extends StatelessWidget {
  final String title;
  final Color iconColor;
  final IconData icon;
  final bool disableBottomPadding;
  const DonationHeaderWidget(
      {super.key,
      required this.title,
      required this.iconColor,
      required this.icon,
      this.disableBottomPadding = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Center(
          child: Icon(
            icon,
            size: ResponsiveHelper.responsiveHeight(context, 25),
            color: iconColor,
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        if (!disableBottomPadding)
          SizedBox(
            height: 30,
          ),
      ],
    );
  }
}
