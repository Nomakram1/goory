import 'package:flutter/material.dart';
import 'package:Doory/constants/app_color.dart';
import 'package:Doory/constants/app_paddings.dart';
import 'package:Doory/constants/app_text_styles.dart';
import 'package:Doory/data/models/user.dart';
import 'package:Doory/widgets/profile/user_profile_photo.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: AppColor.primaryColor,
      child: Container(
        padding: AppPaddings.defaultPadding(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //user profile photo
            UserProfilePhoto(
              userProfileImageUrl: user != null ? user.photo : "",
            ),

            //user full name
            SizedBox(
              height: 10,
            ),
            Text(
              user != null ? user.name : "",
              style: AppTextStyle.h3TitleTextStyle(
                color: Colors.white,
              ),
            ),
            //user email/phone
            Text(
              user != null ? user.email : "",
              style: AppTextStyle.h5TitleTextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
