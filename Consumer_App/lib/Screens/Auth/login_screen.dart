import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Models/user_role.dart';
import '../../Services/user_session.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.normal;

  void _handleSignIn() {
    if (_selectedRole == UserRole.normal) {
      UserSession.instance.login(
        UserRole.normal,
        name: 'Aarav Sharma',
        phone: '+91 98765 43210',
      );
    } else {
      UserSession.instance.login(
        UserRole.enterprise,
        name: 'Vikram Mehrotra',
        orgName: 'Apex Buildcon & Crafts Corp',
        orgGstin: '03AAACA1234E1Z5',
        phone: '+91 98765 11223',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App Brand Logo
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.primaryTerracotta,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTerracotta
                                .withValues(alpha: 0.28),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.handyman_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Brand Title
                  Center(
                    child: Text(
                      'SkillsKart',
                      style: GoogleFonts.fraunces(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryTerracotta,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Subtitle
                  Center(
                    child: Text(
                      'Select your account type to proceed',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Header label
                  Text(
                    'CHOOSE USER TYPE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Two Role Selector Cards
                  Row(
                    children: [
                      // Normal User Card
                      Expanded(
                        child: _buildRoleCard(
                          role: UserRole.normal,
                          title: 'Normal User',
                          subtitle: 'Individual / Home',
                          icon: Icons.person_rounded,
                          badgeText: 'Standard',
                          isSelected: _selectedRole == UserRole.normal,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Enterprise User Card
                      Expanded(
                        child: _buildRoleCard(
                          role: UserRole.enterprise,
                          title: 'Enterprise',
                          subtitle: 'Corporate / Org',
                          icon: Icons.apartment_rounded,
                          badgeText: 'Bulk Staffing',
                          isSelected: _selectedRole == UserRole.enterprise,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // SignIn Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _handleSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTerracotta,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'SignIn',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required String badgeText,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        setState(() => _selectedRole = role);
      },
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF6F0E8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryTerracotta
                : const Color(0xFFEADFD4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryTerracotta.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFBF4ED)
                        : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected
                        ? AppColors.primaryTerracotta
                        : AppColors.textMuted,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFF3E7DC)
                          : const Color(0xFFEBE3D8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.primaryTerracotta
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.fraunces(
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? AppColors.primaryTerracotta
                    : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
