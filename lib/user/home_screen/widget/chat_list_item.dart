import 'package:chat_app/model/chat_thread_model.dart';
import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';

import 'package:chat_app/user/chat_screen/presentation/chat_screen.dart';

class ChatListItem extends StatelessWidget {
  final ChatThread thread;

  const ChatListItem({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();
    final hasUnread = thread.unreadCount > 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          chatProvider.selectChat(thread.id);
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const ChatScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position:
                          Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: animation,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                      child: child,
                    );
                  },
              transitionDuration: const Duration(milliseconds: 400),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: NetworkImage(thread.avatarUrl),
                    backgroundColor: AppColors.border,
                  ),
                  if (thread.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 13,
                        height: 13,
                        decoration: BoxDecoration(
                          color: AppColors.activeGreen,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          thread.name,
                          size: 15,
                          weight: hasUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                        CustomText(
                          thread.time,
                          size: 12,
                          color: hasUnread
                              ? AppColors.primary
                              : AppColors.textMuted,
                          weight: hasUnread ? FontWeight.bold : FontWeight.w400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomText(
                            thread.lastMessage,
                            size: 13.5,
                            color: hasUnread
                                ? AppColors.textDark
                                : AppColors.textMuted,
                            weight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: CustomText(
                              thread.unreadCount.toString(),
                              size: 10,
                              color: AppColors.surface,
                              weight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
