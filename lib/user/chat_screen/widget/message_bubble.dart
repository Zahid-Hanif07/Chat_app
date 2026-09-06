import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/model/message_model.dart';

import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  // =========================================================
  // Format Time
  // =========================================================

  String _formatTimestamp(Timestamp timestamp) {
    final dt = timestamp.toDate();

    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);

    final minute = dt.minute.toString().padLeft(2, '0');

    final ampm = dt.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $ampm';
  }

  // =========================================================
  // Build
  // =========================================================

  @override
  Widget build(BuildContext context) {
    // READ = no rebuild when provider changes
    final currentUserId = context.read<ChatProvider>().currentUserId;

    final bool isOut = message.senderId == currentUserId;

    final String text = message.message;

    final String time = _formatTimestamp(message.timestamp);

    return Align(
      alignment: isOut ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),

        child: Column(
          crossAxisAlignment: isOut
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,

          children: [
            // =================================================
            // Message
            // =================================================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),

              decoration: BoxDecoration(
                color: isOut ? AppColors.primary : AppColors.surface,

                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),

                  bottomLeft: isOut ? const Radius.circular(16) : Radius.zero,

                  bottomRight: isOut ? Radius.zero : const Radius.circular(16),
                ),

                border: isOut
                    ? null
                    : Border.all(color: AppColors.border, width: 1),

                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: CustomText(
                text,
                size: 14.5,

                color: isOut ? AppColors.surface : AppColors.textDark,

                height: 1.3,
              ),
            ),

            const SizedBox(height: 4),

            // =================================================
            // Time + Seen
            // =================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),

              child: Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CustomText(time, size: 10, color: AppColors.textMuted),

                  if (isOut) ...[
                    const SizedBox(width: 4),

                    Icon(
                      message.isSeen
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      color: message.isSeen
                          ? AppColors.accent
                          : AppColors.textMuted,
                      size: 14,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
