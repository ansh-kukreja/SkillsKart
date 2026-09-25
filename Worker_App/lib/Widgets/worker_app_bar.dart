import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';
import 'role_switch_sheet.dart';
import '../Screens/Onboarding/role_selection_screen.dart';

class WorkerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final WorkerRole currentRole;
  final List<Widget>? actions;

  const WorkerAppBar({
    super.key,
    this.title,
    required this.currentRole,
    this.actions,
  });

  String get _roleLabel {
    switch (currentRole) {
      case WorkerRole.gigWorker:
        return 'Gig Worker';
      case WorkerRole.productSeller:
        return 'Product Seller';
      case WorkerRole.businessOwner:
        return 'Business Owner';
      case WorkerRole.communityOrg:
        return 'Community Org';
    }
  }

  Color get _roleColor {
    switch (currentRole) {
      case WorkerRole.gigWorker:
        return AppColors.gigWorker;
      case WorkerRole.productSeller:
        return AppColors.productSeller;
      case WorkerRole.businessOwner:
        return AppColors.businessOwner;
      case WorkerRole.communityOrg:
        return AppColors.communityOrg;
    }
  }

  IconData get _roleIcon {
    switch (currentRole) {
      case WorkerRole.gigWorker:
        return Icons.handyman_rounded;
      case WorkerRole.productSeller:
        return Icons.storefront_rounded;
      case WorkerRole.businessOwner:
        return Icons.business_center_rounded;
      case WorkerRole.communityOrg:
        return Icons.volunteer_activism_rounded;
    }
  }

  static void performLogout(BuildContext context, String roleName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.primaryWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          'Log out of $roleName?',
          style: GoogleFonts.fraunces(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          'You will be returned to the role selection login screen.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: AppColors.textBody,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.notificationRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
                (route) => false,
              );
            },
            child: Text(
              'Log Out',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return AppBar(
      backgroundColor: AppColors.primaryTerracotta,
      foregroundColor: AppColors.primaryWhite,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      leading: canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.engineering_rounded,
                    color: AppColors.primaryWhite,
                    size: 20,
                  ),
                ),
              ),
            ),
      titleSpacing: canPop ? 0 : 12,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'SkillsKart',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.primaryWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'PARTNER',
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryWhite,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          if (title != null)
            Text(
              title!,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      actions: actions ??
          [
            // Read-only role chip
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_roleIcon, size: 14, color: _roleColor),
                    const SizedBox(width: 5),
                    Text(
                      _roleLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: _roleColor,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Logout Action button
            IconButton(
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.primaryWhite,
                size: 20,
              ),
              tooltip: 'Log Out',
              onPressed: () => performLogout(context, _roleLabel),
            ),
            const SizedBox(width: 6),
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
