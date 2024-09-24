import 'package:bars/utilities/exports.dart';

class PortfolioWorkRequestWidget extends StatelessWidget {
  final List<WorkRequestOrOfferModel> workReQuests;
  final bool seeMore;
  final bool edit;
  final bool onTapToGoTODiscovery;

  PortfolioWorkRequestWidget({
    required this.workReQuests,
    required this.seeMore,
    required this.edit,
    required this.onTapToGoTODiscovery,
  });

  _buildDisplayPortfolioList(BuildContext context) {
    List<Widget> forumViews = [];
    workReQuests.forEach((portfolio) {
      forumViews.add(RequestWidget(
        edit: edit,
        seeMore: seeMore,
        workRequest: portfolio,
        onTapToGoTODiscovery: onTapToGoTODiscovery,
      ));
    });
    return Column(children: forumViews);
  }

  @override
  Widget build(BuildContext context) {
    workReQuests.sort((a, b) => a.price.compareTo(b.price));

    return workReQuests.length < 1
        ? SizedBox.shrink()
        : _buildDisplayPortfolioList(context);
  }
}

class RequestWidget extends StatefulWidget {
  final bool seeMore;
  final bool edit;
  final WorkRequestOrOfferModel workRequest;
  final bool onTapToGoTODiscovery;

  RequestWidget({
    required this.workRequest,
    required this.seeMore,
    required this.edit,
    required this.onTapToGoTODiscovery,
  });

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {
  bool _isLoading = false;

  _removePortfolio(
      BuildContext context, WorkRequestOrOfferModel request) async {}

  _buildPeople(
    BuildContext context,
    double width,
    String value,
  ) {
    return Container(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  _buildDisplayPortfolioGrid(BuildContext context, List<String> type) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: type.length,
        itemBuilder: (context, index) {
          return _buildPeople(
            context,
            width,
            type[index],
          );
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetErrorMessage(BuildContext context, Object e) {
    String error = e.toString();
    String result = error.contains(']')
        ? error.substring(error.lastIndexOf(']') + 1)
        : error;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DisplayErrorHandler(
          buttonText: 'Ok',
          onPressed: () async {
            Navigator.pop(context);
          },
          title: 'Failed to load booking portfolio.',
          subTitle: result,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    var _sizedBox = SizedBox(
      height: 10,
    );
    var _style = TextStyle(
      fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
      color: Theme.of(context).secondaryHeaderColor,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        color: widget.seeMore
            ? Theme.of(context).primaryColor
            : Theme.of(context).primaryColorLight,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
              onTap: widget.onTapToGoTODiscovery
                  ? () async {
                      if (_isLoading) return;
                      _isLoading = true;
                      try {
                        UserStoreModel? _user =
                            await DatabaseService.getUserProfessionalWithId(
                          widget.workRequest.userId,
                        );

                        if (_user != null) {
                          _navigateToPage(
                            context,
                            DiscographyWidget(
                              currentUserId: _currentUserId!,
                              userIndex: 0,
                              userPortfolio: _user,
                            ),
                          );
                        } else {
                          mySnackBar(context, 'Could not block this person');
                        }
                      } catch (e) {
                        _showBottomSheetErrorMessage(context, e);
                      } finally {
                        _isLoading = false;
                      }
                    }
                  : () {},
              title: ListTile(
                trailing: widget.edit
                    ? IconButton(
                        onPressed: () =>
                            _removePortfolio(context, widget.workRequest),
                        icon: Icon(
                          Icons.remove,
                          color: Colors.red,
                          size: ResponsiveHelper.responsiveHeight(context, 25),
                        ),
                      )
                    : null,
                leading: _isLoading
                    ? SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.blue,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: EdgeInsets.all(
                            ResponsiveHelper.responsiveHeight(context, 5),
                          ),
                          child: Icon(
                            widget.workRequest.isEvent
                                ? Icons.work_outline_sharp
                                : Icons.people_outline,
                            color: Theme.of(context).primaryColor,
                            size:
                                ResponsiveHelper.responsiveHeight(context, 20),
                          ),
                        ),
                      ),
                title: Text(
                  "${widget.workRequest.currency}   ${widget.workRequest.price.toString()}\n",
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 14.0),
                    color: Colors.blue,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              subtitle: widget.seeMore
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.workRequest.overView.replaceAll('\n', ' '),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Divider(
                          thickness: .2,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        _sizedBox,
                        Text(
                          'Type',
                          style: _style,
                        ),
                        _sizedBox,
                        _buildDisplayPortfolioGrid(
                            context, widget.workRequest.type),
                        _sizedBox,
                        Divider(
                          thickness: .2,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        Text(
                          'Genre',
                          style: _style,
                        ),
                        _sizedBox,
                        _buildDisplayPortfolioGrid(
                            context, widget.workRequest.genre),
                        _sizedBox,
                        Divider(
                          thickness: .2,
                          color: Theme.of(context).primaryColorLight,
                        ),
                        Text(
                          'Location',
                          style: _style,
                        ),
                        _sizedBox,
                        _buildDisplayPortfolioGrid(
                            context, widget.workRequest.availableLocations)
                      ],
                    )
                  : null),
        ),
      ),
    );
  }
}
