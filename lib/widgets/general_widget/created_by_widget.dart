import 'package:bars/utilities/exports.dart';

class CreatedBy extends StatelessWidget {
  final String author;
  final String authorProfileHande;
  final int score;
  final Function onPressed;

  CreatedBy(
      {required this.author,
      required this.authorProfileHande,
      required this.onPressed,
      required this.score});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BarsTextSubTitle(
            text: 'created by:',
          ),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(author,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                    )),
              ),
              // !verified
              //     ? nil
              //     :
              Positioned(
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
          BarsTextSubTitle(
            text: authorProfileHande,
          ),
          authorProfileHande.startsWith('F') || authorProfileHande.isEmpty
              ? const SizedBox.shrink()
              : Stars(
                  score: score,
                ),
        ],
      ),
    );
  }
}
