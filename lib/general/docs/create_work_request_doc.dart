import 'package:bars/utilities/exports.dart';

class CreateWorkRequestDoc extends StatelessWidget {
  final bool fromWelcome;
  const CreateWorkRequestDoc({super.key, required this.fromWelcome});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<UserData>(context, listen: false);
    var _user = _provider.user;
    var featureStyleBig = TextStyle(
      color: Theme.of(context).secondaryHeaderColor,
      fontSize: ResponsiveHelper.responsiveFontSize(context, 18),
    );

    return Container(
        height: ResponsiveHelper.responsiveHeight(context, 600),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            TicketPurchasingIcon(
              title: '',
            ),
            Center(
              child: Text(
                "\nBe creative\nwith creatives.    ",
                style: featureStyleBig,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: ShakeTransition(
                axis: Axis.vertical,
                child: Container(
                  color: Colors.grey,
                  height: 1,
                  width: ResponsiveHelper.responsiveWidth(context, 70),
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "\nA wide range of creatives in your palm.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              '\nOnce again,\nIn all aspects, \nYou are covered.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "\nCreate a work request for a specific geographical location and event types, so that events happening in that area can become aware that you are prepared to shine.\n\nExplore and engage with a diverse pool of talented creatives from various backgrounds for your projects, collaborations, and events.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "\n\nDiscover and get discovered.\n",
              style: featureStyleBig,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                color: Colors.grey,
                height: 1,
                width: ResponsiveHelper.responsiveWidth(context, 70),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            RichText(
              textScaler: MediaQuery.of(context).textScaler,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "\nSet up your brand.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nSet up your brand in a way that enables other creatives and event organizers to easily contact you for potential business opportunities.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nDiscover.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nDiscover and book creatives effortlessly to enhance your projects and events.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: "\n\nGet discovered.",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text:
                        "\nAn oppourtunity to position your brand to get oppourtunites .",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (!fromWelcome)
              GestureDetector(
                onTap: () {
                  _navigateToPage(
                      context,
                      UserBarcode(
                        profileImageUrl: _user!.profileImageUrl!,
                        userDynamicLink: _user.dynamicLink!,
                        bio: _user.bio!,
                        userName: _user.userName!,
                        userId: _user.userId!,
                      ));
                },
                child: Hero(
                    tag: _user!.userId!,
                    child: Icon(
                      Icons.qr_code,
                      color: Colors.blue,
                      size: ResponsiveHelper.responsiveHeight(context, 30),
                    )),
              ),
            const SizedBox(height: 60),
          ],
        ));
  }
}
