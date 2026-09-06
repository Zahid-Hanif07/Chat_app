import 'package:chat_app/core/providers/call_provider.dart';
import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/core/utils/user_utils.dart';

import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/model/user_model.dart';

import 'package:chat_app/user/call_screen/presentation/calling_screen.dart';

class ChatAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  // =========================================================
  // Initiate Call
  // =========================================================

  void _initiateCall(BuildContext context, UserModel user, bool isVideo) {
    final callProvider = context.read<CallProvider>();

    callProvider.startCall(user.name, user.imageUrl ?? '', isIncoming: false);

    if (!isVideo) {
      callProvider.toggleVideo();
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CallingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final selectedUserId = context.select<ChatProvider, String?>(
      (provider) => provider.selectedUserId,
    );

    if (selectedUserId == null) {
      return AppBar(backgroundColor: AppColors.surface, elevation: 0);
    }

    // IMPORTANT:
    // StreamBuilder keeps listening to Firebase in realtime.
    return StreamBuilder<UserModel?>(
      stream: FirestoreServices().watchUser(selectedUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingAppBar();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return _buildEmptyAppBar();
        }

        final user = snapshot.data!;

        return _buildAppBar(context, user);
      },
    );
  }

  // =========================================================
  // Actual AppBar
  // =========================================================

  Widget _buildAppBar(BuildContext context, UserModel user) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1.2)),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leadingWidth: 40,

        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textDark,
              size: 20,
            ),
            onPressed: () {
              context.read<ChatProvider>().deselectChat();

              Navigator.pop(context);
            },
          ),
        ),

        title: Row(
          children: [
            // =================================================
            // Avatar
            // =================================================
            Stack(
              children: [
                _buildAvatar(user),

                if (user.isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.activeGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.surface,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // =================================================
            // User Information
            // =================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    user.name,
                    size: 15,
                    weight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),

                  const SizedBox(height: 2),

                  CustomText(
                    user.isOnline ? 'Active now' : _getLastSeenText(user),
                    size: 11,
                    color: user.isOnline
                        ? AppColors.activeGreen
                        : AppColors.textMuted,
                    weight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ),

        // =====================================================
        // Call Buttons
        // =====================================================
        actions: [
          IconButton(
            icon: const Icon(
              Icons.phone_rounded,
              color: AppColors.primary,
              size: 22,
            ),
            onPressed: () {
              _initiateCall(context, user, false);
            },
          ),

          IconButton(
            icon: const Icon(
              Icons.videocam_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            onPressed: () {
              _initiateCall(context, user, true);
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }

  // =========================================================
  // Last Seen
  // =========================================================

  String _getLastSeenText(UserModel user) {
    final lastSeen = user.lastSeen;

    if (lastSeen == null) {
      return 'Offline';
    }

    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inSeconds < 60) {
      return 'Last seen just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;

      return 'Last seen $minutes '
          '${minutes == 1 ? 'minute' : 'minutes'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;

      return 'Last seen $hours '
          '${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays == 1) {
      return 'Last seen yesterday';
    }

    if (difference.inDays < 7) {
      return 'Last seen ${difference.inDays} days ago';
    }

    return 'Last seen ${lastSeen.day}/'
        '${lastSeen.month}/'
        '${lastSeen.year}';
  }

  // =========================================================
  // Avatar
  // =========================================================

  Widget _buildAvatar(UserModel user) {
    final hasImage = user.imageUrl != null && user.imageUrl!.trim().isNotEmpty;

    if (hasImage) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.border,
        backgroundImage: NetworkImage(user.imageUrl!),
      );
    }

    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.primary,
      child: Text(
        Userutils.getInitial(user.name),
        style: const TextStyle(
          color: AppColors.surface,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================
  // Loading AppBar
  // =========================================================

  PreferredSizeWidget _buildLoadingAppBar() {
    return AppBar(backgroundColor: AppColors.surface, elevation: 0);
  }

  // =========================================================
  // Empty AppBar
  // =========================================================

  PreferredSizeWidget _buildEmptyAppBar() {
    return AppBar(backgroundColor: AppColors.surface, elevation: 0);
  }
}
