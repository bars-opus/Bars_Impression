import 'package:bars/general/models/user_author_model.dart';
import 'package:bars/utilities/exports.dart';

class UserListTile extends StatelessWidget {
  final AccountHolderAuthor user;
  final VoidCallback onPressed;

  UserListTile({required this.user, required this.onPressed});

  final RandomColor _randomColor = RandomColor();
  final List<ColorHue> _hueType = <ColorHue>[
    ColorHue.green,
    ColorHue.red,
    ColorHue.pink,
    ColorHue.purple,
    ColorHue.blue,
    ColorHue.yellow,
    ColorHue.orange
  ];

  final ColorSaturation _colorSaturation = ColorSaturation.random;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListTile(
      leading: user.profileImageUrl!.isEmpty
          ? Icon(
              Icons.account_circle,
              size: 60.0,
              color: Colors.grey,
            )
          : CircleAvatar(
              radius: 25.0,
              backgroundColor: ConfigBloc().darkModeOn
                  ? Color(0xFF1a1a1a)
                  : Color(0xFFf2f2f2),
              backgroundImage:
                  CachedNetworkImageProvider(user.profileImageUrl!),
            ),
      title: Align(
        alignment: Alignment.topLeft,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(user.userName!,
                  style: TextStyle(
                    fontSize: width > 800 ? 18 : 14.0,
                    fontWeight: FontWeight.bold,
                    color:
                        ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                  )),
            ),
            user.verified!.isEmpty
                ? const SizedBox.shrink()
                : Positioned(
                    top: 3,
                    right: 0,
                    child: Icon(
                      MdiIcons.checkboxMarkedCircle,
                      size: 11,
                      color: Colors.blue,
                    ),
                  ),
          ],
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Container(
                  color: _randomColor.randomColor(
                    colorHue: ColorHue.multiple(colorHues: _hueType),
                    colorSaturation: _colorSaturation,
                  ),
                  height: 1.0,
                  width: 25.0,
                ),
              ),
            ],
          ),
          Text(user.profileHandle!,
              style: TextStyle(
                fontSize: width > 800 ? 14 : 12,
                color: Colors.blue,
              )),
        
          SizedBox(
            height: 10.0,
          ),
          Divider(
            color:
                ConfigBloc().darkModeOn ? Colors.grey[850] : Colors.grey[350],
          )
        ],
      ),
      onTap: onPressed,
    );
  }
}
