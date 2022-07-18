import 'package:bars/utilities/exports.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget child;

  const ResponsiveScaffold({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
          textScaleFactor:
              MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
      child: Scaffold(
        backgroundColor:
            ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.grey[300],
        body: Align(
          alignment: Alignment.center,
          child: Container(
            width: width,
            child: child,
          ),
        ),
      ),
    );
  }
}
