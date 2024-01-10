import 'package:bars/utilities/exports.dart';

class ExpandEventBarcodeScreen extends StatelessWidget {
  final Event event;

  ExpandEventBarcodeScreen({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        alignment: FractionalOffset.center,
        children: [
          Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(event.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.6),
                      Colors.black.withOpacity(.6),
                    ],
                  ),
                ),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: event.id,
                child: QrImageView(
                  version: QrVersions.auto,
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.transparent,
                  data: event.dynamicLink,
                  size: ResponsiveHelper.responsiveHeight(context, 200.0),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RichText(
                textScaleFactor: MediaQuery.of(context).textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'SCAN',
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 40.0),
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "\nTo get event\n",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 18.0),
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text:
                          "\nYou can take a picture of this barcode, print it out, and stick it somewhere. This way, people can scan it to access the event.",
                      style: TextStyle(
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 14.0),
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: EventBottomButton(
                  onlyWhite: true,
                  buttonText: 'Share link instead',
                  onPressed: () {
                    Share.share(event.dynamicLink);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
