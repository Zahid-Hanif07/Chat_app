import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/user/chat_screen/presentation/chat_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  Future<void> _openChat(BuildContext context, UserModel user) async {
    final chatProvider = context.read<ChatProvider>();

    await chatProvider.selectChat(user.uid);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreServices firestoreServices = FirestoreServices();
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              'New Chat',
              size: 18,
              weight: FontWeight.bold,
              color: AppColors.textDark,
            ),
            CustomText(
              'Select user to start messaging',
              size: 12,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // =================================================
          // SEARCH
          // =================================================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, _) {
                return Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: TextField(
                    controller: chatProvider.searchController,

                    onChanged: chatProvider.setSearchQuery,

                    decoration: InputDecoration(
                      hintText: 'Search by name or username...',

                      hintStyle: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),

                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textMuted,
                      ),

                      suffixIcon: chatProvider.searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 19),
                              onPressed: chatProvider.clearSearch,
                            )
                          : null,

                      border: InputBorder.none,

                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                );
              },
            ),
          ),

          // =================================================
          // USERS
          // =================================================
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: firestoreServices.getAllUsers(),

              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: CustomText(
                      'Failed to load users.',
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  );
                }

                final currentUserId = context
                    .read<ChatProvider>()
                    .currentUserId;

                final users = (snapshot.data ?? [])
                    .where((user) => user.uid != currentUserId)
                    .toList();

                return Consumer<ChatProvider>(
                  builder: (context, chatProvider, _) {
                    final query = chatProvider.searchQuery;

                    final filteredUsers = users.where((user) {
                      if (query.isEmpty) {
                        return true;
                      }

                      final cleanQuery = query.startsWith('@')
                          ? query.substring(1)
                          : query;

                      return user.name.toLowerCase().contains(query) ||
                          user.username.toLowerCase().contains(cleanQuery);
                    }).toList();

                    if (filteredUsers.isEmpty) {
                      return Center(
                        child: CustomText(
                          query.isEmpty
                              ? 'No other users found.'
                              : 'No users found.',
                          size: 14,
                          color: AppColors.textMuted,
                          weight: FontWeight.w500,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      itemCount: filteredUsers.length,

                      separatorBuilder: (_, __) => const Divider(
                        color: AppColors.border,
                        height: 1,
                        indent: 64,
                      ),

                      itemBuilder: (context, index) {
                        final user = filteredUsers[index];

                        final hasImage =
                            user.imageUrl != null && user.imageUrl!.isNotEmpty;

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),

                          onTap: () => _openChat(context, user),

                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 25,

                                backgroundImage: hasImage
                                    ? NetworkImage(user.imageUrl!)
                                    : null,

                                backgroundColor: AppColors.border,

                                child: !hasImage
                                    ? CustomText(
                                        user.name.isNotEmpty
                                            ? user.name[0].toUpperCase()
                                            : 'U',
                                        size: 18,
                                        weight: FontWeight.bold,
                                        color: AppColors.primary,
                                      )
                                    : null,
                              ),

                              if (user.isOnline)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
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

                          title: CustomText(
                            user.name,
                            size: 15,
                            weight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),

                          subtitle: CustomText(
                            '@${user.username}',
                            size: 12,
                            color: AppColors.primary,
                            weight: FontWeight.w600,
                          ),

                          trailing: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
