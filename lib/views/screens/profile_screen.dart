import 'package:avatar_glow/avatar_glow.dart';
import 'package:clozet/views/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../models/users.dart';
import '../utils/constants/color.dart';
import '../utils/constants/textstyle.dart';

class ProfileScreen extends StatelessWidget {
  final UserModel? user;
  const ProfileScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: Column(
        children: [
          sizeVar(30),
          Align(
            alignment: Alignment.topCenter,
            child: AvatarGlow(
              glowColor: Colors.red,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    user?.profileImage != null && user!.profileImage.isNotEmpty
                        ? NetworkImage(user!.profileImage)
                        : const AssetImage('assets/ads-1.png'),
              ),
            ),
          ),
          sizeVar(20),
          Text(
            user?.name ?? 'Guest',
            style: TextStyleConst().headingStyle(
              color: Colors.black,
              size: 35,
            ),
          ),
          sizeVar(20),
          profileCard(title: 'My Orders', icon: Icons.shopping_cart),
          sizeVar(20),
          profileCard(title: 'My Wishlist', icon: Icons.favorite),
          sizeVar(20),
          profileCard(title: 'My Account', icon: Icons.account_circle),
          sizeVar(20),
          profileCard(title: 'My Cart', icon: Icons.shopping_cart),
          sizeVar(20),
          profileCard(title: 'My Address', icon: Icons.location_on),
          sizeVar(20),
          profileCard(title: 'My Profile', icon: Icons.person),
          sizeVar(20),
          profileCard(title: 'My Settings', icon: Icons.settings),
          sizeVar(20),
          profileCard(title: 'My Logout', icon: Icons.logout),
        ],
      ),
    );
  }
}

Widget profileCard({required String title, required IconData icon}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: AppColor.gray,
              size: 35,
            ),
            sizeHor(20),
            Text(
              title,
              style: TextStyleConst().headingStyle(
                color: Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
        const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black,
          size: 20,
        ),
      ],
    ),
  );
}
