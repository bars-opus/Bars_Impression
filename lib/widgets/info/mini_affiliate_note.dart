import 'package:bars/utilities/exports.dart';

class MiniAffiliateNote extends StatefulWidget {
  // final VoidCallback onPressed;
  final String updateNote;
  final bool displayMiniUpdate;
  final bool showinfo;

  MiniAffiliateNote({
    // required this.onPressed,
    required this.displayMiniUpdate,
    required this.showinfo,
    required this.updateNote,
  });

  @override
  State<MiniAffiliateNote> createState() => _MiniAffiliateNoteState();
}

class _MiniAffiliateNoteState extends State<MiniAffiliateNote> {
  bool _showinfo = true;

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context);

    final width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 800),
        height: widget.displayMiniUpdate && widget.showinfo && _showinfo
            ? 100
            : 0.0,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: IconButton(
                icon: Icon(Icons.attach_money),
                iconSize: ResponsiveHelper.responsiveHeight(
                  context,
                  25,
                ),
                color: Colors.black,
                onPressed: () {},
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.close),
              iconSize: ResponsiveHelper.responsiveHeight(
                context,
                20,
              ),
              color: Colors.black,
              onPressed: () {
                if (mounted) {
                  setState(() {
                    _showinfo = false;
                  });
                }
              },
            ),
            title: Text('Affiliate deal',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    14,
                  ),
                  color: Colors.black,
                )),
            subtitle: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.updateNote,
                    style: TextStyle(
                      fontSize: ResponsiveHelper.responsiveFontSize(
                        context,
                        11,
                      ),
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '\nTap here to see.',
                    style: TextStyle(
                      fontSize:
                          ResponsiveHelper.responsiveFontSize(context, 11.0),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
            ),
            onTap: () {
              if (mounted) {
                setState(() {
                  _showinfo = false;
                });
              }
              _navigateToPage(
                UserAffilate(
                  currentUserId: _provider.currentUserId!,
                  eventId: '',
                  marketingType: '',
                  isUser: true,
                  fromActivity: false,
                ),
              );
            }));
  }
}
