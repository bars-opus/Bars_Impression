import 'package:bars/utilities/exports.dart';

class UserHeaderListTileWidget extends StatelessWidget {
 final UserStoreModel shop;
  final Widget trailing;
  String imageUrl;
  final VoidCallback onPressed;

  UserHeaderListTileWidget(
      {super.key,
      required this.shop,
      required this.imageUrl,
      this.trailing = const SizedBox.shrink(),
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      trailing: trailing,
      leading: imageUrl.isEmpty
          ? Icon(
              Icons.account_circle,
              size: ResponsiveHelper.responsiveHeight(context, 50.0),
              color: Colors.grey,
            )
          : Container(
              height: ResponsiveHelper.responsiveHeight(context, 40.0),
              width: ResponsiveHelper.responsiveHeight(context, 40.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
                image: DecorationImage(
                  image:
                      CachedNetworkImageProvider(imageUrl, errorListener: (_) {
                    return;
                  }),
                  fit: BoxFit.cover,
                ),
              ),
            ),
      title: RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(
          children: [
            TextSpan(
                text: shop.shopName.toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(
              text: "\n${shop.shopType}",
              style: TextStyle(
                color: Colors.blue,
                fontSize: ResponsiveHelper.responsiveFontSize(context, 12.0),
              ),
            )
          ],
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
