import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:bars/utilities/exports.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class EventViewWidget extends StatelessWidget {
  final int askCount;
  final String currentUserId;
  final String titleHero;
  final int difference;
  final bool completed;
  final int feed;
  final String exploreLocation;
  final Event event;

  EventViewWidget({
    required this.currentUserId,
    required this.event,
    required this.titleHero,
    required this.askCount,
    required this.difference,
    required this.completed,
    required this.feed,
    required this.exploreLocation,
  });
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
    final List<String> namePartition = event.title.split(" ");
    final width =
        Responsive.isDesktop(context) ? 600 : MediaQuery.of(context).size.width;
    return OpenContainer(
      openColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      closedColor: ConfigBloc().darkModeOn ? Color(0xFF1a1a1a) : Colors.white,
      transitionType: ContainerTransitionType.fade,
      closedBuilder: (BuildContext _, VoidCallback openContainer) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: width / 2,
                        width: width + 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            Material(
                              color: Colors.transparent,
                              child: Container(
                                height: width / 2,
                                width: width / 4,
                                decoration: BoxDecoration(
                                    color: ConfigBloc().darkModeOn
                                        ? Color(0xFF1a1a1a)
                                        : Colors.white,
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          event.imageUrl),
                                      fit: BoxFit.cover,
                                    )),
                                child: event.report.isNotEmpty
                                    ? buildBlur(
                                        borderRadius: BorderRadius.circular(0),
                                        child: Container(
                                            color: Colors.black.withOpacity(.8),
                                            child: Icon(
                                              MdiIcons.eyeOff,
                                              color: Colors.grey,
                                              size: 30.0,
                                            )))
                                    : Container(),
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 30),
                                  child: Hero(
                                      tag: titleHero,
                                      child: Material(
                                          color: Colors.transparent,
                                          child: Container(
                                            width: width / 2 * 1.2,
                                            height: width / 2,
                                            child: event.report.isNotEmpty
                                                ? RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor,
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text: namePartition[0]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          decorationColor:
                                                              Colors.grey,
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize: 25,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (namePartition.length >
                                                          1)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[1].toUpperCase()} ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 25,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          2)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[2].toUpperCase()} ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 25,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          3)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[3].toUpperCase()} ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 25,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          4)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[4].toUpperCase()} ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 25,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          5)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[5].toUpperCase()}",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 25,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "\n${event.theme.toUpperCase()}",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "\n${event.venue}",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "\n${MyDateFormat.toDate(DateTime.parse(event.date))}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .green,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "Special guess: ",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.guess}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "Artist performing: ",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.artist}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text: "Time: ",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${MyDateFormat.toTime(DateTime.parse(event.time))}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text: "Host: ",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.host}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text: "Rate: ",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.rate}\n",
                                                                style:
                                                                    TextStyle(
                                                                  decorationColor:
                                                                      Colors
                                                                          .grey,
                                                                  decorationStyle:
                                                                      TextDecorationStyle
                                                                          .solid,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey,
                                                                )),
                                                          ],
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            color: Colors.grey,
                                                          )),
                                                      TextSpan(
                                                          text: "Dress code: ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              " ${event.dressCode}\n",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          )),
                                                      TextSpan(
                                                          text: "DJ: ",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              " ${event.dj}\n",
                                                          style: TextStyle(
                                                            decorationColor:
                                                                Colors.grey,
                                                            decorationStyle:
                                                                TextDecorationStyle
                                                                    .solid,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          )),
                                                    ]),
                                                    textAlign: TextAlign.start,
                                                  )
                                                : RichText(
                                                    textScaleFactor:
                                                        MediaQuery.of(context)
                                                            .textScaleFactor,
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                        text: namePartition[0]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 25,
                                                          color: ConfigBloc()
                                                                  .darkModeOn
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      if (namePartition.length >
                                                          1)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[1].toUpperCase()} ",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          2)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[2].toUpperCase()} ",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          3)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[3].toUpperCase()} ",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          4)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[4].toUpperCase()} ",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      if (namePartition.length >
                                                          5)
                                                        TextSpan(
                                                          text:
                                                              "\n${namePartition[5].toUpperCase()}",
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      TextSpan(
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "\n${event.theme.toUpperCase()}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .grey
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "\n${event.venue}",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "\n${MyDateFormat.toDate(DateTime.parse(event.date))}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "Special guess: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.guess}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "Artist performing: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.artist}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text: "Time: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    "${MyDateFormat.toTime(DateTime.parse(event.time))}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text: "Host: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.host}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                            TextSpan(
                                                                text: "Rate: ",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .blueGrey,
                                                                )),
                                                            TextSpan(
                                                                text:
                                                                    " ${event.rate}\n",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: ConfigBloc()
                                                                          .darkModeOn
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                )),
                                                          ],
                                                          style: TextStyle(
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                          )),
                                                      TextSpan(
                                                          text: "Dress code: ",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.blueGrey,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              " ${event.dressCode}\n",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                          )),
                                                      TextSpan(
                                                          text: "DJ: ",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.blueGrey,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              " ${event.dj}\n",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: ConfigBloc()
                                                                    .darkModeOn
                                                                ? Colors.white
                                                                : Colors.black,
                                                          )),
                                                    ]),
                                                    textAlign: TextAlign.start,
                                                  ),
                                          ))),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: event.isPrivate ? 'Private' : 'Public',
                            style: TextStyle(
                                fontSize: 10,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black)),
                        TextSpan(
                            text: '\nAsks: ',
                            style: TextStyle(
                                fontSize: 10,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black)),
                        TextSpan(
                            text: NumberFormat.compact().format(askCount),
                            style: TextStyle(
                                fontSize: 12,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black)),
                        TextSpan(
                            text: '\n${event.authorName}',
                            style: TextStyle(
                                fontSize: 12,
                                color: ConfigBloc().darkModeOn
                                    ? Colors.white
                                    : Colors.black)),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                  RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: timeago.format(event.timestamp!.toDate()),
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                        TextSpan(
                            text: completed
                                ? '\nCompleted'
                                : difference < 0
                                    ? '\nOngoing...'
                                    : '\n',
                            style: TextStyle(
                                fontSize: 10,
                                color: completed ? Colors.red : Colors.green)),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey[800],
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        );
      },
      openBuilder:
          (BuildContext context, void Function({Object? returnValue}) action) {
        return AllEvenEnlarged(
          exploreLocation: exploreLocation,
          feed: feed,
          askCount: askCount,
          currentUserId: currentUserId,
          event: event,
        );
      },
    );
  }
}
