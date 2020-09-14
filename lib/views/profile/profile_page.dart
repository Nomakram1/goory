import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:foodie/bloc/profile.bloc.dart';
import 'package:foodie/constants/app_paddings.dart';
import 'package:foodie/constants/app_routes.dart';
import 'package:foodie/constants/strings/profile/profile.strings.dart';
import 'package:foodie/widgets/menu/menu_item.dart';
import 'package:foodie/widgets/profile/user_profile_card.dart';
import 'package:tellam/tellam.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  @override
  bool get wantKeepAlive => true;

  //profile bloc
  ProfileBloc _profileBloc = new ProfileBloc();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Colors.white,
      child: ListView(
        padding: AppPaddings.defaultPadding(),
        children: <Widget>[
          //profile header
          StreamBuilder(
            stream: _profileBloc.appDatabase.userDao.findCurrentAsStream(),
            builder: (context, snapshot) {
              return UserProfileCard(
                user: snapshot.data,
              );
            },
          ),

          //
          SizedBox(
            height: 20,
          ),

          //options
          // My Details menu item
          MenuItem(
            icon: Icon(
              FlutterIcons.user_ant,
            ),
            title: ProfileStrings.updateProfile,
            onPressed: () {
              // Edit profile
              Navigator.pushNamed(
                context,
                AppRoutes.editProfileRoute,
              );
            },
          ),
          Divider(
            height: 1,
          ),

          // Chnage password menu item
          MenuItem(
            icon: Icon(
              FlutterIcons.lock_ant,
            ),
            title: ProfileStrings.changePassword,
            onPressed: () {
              // Edit profile
              Navigator.pushNamed(
                context,
                AppRoutes.changePasswordRoute,
              );
            },
          ),
          Divider(
            height: 1,
          ),

          //Delivery Addresses menu item
          MenuItem(
            icon: Icon(
              SimpleLineIcons.location_pin,
            ),
            title: ProfileStrings.deliveryAddress,
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.deliveryAddressesRoute,
              );
            },
          ),
          Divider(
            height: 1,
          ),

          // Notifications menu item
          MenuItem(
            icon: Icon(
              FlutterIcons.bells_ant,
            ),
            title: ProfileStrings.notifications,
            onPressed: () {
              // Edit profile
              Navigator.pushNamed(
                context,
                AppRoutes.notificationsRoute,
              );
            },
          ),
          Divider(
            height: 1,
          ),

          // Chat and faq menu item
          MenuItem(
            icon: Icon(
              FlutterIcons.chat_bubble_outline_mdi,
            ),
            title: ProfileStrings.faqs,
            onPressed: () {
              // Edit profile
              Tellam.show(
                context,
                enableChat: true,
              );
            },
          ),
          Divider(
            height: 1,
          ),

          Divider(),
          MenuItem(
            icon: Icon(
              AntDesign.logout,
            ),
            title: ProfileStrings.logout,
            onPressed: _processLogout,
          ),
          Divider(),
        ],
      ),
    );
  }

  void _processLogout() async {
    await _profileBloc.logout();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.welcomeRoute,
      (route) => false,
    );
  }
}
