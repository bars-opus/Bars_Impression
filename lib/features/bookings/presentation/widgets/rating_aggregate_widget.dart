import 'package:bars/utilities/exports.dart';

class RatingAggregateWidget extends StatelessWidget {
  final Map<int, int> starCounts;
  final bool isCurrentUser;
  // Count of ratings for each star level

  RatingAggregateWidget({
    required this.starCounts,
    required this.isCurrentUser,
  });

  // Calculate the total number of ratings
  int get totalRatings {
    return starCounts.values.fold(0, (sum, count) => sum + count);
  }

  // Calculate the average rating
//   Total Ratings: The totalRatings getter calculates the total number of ratings by summing all values in the starCounts map.
// Average Rating: The averageRating getter calculates the weighted average rating. It multiplies each star level by its count,
//sums these products, and divides by the total number of ratings.

// Example
// The total number of ratings is 250.
// Average Rating=
// (5×150)+(4×60)+(3×20)+(2×10)+(1×10)
// -----------------------------------
//               250 ​
//The starCounts map shows how many times each star rating was given
// 5×150=750
// 4×60=240
// 3×20=60
// 2×10=20
// 1×10=10

// Summing these products: 750+240+60+20+10=1080
// Finally, divide by the total number of ratings:

// Average Rating= 1080
  // ---- =4.32
  // 250

  double get averageRating {
    int totalStars = starCounts.entries
        .fold(0, (sum, entry) => sum + (entry.key * entry.value));
    return totalRatings > 0 ? totalStars / totalRatings : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    var _smallFont =
        TextStyle(fontSize: ResponsiveHelper.responsiveFontSize(context, 12));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Average Rating Score
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display the average rating score
            Text(
              averageRating.toStringAsFixed(1),
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 30),
                fontWeight: FontWeight.bold,
              ),
            ),
            // Display the total number of ratings
            Text(
              '$totalRatings Ratings',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12),
                color: Theme.of(context).secondaryHeaderColor,
              ),
            ),
          ],
        ),
        // Star Aggregates
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(5, (index) {
            int star = 5 - index;
            int count = starCounts[star] ??
                0; // Get the count of ratings for the current star level, default to 0 if not present
            double percentage = totalRatings > 0
                ? (count / totalRatings)
                : 0; // Calculate the percentage of ratings for the current star level

            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Display the star level (e.g., "5")
                Text('$star', style: _smallFont),
                // Spacer
                SizedBox(width: 8),
                // Rating bar representing the percentage of ratings for the current star level
                Container(
                  width: ResponsiveHelper.responsiveWidth(context, 200),
                  height: 8,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(.1), // Background color of the rating bar
                    borderRadius: BorderRadius.circular(
                        4), // Rounded corners for the rating bar
                  ),
                  child: FractionallySizedBox(
                    widthFactor:
                        percentage, // Set the width factor according to the percentage of ratings
                    alignment: Alignment
                        .centerLeft, // Align the filled portion to the left
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .secondaryHeaderColor, // Color of the filled portion of the rating bar
                        borderRadius: BorderRadius.circular(
                            4), // Rounded corners for the filled portion
                      ),
                    ),
                  ),
                ),
                // if (isCurrentUser) SizedBox(width: 8),
                // if (isCurrentUser)
                //   Text(
                //     '$count',
                //     style: _smallFont,
                //   ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
