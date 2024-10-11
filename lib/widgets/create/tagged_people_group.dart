import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class TaggedPeopleGroup extends StatelessWidget {
  List<ShopWorkerModel> workers;
  final bool canBeEdited;

  TaggedPeopleGroup({
    required this.workers,
    required this.canBeEdited,
  });

  void _removeTaggedEventPeople(
    BuildContext context,
    ShopWorkerModel removingTaggedEventPeople,
  ) {
    var _provider = Provider.of<UserData>(context, listen: false);
    _provider.taggedEventPeople.removeWhere(
        (taggedPerson) => taggedPerson.id == removingTaggedEventPeople.id);
    _provider.setInt2(3);
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

  void _verifyInfo(BuildContext context, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: ResponsiveHelper.responsiveHeight(context, 200),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(30),
            ),
            child: VerifyInfo(userName: name));
      },
    );
  }

  _display(BuildContext context, ShopWorkerModel worker) {
    String imageUrl = worker.profileImageUrl ?? '';
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

              backgroundImage: NetworkImage(worker.profileImageUrl!),
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
                  worker,
                );
              })
          : Container(
              width: ResponsiveHelper.responsiveFontSize(context, 60),
              height: ResponsiveHelper.responsiveFontSize(context, 30),
              child: Row(
                children: [
                  // if (worker.verifiedTag)
                  GestureDetector(
                    onTap: () => _verifyInfo(context, worker.name),
                    child: Icon(
                      Icons.check_circle_sharp,
                      color: Colors.green,
                      size: ResponsiveHelper.responsiveHeight(context, 15),
                    ),
                  ),
                  Icon(
                    // taggedPerson.internalProfileLink!.isEmpty
                    //     ? Icons.link
                    //     :
                    Icons.arrow_forward_ios_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                ],
              ),
            ),
      onTap: () {
        HapticFeedback.lightImpact();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ProfileScreen(
                      user: null,
                      currentUserId:
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId!,
                      userId: worker.id, accountType: '',
                    )));
      },
      title: RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(
          children: [
            TextSpan(
              text: worker.name,
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
                    text: '',
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
    // List<ShopWorkerModel> newworkers =
    //     workers;
    // Map<String, List<ShopWorkerModel>> taggedByGroup = {};
    // for (ShopWorkerModel workers
    //     in workerss) {
    //   if (!taggedByGroup.containsKey(workers.role)) {
    //     taggedByGroup[workers.role] = [];
    //   }
    //   taggedByGroup[workers.role]!
    //       .add(workers);
    // }
    // final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      // scrollDirection: Axis.horizontal,
      itemCount: workers.length,
      itemBuilder: (context, index) {
        // bool isSelected = _selectedIndex == index;
        var worker = workers[index];

        return _display(context, worker);
      },
    );
  }
}
