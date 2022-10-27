import 'package:flutter/material.dart';

class PageFeatureWidget extends StatelessWidget {
  final String heroTag;
  final String title;

  PageFeatureWidget({required this.heroTag, required this.title});

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: [
        Hero(
          tag: heroTag,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.work,
                color: Color(0xFF1a1a1a),
                size: 20.0,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 14.0, height: 1),
        ),
      ],
    );
  }
}
