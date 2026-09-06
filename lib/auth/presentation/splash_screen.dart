import 'package:flutter/material.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/auth/presentation/widget/splash_logo.dart';
import 'package:chat_app/auth/presentation/signin_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _startTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SignInScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Trigger transition delay
    _startTimer(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary,
              AppColors.accent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            const SplashLogo(),
            const SizedBox(height: 24),
            const CustomText(
              'AuraChat',
              size: 32,
              color: AppColors.surface,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomText(
              'Connect instantly, seamlessly, securely',
              size: 14,
              color: AppColors.surface.withOpacity(0.8),
              weight: FontWeight.w400,
            ),
            const Spacer(flex: 2),
            CustomText(
              'v1.0.0',
              size: 12,
              color: AppColors.surface.withOpacity(0.5),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
