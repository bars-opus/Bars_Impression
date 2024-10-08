import 'package:bars/utilities/exports.dart';

class UpdateInfoMini extends StatefulWidget {
  final VoidCallback onPressed;
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
            widget.displayMiniUpdate && widget.showinfo && _showinfo ? 90 : 0.0,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
                width: ResponsiveHelper.responsiveHeight(
                  context,
                  20,
                ),
                height: ResponsiveHelper.responsiveHeight(
                  context,
                  20,
                ),
                child: Image.asset(
                  'assets/images/bars.png',
                  color: Colors.black,
                )),
          ),
          trailing: IconButton(
            icon: Icon(Icons.close),
            iconSize: ResponsiveHelper.responsiveHeight(
              context,
              20,
            ),
            color: Colors.black,
            onPressed: () {
              if (mounted) {
                setState(() {
                  _showinfo = false;
                });
              }
            },
          ),
          title: Text('update is available',
              style: TextStyle(
                fontSize: ResponsiveHelper.responsiveFontSize(
                  context,
                  14,
                ),
                color: Colors.black,
              )),
          subtitle: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.updateNote,
                  style: TextStyle(
                    fontSize: ResponsiveHelper.responsiveFontSize(
                      context,
                      11,
                    ),
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '\nTap here to update.',
                  style: TextStyle(
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 11.0),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaleFactor.clamp(0.5, 1.5)),
          ),
          onTap: widget.onPressed,
        ));
  }
}
