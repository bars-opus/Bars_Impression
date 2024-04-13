import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class LoadingChats extends StatelessWidget {
  final bool deleted;
  final String userId;
  final VoidCallback onPressed;

  const LoadingChats(
      {super.key,
      required this.deleted,
      required this.userId,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: CircleAvatar(
          radius: 20.0,
          backgroundColor: deleted ? Colors.black : Colors.blue,
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Text(
                deleted ? 'User not found' : 'Loading...',
                style: TextStyle(
                  fontWeight: deleted ? FontWeight.normal : FontWeight.bold,
                  fontSize: ResponsiveHelper.responsiveFontSize(
                    context,
                    ResponsiveHelper.responsiveFontSize(
                        context, deleted ? 12 : 14.0),
                  ),
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
            ),
            const SizedBox(
              height: 2.0,
            ),
          ],
        ),
        onTap: deleted ? onPressed : () {});
  }
}
