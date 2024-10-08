import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class TaggedPeopleGroup extends StatelessWidget {
  List<TaggedEventPeopleModel> groupTaggedEventPeopleGroup;
  final bool canBeEdited;

  TaggedPeopleGroup({
    required this.groupTaggedEventPeopleGroup,
    required this.canBeEdited,
  });

  void _removeTaggedEventPeople(
    BuildContext context,
    TaggedEventPeopleModel removingTaggedEventPeople,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);

    _provider.taggedEventPeople.removeWhere(
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
            height: ResponsiveHelper.responsiveHeight(context, 450),
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

  _display(BuildContext context, TaggedEventPeopleModel taggedPerson) {
    String imageUrl = taggedPerson.profileImageUrl ?? '';
    return ListTile(
      leading: imageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: 43.0,
              color: Colors.grey,
            )
          : CircleAvatar(
              radius: 18, // Adjust the radius as needed
              backgroundColor: Colors.blue,

              backgroundImage: NetworkImage(taggedPerson.profileImageUrl!),
            ),
      trailing: canBeEdited
          ? IconButton(
              icon: Icon(
                Icons.remove,
                color: Colors.red,
              ),
              onPressed: () {
                _removeTaggedEventPeople(
                  context,
                  taggedPerson,
                );
              })
          : Icon(
              taggedPerson.internalProfileLink!.isEmpty
                  ? Icons.link
                  : Icons.arrow_forward_ios_outlined,
              color: Colors.black,
              size: taggedPerson.internalProfileLink!.isEmpty ? 25 : 15,
            ),
      onTap: () {
        HapticFeedback.lightImpact();
        taggedPerson.internalProfileLink!.isEmpty
            ? _showBottomTaggedPersonExternalLink(
                context, taggedPerson.externalProfileLink!)
            : Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProfileScreen(
                          user: null,
                          currentUserId:
                              Provider.of<UserData>(context, listen: false)
                                  .currentUserId!,
                          userId: taggedPerson.internalProfileLink!,
                        )));
      },
      title: RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(
          children: [
            TextSpan(
              text: taggedPerson.name,
              style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textScaler: MediaQuery.of(context).textScaler,
            text: TextSpan(
              children: [
                TextSpan(
                    text: taggedPerson.taggedType.startsWith('Sponsor') ||
                            taggedPerson.taggedType.startsWith('Partner')
                        ? ''
                        : "${taggedPerson.taggedType}:  ${taggedPerson.role}",
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 12.0),
                      color: Colors.black,
                    ))
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Divider(
            thickness: .2,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TaggedEventPeopleModel> groupTaggedEventPeopleGroups =
        groupTaggedEventPeopleGroup;
    Map<String, List<TaggedEventPeopleModel>> taggedByGroup = {};
    for (TaggedEventPeopleModel groupTaggedEventPeopleGroup
        in groupTaggedEventPeopleGroups) {
      if (!taggedByGroup.containsKey(groupTaggedEventPeopleGroup.role)) {
        taggedByGroup[groupTaggedEventPeopleGroup.role] = [];
      }
      taggedByGroup[groupTaggedEventPeopleGroup.role]!
          .add(groupTaggedEventPeopleGroup);
    }
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: width * 5,
      width: width - 40,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: taggedByGroup.length,
        itemBuilder: (BuildContext context, int groupIndex) {
          // Get the group name and tickets for the current index
          String groupName = taggedByGroup.keys.elementAt(groupIndex);
          List<TaggedEventPeopleModel> taggedGroup =
              taggedByGroup.values.elementAt(groupIndex);

          // Create a sublist of widgets for each ticket in the group
          List<Widget> taggedPeoplwWidgets = taggedGroup
              .map((taggedPerson) => Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: _display(context, taggedPerson),
                  ))
              .toList();

          // Return a Card widget for the group, containing a ListView of the tickets
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      groupName.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10)),
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: taggedPeoplwWidgets.length,
                      itemBuilder:
                          (BuildContext context, int taggedPeopleIndex) {
                        return taggedPeoplwWidgets[taggedPeopleIndex];
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
