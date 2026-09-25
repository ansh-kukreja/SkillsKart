import 'package:flutter/material.dart';
import '../Theme/app_theme.dart';

/// A robust, ultra-fast image widget that uses offline bundled assets
/// for 0ms instantaneous loading and zero network delay, with graceful fallback
/// to beautiful static logo/icon badges.
class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final IconData fallbackIcon;
  final bool isCircle;
  final Color? fallbackBgColor;
  final Color? fallbackIconColor;
  final bool useStaticIconOnly;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.image_rounded,
    this.isCircle = false,
    this.fallbackBgColor,
    this.fallbackIconColor,
    this.useStaticIconOnly = false,
  });

  /// Factory constructor for rendering an instant, beautiful static logo/icon badge
  const AppNetworkImage.staticIcon({
    super.key,
    required IconData icon,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
    this.fallbackBgColor,
    this.fallbackIconColor,
  })  : imageUrl = '',
        fallbackIcon = icon,
        fit = BoxFit.cover,
        useStaticIconOnly = true;

  /// Map of legacy Unsplash image IDs to fast, offline bundled assets.
  static const Map<String, String> _networkToOfflineAssetMap = {
    '1621905251189-08b45d6a269e': 'assets/images/roles/role_gig_worker.jpg',
    '1600121848594-d8644e57abab': 'assets/images/roles/role_product_seller.jpg',
    '1441986300917-64674bd600d8': 'assets/images/roles/role_business_owner.jpg',
    '1615461066841-6116e61058f4': 'assets/images/roles/role_community_org.jpg',
    '1581092160607-ee22621dd758': 'assets/images/gigs/gig_fan.jpg',
    '1558494949-ef010cbdcc31': 'assets/images/gigs/gig_solar.jpg',
    '1504307651254-35680f356dfd': 'assets/images/gigs/gig_ac_repair.jpg',
    '1617347454431-f49d7ff5c3b1': 'assets/images/jobs/job_driver.jpg',
    '1555396273-367ea4eb4db5': 'assets/images/jobs/job_cafe.jpg',
    '1584515979956-d9f6e5d09982': 'assets/images/events/event_health_camp.jpg',
    '1593113598332-cd288d649433': 'assets/images/events/event_blanket_drive.jpg',
    '1582562124811-c09040d0a901': 'assets/images/products/product_diya.jpg',
    '1544816155-12df9643f363': 'assets/images/products/product_stole.jpg',
    '1612196808214-b8e1d6145a8c': 'assets/images/products/product_cutlery.jpg',
    '1579656381226-5fc0f0100c3b': 'assets/images/products/product_craft.jpg',
    '1507003211169-0a1dd7228f2d': 'assets/images/avatars/avatar_rajesh.jpg',
    '1500648767791-00dcc994a43e': 'assets/images/avatars/avatar_amit.jpg',
    '1494790108377-be9c29b29330': 'assets/images/avatars/avatar_priya.jpg',
    '1544005313-94ddf0286df2': 'assets/images/avatars/avatar_sunita.jpg',
    '1506794778202-cad84cf45f1d': 'assets/images/avatars/avatar_rahul.jpg',
    '1472099645785-5658abf4ff4e': 'assets/images/avatars/avatar_vikram.jpg',
    '1534528741775-53994a69daeb': 'assets/images/avatars/avatar_meena.jpg',
    '1535713875002-d1d0cf377fde': 'assets/images/avatars/avatar_user.jpg',
  };

  String? _resolveOfflineAsset() {
    final trimmed = imageUrl.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('assets/')) return trimmed;
    for (final entry in _networkToOfflineAssetMap.entries) {
      if (trimmed.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: fallbackBgColor ?? AppColors.surfaceWarm,
        borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(12)),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(color: AppColors.borderWarm.withValues(alpha: 0.8)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fallbackBgColor ?? AppColors.surfaceWarm,
            AppColors.gigWorkerLight.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          fallbackIcon,
          size: ((width ?? height ?? 48) * 0.44).clamp(18.0, 36.0),
          color: fallbackIconColor ?? AppColors.primaryTerracotta,
        ),
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        borderRadius: isCircle ? null : (borderRadius ?? BorderRadius.circular(12)),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
      ),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primaryTerracotta.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (useStaticIconOnly || imageUrl.trim().isEmpty) {
      return _buildFallback(context);
    }

    // 1. Check if an offline local asset is available (0ms instant loading)
    final offlineAsset = _resolveOfflineAsset();
    Widget imageWidget;

    if (offlineAsset != null) {
      imageWidget = Image.asset(
        offlineAsset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    } else {
      // 2. Fallback to network image with progressive loading
      imageWidget = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoading(context);
        },
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      );
    }

    if (isCircle) {
      return ClipOval(child: imageWidget);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
