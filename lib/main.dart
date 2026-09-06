import 'package:chat_app/auth/provider/login_provider.dart';
import 'package:chat_app/auth/provider/signup_provider.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/user/chat_screen/provider/chat_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/providers/auth_provider.dart';
import 'package:chat_app/core/providers/home_provider.dart';

import 'package:chat_app/core/providers/call_provider.dart';
import 'package:chat_app/auth/presentation/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(
          create: (_) => ChatProvider()
            ..listenToChatThreads()
            ..initializeOnlineStaus(),
        ),
        ChangeNotifierProvider(create: (_) => CallProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraChat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.textDark),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.border,
          thickness: 0.8,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
