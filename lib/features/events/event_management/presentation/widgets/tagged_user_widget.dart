import 'dart:math';

import 'package:bars/utilities/exports.dart';

class TaggedUsersWidget extends StatefulWidget {
  List<TaggedEventPeopleModel> taggedPeopleOption;

  TaggedUsersWidget({required this.taggedPeopleOption});

  @override
  State<TaggedUsersWidget> createState() => _TaggedUsersWidgetState();
}

class _TaggedUsersWidgetState extends State<TaggedUsersWidget> {
  List<Offset> positions = []; // Initialize positions to an empty list
  final double taggedUserWidth = 100; // Adjust accordingly
  final double taggedUserHeight = 50; // Adjust accordingly
  final double minDistance = 100.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newPositions = _generatePositions();
      // Use setState only if new positions are generated
      if (newPositions.isNotEmpty) {
        setState(() {
          positions = newPositions;
        });
      }
    });
  }

  List<Offset> _generatePositions() {
    final random = Random();
    final size = MediaQuery.of(context).size;
    final List<Offset> newPositions = [];

    for (int i = 0; i < widget.taggedPeopleOption.length; i++) {
      // Ensure tagged users are within the visible area considering their size
      final offsetX = random.nextDouble() * (size.width - taggedUserWidth);
      final offsetY =
          random.nextDouble() * (size.height - 100 - taggedUserHeight);
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
        i--; // Retry generating a position for this tagged user
      }
    }

    return newPositions;
  }

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
            height: ResponsiveHelper.responsiveHeight(context, 400),
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
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    var _provider = Provider.of<UserData>(context, listen: false);
    if (positions.isEmpty) {
      // Return a placeholder widget or an empty Container
      return SizedBox.shrink();
    }

    return Stack(
      alignment: FractionalOffset.center,
      children: List.generate(widget.taggedPeopleOption.length, (index) {
        var taggedPerson = widget.taggedPeopleOption[index];
        final color = taggedPerson.taggedType.startsWith('Sponsor')
            ? Colors.yellow
            : taggedPerson.taggedType.startsWith('Partner')
                ? Colors.green
                : taggedPerson.taggedType.startsWith('Crew')
                    ? Colors.black
                    : Colors.blue;

        final position = positions[index];

        final random = Random();
        // final offsetX =
        //     random.nextDouble() * width / 2; // Adjust the range as needed
        // final offsetY =
        //     random.nextDouble() * height; // Adjust the range as needed
        final isHorizontal = random.nextBool();
        final axis = isHorizontal ? Axis.horizontal : Axis.vertical;
        return Positioned(
          left: position.dx,
          top: position.dy,
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
                        color: Colors.white,
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
                                              .responsiveFontSize(context, 10),
                                          color: color,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: taggedPerson.name,
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 12),
                                        color: Colors.black,
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
                      color: Colors.white,
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
}
