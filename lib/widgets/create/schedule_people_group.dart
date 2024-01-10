import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class SchedulePeopleGroup extends StatelessWidget {
  List<SchedulePeopleModel> groupTaggedEventPeopleGroup;
  final bool canBeEdited;

  SchedulePeopleGroup({
    required this.groupTaggedEventPeopleGroup,
    required this.canBeEdited,
  });

  void _removeTaggedEventPeople(
    SchedulePeopleModel removingTaggedEventPeople,
  ) {
    groupTaggedEventPeopleGroup.removeWhere(
        (taggedPerson) => taggedPerson.id == removingTaggedEventPeople.id);
  }

  void _showBottomTaggedPersonExternalLink(
    BuildContext context,
    String link,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 650),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: link,
              contentType: 'Link',
              icon: Icons.link,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // List<SchedulePeopleModel> groupTaggedEventPeopleGroups =
    //     groupTaggedEventPeopleGroup;
    // Map<String, List<SchedulePeopleModel>> taggedByGroup = {};
    // for (SchedulePeopleModel groupTaggedEventPeopleGroup
    //     in groupTaggedEventPeopleGroups) {
    //   if (!taggedByGroup.containsKey(groupTaggedEventPeopleGroup.role)) {
    //     taggedByGroup[groupTaggedEventPeopleGroup.title] = [];
    //   }
    //   taggedByGroup[groupTaggedEventPeopleGroup.title]!
    //       .add(groupTaggedEventPeopleGroup);
    // }
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: groupTaggedEventPeopleGroup.length,
                itemBuilder: (BuildContext context, int index) {
                  SchedulePeopleModel groupTaggedEventPeopleGroups =
                      groupTaggedEventPeopleGroup[index];
                  // String tagName =
                  //     groupTaggedEventPeopleGroups[taggedPeopleIndex];

                  return ListTile(
                      trailing: canBeEdited
                          ? IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _removeTaggedEventPeople(
                                  groupTaggedEventPeopleGroups,
                                );
                              })
                          : Icon(
                              groupTaggedEventPeopleGroups
                                      .internalProfileLink!.isEmpty
                                  ? Icons.link
                                  : Icons.arrow_forward_ios_outlined,
                              color: Colors.black,
                              size: groupTaggedEventPeopleGroups
                                      .internalProfileLink!.isEmpty
                                  ? 25
                                  : 15,
                            ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        groupTaggedEventPeopleGroups
                                .internalProfileLink!.isEmpty
                            ? _showBottomTaggedPersonExternalLink(
                                context,
                                groupTaggedEventPeopleGroups
                                    .externalProfileLink!)
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ProfileScreen(
                                          user: null,
                                          currentUserId: Provider.of<UserData>(
                                                  context,
                                                  listen: false)
                                              .currentUserId!,
                                          userId: groupTaggedEventPeopleGroups
                                              .internalProfileLink!,
                                        )));
                      },
                      title: RichText(
                        textScaleFactor: MediaQuery.of(context).textScaleFactor,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: groupTaggedEventPeopleGroups.name,
                              style: TextStyle(
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 14.0),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Divider());
                },
              ),
            ),
          ],
        ),
      ),
    );

    // Container(
    //   height: width * 2,
    //   width: width - 40,
    //   child: ListView.builder(
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: groupTaggedEventPeopleGroups.length,
    //     itemBuilder: (BuildContext context, int groupIndex) {
    //       // Get the group name and tickets for the current index
    //       // String groupName = groupTaggedEventPeopleGroups.keys.elementAt(groupIndex);
    //       // List<SchedulePeopleModel> taggedGroup =
    //       //     taggedByGroup.values.elementAt(groupIndex);

    //       // Create a sublist of widgets for each ticket in the group
    //       List<Widget> taggedPeoplwWidgets = groupTaggedEventPeopleGroups
    //           .map((taggedPerson) => Padding(
    //                 padding: const EdgeInsets.only(top: 10.0),
    //                 child: ListTile(
    //                   trailing: canBeEdited
    //                       ? IconButton(
    //                           icon: Icon(
    //                             Icons.remove,
    //                             color: Colors.red,
    //                           ),
    //                           onPressed: () {
    //                             _removeTaggedEventPeople(
    //                               taggedPerson,
    //                             );
    //                           })
    //                       : Icon(
    //                           taggedPerson.internalProfileLink!.isEmpty
    //                               ? Icons.link
    //                               : Icons.arrow_forward_ios_outlined,
    //                           color: Colors.black,
    //                           size: taggedPerson.internalProfileLink!.isEmpty
    //                               ? 25
    //                               : 15,
    //                         ),
    //                   onTap: () {
    //                     HapticFeedback.lightImpact();
    //                     taggedPerson.internalProfileLink!.isEmpty
    //                         ? _showBottomTaggedPersonExternalLink(
    //                             context, taggedPerson.externalProfileLink!)
    //                         : Navigator.push(
    //                             context,
    //                             MaterialPageRoute(
    //                                 builder: (_) => ProfileScreen(
    //                                       user: null,
    //                                       currentUserId: Provider.of<UserData>(
    //                                               context,
    //                                               listen: false)
    //                                           .currentUserId!,
    //                                       userId:
    //                                           taggedPerson.internalProfileLink!,
    //                                     )));
    //                   },
    //                   title: RichText(
    //                     textScaleFactor: MediaQuery.of(context).textScaleFactor,
    //                     text: TextSpan(
    //                       children: [
    //                         TextSpan(
    //                           text: taggedPerson.name,
    //                           style: TextStyle(
    //                               fontSize: ResponsiveHelper.responsiveFontSize(
    //                                   context, 14.0),
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.bold),
    //                         )
    //                       ],
    //                     ),
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                   subtitle: Column(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       // RichText(
    //                       //   textScaleFactor:
    //                       //       MediaQuery.of(context).textScaleFactor,
    //                       //   text: TextSpan(
    //                       //     children: [
    //                       //       TextSpan(
    //                       //           text: taggedPerson.taggedType
    //                       //                       .startsWith('Sponsor') ||
    //                       //                   taggedPerson.taggedType
    //                       //                       .startsWith('Partner')
    //                       //               ? ''
    //                       //               : "${taggedPerson.taggedType}:  ${taggedPerson.role}",
    //                       //           style: TextStyle(
    //                       //             fontSize:
    //                       //                 ResponsiveHelper.responsiveFontSize(
    //                       //                     context, 12.0),
    //                       //             color: Colors.black,
    //                       //           ))
    //                       //     ],
    //                       //   ),
    //                       //   overflow: TextOverflow.ellipsis,
    //                       // ),
    //                       Divider()
    //                     ],
    //                   ),
    //                 ),
    //               ))
    //           .toList();

    //       // Return a Card widget for the group, containing a ListView of the tickets
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: Theme.of(context).primaryColorLight,
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //           child: Column(
    //             children: <Widget>[
    //               ListTile(
    //                   // title: Text(
    //                   //   groupName.toUpperCase(),
    //                   //   style: Theme.of(context).textTheme.bodyLarge,
    //                   // ),
    //                   ),
    //               Container(
    //                 decoration: BoxDecoration(
    //                     color: Colors.grey[100],
    //                     borderRadius: BorderRadius.circular(10)),
    //                 child: ListView.builder(
    //                   physics: const NeverScrollableScrollPhysics(),
    //                   shrinkWrap: true,
    //                   itemCount: taggedPeoplwWidgets.length,
    //                   itemBuilder:
    //                       (BuildContext context, int taggedPeopleIndex) {
    //                     return taggedPeoplwWidgets[taggedPeopleIndex];
    //                   },
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
