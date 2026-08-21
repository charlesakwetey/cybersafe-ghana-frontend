import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(const CyberSafeGhanaApp());
}

class CyberSafeGhanaApp extends StatelessWidget {
  const CyberSafeGhanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberSafe Ghana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.navy,
        scaffoldBackgroundColor: AppColors.cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.navy,
          primary: AppColors.navy,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}