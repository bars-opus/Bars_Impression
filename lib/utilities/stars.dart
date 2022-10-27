import 'package:bars/utilities/exports.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class Stars extends StatefulWidget {
  final int score;

  const Stars({
    required this.score,
  });

  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  @override
  Widget build(BuildContext context) {
    return widget.score <= 100
        ? SmoothStarRating(
            rating: 0,
            color: Colors.yellow[900],
            borderColor: Colors.grey,
            size: 25,
            filledIconData: Icons.star,
            halfFilledIconData: Icons.bar_chart,
            defaultIconData: Icons.star_border,
            starCount: 5,
            allowHalfRating: false,
            spacing: 2.0,
          )
        : widget.score >= 100 && widget.score <= 1000
            ? SmoothStarRating(
                rating: 1,
                color: Colors.yellow[900],
                borderColor: Colors.grey,
                size: 25,
                filledIconData: Icons.star,
                halfFilledIconData: Icons.star_half,
                defaultIconData: Icons.star_border,
                starCount: 5,
                allowHalfRating: false,
                spacing: 2.0,
              )
            : widget.score >= 1000 && widget.score <= 10000
                ? SmoothStarRating(
                    rating: 2,
                    color: Colors.yellow[900],
                    borderColor: Colors.grey,
                    size: 25,
                    filledIconData: Icons.star,
                    halfFilledIconData: Icons.star_half,
                    defaultIconData: Icons.star_border,
                    starCount: 5,
                    allowHalfRating: false,
                    spacing: 2.0,
                  )
                : widget.score >= 10000 && widget.score <= 100000
                    ? SmoothStarRating(
                        rating: 3,
                        color: Colors.yellow[900],
                        borderColor: Colors.grey,
                        size: 20,
                        filledIconData: Icons.linear_scale,
                        halfFilledIconData: Icons.star_half,
                        defaultIconData: Icons.star_border,
                        starCount: 5,
                        allowHalfRating: false,
                        spacing: 2.0,
                      )
                    : widget.score >= 100000 && widget.score <= 1000000
                        ? SmoothStarRating(
                            rating: 4,
                            color: Colors.yellow[900],
                            borderColor: Colors.grey,
                            size: 25,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: false,
                            spacing: 2.0,
                          )
                        : widget.score >= 1000000 && widget.score <= 10000000
                            ? SmoothStarRating(
                                rating: 5,
                                color: Colors.yellow[900],
                                borderColor: Colors.grey,
                                size: 25,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: false,
                                spacing: 2.0,
                              )
                            : SmoothStarRating(
                                rating: 5,
                                color: Colors.yellow[900],
                                borderColor: Colors.grey,
                                size: 25,
                                filledIconData: Icons.star,
                                halfFilledIconData: Icons.star_half,
                                defaultIconData: Icons.star_border,
                                starCount: 5,
                                allowHalfRating: false,
                                spacing: 2.0,
                              );
  }
}
