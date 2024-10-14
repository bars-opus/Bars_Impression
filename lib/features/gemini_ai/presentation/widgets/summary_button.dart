import 'package:bars/utilities/exports.dart';

class SummaryButton extends StatelessWidget {
  final IconData? icon;
  final Color color;
  final String summary;
  final bool isAi;

  const SummaryButton(
      {super.key,
      required this.icon,
      required this.color,
      required this.summary,
      this.isAi = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: isAi ? color : Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          isAi
              ? Center(
                  child: AnimatedCircle(
                    size: 20,
                    animateSize: true,
                    animateShape: true,
                  ),
                )
              : Icon(
                  icon,
                  size: ResponsiveHelper.responsiveHeight(context, 20),
                  color: color,
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              summary,
              style: TextStyle(
                color: isAi
                    ? Colors.white
                    : Theme.of(context).secondaryHeaderColor,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
            ),
          ),
        ],
      ),

      // _summaryRow(
      //   context,
      //   icon,
      //   color,
      //   summary,
      // ),
    );
  }
}
