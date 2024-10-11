import 'package:bars/utilities/exports.dart';

class EventTaggedPeople extends StatelessWidget {
  final List<ShopWorkerModel> workers; // final bool isSponsor;
  final bool showTagsOnImage;

  const EventTaggedPeople(
      {super.key,
      required this.workers,
      // required this.isSponsor,
      required this.showTagsOnImage});

  @override
  Widget build(BuildContext context) {
    // var _size = MediaQuery.of(context).size;
    List<ShopWorkerModel> taggedPeople = workers;
    List<ShopWorkerModel> taggedPeopleOption = [];
    for (ShopWorkerModel taggedPeople in taggedPeople) {
      ShopWorkerModel taggedPersonOption = taggedPeople;
      taggedPeopleOption.add(taggedPersonOption);
    }
    taggedPeopleOption.sort((a, b) => a.name.compareTo(b.name));
    return TaggedPeopleGroup(
      workers: taggedPeopleOption,
      // .where((taggedPerson) =>
      //     taggedPerson.taggedType == 'performer')
      // .toList(),
      canBeEdited: false,
    );
    //  showTagsOnImage
    //     ? taggedPeopleOption.isEmpty
    //         ? Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               ShakeTransition(
    //                 offset: 40,
    //                 child: ShakeTransition(
    //                   child: Icon(
    //                     Icons.people_outline,
    //                     color: Colors.white,
    //                     size: ResponsiveHelper.responsiveHeight(context, 50.0),
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: 10),
    //               ShakeTransition(
    //                 axis: Axis.vertical,
    //                 offset: 40,
    //                 child: Text(
    //                   'No tagged people',
    //                   style: TextStyle(
    //                     color: Colors.white,
    //                     fontSize:
    //                         ResponsiveHelper.responsiveFontSize(context, 14),
    //                   ),
    //                   textAlign: TextAlign.center,
    //                 ),
    //               ),
    //             ],
    //           )
    //         : TaggedUsersWidget(
    //             taggedPeopleOption: taggedPeopleOption,
    //           )
    //     :

    // Container(
    //     height: ResponsiveHelper.responsiveHeight(context, 700),
    //     decoration: BoxDecoration(
    //         color: Theme.of(context).cardColor,
    //         borderRadius: BorderRadius.circular(30)),
    //     child: Padding(
    //         padding: const EdgeInsets.only(top: 30),
    //         child: DoubleOptionTabview(
    //           lightColor: false,
    //           height: taggedPeopleOption.length * 300,
    //           onPressed: (int) {},
    //           tabText1: isSponsor ? 'Sponsors' : 'Performers',
    //           tabText2: isSponsor ? 'Partners' : 'Crew',
    //           initalTab: 0,
    //           widget1: ListView(
    //             physics: const NeverScrollableScrollPhysics(),
    //             children: [
    //               // isSponsor
    //               //     ? TaggedPeopleGroup(
    //               //         groupTaggedEventPeopleGroup: taggedPeopleOption
    //               //             .where((taggedPerson) =>
    //               //                 taggedPerson.taggedType == 'Sponsor')
    //               //             .toList(),
    //               //         canBeEdited: false,
    //               //       )
    //               //     : TaggedPeopleGroup(
    //               //         groupTaggedEventPeopleGroup: taggedPeopleOption
    //               //             .where((taggedPerson) =>
    //               //                 taggedPerson.taggedType == 'performer')
    //               //             .toList(),
    //               //         canBeEdited: false,
    //               //       ),
    //             ],
    //           ),
    //           widget2: ListView(
    //             physics: const NeverScrollableScrollPhysics(),
    //             children: [
    //               // isSponsor
    //               //     ? TaggedPeopleGroup(
    //               //         groupTaggedEventPeopleGroup: taggedPeopleOption
    //               //             .where((taggedPerson) =>
    //               //                 taggedPerson.taggedType == 'Partner')
    //               //             .toList(),
    //               //         canBeEdited: false,
    //               //       )
    //               //     : TaggedPeopleGroup(
    //               //         groupTaggedEventPeopleGroup: taggedPeopleOption
    //               //             .where((taggedPerson) =>
    //               //                 taggedPerson.taggedType == 'crew')
    //               //             .toList(),
    //               //         canBeEdited: false,
    //               //       ),
    //             ],
    //           ),
    //           pageTitle: '',
    //         )));
  }
}
