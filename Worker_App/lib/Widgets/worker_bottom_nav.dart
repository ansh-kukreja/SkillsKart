import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Theme/app_theme.dart';

class WorkerNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const WorkerNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class WorkerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<WorkerNavItem> items;
  final Color activeColor;

  const WorkerBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.activeColor = AppColors.primaryTerracotta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, -3),
            blurRadius: 10,
          ),
        ],
        border: const Border(
          top: BorderSide(color: AppColors.borderWarm, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final isSelected = index == currentIndex;
              final item = items[index];

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: activeColor.withValues(alpha: 0.08),
                  highlightColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Active indicator bar at top
                      if (isSelected)
                        Container(
                          width: 32,
                          height: 3,
                          decoration: BoxDecoration(
                            color: activeColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(3),
                              bottomRight: Radius.circular(3),
                            ),
                          ),
                        ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected
                                  ? (item.activeIcon ?? item.icon)
                                  : item.icon,
                              color: isSelected ? activeColor : AppColors.textMuted,
                              size: 23,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? activeColor : AppColors.textMuted,
                                fontSize: 10.5,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
