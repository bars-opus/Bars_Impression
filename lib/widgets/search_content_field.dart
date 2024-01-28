import 'package:bars/utilities/exports.dart';

class SearchContentField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback cancelSearch;
  final VoidCallback onTap;
  final VoidCallback onClearText;
  final Function(String) onChanged;
  final bool showCancelButton;
  final bool fromEventDashBoard;

  final bool autoFocus;
  SearchContentField({
    this.hintText = 'Type to search...',
    required this.controller,
    required this.focusNode,
    required this.cancelSearch,
    required this.onTap,
    required this.onClearText,
    required this.onChanged,
    this.showCancelButton = false,
    this.fromEventDashBoard = false,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: showCancelButton || focusNode.hasFocus
          ? TextButton(
              onPressed: cancelSearch,
              child: Text(
                'Cancel',
                style: fromEventDashBoard
                    ? TextStyle(
                        color: Colors.white,
                        fontSize:
                            ResponsiveHelper.responsiveFontSize(context, 12.0),
                      )
                    : Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.right,
              ),
            )
          : null,
      title: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        height: focusNode.hasFocus
            ? ResponsiveHelper.responsiveHeight(context, 45)
            : ResponsiveHelper.responsiveHeight(context, 35),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextField(
          keyboardAppearance: MediaQuery.of(context).platformBrightness,
          autofocus: autoFocus,
          onTap: onTap,
          focusNode: focusNode,
          style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: ResponsiveHelper.responsiveFontSize(context, 14.0),
              fontWeight: FontWeight.normal),
          cursorColor: Colors.blue,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveHelper.responsiveHeight(context, 10),
              vertical: focusNode.hasFocus
                  ? ResponsiveHelper.responsiveHeight(context, 20)
                  : ResponsiveHelper.responsiveHeight(context, 2),
            ),
            border: InputBorder.none,
            hintText: hintText,
            prefixIcon: controller.text.trim().length > 0
                ? null
                : Icon(
                    Icons.search,
                    size: ResponsiveHelper.responsiveHeight(context, 20),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
            hintStyle: Theme.of(context).textTheme.bodySmall,
            suffixIcon: controller.text.trim().isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: ResponsiveHelper.responsiveHeight(context, 15),
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    onPressed: onClearText,
                  )
                : null,
          ),
          onSubmitted: (string) {
            cancelSearch();
          },
        ),
      ),
    );
  }
}
