import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';

class ActiveUsersList extends StatelessWidget {
  const ActiveUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final onlineThreads = chatProvider.chatThreads
        .where((t) => t.isOnline)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomText(
            'Active Now',
            size: 15,
            weight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: onlineThreads.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // "Your Status" addition button
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.border,
                                width: 2,
                              ),
                              color: AppColors.surface,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const CustomText(
                        'My Status',
                        size: 12,
                        color: AppColors.textMuted,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                );
              }

              final thread = onlineThreads[index - 1];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: NetworkImage(thread.avatarUrl),
                          backgroundColor: AppColors.border,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
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
                    const SizedBox(height: 6),
                    CustomText(
                      thread.name.split(' ').first,
                      size: 12,
                      color: AppColors.textDark,
                      weight: FontWeight.w500,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
