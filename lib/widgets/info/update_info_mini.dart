import 'package:flutter/material.dart';

import 'package:bars/utilities/exports.dart';

class UpdateInfoMini extends StatefulWidget {
  final Function onPressed;
  final String updateNote;
  final bool displayMiniUpdate;
  final bool showinfo;

  UpdateInfoMini({
    required this.onPressed,
   required this.displayMiniUpdate,
   required this.showinfo,
    required this.updateNote,
  });

  @override
  State<UpdateInfoMini> createState() => _UpdateInfoMiniState();
}

bool _showinfo = true;

class _UpdateInfoMiniState extends State<UpdateInfoMini> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 800),
        height:
            widget.displayMiniUpdate && widget.showinfo && _showinfo ? 80 : 0.0,
        width: width,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                width: 20.0,
                height: 20.0,
                child: Image.asset(
                  'assets/images/bars.png',
                  color: Colors.black,
                )),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            iconSize: 25.0,
            color: Colors.black,
            onPressed: () {
              if (mounted) {
                setState(() {
                  _showinfo = false;
                });
              }
            },
          ),
          title: Text('Update is available',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
              )),
          subtitle: Text(
            widget.updateNote,
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.black,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => widget.onPressed,
        ));
  }
}
