
import 'package:bars/utilities/exports.dart';

class TapToAccessDashboard extends StatelessWidget {
  
  const TapToAccessDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return   ListTile(
               
                leading: ShakeTransition(
                  duration: const Duration(seconds: 2),
                  child: Icon(
                    color: Colors.blue,
                    Icons.dashboard,
                    size: ResponsiveHelper.responsiveFontSize(context, 40),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: ResponsiveHelper.responsiveHeight(context, 18.0),
                ),
                title: Text(
                  "Tap to access your dashboard",
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    color: Colors.blue,
                  ),
                ),
              );
  }
}
