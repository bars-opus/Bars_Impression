import 'package:bars/utilities/exports.dart';

class SchimmerSkeleton extends StatelessWidget {
  final Widget schimmerWidget;

  SchimmerSkeleton({required this.schimmerWidget});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: Colors.black54,
        highlightColor: Colors.grey,
        child: schimmerWidget);
  }
}
