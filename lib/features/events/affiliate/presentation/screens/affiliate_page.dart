import 'package:bars/utilities/exports.dart';

class AffiliatePage extends StatelessWidget {
  final AffiliateModel affiliate;
  final bool isUser;
  final String currentUserId;

  const AffiliatePage(
      {super.key,
      required this.affiliate,
      required this.isUser,
      required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
        title: '',
        widget: AffiliateWidget(
          isUser: isUser,
          affiliate: affiliate,
          currentUserId: currentUserId,
        ));
  }
}
