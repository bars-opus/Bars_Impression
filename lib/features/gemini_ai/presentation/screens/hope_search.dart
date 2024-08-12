/// The `HopeSearch` widget provides a search functionality for events or users.
/// It allows users to search for events or users by typing in the search field.
/// The search can be customized to target either events or users based on the `isEvent` flag.

import 'package:bars/utilities/exports.dart';

class HopeSearch extends StatefulWidget {
  final bool isEvent;

  HopeSearch({
    required this.isEvent,
  });

  @override
  State<HopeSearch> createState() => _HopeSearchState();
}

class _HopeSearchState extends State<HopeSearch> with TickerProviderStateMixin {
  TextEditingController _searchController = TextEditingController();
  // Focus nodes to manage focus on the search field.
  final FocusNode _addressSearchfocusNode = FocusNode();
  final FocusNode _focusNode = FocusNode();
  final _debouncer = Debouncer(milliseconds: 500);
  ValueNotifier<bool> _isTypingNotifier = ValueNotifier<bool>(false);
  Future<QuerySnapshot>? _users;
  Future<List<DocumentSnapshot>>? _event;

  @override
  void dispose() {
    // Dispose of controllers and focus nodes to free resources.
    _searchController.dispose();
    _addressSearchfocusNode.dispose();
    _isTypingNotifier.dispose();
    _debouncer.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  // Cancel the search operation and reset search results.
  _cancelSearch() {
    var _provider = Provider.of<UserData>(context, listen: false);
    widget.isEvent ? _event = null : _users = null;
    FocusScope.of(context).unfocus();
    _provider.setFlorenceActive(!_provider.florenceActive);
    _provider.setIsLoading(false);
  }

  // Clear the search input field.
  _clearSearch() {
    var _provider = Provider.of<UserData>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _searchController.clear());
    _provider.setIsLoading(false);
  }

  // Perform the search based on the input and target type (event/user).
  void _search() {
    var _provider = Provider.of<UserData>(context, listen: false);
    String input = _searchController.text.trim();
    widget.isEvent
        ? setState(() {
            _event = searchEvents(input.toLowerCase());
          })
        : setState(() {
            _users = DatabaseService.searchUsers(input.toLowerCase());
          });
    _provider.setSearchInput('');
  }

  /// Batch process to determine if event summaries are a good match for the search query.
  final _googleGenerativeAIService = GoogleGenerativeAIService();
  Future<List<bool>> batchIsGoodMatchForQuery(
      String query, List<String> summaries) async {
    final batchPayload = summaries
        .map((summary) => {
              'prompt': '''
Based on the user's request, determine if the event summary is a good match:
User's Request: "$query"
Event Summary: "$summary"
Is this event a good match? (yes or no)
'''
            })
        .toList();

    final responses = await Future.wait(batchPayload.map((payload) async {
      final response =
          await _googleGenerativeAIService.generateResponse(payload['prompt']!);
      return response!.trim().toLowerCase().contains('yes');
    }));

    return responses;
  }

  /// Search for events that match the user's query.
  Future<List<DocumentSnapshot>> searchEvents(String userQuery) async {
    List<DocumentSnapshot> matchingDocs = [];
    var _provider = Provider.of<UserData>(context, listen: false);

    _provider.setIsLoading(true);
    QuerySnapshot filteredSnapshot = await allEventsSummaryRef.get();

    int batchSize = 10;
    List<Future> batchTasks = [];

    for (int i = 0; i < filteredSnapshot.docs.length; i += batchSize) {
      List<DocumentSnapshot> batch =
          filteredSnapshot.docs.skip(i).take(batchSize).toList();

      batchTasks.add(() async {
        List<String> summaries = [];
        List<String> eventIds = [];

        for (var doc in batch) {
          summaries.add(doc['summary']);
          eventIds.add(doc['eventId']);
        }

        List<bool> matches =
            await batchIsGoodMatchForQuery(userQuery, summaries);

        for (int j = 0; j < matches.length; j++) {
          if (matches[j]) {
            DocumentSnapshot eventDoc =
                await allEventsRef.doc(eventIds[j]).get();
            if (eventDoc.exists) {
              matchingDocs.add(eventDoc);
            }
          }
        }
      }());
    }

    await Future.wait(batchTasks);
    _provider.setIsLoading(false);

    return matchingDocs;
  }

  /// Builds the search content field with necessary configurations.
  _searchContentField({
    required String hintText,
    required FocusNode focusNode,
    required VoidCallback cancelSearch,
    required VoidCallback onTap,
    required VoidCallback onClearText,
    required Function(String) onChanged,
    required bool showCancelButton,
  }) {
    var _provider = Provider.of<UserData>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: focusNode.hasFocus
                  ? ResponsiveHelper.responsiveHeight(
                      context, _searchController.text.isEmpty ? 50 : 60)
                  : ResponsiveHelper.responsiveHeight(context, 45),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                keyboardAppearance: MediaQuery.of(context).platformBrightness,
                keyboardType: TextInputType.multiline,
                autofocus: true,
                onTap: onTap,
                focusNode: focusNode,
                style: TextStyle(
                    color: Theme.of(context).secondaryHeaderColor,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    fontWeight: FontWeight.normal),
                cursorColor: Colors.blue,
                controller: _searchController,
                onChanged: onChanged,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveHelper.responsiveHeight(context, 10),
                    vertical: focusNode.hasFocus
                        ? ResponsiveHelper.responsiveHeight(context, 20)
                        : ResponsiveHelper.responsiveHeight(context, 6),
                  ),
                  border: InputBorder.none,
                  hintText: hintText,
                  prefixIcon: _searchController.text.trim().length > 0
                      ? null
                      : Padding(
                          padding: EdgeInsets.all(focusNode.hasFocus ? 12 : 13),
                          child: AnimatedCircle(
                            size: 5,
                            stroke: 2,
                            animateSize: false,
                            animateShape: false,
                          ),
                        ),
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  suffixIcon: _searchController.text.trim().isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 15),
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          onPressed: onClearText,
                        )
                      : null,
                ),
                onSubmitted: (string) {
                  cancelSearch();
                },
              ),
            ),
          ),
          SingleChildScrollView(
            child: AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 800),
              width: _provider.isLoading ? 50 : 80,
              child: Row(
                children: [
                  _provider.isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: AnimatedCircle(
                            size: 20,
                            stroke: 2,
                            animateSize: false,
                            animateShape: true,
                          ),
                        )
                      : showCancelButton || focusNode.hasFocus
                          ? TextButton(
                              onPressed: _provider.searchInput.isNotEmpty &&
                                      _searchController.text.trim().isNotEmpty
                                  ? () {
                                      _search();
                                    }
                                  : cancelSearch,
                              child: Text(
                                _provider.searchInput.isNotEmpty &&
                                        _searchController.text.trim().isNotEmpty
                                    ? 'Search'
                                    : 'Cancel',
                                style: TextStyle(
                                  color: _provider.searchInput.isNotEmpty
                                      ? Colors.blue
                                      : Colors.white,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                      context, 12.0),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            )
                          : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the search field widget.
  _searchField() {
    var _provider = Provider.of<UserData>(context, listen: false);

    return _searchContentField(
      showCancelButton: true,
      cancelSearch: () {
        _cancelSearch();
      },
      focusNode: _focusNode,
      hintText: 'Type to search...',
      onClearText: () {
        _clearSearch();
      },
      onChanged: (value) {
        if (value.trim().isNotEmpty) {
          _provider.setSearchInput(value);
        }
      },
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: widget.isEvent
          ? AppBar(
              automaticallyImplyLeading: false,
              elevation: 0.0,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              primary: true,
              title: _searchField(),
              titleSpacing: 0,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: widget.isEvent
            ? EventSearch(
                fromFlorence: true,
                events: _event,
              )
            : UserSearch(fromFlorence: true, users: _users),
      ),
    );
  }
}
