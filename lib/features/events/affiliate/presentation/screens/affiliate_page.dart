import 'package:bars/utilities/exports.dart';

class AffiliatePage extends StatelessWidget {
  final AffiliateModel affiliate;
  final bool isUser;
  final String currentUserId;
    final bool fromActivity;

  const AffiliatePage(
      {super.key,
      required this.affiliate,
      required this.isUser,
      required this.currentUserId, required this.fromActivity});

  @override
  Widget build(BuildContext context) {
    return EditProfileScaffold(
        title: '',
        widget: AffiliateWidget(
          isUser: isUser,
          affiliate: affiliate,
          currentUserId: currentUserId, fromActivity: fromActivity,
        ));
  }
}
