import 'package:flutter/material.dart';
import 'Theme/app_theme.dart';
import 'Widgets/floating_nav_bar.dart';
import 'Screens/Services/services_screen.dart';
import 'Screens/Jobs/jobs_screen.dart';
import 'Screens/ProductStore/product_store_screen.dart';
import 'Screens/CommunityWork/community_work_screen.dart';
import 'Screens/Auth/login_screen.dart';
import 'Models/user_role.dart';
import 'Services/user_session.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final UserRole? initialRole;

  const MyApp({super.key, this.initialRole});

  @override
  Widget build(BuildContext context) {
    if (initialRole != null && !UserSession.instance.isLoggedIn) {
      UserSession.instance.login(initialRole!);
    }

    return MaterialApp(
      title: 'SkillsKart',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: UserSession.instance,
        builder: (context, _) {
          if (!UserSession.instance.isLoggedIn) {
            return const LoginScreen();
          }
          return const MainNavigation();
        },
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Default to Services (index 0) matching user requirement
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ServicesScreen(),
    JobsScreen(),
    ProductStoreScreen(),
    CommunityWorkScreen(),
  ];

  final List<NavItem> _navItems = const [
    NavItem(
      icon: Icons.business_center_outlined,
      activeIcon: Icons.business_center_rounded,
      label: 'Services',
    ),
    NavItem(
      icon: Icons.work_outline_rounded,
      activeIcon: Icons.work_rounded,
      label: 'Jobs',
    ),
    NavItem(
      icon: Icons.store_mall_directory_outlined,
      activeIcon: Icons.store_mall_directory_rounded,
      label: 'Craft Store',
    ),
    NavItem(
      icon: Icons.volunteer_activism_outlined,
      activeIcon: Icons.volunteer_activism_rounded,
      label: 'Community Services',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: FloatingNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}