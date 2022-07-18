import 'package:bars/utilities/exports.dart';

class ExploreClose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ConfigBloc().darkModeOn ? Color(0xFF1f2022) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 10),
            blurRadius: 10.0,
            spreadRadius: 4.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: IconButton(
          icon: Icon(Icons.close),
          iconSize: 30.0,
          color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
