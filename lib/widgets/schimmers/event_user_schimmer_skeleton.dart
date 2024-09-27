import 'package:bars/utilities/exports.dart';

class EventAndUserScimmerSkeleton extends StatelessWidget {
  late final String from;

  EventAndUserScimmerSkeleton({
    required this.from,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    _container() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: SchimmerSkeleton(
          schimmerWidget: Container(
            height: ResponsiveHelper.responsiveHeight(
              context,
              10,
            ),
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    Widget _buildEventGrid() {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        // physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1, // Adjust based on the aspect ratio of your items
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          // Post post = _postsList[index];
          return _container();
        },
      );
    }

    return from.startsWith('Posts')
        ? _buildEventGrid()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              height: ResponsiveHelper.responsiveHeight(
                context,
                80,
              ),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                  leading: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: ResponsiveHelper.responsiveHeight(
                        context,
                        40,
                      ),
                      width: ResponsiveHelper.responsiveHeight(
                        context,
                        40,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: from.startsWith('Event')
                            ? BorderRadius.circular(5)
                            : BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  trailing: SchimmerSkeleton(
                    schimmerWidget: Container(
                      height: ResponsiveHelper.responsiveHeight(
                        context,
                        20,
                      ),
                      width: ResponsiveHelper.responsiveHeight(
                        context,
                        20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: List.generate(4, (index) => _container()),
                    ),
                  )),
            ));
  }
}
