import 'package:bars/utilities/exports.dart';

class ViewImage extends StatefulWidget {
  final AccountHolder user;

  ViewImage({
    required this.user,
  });

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;

    return ResponsiveScaffold(
      child: Container(
        color: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
        child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxScrolled) => [
                  SliverAppBar(
                    elevation: 0.0,
                    automaticallyImplyLeading: true,
                    floating: true,
                    snap: true,
                    iconTheme: new IconThemeData(
                      color:
                          ConfigBloc().darkModeOn ? Colors.white : Colors.black,
                    ),
                    backgroundColor: ConfigBloc().darkModeOn
                        ? Color(0xFF1a1a1a)
                        : Colors.white,
                  ),
                ],
            body: SafeArea(
              child: ListView(
                children: <Widget>[
                  Hero(
                    tag: 'container1' + widget.user.id.toString(),
                    child: Container(
                      height: width,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              widget.user.profileImageUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 30),
                    child: Container(
                      width: width,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProfileScreen(
                                        currentUserId: Provider.of<UserData>(
                                                context,
                                                listen: false)
                                            .currentUserId!,
                                        user: widget.user,
                                        userId: widget.user.id!,
                                      ))),
                          child: Text(
                            'Got to profile',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
