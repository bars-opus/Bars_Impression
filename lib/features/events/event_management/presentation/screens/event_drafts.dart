import 'package:bars/utilities/exports.dart';

class EventDrafts extends StatelessWidget {
  final List<Event> eventsList;
  const EventDrafts({super.key, required this.eventsList});

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    return Container(
      height: ResponsiveHelper.responsiveHeight(context, 600),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: eventsList.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: eventsList.isEmpty
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (eventsList.isNotEmpty)
            TicketPurchasingIcon(
              title: 'Draft',
            ),
          if (eventsList.isNotEmpty)
            Divider(
              thickness: .3,
              color: Colors.grey,
            ),
          eventsList.isEmpty
              ? NoContents(
                  title: 'No drafts',
                  subTitle:
                      'The events you have created but have not yet published will be automatically saved as drafts here.',
                  icon: Icons.event)
              : Container(
                  height: ResponsiveHelper.responsiveHeight(context, 500),
                  child: ListView.builder(
                    itemCount: eventsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final event = eventsList[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditEventScreen(
                                    currentUserId: _provider.currentUserId,
                                    event: event,
                                    isCompleted: false,
                                    isDraft: true,
                                  ),
                                ),
                              );
                            },
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      event.imageUrl, errorListener: (_) {
                                    return;
                                  }),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            trailing: Icon(
                              Icons.edit,
                              color: Colors.blue,
                              size: 20,
                            ),
                            title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title.toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    event.theme,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                          ),
                          Divider(
                            thickness: .3,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
