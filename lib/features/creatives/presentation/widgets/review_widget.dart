import 'package:bars/utilities/exports.dart';

class ReviewWidget extends StatelessWidget {
  final ReviewModel review;
  final bool fullWidth;
  const ReviewWidget({super.key, required this.review, required this.fullWidth});

  @override
  Widget build(BuildContext context) {
        final width = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.all(10),
      width: width,
      child: ListTile(
        onTap: () {},
        title: StarRatingWidget(
          isMini: true,
          rating: review.rating,
          onRatingChanged: (rating) {},
        ),
        subtitle: Text(
          review.comment * 3,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: fullWidth ? null : 4,
          overflow: fullWidth ? null : TextOverflow.ellipsis,
        ),
      ),
    );
    ;
  }
}
