import 'package:bars/utilities/exports.dart';

class AffiliateBarcode extends StatelessWidget {
  final AffiliateModel affiliate;

  const AffiliateBarcode({
    super.key,
    required this.affiliate,
  });

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).primaryColorLight,
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Hero(
                  tag: affiliate.affiliateLink,
                  child: QrImageView(
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.blue,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.circle,
                      color: Colors.blue.withOpacity(.6),
                    ),
                    backgroundColor: Colors.transparent,
                    data: affiliate.affiliateLink,
                    size: ResponsiveHelper.responsiveHeight(context, 200.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ListTile(
                leading: Container(
                  height: ResponsiveHelper.responsiveHeight(context, 50),
                  width: ResponsiveHelper.responsiveHeight(context, 50),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(affiliate.eventImageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: RichText(
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5),
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: affiliate.eventTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextSpan(
                        text: '\nScan Qr code to attend.',
                        style: TextStyle(
                          fontSize: ResponsiveHelper.responsiveFontSize(
                              context, 14.0),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ]),
      )),
    );
  }
}
