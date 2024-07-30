import 'package:bars/utilities/exports.dart';

class AffiliateCommissionOptions extends StatelessWidget {
  final Widget widget;
  final String title;
  final VoidCallback onPressed;
  final bool isSelected;

  AffiliateCommissionOptions({
    super.key,
    required this.widget,
    required this.title,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: ResponsiveHelper.responsiveHeight(context, 130),
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
      ),
    );
  }
}
