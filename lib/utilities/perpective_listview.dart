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

  const PerpectiveListView({
    super.key,
    required this.children,
    required this.extentItem,
    required this.visualizedItem,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0),
    required this.onTapFrontItem,
    required this.onChangeItem,
  });

  @override
  State<PerpectiveListView> createState() => _PerpectiveListViewState();
}

class _PerpectiveListViewState extends State<PerpectiveListView> {
  late PageController _pageController;
  late double _pagePercent;
  late int _currentIndex;
  // bool _ignorePointer = false;
  // Timer? _ignoreTimer;
  // DateTime? _lastScrollTime;
  // DateTime? _lastTapTime;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1 / widget.visualizedItem,
    );
    _currentIndex = widget.initialIndex;
    _pagePercent = 0.0;
    _pageController.addListener(_pageListener);
    super.initState();
  }


  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }


  void _pageListener() {
    _currentIndex = _pageController.page!.floor();
    _pagePercent = (_pageController.page! - _currentIndex).abs();
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
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
