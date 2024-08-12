import 'package:bars/utilities/exports.dart';

class HopeActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final bool ready;
  const HopeActionButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.ready = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveHelper.responsiveFontSize(context, 50),
      width: ResponsiveHelper.responsiveFontSize(context, 150),
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
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
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 800),
                  width: double.infinity,
                  alignment: ready ? Alignment.centerLeft : Alignment.center,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12),
                      color: ready ? Colors.white : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
