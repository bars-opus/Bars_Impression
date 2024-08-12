import 'package:bars/utilities/exports.dart';

class ShedulePeopleHorizontal extends StatelessWidget {
  final bool edit;
  final String from;
  final List schedulepeople;
  final String currentUserId;
  final Event event;
  final bool fromDetails;
  final bool? isSponsor;

  const ShedulePeopleHorizontal(
      {super.key,
      required this.edit,
      required this.from,
      required this.schedulepeople,
      required this.event,
      required this.fromDetails,
      this.isSponsor,
      required this.currentUserId});

// To display the people tagged in a post as performers, crew, sponsors or partners
  void _showBottomSheetTaggedPeople(
    BuildContext context,
    final bool isSponsor,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return EventTaggedPeople(
          event: event,
          isSponsor: isSponsor,
          showTagsOnImage: false,
        );
      },
    );
  }

  void _showBottomSheetTaggedPeopleOption(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
            height: ResponsiveHelper.responsiveHeight(context, 200),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(30)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.people_outline,
                  onPressed: () {
                    _showBottomSheetTaggedPeople(context, false);
                  },
                  text: 'Crew and performers',
                ),
                BottomModelSheetListTileActionWidget(
                  colorCode: '',
                  icon: Icons.handshake_outlined,
                  onPressed: () {
                    _showBottomSheetTaggedPeople(context, true);
                  },
                  text: 'Partners and sponser',
                ),
              ],
            ));
      },
    );
  }

  _peopleMini(BuildContext context) {
    int maxDisplayCount = fromDetails ? 9 : 5;
    int displayCount = schedulepeople.length > maxDisplayCount
        ? maxDisplayCount
        : schedulepeople.length;
    int remainingCount = schedulepeople.length > maxDisplayCount
        ? schedulepeople.length - maxDisplayCount
        : 0;

    double overlapOffset = 25.0;
    double circleAvatarDiameter = 36.0; // 2 * radius + padding
    double totalWidth =
        (displayCount - 1) * overlapOffset + circleAvatarDiameter;
    double screenWidth = MediaQuery.of(context).size.width;
    double startPosition = (screenWidth - totalWidth) / 2;

    return GestureDetector(
      onTap: fromDetails
          ? () {
              _showBottomSheetTaggedPeople(
                context,
                isSponsor ?? false,
              );
            }
          : () {
              _showBottomSheetTaggedPeopleOption(
                context,
              );
            },
      child: ShakeTransition(
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            height: schedulepeople.isEmpty
                ? 0
                : ResponsiveHelper.responsiveWidth(context, 50),
            child: Center(
              child: Container(
                height: 50, // Adjust the height as needed
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ...List.generate(displayCount, (index) {
                      String imageUrl =
                          schedulepeople[index].profileImageUrl ?? '';

                      return Positioned(
                        left: startPosition + index * overlapOffset - 10,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: fromDetails
                                ? Theme.of(context).primaryColorLight
                                : Colors.black12,
                            shape: BoxShape.circle,
                          ),
                          child: imageUrl.isEmpty
                              ? Icon(
                                  Icons.account_circle,
                                  size: 36.0,
                                  color: Colors.grey,
                                )
                              : CircleAvatar(
                                  radius: 17, // Adjust the radius as needed
                                  backgroundColor: Colors.blue,
                                  backgroundImage: NetworkImage(imageUrl),
                                ),
                        ),
                      );
                    }),
                    if (remainingCount > 0)
                      Positioned(
                        left: startPosition + displayCount * overlapOffset - 20,
                        child: Container(
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '+$remainingCount',
                            style: TextStyle(
                              fontSize: ResponsiveHelper.responsiveFontSize(
                                  context, 12),
                              color: Theme.of(context).secondaryHeaderColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _peopleMini(
      context,
    );
  }
}
