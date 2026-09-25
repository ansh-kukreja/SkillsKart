import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Widgets/role_switch_sheet.dart';
import '../../Widgets/app_network_image.dart';
import '../GigWorker/gig_worker_main_screen.dart';
import '../ProductSeller/product_seller_main_screen.dart';
import '../BusinessOwner/business_owner_main_screen.dart';
import '../CommunityOrg/community_org_main_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _loginAsRole(BuildContext context, WorkerRole role) {
    Widget targetScreen;
    switch (role) {
      case WorkerRole.gigWorker:
        targetScreen = const GigWorkerMainScreen();
        break;
      case WorkerRole.productSeller:
        targetScreen = const ProductSellerMainScreen();
        break;
      case WorkerRole.businessOwner:
        targetScreen = const BusinessOwnerMainScreen();
        break;
      case WorkerRole.communityOrg:
        targetScreen = const CommunityOrgMainScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Brand Logo & Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTerracotta,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTerracotta.withValues(alpha: 0.28),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.engineering_rounded,
                        color: AppColors.primaryWhite,
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'SkillsKart',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fraunces(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'PARTNER PORTAL',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryTerracotta,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Prompt
                  Text(
                    'Select your role',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose your partner workspace to continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 4 Harmonized Role Cards with Dummy Images
                  _buildUnifiedRoleCard(
                    context: context,
                    title: 'Gig Worker',
                    subtitle: 'Verify skills & receive local service bookings',
                    imageUrl: 'assets/images/roles/role_gig_worker.jpg',
                    fallbackIcon: Icons.handyman_rounded,
                    onTap: () => _loginAsRole(context, WorkerRole.gigWorker),
                  ),
                  const SizedBox(height: 12),

                  _buildUnifiedRoleCard(
                    context: context,
                    title: 'Product Seller',
                    subtitle: 'List artisan handicrafts & manage customer orders',
                    imageUrl: 'assets/images/roles/role_product_seller.jpg',
                    fallbackIcon: Icons.storefront_rounded,
                    onTap: () => _loginAsRole(context, WorkerRole.productSeller),
                  ),
                  const SizedBox(height: 12),

                  _buildUnifiedRoleCard(
                    context: context,
                    title: 'Business Owner',
                    subtitle: 'Post local jobs & hire qualified workers',
                    imageUrl: 'assets/images/roles/role_business_owner.jpg',
                    fallbackIcon: Icons.business_center_rounded,
                    onTap: () => _loginAsRole(context, WorkerRole.businessOwner),
                  ),
                  const SizedBox(height: 12),

                  _buildUnifiedRoleCard(
                    context: context,
                    title: 'Community Org',
                    subtitle: 'Organize blood camps & community welfare drives',
                    imageUrl: 'assets/images/roles/role_community_org.jpg',
                    fallbackIcon: Icons.volunteer_activism_rounded,
                    onTap: () => _loginAsRole(context, WorkerRole.communityOrg),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedRoleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String imageUrl,
    required IconData fallbackIcon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Dummy visual image thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AppNetworkImage(
                    imageUrl: imageUrl,
                    width: 52,
                    height: 52,
                    fit: BoxFit.cover,
                    fallbackIcon: fallbackIcon,
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
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWarm,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.primaryTerracotta,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
