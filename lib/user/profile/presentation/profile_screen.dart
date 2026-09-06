import 'package:flutter/material.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/user/profile/widget/profile_header.dart';
import 'package:chat_app/user/profile/widget/profile_option_tile.dart';
import 'package:chat_app/auth/presentation/signin_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const CustomText('Log Out', size: 18, weight: FontWeight.bold),
          content: const CustomText('Are you sure you want to log out from AuraChat?', size: 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CustomText('Cancel', size: 14, color: AppColors.textMuted, weight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: const Duration(milliseconds: 500),
                  ),
                  (route) => false,
                );
              },
              child: const CustomText('Log Out', size: 14, color: AppColors.activeRed, weight: FontWeight.bold),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: CustomText(
              'Profile',
              size: 26,
              weight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          
          // Profile Header card
          const ProfileHeader(),
          const SizedBox(height: 24),
          
          // Option Items Group
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border, width: 1.2),
            ),
            child: Column(
              children: [
                ProfileOptionTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Account Settings',
                  subtitle: 'Privacy, security, change mobile number',
                  onTap: () {},
                ),
                const Divider(color: AppColors.border, thickness: 0.8, height: 1, indent: 64),
                ProfileOptionTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Message tones, groups & call vibrations',
                  onTap: () {},
                ),
                const Divider(color: AppColors.border, thickness: 0.8, height: 1, indent: 64),
                ProfileOptionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'Chat Options',
                  subtitle: 'Appearance themes, wallpapers, backup history',
                  onTap: () {},
                ),
                const Divider(color: AppColors.border, thickness: 0.8, height: 1, indent: 64),
                ProfileOptionTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  subtitle: 'Frequently asked questions, system status, policies',
                  onTap: () {},
                ),
                const Divider(color: AppColors.border, thickness: 0.8, height: 1, indent: 64),
                ProfileOptionTile(
                  icon: Icons.logout_rounded,
                  title: 'Log Out',
                  subtitle: 'Disconnect and exit active session',
                  iconColor: AppColors.activeRed,
                  trailing: const SizedBox.shrink(),
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
