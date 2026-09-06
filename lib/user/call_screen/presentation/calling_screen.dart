import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/core/providers/call_provider.dart';
import 'package:chat_app/user/call_screen/widget/calling_avatar.dart';
import 'package:chat_app/user/call_screen/widget/call_controls.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final callProvider = context.watch<CallProvider>();

    return Scaffold(
      backgroundColor: AppColors.callingBg,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            
            // Calling Avatar View
            CallingAvatar(avatarUrl: callProvider.callerAvatar),
            const SizedBox(height: 32),
            
            // Name
            CustomText(
              callProvider.callerName,
              size: 26,
              color: AppColors.surface,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            
            // Connection Status
            CustomText(
              callProvider.isCallConnected
                  ? callProvider.formattedDuration
                  : (callProvider.isIncoming
                      ? 'Incoming call...'
                      : 'Ringing...'),
              size: 16,
              color: AppColors.surface.withOpacity(0.8),
              weight: FontWeight.w500,
            ),
            
            const Spacer(flex: 3),
            
            // Controls overlay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: callProvider.isIncoming
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Decline Call Button
                        GestureDetector(
                          onTap: () {
                            callProvider.endCall();
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: AppColors.activeRed,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.call_end_rounded, color: AppColors.surface, size: 28),
                              ),
                              const SizedBox(height: 12),
                              const CustomText('Decline', size: 14, color: AppColors.surface, weight: FontWeight.w500),
                            ],
                          ),
                        ),
                        
                        // Accept Call Button
                        GestureDetector(
                          onTap: () {
                            callProvider.acceptCall();
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: AppColors.activeGreen,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.call_rounded, color: AppColors.surface, size: 28),
                              ),
                              const SizedBox(height: 12),
                              const CustomText('Accept', size: 14, color: AppColors.surface, weight: FontWeight.w500),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const CallControls(),
            ),
          ],
        ),
      ),
    );
  }
}
