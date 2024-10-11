import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';

class ProfileImageDisplayWidget extends StatelessWidget {
  final String imageUrl;
   final String userId;

  const ProfileImageDisplayWidget({super.key, required this.imageUrl, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'container1' + userId.toString(),
      child: imageUrl.isEmpty
          ? Icon(
              Icons.store,
              color: Colors.grey,
              size: ResponsiveHelper.responsiveHeight(context, 80),
            )
          : CircleAvatar(
              backgroundColor: Color(0xFF1e4848),
              radius: ResponsiveHelper.responsiveHeight(context, 40.0),
              backgroundImage:
                  CachedNetworkImageProvider(imageUrl, errorListener: (_) {
                return;
              }),
            ),
    );
    
  }
}
