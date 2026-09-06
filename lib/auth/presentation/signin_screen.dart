import 'package:chat_app/auth/provider/login_provider.dart';
import 'package:chat_app/auth/provider/signup_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text.dart';
import 'package:chat_app/core/widgets/custom_textfield.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/auth/presentation/widget/auth_header.dart';
import 'package:chat_app/auth/presentation/widget/social_login_buttons.dart';
import 'package:chat_app/core/providers/auth_provider.dart';
import 'package:chat_app/user/home_screen/presentation/all_chat_screen.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final signinProvider = context.watch<LoginProvider>();
    final signupProvider = context.watch<SignupProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              AuthHeader(
                title: authProvider.isSignUp
                    ? 'Create Account'
                    : 'Welcome Back',
                subtitle: authProvider.isSignUp
                    ? 'Fill in your details below to set up your profile.'
                    : 'Log in to start messaging with your friends and groups.',
              ),
              const SizedBox(height: 36),
              if (authProvider.isSignUp) ...[
                CustomTextField(
                  controller: signupProvider.nameController,
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: signupProvider.usernameController,
                  labelText: 'Unique Username',
                  hintText: 'e.g. john_doe or @john_doe',
                  prefixIcon: const Icon(
                    Icons.alternate_email_rounded,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              CustomTextField(
                controller: authProvider.isSignUp
                    ? signupProvider.emailController
                    : signinProvider.emailController,
                labelText: 'Email Address',
                hintText: 'Enter your email address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: authProvider.isSignUp
                    ? signupProvider.passwordController
                    : signinProvider.passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                obscureText: true,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textMuted,
                ),
              ),
              if (authProvider.isSignUp) ...[
                const SizedBox(height: 20),
                CustomTextField(
                  controller: signupProvider.confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Re-enter your password',
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
              if (!authProvider.isSignUp) ...[
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: GestureDetector(
                      onTap: () {},
                      child: const CustomText(
                        'Forgot Password?',
                        size: 13,
                        color: AppColors.primary,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              CustomButton(
                text: authProvider.isSignUp ? 'Sign Up' : 'Sign In',
                isLoading: authProvider.isSignUp
                    ? signupProvider.isLoading
                    : signinProvider.isLoading,
                onPressed: () async {
                  bool success;
                  if (authProvider.isSignUp) {
                    success = await signupProvider.signUp();
                  } else {
                    success = await signinProvider.signIn();
                  }

                  if (success && context.mounted) {
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const AllChatScreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(1, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: animation,
                                        curve: Curves.easeOutCubic,
                                      ),
                                    ),
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                  } else {
                    final errorMessage = authProvider.isSignUp
                        ? signupProvider.errorMessage
                        : signinProvider.errorMessage;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: AppColors.activeRed,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 32),
              const SocialLoginButtons(),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    authProvider.isSignUp
                        ? 'Already have an account? '
                        : "Don't have an account? ",
                    size: 14,
                    color: AppColors.textMuted,
                  ),
                  GestureDetector(
                    onTap: () {
                      authProvider.toggleAuthMode();
                      signupProvider.clearForm();
                      signinProvider.clearForm();
                    },

                    child: CustomText(
                      authProvider.isSignUp ? 'Sign In' : 'Sign Up',
                      size: 14,
                      color: AppColors.primary,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
