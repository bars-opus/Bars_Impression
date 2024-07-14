import 'package:bars/utilities/exports.dart';

class MessageImage extends StatefulWidget {
  final String messageId;
  final String mediaUrl;

  MessageImage({required this.messageId, required this.mediaUrl});

  @override
  _MessageImageState createState() => _MessageImageState();
}

class _MessageImageState extends State<MessageImage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: Theme.of(context).primaryColor,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxScrolled) => [
          SliverAppBar(
            elevation: 0.0,
            automaticallyImplyLeading: true,
            floating: true,
            snap: true,
            iconTheme: new IconThemeData(
              color: Theme.of(context).secondaryHeaderColor,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Hero(
                tag: 'image ${widget.messageId}',
                child: Container(
                  height: width,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.mediaUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
