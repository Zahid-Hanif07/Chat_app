// import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:chat_app/core/theme/app_colors.dart';

// import 'package:google_fonts/google_fonts.dart';

// class ChatInputBar extends StatelessWidget {
//   const ChatInputBar({super.key});

//   void _showAttachmentSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(24),
//           decoration: const BoxDecoration(
//             color: AppColors.surface,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: AppColors.border,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildAttachmentOption(Icons.image_rounded, 'Gallery', Colors.purple),
//                   _buildAttachmentOption(Icons.description_rounded, 'Document', Colors.blue),
//                   _buildAttachmentOption(Icons.headphones_rounded, 'Audio', Colors.orange),
//                   _buildAttachmentOption(Icons.location_on_rounded, 'Location', Colors.green),
//                 ],
//               ),
//               const SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAttachmentOption(IconData icon, String label, Color color) {
//     return Column(
//       children: [
//         Container(
//           width: 56,
//           height: 56,
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.12),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(icon, color: color, size: 26),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: GoogleFonts.inter(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: AppColors.textDark,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatProvider = context.read<ChatProvider>();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         color: AppColors.surface,
//         border: Border(
//           top: BorderSide(color: AppColors.border, width: 1.2),
//         ),
//       ),
//       child: Row(
//         children: [
//           IconButton(
//             onPressed: () => _showAttachmentSheet(context),
//             icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 26),
//           ),
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: AppColors.background,
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(color: AppColors.border, width: 1.0),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: chatProvider.messageController,
//                       style: GoogleFonts.inter(fontSize: 14, color: AppColors.textDark),
//                       maxLines: null,
//                       decoration: InputDecoration(
//                         hintText: 'Type a message...',
//                         hintStyle: GoogleFonts.inter(
//                           fontSize: 14,
//                           color: AppColors.textMuted.withOpacity(0.6),
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.sentiment_satisfied_alt_rounded, color: AppColors.textMuted, size: 22),
//                     padding: EdgeInsets.zero,
//                     constraints: const BoxConstraints(),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           ValueListenableBuilder<TextEditingValue>(
//             valueListenable: chatProvider.messageController,
//             builder: (context, value, child) {
//               final isNotEmpty = value.text.trim().isNotEmpty;
//               return Container(
//                 width: 44,
//                 height: 44,
//                 decoration: const BoxDecoration(
//                   color: AppColors.primary,
//                   shape: BoxShape.circle,
//                 ),
//                 child: IconButton(
//                   onPressed: () {
//                     if (isNotEmpty) {
//                       chatProvider.sendMessage();
//                     } else {
//                       // Trigger audio note mock toast
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                           content: Text('Audio messaging is not supported in demo.'),
//                           duration: Duration(seconds: 1),
//                         ),
//                       );
//                     }
//                   },
//                   icon: Icon(
//                     isNotEmpty ? Icons.send_rounded : Icons.mic_none_rounded,
//                     color: AppColors.surface,
//                     size: 18,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({super.key});

  void _showAttachmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    Icons.image_rounded,
                    'Gallery',
                    Colors.purple,
                  ),
                  _buildAttachmentOption(
                    Icons.description_rounded,
                    'Document',
                    Colors.blue,
                  ),
                  _buildAttachmentOption(
                    Icons.headphones_rounded,
                    'Audio',
                    Colors.orange,
                  ),
                  _buildAttachmentOption(
                    Icons.location_on_rounded,
                    'Location',
                    Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1.2)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _showAttachmentSheet(context),
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              size: 26,
            ),
          ),

          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatProvider.messageController,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textDark,
                      ),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textMuted.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.sentiment_satisfied_alt_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 8),

          ValueListenableBuilder<TextEditingValue>(
            valueListenable: chatProvider.messageController,
            builder: (context, value, child) {
              final isNotEmpty = value.text.trim().isNotEmpty;

              return Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: chatProvider.isSending
                      ? null
                      : () async {
                          if (isNotEmpty) {
                            await chatProvider.sendMessage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Audio messaging is not supported yet.',
                                ),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                  icon: chatProvider.isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              AppColors.surface,
                            ),
                          ),
                        )
                      : Icon(
                          isNotEmpty
                              ? Icons.send_rounded
                              : Icons.mic_none_rounded,
                          color: AppColors.surface,
                          size: 18,
                        ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
