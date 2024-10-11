import 'package:bars/utilities/exports.dart';

class ShedulePeopleHorizontal extends StatelessWidget {
  final bool edit;
  // final String from;
  final List<ShopWorkerModel> workers;
  final String currentUserId;
  final bool small;
  // final Event event;
  // final bool fromDetails;
  // final bool? isSponsor;

  const ShedulePeopleHorizontal(
      {super.key,
      required this.edit,
      // required this.from,
      required this.workers,
      this.small = false,
      // required this.event,
      // required this.fromDetails,
      // this.isSponsor,
      required this.currentUserId});

// To display the people tagged in a post as performers, crew, sponsors or partners
  void _showBottomSheetTaggedPeople(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: ResponsiveHelper.responsiveHeight(context, 700),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              TicketPurchasingIcon(
                title: '',
              ),
              const SizedBox(height: 40),
              Container(
                height: ResponsiveHelper.responsiveHeight(context, 600),
                child: TaggedPeopleGroup(
                  workers: workers,
                  // .where((taggedPerson) =>
                  //     taggedPerson.taggedType == 'performer')
                  // .toList(),
                  canBeEdited: false,
                ),
              ),
            ],
          ),
        );

        //     TaggedPeopleGroup(
        //   workers: workers,
        //   // .where((taggedPerson) =>
        //   //     taggedPerson.taggedType == 'performer')
        //   // .toList(),
        //   canBeEdited: false,
        // );
      },
    );
  }

  // void _showBottomSheetTaggedPeopleOption(
  //   BuildContext context,
  // ) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
  //           height: ResponsiveHelper.responsiveHeight(context, 200),
  //           decoration: BoxDecoration(
  //               color: Theme.of(context).primaryColorLight,
  //               borderRadius: BorderRadius.circular(30)),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               BottomModelSheetListTileActionWidget(
  //                 colorCode: '',
  //                 icon: Icons.people_outline,
  //                 onPressed: () {
  //                   _showBottomSheetTaggedPeople(context, false);
  //                 },
  //                 text: 'Crew and performers',
  //               ),
  //               BottomModelSheetListTileActionWidget(
  //                 colorCode: '',
  //                 icon: Icons.handshake_outlined,
  //                 onPressed: () {
  //                   _showBottomSheetTaggedPeople(context, true);
  //                 },
  //                 text: 'Partners and sponser',
  //               ),
  //             ],
  //           ));
  //     },
  //   );
  // }

  _peopleMini(BuildContext context) {
    int maxDisplayCount = 5;
    int displayCount =
        workers.length > maxDisplayCount ? maxDisplayCount : workers.length;
    int remainingCount =
        workers.length > maxDisplayCount ? workers.length - maxDisplayCount : 0;

    double overlapOffset = small ? 15 : 25.0;
    double circleAvatarDiameter = 36.0; // 2 * radius + padding

    return GestureDetector(
      onTap: () {
        _showBottomSheetTaggedPeople(
          context,
        );
      },
      child: ShakeTransition(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 700),
          height: workers.isEmpty
              ? 0
              : ResponsiveHelper.responsiveWidth(context, small ? 30 : 50),
          child: Container(
            height: small ? 30 : 50, // Adjust the height as needed
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                ...List.generate(displayCount, (index) {
                  String imageUrl = workers[index].profileImageUrl ?? '';

                  return Positioned(
                    left: index * overlapOffset,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        shape: BoxShape.circle,
                      ),
                      child: imageUrl.isEmpty
                          ? Icon(
                              Icons.account_circle,
                              size: small ? 20 : 30.0,
                              color: Colors.grey,
                            )
                          : CircleAvatar(
                              radius: small
                                  ? 10
                                  : 15, // Adjust the radius as needed
                              backgroundColor: Colors.blue,
                              backgroundImage: NetworkImage(imageUrl),
                            ),
                    ),
                  );
                }),
                if (remainingCount > 0)
                  Positioned(
                    left: displayCount * overlapOffset,
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
                          fontSize:
                              ResponsiveHelper.responsiveFontSize(context, 12),
                          color: Theme.of(context).secondaryHeaderColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
