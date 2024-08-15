import 'package:bars/utilities/exports.dart';

class HopeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final bool ready;
  final bool isOne;

  const HopeActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.ready = false,
    this.isOne = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 50),
      width: ResponsiveHelper.responsiveFontSize(context, isOne ? 320 : 150),
      child: TextButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: ready ? 1.0 : 0.0,
              duration: Duration(milliseconds: 1300),
              curve: Curves.easeInOut,
              child: Icon(
                size: ResponsiveHelper.responsiveFontSize(context, 15.0),
                icon,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 800),
                width: double.infinity,
                height: ResponsiveHelper.responsiveFontSize(context, 50),
                alignment: ready ? Alignment.centerLeft : Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
