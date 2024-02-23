import 'package:bars/utilities/exports.dart';

class UserBarcode extends StatelessWidget {
  final String userDynamicLink;
  final String userId;
  final String profileImageUrl;

  final String userName;

  final String bio;

  const UserBarcode(
      {super.key,
      required this.userDynamicLink,
      required this.userName,
      required this.profileImageUrl,
      required this.bio,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);

    return Scaffold(
      backgroundColor: Color(0xFF1a1a1a),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Color(0xFF1a1a1a),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Hero(
                  tag: userId,
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
                    data: userDynamicLink,
                    size: ResponsiveHelper.responsiveHeight(context, 200.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ListTile(
                leading: profileImageUrl.isEmpty
                    ? Icon(
                        Icons.account_circle,
                        size: ResponsiveHelper.responsiveHeight(context, 40.0),
                        color: Colors.grey,
                      )
                    : CircleAvatar(
                        radius:
                            ResponsiveHelper.responsiveHeight(context, 18.0),
                        backgroundColor: Colors.blue,
                        backgroundImage:
                            CachedNetworkImageProvider(profileImageUrl),
                      ),
                title: Text(
                  userName,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context,
                        ResponsiveHelper.responsiveFontSize(context, 20)),
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '${bio.trim().replaceAll('\n', ' ')}',
                style: TextStyle(
                  fontSize: ResponsiveHelper.responsiveFontSize(context,
                      ResponsiveHelper.responsiveFontSize(context, 14)),
                  color: Colors.white,
                ),
                maxLines: 5,
              ),
              SizedBox(
                height: ResponsiveHelper.responsiveHeight(context, 50),
              ),
              if (_provider.currentUserId == userId)
                Text(
                  'This is your account barcode. You can take a screenshot of this barcode and display it in your studio or workplace. This way, new customers can scan it to access your Bars Impression page and stay in touch with you.',
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(context,
                        ResponsiveHelper.responsiveFontSize(context, 12)),
                    color: Colors.white,
                  ),
                ),
            ]),
      )),
    );
  }
}
