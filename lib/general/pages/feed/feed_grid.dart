import 'dart:ui';
import 'package:bars/utilities/exports.dart';

class FeedGrid extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final AccountHolder author;
  final String feed;

  FeedGrid({
    required this.currentUserId,
    required this.post,
    required this.author,
    required this.feed,
  });

  @override
  _FeedGridState createState() => _FeedGridState();
}

class _FeedGridState extends State<FeedGrid> {
  Widget buildBlur({
    required Widget child,
    double sigmaX = 10,
    double sigmaY = 10,
    BorderRadius? borderRadius,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: child,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GridTile(
        child: GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => AllPostEnlarged(
                        currentUserId: widget.currentUserId,
                        post: widget.post,
                        feed: widget.feed,
                        author: widget.author))),
            child: Tooltip(
              showDuration: Duration(seconds: 10),
              padding: EdgeInsets.all(20.0),
              message: widget.post.punch + '\n\n' + widget.post.caption,
              child: Stack(alignment: FractionalOffset.bottomCenter, children: <
                  Widget>[
                Stack(alignment: Alignment.bottomCenter, children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: ConfigBloc().darkModeOn
                            ? Color(0xFF1f2022)
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 0.0,
                            spreadRadius: 1.0,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Hero(
                        tag: 'postImage' + widget.post.id.toString(),
                        child: Container(
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.post.imageUrl),
                            fit: BoxFit.cover,
                          )),
                          child: widget.post.report.isNotEmpty
                              ? buildBlur(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Container(
                                    color: Colors.black.withOpacity(.8),
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          colors: [
                                        Colors.black.withOpacity(.7),
                                        Colors.black.withOpacity(.7)
                                      ])),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(bottom: 10.0, left: 15.0, right: 15.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: width > 600 ? 150 : 100.0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.0, vertical: 1.0),
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: widget.post.report.isNotEmpty
                                  ? Alignment.center
                                  : Alignment.bottomCenter,
                              child: widget.post.report.isNotEmpty
                                  ? const Icon(
                                      MdiIcons.eyeOff,
                                      color: Colors.grey,
                                      size: 30.0,
                                    )
                                  : Hero(
                                      tag: 'punch' + widget.post.id.toString(),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: Text(
                                          ' " ${widget.post.punch} "'
                                              .toLowerCase(),
                                          style: TextStyle(
                                            fontSize: width > 600 ? 16 : 12.0,
                                            color: Colors.white,
                                            shadows: [
                                              const BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(0, 3),
                                                blurRadius: 2.0,
                                                spreadRadius: 1.0,
                                              )
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          widget.post.report.isNotEmpty
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Hero(
                                        tag: 'artist2' +
                                            widget.post.id.toString(),
                                        child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            height: 2.0,
                                            color: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.0, vertical: 3.0),
                                            child: Text(
                                              ' @ ${widget.post.artist} ',
                                              style: const TextStyle(
                                                fontSize: 6.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ]),
                  )
                ]),
                widget.post.report.isNotEmpty
                    ? const SizedBox.shrink()
                    : widget.post.musicLink.isEmpty
                        ? const SizedBox.shrink()
                        : Positioned(
                            right: 15.0,
                            top: 15.0,
                            child: const Icon(
                              MdiIcons.playCircleOutline,
                              color: Colors.white,
                            ),
                          ),
              ]),
            )));
  }
}
