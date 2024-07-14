import 'dart:ui';

import 'package:bars/utilities/exports.dart';
// Make sure this import is at the top

class PerpectiveListView extends StatefulWidget {
  final List<Widget> children;
  final double extentItem;
  final int visualizedItem;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int> onTapFrontItem;
  final ValueChanged<int> onChangeItem;
  // final Color backItemsShadowColor;

  // final List<TicketOrderModel> selectedEvents;
  // final String currentUserId;

  const PerpectiveListView({
    super.key,
    required this.children,
    required this.extentItem,
    required this.visualizedItem,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0),
    required this.onTapFrontItem,
    required this.onChangeItem,
    // required this.selectedEvents,
    // required this.currentUserId,
    // this.backItemsShadowColor = Colors.black
  });

  @override
  State<PerpectiveListView> createState() => _PerpectiveListViewState();
}

class _PerpectiveListViewState extends State<PerpectiveListView> {
  late PageController _pageController;
  late double _pagePercent;
  late int _currentIndex;
  bool _ignorePointer = false;
  Timer? _ignoreTimer;
  DateTime? _lastScrollTime;
  DateTime? _lastTapTime;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1 / widget.visualizedItem,
    );
    _currentIndex = widget.initialIndex;
    // _peroidicTimer();
    _pagePercent = 0.0;
    _pageController.addListener(_pageListener);
    super.initState();
  }

  // _peroidicTimer() {
  //   Timer.periodic(Duration(seconds: 1), (Timer timer) {
  //     setState(() {
  //       _ignorePointer = false;
  //     });
  //   });
  // }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  // void _startIgnoreTimer() {
  //   _ignoreTimer = Timer(const Duration(milliseconds: 100), () {
  //     if (_lastTapTime == null ||
  //         DateTime.now().difference(_lastTapTime!) >
  //             const Duration(milliseconds: 100)) {
  //       setState(() {
  //         _ignorePointer = true;
  //       });
  //     }
  //   });
  // }

  void _pageListener() {
    _currentIndex = _pageController.page!.floor();
    _pagePercent = (_pageController.page! - _currentIndex).abs();
    setState(() {});
  }

  // void _cancelIgnoreTimer() {
  //   _ignoreTimer?.cancel();
  //   _ignoreTimer = null;
  // }

  // void _startIgnoreTimer() {
  //   _cancelIgnoreTimer();
  //   _ignoreTimer = Timer(Duration(milliseconds: 100), () {
  //     setState(() => _ignorePointer = true);
  //   });
  // }

  void _navigateToPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

 

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      return Stack(
        children: [
          // Perspective items
          Padding(
            padding: widget.padding,
            child: _PerspectiveItem(
              currentIndex: _currentIndex,
              generateItem: widget.visualizedItem - 1,
              heightItem: widget.extentItem,
              pagePercent: _pagePercent,
              children: widget.children,
            ),
          ),

          // Listener that captures user input and manages ignorePointer state
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.children.length,
            onPageChanged: widget.onChangeItem,
            itemBuilder: (context, index) {
              return SizedBox
                  .shrink(); // Transparent, non-interactive placeholder
            },
          ),

          // Positioned.fill(
          //   top: height - widget.extentItem,
          //   child: GestureDetector(
          //     onTap: () {
          //       // if (widget.onTapFrontItem != null) {
          //       //   widget.onTapFrontItem(_currentIndex);

          //       final ticket = widget.selectedEvents[_currentIndex];

          //       //   print(ticket.eventTitle);
          //       //   // Use the ticket ID in your callback
          //       //   // widget.onTapFrontItem(ticket.orderId);
          //       // }

          //       //    widget.ticketOrder.isDeleted
          //       // ?
          //       //     _showBottomDeletedEvent(context)

          //       // :
          //       //
          //       _navigateToTicketOrder(ticket);
          //     },
          //   ),
          // )
        ],
      );
    });
  }
}

class _PerspectiveItem extends StatelessWidget {
  final int generateItem;
  final int currentIndex;
  final double heightItem;
  final double pagePercent;
  final List<Widget> children;

  const _PerspectiveItem(
      {required this.generateItem,
      required this.currentIndex,
      required this.heightItem,
      required this.pagePercent,
      required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      return Stack(
        fit: StackFit.expand,
        children: List.generate(generateItem, (index) {
          final invertedIndex = (generateItem - 2) - index;
          final indexPlus = index + 1;
          final positionPercent = indexPlus / generateItem;
          final endPositionPercent = index / generateItem;

          return (currentIndex > invertedIndex)
              ? _TransformedItem(
                  heightItem: heightItem,
                  factorChange: pagePercent,
                  scale: lerpDouble(.5, 1.0, positionPercent)!,
                  endScale: lerpDouble(.5, 1.0, endPositionPercent)!,
                  translateY: (height - heightItem) * positionPercent,
                  endTranslateY: (height - heightItem) * endPositionPercent,
                  child: children[currentIndex - (invertedIndex + 1)],
                )
              : const SizedBox();
        })
          //Hide bottom list
          ..add((currentIndex < (children.length - 1)
              ? Opacity(
                  opacity: 0.6, // Fully transparent

                  child: _TransformedItem(
                    heightItem: heightItem,
                    factorChange: pagePercent,
                    translateY: height + 20,
                    endTranslateY: (height - heightItem),
                    child: children[currentIndex + 1],
                  ),
                )
              : const SizedBox()))
          //Static last item
          ..insert(
              0,
              (currentIndex > (generateItem - 1)
                  ? _TransformedItem(
                      heightItem: heightItem,
                      factorChange: 1.0,
                      endScale: .5,
                      child: children[currentIndex - generateItem],
                    )
                  : const SizedBox())),
      );
    });
  }
}

class _TransformedItem extends StatelessWidget {
  final Widget child;
  final double heightItem;
  final double factorChange;
  final double scale;
  final double endScale;
  final double translateY;
  final double endTranslateY;

  const _TransformedItem({
    required this.child,
    required this.heightItem,
    required this.factorChange,
    this.scale = 1.0,
    this.endScale = 1.0,
    this.translateY = 0.0,
    this.endTranslateY = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.topCenter,
      transform: Matrix4.identity()
        ..scale(
          lerpDouble(
            scale,
            endScale,
            factorChange,
          ),
        )
        ..translate(
          0.0,
          lerpDouble(
            translateY,
            endTranslateY,
            factorChange,
          )!,
          0.0,
        ),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: heightItem,
          width: double.infinity,
          child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(5, 5),
                  blurRadius: 10.0,
                  spreadRadius: 10.0,
                )
              ]),
              child: child),
        ),
      ),
    );
  }
}

// class PerspectiveCardStack extends StatefulWidget {
//   @override
//   _PerspectiveCardStackState createState() => _PerspectiveCardStackState();
// }

// class _PerspectiveCardStackState extends State<PerspectiveCardStack> {
//   final PageController _pageController = PageController(viewportFraction: 0.8);

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       controller: _pageController,
//       scrollDirection: Axis.horizontal,
//       itemCount: 5, // Replace with your desired number of cards
//       itemBuilder: (context, index) {
//         return AnimatedBuilder(
//           animation: _pageController,
//           builder: (context, child) {
//             double value = 1.0;
//             if (_pageController.position.haveDimensions) {
//               value = _pageController.page! - index;
//               value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
//             }

//             return Center(
//               child: Transform(
//                 alignment: Alignment.center,
//                 transform: Matrix4.identity()
//                   ..setEntry(3, 2, 0.001) // perspective
//                   ..rotateY(value * math.pi / 6) // apply the 3D effect
//                   ..scale(value), // scale the card
//                 child: child,
//               ),
//             );
//           },
//           child: CardItem(index: index),
//         );
//       },
//     );
//   }
// }

// class CardItem extends StatelessWidget {
//   final int index;

//   CardItem({required this.index});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.blue[100 * (index % 9) + 100],
//       child: Center(
//         child: Text(
//           "Card $index",
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
// }
