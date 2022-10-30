import 'package:bars/utilities/exports.dart';

// ignore: must_be_immutable
class BookingGallery extends StatefulWidget {
  final AccountHolder user;
  final String currentUserId;
  BookingGallery({
    required this.user,
    required this.currentUserId,
  });

  @override
  State<BookingGallery> createState() => _BookingGalleryState();
}

class _BookingGalleryState extends State<BookingGallery> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = Responsive.isDesktop(context)
        ? 600.0
        : MediaQuery.of(context).size.width;
    return ResponsiveScaffold(
      child: Scaffold(
        backgroundColor: Color(0xFF1a1a1a),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Color(0xFF1a1a1a),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: width,
                width: width,
                child: PageView(
                    controller: _pageController,
                    physics: AlwaysScrollableScrollPhysics(),
                   
                    children: [
                      Hero(
                        tag: 'image1',
                        child: Container(
                          width: width,
                          height: width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.user.professionalPicture1!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 10),
                                blurRadius: 10.0,
                                spreadRadius: 4.0,
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'image2',
                        child: Container(
                          width: width,
                          height: width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.user.professionalPicture2!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 10),
                                blurRadius: 10.0,
                                spreadRadius: 4.0,
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Hero(
                        tag: 'image3',
                        child: Container(
                          width: width,
                          height: width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  widget.user.professionalPicture3!),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 10),
                                blurRadius: 10.0,
                                spreadRadius: 4.0,
                              ),
                            ],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(
                height: 40,
              ),
              Center(
                child: Text('Swipe left',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
