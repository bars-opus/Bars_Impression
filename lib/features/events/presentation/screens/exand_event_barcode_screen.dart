import 'package:bars/utilities/exports.dart';

class ExpandEventBarcodeScreen extends StatelessWidget {
  final Event event;
  bool justCreated;

  ExpandEventBarcodeScreen({
    required this.event,
    this.justCreated = false,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var _provider = Provider.of<UserData>(context);
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
                tag: justCreated ? "new ${event.id}" : event.id,
                child: QrImageView(
                  version: QrVersions.auto,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Colors.white,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.circle,
                    color: Colors.grey,
                  ),
                  backgroundColor: Colors.transparent,
                  data: event.dynamicLink,
                  size: ResponsiveHelper.responsiveHeight(context, 200.0),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'SCAN',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 40.0),
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "\nTo get event\n",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 18.0),
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: _provider.currentUserId == event.authorId
                            ? "\nTake a screenshot of the barcode and place it at your desired location. Potential attendees can then scan the barcode to gain access to the event. It\'s a hassle-free way to promote the event."
                            : "\nScan the QR code with your phone camera or a QR code scanner app to access this event.",
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
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
