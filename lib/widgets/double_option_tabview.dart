import 'package:bars/utilities/exports.dart';

class DoubleOptionTabview extends StatelessWidget {
  final int initalTab;
  final String tabText1;
  final String tabText2;
  final Widget widget1;
  final Widget widget2;
  final double height;
  final bool lightColor;
  final String pageTitle;
  final Function(int) onPressed;

  DoubleOptionTabview(
      {required this.onPressed,
      required this.initalTab,
      required this.tabText1,
      required this.tabText2,
      required this.widget1,
      required this.height,
      required this.widget2,
      required this.lightColor,
      required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: initalTab,
        child: Scaffold(
            backgroundColor: lightColor
                ? Theme.of(context).primaryColorLight
                : Theme.of(context).cardColor,
            body: ListView(
              children: [
                TicketPurchasingIcon(
                  // icon: Icons.payment,
                  title: pageTitle,
                ),
                Container(
                  height: ResponsiveHelper.responsiveHeight(context, 40,),
                  child: TabBar(
                    indicatorColor: Colors.blue,
                    onTap: onPressed,
                    tabs: <Widget>[
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        tabText1,
                      ),
                      Text(
                        style: Theme.of(context).textTheme.bodyMedium,
                        tabText2,
                      ),
                     
                    ],
                  ),
                ),
               
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: height,
                  // color: Colors.blue,
                  child: TabBarView(
                    children: [
                      widget1,
                      widget2,
                    ],
                  ),
                ),
              ],
            )));
  }
}
