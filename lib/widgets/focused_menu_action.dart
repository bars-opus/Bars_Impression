import 'package:bars/utilities/exports.dart';

class FocusedMenuAction extends StatelessWidget {
  final VoidCallback onPressedShare;
  final VoidCallback onPressedSend;
  final VoidCallback onPressedReport;
  final Widget child;
  final bool isAuthor;

  FocusedMenuAction(
      {required this.onPressedShare,
      required this.onPressedSend,
      required this.onPressedReport,
      required this.child,
      required this.isAuthor});

  _action(BuildContext context, String text) {
    return Expanded(
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return FocusedMenuHolder(
      menuWidth: width.toDouble(),
      menuItemExtent: 60,
      menuOffset: 10,
      blurBackgroundColor: Colors.transparent,
      openWithTap: false,
      onPressed: () {},
      menuItems: [
        FocusedMenuItem(
          title: _action(
            context,
            'Send',
          ),
          onPressed: onPressedSend,
        ),
        FocusedMenuItem(
          title: _action(
            context,
            'share',
          ),
          onPressed: onPressedShare,
        ),
        FocusedMenuItem(
            title: _action(
              context,
              isAuthor ? 'Edit' : 'Report',
            ),
            onPressed: onPressedReport),
        FocusedMenuItem(
          title: _action(
            context,
            'Suggest',
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SuggestionBox()));
          },
        ),
      ],
      child: child,
    );
  }
}
