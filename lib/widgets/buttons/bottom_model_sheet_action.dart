import 'package:bars/utilities/exports.dart';

class MyBottomModelSheetAction extends StatelessWidget {
  final List<Widget> actions;

  MyBottomModelSheetAction({required this.actions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      itemBuilder: (BuildContext context, int index) {
        return actions[index];
      },
    );
  }
}
