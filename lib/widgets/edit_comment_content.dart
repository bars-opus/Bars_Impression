import 'package:bars/utilities/exports.dart';

class EditCommentContent extends StatelessWidget {
  final String content;
  String newContentVaraible;
  final String contentType;
  final VoidCallback onPressedSave;
  final VoidCallback onPressedDelete;
  final Function(String) onSavedText;

  EditCommentContent(
      {required this.content,
      required this.contentType,
      required this.newContentVaraible,
      required this.onPressedSave,
      required this.onPressedDelete,
      required this.onSavedText});

  void _showBottomSheetClearActivity(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return ConfirmationPrompt(
          buttonText: 'Delete',
          onPressed: onPressedDelete,
          title: 'Are you sure you want to delete this $contentType?',
          subTitle: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 650),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TicketPurchasingIcon(
                    // icon: Icons.info,
                    title: 'Edit or delete \n$contentType.',
                  ),
                  MiniCircularProgressButton(
                    color: Colors.blue,
                    onPressed: onPressedSave,
                    text: "Save",
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              EditProfileTextField(
                autofocus: true,
                enableBorder: false,
                labelText: '',
                hintText: "$contentType cannot be empty",
                initialValue: content,
                onValidateText: (input) => newContentVaraible.length < 1
                    ? ' $contentType cannot be empty.'
                    : null,
                onSavedText: onSavedText,
              ),
              const SizedBox(
                height: 50.0,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    _showBottomSheetClearActivity(context);
                  },
                  child: Container(
                    height: ResponsiveHelper.responsiveHeight(
                      context,
                      50,
                    ),
                    width: ResponsiveHelper.responsiveHeight(
                      context,
                      50,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.delete_forever,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
