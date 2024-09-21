// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bars/utilities/exports.dart';

class AddTaggedPeople extends StatefulWidget {
  // String selectedNameToAdd;
  // String selectedNameToAddProfileImageUrl;
  // String taggedUserExternalLink;
  TextEditingController tagNameController;
  Future<QuerySnapshot>? users;
  GlobalKey<FormState> addPersonFormKey;
  final FocusNode nameSearchfocusNode;
  final bool isSchedule;

  // final VoidCallback cancelSearch;
  // final Function(String) onChanged;

  AddTaggedPeople({
    Key? key,
    // required this.selectedNameToAdd,
    // required this.selectedNameToAddProfileImageUrl,
    // required this.taggedUserExternalLink,
    required this.tagNameController,
    this.users,
    required this.addPersonFormKey,
    required this.nameSearchfocusNode,
    required this.isSchedule,
  }) : super(key: key);

  @override
  State<AddTaggedPeople> createState() => _AddTaggedPeopleState();
}

class _AddTaggedPeopleState extends State<AddTaggedPeople> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

//section for people performain in an event
  _cancelSearchUser() {
    if (mounted) {
      setState(() {
        widget.users = null;
        _clearSearchUser();
      });
    }
  }

  _clearSearchUser() {
    var _provider = Provider.of<UserData>(context, listen: false);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.tagNameController.clear());
    // widget.selectedNameToAdd = '';
    _provider.setTaggedUserSelectedProfileName('');
    _provider.setTaggedUserSelectedProfileImageUrl('');
    // widget.selectedNameToAddProfileImageUrl = '';
    widget.tagNameController.clear();
  }

  _buildUserTile(AccountHolderAuthor user, bool isSchedule) {
    return SearchUserTile(
        verified: user.verified!,
        userName: user.userName!.toUpperCase(),
        profileHandle: user.profileHandle!,
        profileImageUrl: user.profileImageUrl!,
        bio: user.bio!,
        onPressed: _addPeopleFunction(user, isSchedule));
  }

  _addPeopleFunction(AccountHolderAuthor user, bool isSchedule) {
    var _provider = Provider.of<UserData>(context, listen: false);
    return isSchedule
        ? () {
            EventDatabaseEventData.addSchedulePeople(
                context: context,
                name: user.userName!,
                internalProfileLink: user.userId!,
                taggedUserExternalLink: '',
                profileImageUrl: user.profileImageUrl!);
            Navigator.pop(context);
          }
        : () {
            _provider.setTaggedUserSelectedProfileLink(user.userId!);
            _provider.setTaggedUserSelectedProfileName(user.userName!);
            _provider
                .setTaggedUserSelectedProfileImageUrl(user.profileImageUrl!);
            // if (mounted) {
            //   setState(() {
            //     widget.selectedNameToAdd = user.userName!;
            //     widget.selectedNameToAddProfileImageUrl = user.profileImageUrl!;
            //   });
            // }

            Navigator.pop(context);
          };
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    var _provider = Provider.of<UserData>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        height: ResponsiveHelper.responsiveHeight(context, 750),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(30)),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: DoubleOptionTabview(
            height: _size.height,
            onPressed: (int) {},
            tabText1: 'From Bars Impression',
            tabText2: 'From external link',
            initalTab: 0,
            widget1: ListView(
              children: [
                Text(
                  widget.tagNameController.text,
                ),
                SearchContentField(
                    cancelSearch: _cancelSearchUser,
                    controller: widget.tagNameController,
                    focusNode: widget.nameSearchfocusNode,
                    hintText: 'Enter username..',
                    onClearText: () {
                      _clearSearchUser();
                    },
                    onTap: () {},
                    onChanged: (input) {
                      if (input.trim().isNotEmpty) {
                        _debouncer.run(() {
                          setState(() {
                            widget.users = DatabaseService.searchUsers(
                                input.toUpperCase());
                          });
                        });
                      }
                    }),
                const SizedBox(
                  height: 30,
                ),
                if (widget.users != null)
                  Text('        Select a person from the list below'),
                if (widget.users != null)
                  FutureBuilder<QuerySnapshot>(
                      future: widget.users,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const SizedBox.shrink();
                        }
                        if (snapshot.data!.docs.length == 0) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RichText(
                                  text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: "No users found. ",
                                      style: TextStyle(
                                          fontSize: ResponsiveHelper
                                              .responsiveFontSize(
                                                  context, 20.0),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey)),
                                  TextSpan(
                                      text: '\nCheck username and try again.',
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveHelper.responsiveFontSize(
                                                context, 14.0),
                                      )),
                                ],
                                style: TextStyle(
                                    fontSize:
                                        ResponsiveHelper.responsiveFontSize(
                                            context, 14.0),
                                    color: Colors.grey),
                              )),
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: SizedBox(
                            height: _size.width,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                SingleChildScrollView(
                                  child: SizedBox(
                                    height: _size.width - 20,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        AccountHolderAuthor? user =
                                            AccountHolderAuthor.fromDoc(
                                                snapshot.data!.docs[index]);
                                        return _buildUserTile(
                                            user, widget.isSchedule);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
              ],
            ),
            widget2: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: widget.addPersonFormKey,
                child: Column(
                  children: [
                    _provider.taggedUserSelectedProfileName.isEmpty ||
                            _provider.taggedUserSelectedExternalLink.isEmpty
                        ? SizedBox.shrink()
                        : Align(
                            alignment: Alignment.centerRight,
                            child: MiniCircularProgressButton(
                              color: Colors.blue,
                              text: '  Add  ',
                              onPressed: !widget.isSchedule
                                  ? () {
                                      if (widget.addPersonFormKey.currentState!
                                          .validate()) Navigator.pop(context);
                                    }
                                  : () {
                                      if (widget.addPersonFormKey.currentState!
                                          .validate()) {
                                        EventDatabaseEventData
                                            .addSchedulePeople(
                                                context: context,
                                                name: _provider
                                                    .taggedUserSelectedProfileName,
                                                // widget.selectedNameToAdd,
                                                internalProfileLink: '',
                                                taggedUserExternalLink: _provider
                                                    .taggedUserSelectedExternalLink,
                                                // widget
                                                //     .taggedUserExternalLink,
                                                profileImageUrl: '');
                                        Navigator.pop(context);
                                      }
                                    },
                            ),
                          ),
                    ContentFieldBlack(
                        onlyBlack: false,
                        onSavedText: (value) {
                          _provider.setTaggedUserSelectedProfileName(value);
                          // setState(() {
                          //   widget.selectedNameToAdd = value;
                          // });
                        },
                        onValidateText: (_) {},
                        initialValue: _provider.taggedUserSelectedExternalLink,
                        // widget.selectedNameToAdd,
                        hintText: 'Nam of person',
                        labelText: 'Name'),
                    ContentFieldBlack(
                        onlyBlack: false,
                        onSavedText: (value) {
                          _provider.setTaggedUserSelectedExternalLink(value);
                          // setState(() {
                          //   widget.taggedUserExternalLink = value;
                          // });
                        },
                        onValidateText: ValidationUtils.validateWebsiteUrl,
                        initialValue: _provider.taggedUserSelectedExternalLink,
                        // widget.taggedUserExternalLink,
                        hintText:
                            'External link to profile(social media, wikipedia)',
                        labelText: 'link'),
                  ],
                ),
              ),
            ),
            lightColor: true,
            pageTitle: '',
          ),
        ),
      ),
    );
  }
}
