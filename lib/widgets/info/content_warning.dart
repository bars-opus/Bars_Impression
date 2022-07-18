import 'dart:ui';
import 'package:bars/utilities/exports.dart';

class ContentWarning extends StatelessWidget {
  final String imageUrl;
  final String report;

  final Function onPressed;

  ContentWarning(
      {required this.imageUrl, required this.report, required this.onPressed});

  Widget buildBlur({
    required Widget child,
    double sigmaX = 20,
    double sigmaY = 20,
    required BorderRadius borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: buildBlur(
          borderRadius: BorderRadius.circular(0),
          child: Container(
              color: Colors.black.withOpacity(.9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ShakeTransition(
                    child: Icon(
                      MdiIcons.eyeOff,
                      color: Colors.grey,
                      size: 50.0,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Text(
                      "REPORTED CONTENT",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        'The following content has been identified by other users as  ' +
                            report +
                            ' which some people my find disturbing or offensive.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 100,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.transparent,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.transparent,
                        side: BorderSide(width: 1.0, color: Colors.transparent),
                      ),
                      onPressed: () => onPressed,
                      child: Text(
                        'Reveal Content',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
