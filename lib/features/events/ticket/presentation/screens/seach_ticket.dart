import 'package:bars/utilities/exports.dart';

class SearchTicket extends StatefulWidget {
  final String currentUserId;

  SearchTicket({super.key, required this.currentUserId});

  @override
  State<SearchTicket> createState() => _SearchTicketState();
}

class _SearchTicketState extends State<SearchTicket> {
  TextEditingController _searchController = TextEditingController();

  Future<QuerySnapshot>? _ticketOrder;
  final FocusNode _addressSearchfocusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _searchController.dispose();
    _addressSearchfocusNode.dispose();
    _debouncer.cancel();
    super.dispose();
  }

  _cancelSearch() {
    FocusScope.of(context).unfocus();
    _clearSearch();
    Navigator.pop(context);
  }

  _clearSearch() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    Provider.of<UserData>(context, listen: false).addressSearchResults = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SearchContentField(
                  autoFocus: true,
                  showCancelButton: true,
                  cancelSearch: _cancelSearch,
                  controller: _searchController,
                  focusNode: _addressSearchfocusNode,
                  hintText: 'Type event title...',
                  onClearText: () {
                    _clearSearch();
                  },
                  onTap: () {},
                  onChanged: (input) {
                    if (input.trim().isNotEmpty)
                      _debouncer.run(() {
                        setState(() {
                          _ticketOrder = DatabaseService.serchTicket(
                              input.toUpperCase(), widget.currentUserId);
                        });
                      });
                  }),
            ),
            _ticketOrder == null
                ? Center(
                    child: Padding(
                    padding: EdgeInsets.only(
                        top: ResponsiveHelper.responsiveHeight(context, 200)),
                    child: NoContents(
                        title: "Searh for ticket. ",
                        subTitle:
                            'Enter the title of the event\'s ticket you want to search for.',
                        icon: Icons.search),
                  ))
                : FutureBuilder<QuerySnapshot>(
                    future: _ticketOrder,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(child: SearchUserSchimmer());
                      }
                      if (snapshot.data!.docs.length == 0) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: ResponsiveHelper.responsiveHeight(
                                  context, 250)),
                          child: Center(
                            child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "No tickets found. ",
                                        style: TextStyle(
                                            fontSize: ResponsiveHelper
                                                .responsiveFontSize(
                                                    context, 20),
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueGrey)),
                                    TextSpan(
                                        text:
                                            '\nCheck the event name and try again.'),
                                  ],
                                  style: TextStyle(
                                      fontSize:
                                          ResponsiveHelper.responsiveFontSize(
                                              context, 14),
                                      color: Colors.grey),
                                )),
                          ),
                        );
                      }
                      return Expanded(
                        child: CustomScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    TicketOrderModel? ticketOrder =
                                        TicketOrderModel.fromDoc(
                                            snapshot.data!.docs[index]);
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2.0),
                                      child: SizedBox.shrink()
                                      //  EventsFeedAttendingWidget(
                                      //   ticketOrder: ticketOrder,
                                      //   currentUserId: widget.currentUserId,
                                      //   ticketList: [],
                                      // ),
                                    );
                                  },
                                  childCount: snapshot.data!.docs.length,
                                ),
                              ),
                            ]),
                      );
                    }),
          ],
        ),
      ),
    );
  }
}
