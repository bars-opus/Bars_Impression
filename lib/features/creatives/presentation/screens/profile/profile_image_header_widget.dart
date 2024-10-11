import 'package:bars/utilities/exports.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileImageHeaderWidget extends StatelessWidget {
  final bool isClient;
  final bool isAuthor;
  final String imageUrl;
  final String userId;
  final bool verified;
  final String name;
  final String shopOrAccountType;
  final String currentUserId;
  final int clientCount;
  final UserStoreModel? user;
  final VoidCallback onPressed;

  const ProfileImageHeaderWidget({
    Key? key,
    required this.isClient,
    required this.isAuthor,
    required this.imageUrl,
    required this.userId,
    required this.verified,
    required this.name,
    required this.currentUserId,
    required this.clientCount,
    required this.shopOrAccountType,
    required this.user,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToPage(BuildContext context, Widget page) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    }

    _buildStatistics(
      BuildContext context,
    ) {
      // final String currentUserId =
      //     Provider.of<UserData>(context, listen: false).currentUserId!;

      bool isAuthor = currentUserId == userId;
      return UserStatistics(
        count: NumberFormat.compact().format(clientCount),
        countColor: Colors.grey,
        titleColor: Colors.grey,
        onPressed: () => clientCount == 0
            ? navigateToPage(
                context,
                NoFollowers(
                  from: 'Clients',
                  isCurrentUser: isAuthor,
                  userName: user!.shopName,
                ))
            : navigateToPage(
                context,
                FollowerFollowing(
                  userId: user!.userId,
                  followerCount: clientCount,
                  followingCount: clientCount,
                  follower: 'Clients',
                )),
        title: '  Clients',
        subTitle: 'The number of accounts following you.',
      );
    }

    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Stack(
            children: [
              ProfileImageDisplayWidget(
                imageUrl: imageUrl,
                userId: userId,
              ),
              if (isAuthor)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(.4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        size: ResponsiveHelper.responsiveHeight(context, 15.0),
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameText(
                color: Colors.black,
                name: name.toUpperCase().trim().replaceAll('\n', ' '),
                verified: verified,
              ),
              if (!isClient) _buildStatistics(context),
              Material(
                color: Colors.transparent,
                child: Text(
                  shopOrAccountType,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize:
                        ResponsiveHelper.responsiveFontSize(context, 12.0),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              if (!isClient)
                StarRatingWidget(
                  isMini: true,
                  enableTap: false,
                  onRatingChanged: (_) {},
                  rating: user!.averageRating ?? 0,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
