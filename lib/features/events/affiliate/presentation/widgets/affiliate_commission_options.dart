import 'package:bars/utilities/exports.dart';

class AffiliateCommissionOptions extends StatelessWidget {
  final Widget widget;
  // final String subTitle;
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  AffiliateCommissionOptions({
    super.key,
    required this.widget,
    required this.title,
    required this.onPressed,
    // required this.subTitle,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: ResponsiveHelper.responsiveHeight(context, 130),
        // height: ResponsiveHelper.responsiveHeight(context, 200),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:
                isSelected ? Colors.blue : Theme.of(context).primaryColorLight,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColorLight.withOpacity(.5),
        ),
        child: Center(child: widget),

        //  Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     widget,
        //     SizedBox(
        //       height: 10,
        //     ),
        //     Text(
        //       title,
        //       style: TextStyle(
        //         color: isSelected
        //             ? Colors.blue
        //             : Theme.of(context).secondaryHeaderColor,
        //         fontWeight: FontWeight.bold,
        //         fontFamily: 'Metropolis',
        //         fontSize: ResponsiveHelper.responsiveFontSize(
        //             context, isSelected ? 14 : 12),
        //       ),
        //     ),
        //     // SizedBox(
        //     //   height: 10,
        //     // ),
        //     // Text(
        //     //   subTitle,
        //     //   style: TextStyle(
        //     //     color: Theme.of(context).secondaryHeaderColor,
        //     //     fontSize: ResponsiveHelper.responsiveFontSize(context, 14),
        //     //   ),
        //     //   textAlign: TextAlign.center,
        //     // ),
        //   ],
        // ),
      ),
    );
  }
}
