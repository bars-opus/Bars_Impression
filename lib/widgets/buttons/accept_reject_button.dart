import 'package:bars/utilities/exports.dart';

class AcceptRejectButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final bool fullLength;
  final bool isAffiliate;
  const AcceptRejectButton(
      {super.key,
      required this.buttonText,
      required this.onPressed,
      required this.fullLength,
      this.isAffiliate = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isAffiliate
              ? 0
              : fullLength
                  ? 20.0
                  : 0,
        ),
        width: ResponsiveHelper.responsiveWidth(
            context,
            isAffiliate
                ? 135
                : fullLength
                    ? double.infinity
                    : 145.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isAffiliate
                ? Theme.of(context).cardColor.withOpacity(.5)
                : Theme.of(context).primaryColorLight,
            elevation: 0.0,
            foregroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
                ),
                textAlign: TextAlign.center,
              ),
              Icon(
                buttonText.startsWith('Accept') ? Icons.check : Icons.close,
                size: ResponsiveHelper.responsiveHeight(context, 20.0),
                color:
                    buttonText.startsWith('Accept') ? Colors.blue : Colors.red,
              )
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
    ;
  }
}
