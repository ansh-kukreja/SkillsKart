import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';
import '../Models/user_role.dart';
import '../Services/user_session.dart';
import '../Screens/Enterprise/bulk_booking_sheet.dart';

class CurvedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBrandHeader;
  final bool hasNotification;
  final List<Widget>? actions;

  const CurvedAppBar({
    super.key,
    this.title,
    this.showBrandHeader = true,
    this.hasNotification = true,
    this.actions,
  });

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Log Out',
            style: GoogleFonts.fraunces(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            'Do you want to logout?',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                UserSession.instance.logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTerracotta,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRoleOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return ListenableBuilder(
          listenable: UserSession.instance,
          builder: (ctx, _) {
            final session = UserSession.instance;
            final isEnt = session.isEnterprise;

            return Material(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderWarm,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.primaryTerracotta,
                        child: Icon(
                          isEnt
                              ? Icons.apartment_rounded
                              : Icons.person_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnt ? session.orgName : session.userName,
                              style: GoogleFonts.fraunces(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                            Text(
                              isEnt
                                  ? 'Enterprise Client Account'
                                  : 'Individual / Normal User Account',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.primaryTerracotta,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28, color: AppColors.borderWarm),

                  // Quick Switch Role Option
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: const Color(0xFFFAF7F2),
                    leading: Icon(
                      isEnt ? Icons.person_rounded : Icons.apartment_rounded,
                      color: AppColors.primaryTerracotta,
                    ),
                    title: Text(
                      isEnt
                          ? 'Switch to Normal User Mode'
                          : 'Switch to Enterprise Client Mode',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: AppColors.textDark,
                      ),
                    ),
                    subtitle: Text(
                      isEnt
                          ? 'Browse single-specialist visits & retail craft store'
                          : 'Unlock bulk gig contracts & federation booking',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      session.switchRole(
                          isEnt ? UserRole.normal : UserRole.enterprise);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isEnt
                                ? 'Switched to Normal User mode'
                                : 'Switched to Enterprise Client mode',
                            style: GoogleFonts.plusJakartaSans(
                                color: Colors.white),
                          ),
                          backgroundColor: AppColors.primaryTerracotta,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // If Enterprise, option to open Bulk Requisitions Desk
                  if (isEnt) ...[
                    ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: const Color(0xFFFAF7F2),
                      leading: const Icon(
                        Icons.assignment_turned_in_rounded,
                        color: AppColors.primaryTerracotta,
                      ),
                      title: Text(
                        'Enterprise Requisitions Desk',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppColors.textDark,
                        ),
                      ),
                      subtitle: Text(
                        'Track corporate requisitions and council matchmakers',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(ctx);
                        EnterpriseRequisitionsSheet.show(context);
                      },
                    ),
                    const SizedBox(height: 10),
                  ],

                  // Logout option
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: const Color(0xFFFFF1F0),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFC62828),
                    ),
                    title: Text(
                      'Log Out',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: const Color(0xFFC62828),
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(ctx);
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        final session = UserSession.instance;
        final isEnterprise = session.isEnterprise;

        return AppBar(
          backgroundColor: AppColors.primaryTerracotta,
          foregroundColor: AppColors.primaryWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          leadingWidth: canPop ? null : (showBrandHeader ? 46.0 : 0),
          leading: canPop
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : (showBrandHeader
                  ? Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Center(
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isEnterprise
                                ? Icons.apartment_rounded
                                : Icons.handyman_rounded,
                            color: AppColors.primaryWhite,
                            size: 19,
                          ),
                        ),
                      ),
                    )
                  : null),
          titleSpacing: canPop ? 0 : 8.0,
          title: showBrandHeader && !canPop
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        'SkillsKart',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryWhite,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    if (isEnterprise) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.35),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          'ENTERPRISE',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                )
              : Text(
                  title ?? 'SkillsKart',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.primaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          actions: actions ??
              [
                // Role Badge & Switcher Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: InkWell(
                    onTap: () => _showRoleOptions(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isEnterprise
                                ? Icons.apartment_rounded
                                : Icons.person_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isEnterprise ? 'Enterprise' : 'Normal',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Direct Logout Action Button
                IconButton(
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.primaryWhite,
                    size: 19,
                  ),
                  tooltip: 'Logout',
                  padding: const EdgeInsets.all(8),
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: () => _showLogoutDialog(context),
                ),

                if (hasNotification)
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(
                              minWidth: 36, minHeight: 36),
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primaryWhite,
                            size: 20,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isEnterprise
                                      ? '2 Federation updates: Contract FED-BLKR-2024-8841 matchmaker assigned.'
                                      : 'No new notifications from artisans',
                                  style: GoogleFonts.plusJakartaSans(),
                                ),
                                backgroundColor:
                                    AppColors.primaryTerracottaDark,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.notificationRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(width: 4),
              ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}