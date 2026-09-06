import 'package:flutter/material.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const CustomText(
              'AuraChat',
              size: 20,
              weight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ],
        ),
        const SizedBox(height: 32),
        CustomText(
          title,
          size: 28,
          weight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        const SizedBox(height: 8),
        CustomText(
          subtitle,
          size: 15,
          color: AppColors.textMuted,
          weight: FontWeight.w400,
        ),
      ],
    );
  }
}
