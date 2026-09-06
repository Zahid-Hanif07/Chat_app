import 'package:chat_app/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/user/chat_screen/widget/chat_appbar.dart';
import 'package:chat_app/user/chat_screen/widget/chat_input_bar.dart';
import 'package:chat_app/user/chat_screen/widget/message_bubble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.read<ChatProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ChatAppbar(),

      body: Column(
        children: [
          Expanded(
            child: Selector<ChatProvider, List<MessageModel>>(
              selector: (_, provider) => provider.activeMessages,

              builder: (context, messages, _) {
                if (messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 48,
                          color: AppColors.border,
                        ),

                        const SizedBox(height: 12),

                        const CustomText(
                          'No messages here yet.',
                          size: 14,
                          color: AppColors.textMuted,
                          weight: FontWeight.w500,
                        ),

                        const SizedBox(height: 4),

                        CustomText(
                          'Say hi to start the conversation!',
                          size: 12,
                          color: AppColors.textMuted.withOpacity(0.8),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: chatProvider.scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: messages.length,

                  itemBuilder: (context, index) {
                    return MessageBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),

          const ChatInputBar(),
        ],
      ),
    );
  }
}
