import 'package:bars/utilities/dimensions.dart';
import 'package:flutter/material.dart';

class CategoryContainer extends StatelessWidget {
  final Widget child;
  final String containerTitle;
  final String containerSubTitle;
  final VoidCallback seeAllOnPressed;
  final bool showSeeAll;

  CategoryContainer({
    required this.child,
    required this.containerTitle,
    required this.containerSubTitle,
    required this.seeAllOnPressed,
    this.showSeeAll = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                trailing: showSeeAll
                    ? GestureDetector(
                        onTap: seeAllOnPressed,
                        child: Container(
                          width:
                              ResponsiveHelper.responsiveWidth(context, 80.0),
                          height:
                              ResponsiveHelper.responsiveHeight(context, 40.0),
                          child: Row(
                            children: [
                              Text(
                                'See all',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: ResponsiveHelper.responsiveFontSize(
                                    context,
                                    14,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                color: Colors.blue,
                                size: ResponsiveHelper.responsiveHeight(
                                  context,
                                  20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$containerTitle\n",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      TextSpan(
                        text: "$containerSubTitle ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ), textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
                ),
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}
