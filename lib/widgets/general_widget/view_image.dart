import 'package:bars/utilities/exports.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  final String imageUrl;

  ViewImage({
  required this.imageUrl,
  });

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          automaticallyImplyLeading: true,
          elevation: 0,
          backgroundColor: Colors.black,
        
          centerTitle: true,
       
        ),
        body: Center(
          child: PhotoView(
            imageProvider: CachedNetworkImageProvider(widget.imageUrl),
            minScale: PhotoViewComputedScale.contained *
                1.0, // You can adjust your zooming scale the way you want
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
            heroAttributes:
                PhotoViewHeroAttributes(tag: widget.imageUrl.toString()),
          ),
        ),
      

      
    );
  }
}
