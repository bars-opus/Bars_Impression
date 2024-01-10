import 'package:bars/utilities/exports.dart';

class NoContents extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData? icon;
  final Color color;

  NoContents({
    required this.title,
    required this.subTitle,
    required this.icon,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: color,
              size: ResponsiveHelper.responsiveHeight(context, 50.0),
            ),
          SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30),
            child: Text(
              subTitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
