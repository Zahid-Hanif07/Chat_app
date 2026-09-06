import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/providers/call_provider.dart';

class CallControls extends StatelessWidget {
  const CallControls({super.key});

  @override
  Widget build(BuildContext context) {
    final callProvider = context.watch<CallProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute Button
          _buildControlButton(
            icon: callProvider.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            isActive: callProvider.isMuted,
            onTap: callProvider.toggleMute,
          ),
          
          // Video Toggle Button
          _buildControlButton(
            icon: callProvider.isVideoOn ? Icons.videocam_rounded : Icons.videocam_off_rounded,
            isActive: !callProvider.isVideoOn,
            onTap: callProvider.toggleVideo,
          ),

          // Speaker Button
          _buildControlButton(
            icon: callProvider.isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_down_rounded,
            isActive: callProvider.isSpeakerOn,
            onTap: callProvider.toggleSpeaker,
          ),

          // End Call (Hang Up) Button
          GestureDetector(
            onTap: () {
              callProvider.endCall();
              Navigator.pop(context);
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: AppColors.activeRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.call_end_rounded,
                color: AppColors.surface,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface : AppColors.surface.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? AppColors.callingBg : AppColors.surface,
          size: 22,
        ),
      ),
    );
  }
}
