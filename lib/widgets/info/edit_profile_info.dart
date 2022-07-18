import 'package:bars/utilities/exports.dart';

class EditProfileInfo extends StatelessWidget {
  final String editTitle;
  final String info;
  final IconData icon;

  EditProfileInfo({
    required this.editTitle,
    required this.info,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text(
              editTitle,
              style: TextStyle(color: Colors.blue, fontSize: 20.0, height: 1),
            ),
          ],
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          info,
          style: TextStyle(
            color: ConfigBloc().darkModeOn ? Colors.white : Colors.black,
            fontSize: 12.0,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: 2,
            color: Colors.blue,
            width: width / 3,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }
}
