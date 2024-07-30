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
                      subtitle: Divider(
                        thickness: .2,
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
