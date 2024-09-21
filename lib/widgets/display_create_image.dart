import 'package:bars/utilities/exports.dart';

class DisplayCreateImage extends StatelessWidget {
  final bool isEvent;

  DisplayCreateImage({
    required this.isEvent,
  });

  _display(BuildContext context) {
    var _provider = Provider.of<UserData>(
      context,
    );
    File? _imgeFile = isEvent ? _provider.eventImage : _provider.postImage;
    if (_provider.imageUrl.isNotEmpty) {
      return Container(
          height: double.infinity,
          decoration: BoxDecoration(
              image: _imgeFile == null
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(_provider.imageUrl),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: FileImage(File(_imgeFile.path)),
                      fit: BoxFit.cover,
                    )),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.5),
              Colors.black.withOpacity(.5),
            ])),
          ));
    } else {
      return Container(
        child: _imgeFile == null
            ? Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black,
              )
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: FileImage(File(_imgeFile.path)),
                  fit: BoxFit.cover,
                )),
                child: Container(
                  decoration: BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.bottomRight, colors: [
                    Colors.black.withOpacity(.5),
                    Colors.black.withOpacity(.5),
                  ])),
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _display(context);
  }
}
