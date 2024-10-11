import 'package:bars/utilities/exports.dart';

class ProfileAddIconWidget extends StatelessWidget {
  final bool isAuthor;

  const ProfileAddIconWidget({super.key, required this.isAuthor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        size: ResponsiveHelper.responsiveHeight(context, 20.0),
        isAuthor
            ? Icons.add
            : Platform.isIOS
                ? Icons.arrow_back_ios
                : Icons.arrow_back,
        color: Theme.of(context).secondaryHeaderColor,
      ),
      onPressed: () {
        // HapticFeedback.mediumImpact();
        isAuthor
            ? 
             Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateEventScreen(
                  isEditting: false,
                  post: null,
                  // isCompleted: false,
                  // isDraft: false,
                ),),
    )
            
            // _navigateToPage(
            //     context,
            //     SetUpBrand(
            //         // isEditting: false,
            //         // post: null,
            //         // isCompleted: false,
            //         // isDraft: false,
            //         )
                // CreateEventScreen(
                //   isEditting: false,
                //   post: null,
                //   // isCompleted: false,
                //   // isDraft: false,
                // ),

            //     )
            : Navigator.pop(context);
      },
    );
  }
}
