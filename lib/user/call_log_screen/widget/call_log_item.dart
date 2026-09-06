import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/core/providers/call_provider.dart';
import 'package:chat_app/user/call_screen/presentation/calling_screen.dart';

class CallLogItem extends StatelessWidget {
  final CallLog log;

  const CallLogItem({
    super.key,
    required this.log,
  });

  void _makeCall(BuildContext context) {
    final callProvider = context.read<CallProvider>();
    callProvider.startCall(log.name, log.avatarUrl, isIncoming: false, isVideo: log.isVideo);
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const CallingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    IconData logIcon;
    Color iconColor;

    if (log.isMissed) {
      logIcon = Icons.call_missed_rounded;
      iconColor = AppColors.activeRed;
    } else if (log.isIncoming) {
      logIcon = Icons.call_received_rounded;
      iconColor = AppColors.activeGreen;
    } else {
      logIcon = Icons.call_made_rounded;
      iconColor = AppColors.accent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(log.avatarUrl),
            backgroundColor: AppColors.border,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  log.name,
                  size: 15,
                  weight: FontWeight.bold,
                  color: log.isMissed ? AppColors.activeRed : AppColors.textDark,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(logIcon, color: iconColor, size: 16),
                    const SizedBox(width: 6),
                    CustomText(
                      '${log.isVideo ? "Video" : "Voice"} • ${log.time}',
                      size: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _makeCall(context),
            icon: Icon(
              log.isVideo ? Icons.videocam_rounded : Icons.phone_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
