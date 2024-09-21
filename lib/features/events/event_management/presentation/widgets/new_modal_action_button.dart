import 'dart:io';

import 'package:bars/features/creatives/presentation/widgets/notification_sort_button.dart';
import 'package:flutter/material.dart';

class NewModalActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String title;
  final Color? color;
  final bool fromModalSheet;
  final bool popOnPressed;

  const NewModalActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.color,
    this.fromModalSheet = true,
       this.popOnPressed = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(popOnPressed)
        Navigator.pop(context);
        onPressed();
      },
      child: Container(
        width: fromModalSheet ? double.infinity : 183,
        padding: EdgeInsets.symmetric(
            vertical: 20, horizontal: fromModalSheet ? 20 : 5),
        margin: EdgeInsets.symmetric(
            horizontal: Platform.isIOS
                ? 1
                : fromModalSheet
                    ? 8
                    : 1,
            vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).cardColor,
        ),
        child: NotificationSortButton(
          fromModalSheet: fromModalSheet,
          icon: icon,
          color: color ?? Theme.of(context).secondaryHeaderColor,
          onPressed: () {
            Navigator.pop(context);
            onPressed();
          },
          title: title,
        ),
      ),
    );
  }
}
