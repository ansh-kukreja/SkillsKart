import 'package:flutter/material.dart';
import 'Theme/app_theme.dart';
import 'Screens/Onboarding/role_selection_screen.dart';

void main() {
  runApp(const SkillsKartWorkerApp());
}

class SkillsKartWorkerApp extends StatelessWidget {
  const SkillsKartWorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillsKart Worker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const RoleSelectionScreen(),
    );
  }
}
