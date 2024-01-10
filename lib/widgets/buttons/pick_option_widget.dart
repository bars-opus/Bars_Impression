import 'package:bars/utilities/exports.dart';

class PickOptionWidget extends StatelessWidget {
  final String title;
  final bool dropDown;

  final VoidCallback onPressed;

  PickOptionWidget(
      {required this.title, required this.onPressed, required this.dropDown});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: ResponsiveHelper.responsiveHeight(context, 2.0),
                  horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          fontWeight: FontWeight.bold)),
                  Icon(
                    dropDown ? Icons.arrow_drop_down : Icons.add,
                    color: Colors.blue,
                    size: ResponsiveHelper.responsiveHeight(context, 30.0),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
