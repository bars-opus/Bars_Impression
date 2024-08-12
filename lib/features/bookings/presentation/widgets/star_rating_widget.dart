import 'package:bars/features/bookings/presentation/widgets/star.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StarRatingWidget extends StatefulWidget {
  final int rating;
  final bool isMini;
  final bool enableTap;
  final Function(int) onRatingChanged;

  StarRatingWidget(
      {required this.rating,
      required this.onRatingChanged,
      this.isMini = false,
      this.enableTap = true});

  @override
  _StarRatingWidgetState createState() => _StarRatingWidgetState();
}

class _StarRatingWidgetState extends State<StarRatingWidget> {
  late int _currentRating;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.rating;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onStarTapped(int rating) {
    setState(() {
      _currentRating = rating;
    });

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      widget.onRatingChanged(_currentRating);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Star(
          isFilled: index < _currentRating,
          onTap: widget.enableTap ? () => _onStarTapped(index + 1) : () {},
          isMini: widget.isMini,
        );
      }),
    );
  }
}
