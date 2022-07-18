import 'package:bars/utilities/exports.dart';

class StarRating extends StatefulWidget {
  final int muximumRating;
  final Function(int) onRatingSelected;

  const StarRating({
    required Key key,
    this.muximumRating = 5,
    required this.onRatingSelected,
  }) : super(key: key);

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _currentRating = 0;

  Widget _buildRatingStar(int index) {
    if (index < _currentRating) {
      return Icon(
        Icons.star,
        color: Colors.yellow[800],
      );
    } else {
      return Icon(
        Icons.star_border_outlined,
        color: Colors.grey,
      );
    }
  }

  Widget _buildBody() {
    final stars = List<Widget>.generate(this.widget.muximumRating, (index) {
      return GestureDetector(
        child: _buildRatingStar(index),
        onTap: () {
          setState(() {
            _currentRating = index + 1;
          });
          this.widget.onRatingSelected(_currentRating);
        },
      );
    });

    return Row(
      children: stars,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }
}
