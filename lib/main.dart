import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'utils/constants.dart';
import 'utils/theme_controller.dart';

void main() {
  runApp(const CyberSafeGhanaApp());
}

class CyberSafeGhanaApp extends StatelessWidget {
  const CyberSafeGhanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'CyberSafe Ghana',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: AppColors.navy,
            scaffoldBackgroundColor: AppColors.cream,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.navy,
              brightness: Brightness.light,
              primary: AppColors.navy,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: AppColors.navy,
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.navy,
              brightness: Brightness.dark,
              primary: AppColors.ghanaGold,
            ),
            useMaterial3: true,
          ),
          home: const LoginScreen(),
        );
      },
    );
  }
}