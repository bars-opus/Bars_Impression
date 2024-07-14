import 'package:bars/utilities/exports.dart';

class DummySearchContainer extends StatelessWidget {
  const DummySearchContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 35),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(
                Icons.search,
                size: ResponsiveHelper.responsiveHeight(context, 20),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              const SizedBox(
                width: 10,
              ),

              Text(
                'Search',
                style: Theme.of(context).textTheme.bodySmall,
              )
              // TextField(
              //   keyboardAppearance: MediaQuery.of(context).platformBrightness,
              //   autofocus: autoFocus,
              //   onTap: onTap,
              //   focusNode: focusNode,
              //   style: TextStyle(
              //       color: Theme.of(context).secondaryHeaderColor,
              //       fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              //       fontWeight: FontWeight.normal),
              //   cursorColor: Colors.blue,
              //   controller: controller,
              //   onChanged: onChanged,
              //   decoration: InputDecoration(
              //     contentPadding: EdgeInsets.symmetric(
              //       horizontal: ResponsiveHelper.responsiveHeight(context, 10),
              //       vertical: focusNode.hasFocus
              //           ? ResponsiveHelper.responsiveHeight(context, 20)
              //           : ResponsiveHelper.responsiveHeight(context, 2),
              //     ),
              //     border: InputBorder.none,
              //     hintText: hintText,
              //     prefixIcon: controller.text.length > 0
              //         ? null
              //         : Icon(
              //             Icons.search,
              //             size: ResponsiveHelper.responsiveHeight(context, 20),
              //             color: Theme.of(context).secondaryHeaderColor,
              //           ),
              //     hintStyle: Theme.of(context).textTheme.bodySmall,
              //     suffixIcon: controller.text.length > 0
              //         ? IconButton(
              //             icon: Icon(
              //               Icons.clear,
              //               size: ResponsiveHelper.responsiveHeight(context, 15),
              //               color: Theme.of(context).secondaryHeaderColor,
              //             ),
              //             onPressed: onClearText,
              //           )
              //         : null,
              //   ),

              // ),
            ],
          ),
        ),
      ),
    );
  }
}
