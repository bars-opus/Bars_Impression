import 'package:bars/utilities/exports.dart';

class AnimatedCircle extends StatefulWidget {
  final bool animateSize;
  final bool animateShape;
  final int size;
  final int stroke;

  AnimatedCircle({
    this.animateSize = false,
    this.animateShape = false,
    this.size = 100,
    this.stroke = 5,
  });

  @override
  _AnimatedCircleState createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<BorderRadius?> _shapeAnimation;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _shapeAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(0),
      end: BorderRadius.circular(50),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sizeAnimation = Tween<double>(
      begin: ResponsiveHelper.responsiveHeight(context, widget.size.toDouble()),
      end: ResponsiveHelper.responsiveHeight(context, widget.size - 20),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _animator(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double size = widget.animateSize
            ? _sizeAnimation.value
            : ResponsiveHelper.responsiveHeight(
                context, widget.size.toDouble());
        BorderRadius? borderRadius = widget.animateShape
            ? _shapeAnimation.value
            : BorderRadius.circular(50);

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(
                color: _colorAnimation.value!, width: widget.stroke.toDouble()),
            color: Colors.transparent,
            borderRadius: borderRadius,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.size != 100
        ? _animator(context)
        : Center(child: _animator(context));
  }
}
