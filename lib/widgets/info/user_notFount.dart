import 'package:bars/utilities/exports.dart';

class UserNotFound extends StatelessWidget {
  final String userName;

  UserNotFound({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1a1a1a),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Color(0xFF1a1a1a),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  ShakeTransition(
                    child: Icon(
                      Icons.person_off_outlined,
                      size: ResponsiveHelper.responsiveFontSize(
                        context,
                        40,
                      ),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(userName,
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(
                          context,
                          40,
                        ),
                        color: Colors.white,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Text('not found',
                      style: TextStyle(
                        fontSize: ResponsiveHelper.responsiveFontSize(
                          context,
                          14,
                        ),
                        color: Colors.red,
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'The account you\'re trying to access does not exist. It may have been deleted or the user data could be incorrect.',
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        14,
                      ),
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
