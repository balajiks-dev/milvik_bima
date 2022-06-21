import 'package:flutter/material.dart';
import 'package:milvik_bima/features/login/login_screen.dart';
import 'package:milvik_bima/utils/assets.dart';
import 'package:milvik_bima/utils/colors.dart';
import 'package:milvik_bima/utils/constants.dart';
import 'package:milvik_bima/utils/sputils.dart';
import 'package:milvik_bima/utils/text_styles.dart';
import 'package:milvik_bima/utils/ui_helpers.dart';

class CommonDrawer extends StatelessWidget {
  const CommonDrawer({
    Key? key,
    required this.userName,
    required this.emailId,
  }) : super(key: key);

  final String userName;
  final String emailId;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorData.kcPrimaryColor,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: screenHeight(context) * 0.3,
            child: DrawerHeader(
              decoration:
              const BoxDecoration(color: ColorData.kcGreyShade1),
              child: Column(
                children: [
                  Image.asset(
                    UIAssets.profileImage,
                    height: screenHeight(context) * 0.15,
                    fit: BoxFit.contain,
                  ),
                  //These can go here or below the header with the same background color
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Admin',
                      style: ktsFontStyle14RegularBlack,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              AppStrings.logout,
              style: ktsFontStyle14White,
            ),
            onTap: () {
              SPUtil.clear();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}