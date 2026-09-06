import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';

import 'package:chat_app/core/providers/home_provider.dart';
import 'package:chat_app/user/home_screen/widget/home_search_bar.dart';
import 'package:chat_app/user/home_screen/widget/active_users_list.dart';
import 'package:chat_app/user/home_screen/widget/chat_list_item.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final homeProvider = context.watch<HomeProvider>();

    final query = homeProvider.searchQuery.toLowerCase();
    final filteredThreads = chatProvider.chatThreads.where((t) {
      return t.name.toLowerCase().contains(query) ||
          t.lastMessage.toLowerCase().contains(query);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top App Bar Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomText(
                'Chats',
                size: 26,
                weight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.edit_note_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Search Bar
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: HomeSearchBar(hintText: 'Search conversations...'),
        ),
        const SizedBox(height: 20),

        // Active Users horizontal list
        if (homeProvider.searchQuery.isEmpty) ...[
          const ActiveUsersList(),
          const SizedBox(height: 12),
        ],

        // Recent Chats Divider Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: CustomText(
            homeProvider.searchQuery.isNotEmpty
                ? 'Search Results'
                : 'Recent Messages',
            size: 15,
            weight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),

        // Chat Threads ListView
        Expanded(
          child: filteredThreads.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline_rounded,
                        size: 48,
                        color: AppColors.textMuted.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      CustomText(
                        'No conversations found',
                        size: 15,
                        color: AppColors.textMuted,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: filteredThreads.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.border,
                    thickness: 0.8,
                    height: 1,
                    indent: 84,
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    return ChatListItem(thread: filteredThreads[index]);
                  },
                ),
        ),
      ],
    );
  }
}
