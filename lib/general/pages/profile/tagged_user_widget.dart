import 'dart:math';

import 'package:bars/utilities/exports.dart';

class TaggedUsersWidget extends StatelessWidget {
  List<TaggedEventPeopleModel> taggedPeopleOption;

  TaggedUsersWidget({required this.taggedPeopleOption});

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void _showBottomSheetExternalLink(
      BuildContext context, String link, IconData icon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height.toDouble() / 2,
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(30)),
            child: WebDisclaimer(
              link: link,
              contentType: 'External Profile',
              icon: icon,
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context, listen: false);

    final positions = _generatePositions(context);

    return Stack(
      alignment: FractionalOffset.center,
      children: taggedPeopleOption.map((taggedPerson) {
        var taggedType = taggedPerson.taggedType;
        final color = taggedType.startsWith('Sponsor')
            ? Colors.yellow
            : taggedType.startsWith('Partners')
                ? Colors.green
                : taggedType.startsWith('Crew')
                    ? Colors.black
                    : Colors.blue;

        final random = Random();
        final offsetX =
            random.nextDouble() * width / 2; // Adjust the range as needed
        final offsetY =
            random.nextDouble() * height; // Adjust the range as needed
        final isHorizontal = random.nextBool();
        final axis = isHorizontal ? Axis.horizontal : Axis.vertical;
        return Positioned(
          left: offsetX,
          top: offsetY,
          child: ShakeTransition(
            axis: axis,
            offset: 40,
            child: GestureDetector(
              onTap: () {
                taggedPerson.internalProfileLink!.isEmpty
                    ? _showBottomSheetExternalLink(
                        context,
                        taggedPerson.externalProfileLink!,
                        Icons.account_circle_outlined,
                      )
                    : _navigateToPage(
                        context,
                        ProfileScreen(
                          currentUserId: _provider.currentUserId!,
                          user: null,
                          userId: taggedPerson.internalProfileLink!,
                        ));
              },
              child: Stack(
                alignment: FractionalOffset.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ShakeTransition(
                              child: RichText(
                                  textScaleFactor:
                                      MediaQuery.of(context).textScaleFactor,
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: "${taggedPerson.role}\n",
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(context, 12),
                                          color: color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: taggedPerson.name,
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14),
                                        color: Colors.white,
                                      ),
                                    )
                                  ])),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              taggedPerson.internalProfileLink!.isEmpty
                                  ? Icons.link
                                  : Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: taggedPerson.internalProfileLink!.isEmpty
                                  ? ResponsiveHelper.responsiveHeight(
                                      context, 25)
                                  : ResponsiveHelper.responsiveHeight(
                                      context, 15),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -8,
                    child: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.grey[700],
                      size: ResponsiveHelper.responsiveHeight(context, 50),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Offset> _generatePositions(BuildContext context) {
    final random = Random();
    final size = MediaQuery.of(context).size;
    final List<Offset> newPositions = [];
    final double minDistance = 100.0; // Minimum distance between usernames
    for (int i = 0; i < taggedPeopleOption.length; i++) {
      final offsetX = random.nextDouble() * (size.width - minDistance);
      final offsetY = random.nextDouble() * (size.height - minDistance);
      final newOffset = Offset(offsetX, offsetY);

      bool isOverlapping = false;
      for (final existingOffset in newPositions) {
        final distance = (existingOffset - newOffset).distance;
        if (distance < minDistance) {
          isOverlapping = true;
          break;
        }
      }

      if (!isOverlapping) {
        newPositions.add(newOffset);
      } else {
        i--;
      }
    }

    return newPositions;
  }
}
