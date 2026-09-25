import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';

enum WorkerRole {
  gigWorker,
  productSeller,
  businessOwner,
  communityOrg,
}

class RoleSwitchSheet extends StatelessWidget {
  final WorkerRole currentRole;
  final ValueChanged<WorkerRole> onRoleSelected;

  const RoleSwitchSheet({
    super.key,
    required this.currentRole,
    required this.onRoleSelected,
  });

  static void show(
    BuildContext context, {
    required WorkerRole currentRole,
    required ValueChanged<WorkerRole> onRoleSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => RoleSwitchSheet(
        currentRole: currentRole,
        onRoleSelected: (role) {
          Navigator.pop(ctx);
          onRoleSelected(role);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryTerracotta.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.swap_horiz_rounded,
                  color: AppColors.primaryTerracotta,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Switch Worker Persona',
                    style: GoogleFonts.fraunces(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Test interfaces for all 4 SkillsKart partner roles',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildRoleOption(
            context: context,
            role: WorkerRole.gigWorker,
            title: 'Gig Worker',
            subtitle: 'Verify skill • Get job leads',
            icon: Icons.handyman_rounded,
            primaryColor: AppColors.gigWorker,
            lightBg: AppColors.gigWorkerLight,
            isSelected: currentRole == WorkerRole.gigWorker,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: WorkerRole.productSeller,
            title: 'Product Seller',
            subtitle: 'List products • Price & photos',
            icon: Icons.storefront_rounded,
            primaryColor: AppColors.productSeller,
            lightBg: AppColors.productSellerLight,
            isSelected: currentRole == WorkerRole.productSeller,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: WorkerRole.businessOwner,
            title: 'Business Owner',
            subtitle: 'Post a job • Local job posting',
            icon: Icons.business_center_rounded,
            primaryColor: AppColors.businessOwner,
            lightBg: AppColors.businessOwnerLight,
            isSelected: currentRole == WorkerRole.businessOwner,
          ),
          const SizedBox(height: 10),
          _buildRoleOption(
            context: context,
            role: WorkerRole.communityOrg,
            title: 'Community Org.',
            subtitle: 'Post an event • Health camps, etc.',
            icon: Icons.volunteer_activism_rounded,
            primaryColor: AppColors.communityOrg,
            lightBg: AppColors.communityOrgLight,
            isSelected: currentRole == WorkerRole.communityOrg,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption({
    required BuildContext context,
    required WorkerRole role,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color primaryColor,
    required Color lightBg,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => onRoleSelected(role),
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: isSelected ? lightBg : AppColors.creamBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? primaryColor : AppColors.borderWarm,
            width: isSelected ? 1.8 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryWhite : primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: isSelected ? primaryColor : AppColors.textMuted,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.primaryWhite,
                  size: 14,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
