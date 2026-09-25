import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Widgets/curved_app_bar.dart';
import '../../Services/user_session.dart';
import '../Enterprise/bulk_booking_sheet.dart';
import 'service_model.dart';
import 'placeholder_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Wood & Clay', 'icon': Icons.carpenter_rounded},
    {'name': 'Home Repair', 'icon': Icons.build_rounded},
    {'name': 'Maintenance', 'icon': Icons.cleaning_services_rounded},
    {'name': 'Care & Assist', 'icon': Icons.volunteer_activism_rounded},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceItem> get _filteredServices {
    return dummyServicesList.where((service) {
      final matchesCategory = _selectedCategory == 'All' ||
          service.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          service.label.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.tag.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.commonTasks.any((t) =>
              t.toLowerCase().contains(_searchQuery.toLowerCase()));
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final services = _filteredServices;

    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        final isEnterprise = UserSession.instance.isEnterprise;

        return Scaffold(
          backgroundColor: AppColors.creamBg,
          appBar: const CurvedAppBar(showBrandHeader: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Screen Title & Icon Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Services',
                              style: GoogleFonts.fraunces(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF883D0E),
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isEnterprise
                                  ? 'Bulk staffing & federation service requisitions for enterprises'
                                  : 'Hire verified master craftsmen & tradespeople directly',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1E6D8),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.borderWarm,
                            width: 0.8,
                          ),
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          color: Color(0xFF883D0E),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Enterprise Portal Hero Banner (ONLY for Enterprise users)
                  if (isEnterprise) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8B3E0C),
                            Color(0xFFA95319),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryTerracotta
                                .withValues(alpha: 0.22),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'ENTERPRISE WORKFORCE DESK',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.verified_user_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Bulk Gig Staffing & Federation Requisitions',
                            style: GoogleFonts.fraunces(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Book teams of 5–100+ verified gig workers on contract or send a direct requisition to the Regional Artisan Federation Council.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.88),
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      FederationRequisitionSheet.show(context),
                                  icon: const Icon(Icons.send_rounded, size: 15),
                                  label: const Text('Request Federation'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTerracotta,
                                    foregroundColor: Colors.white,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      EnterpriseRequisitionsSheet.show(context),
                                  icon: const Icon(Icons.assignment_outlined,
                                      size: 15),
                                  label: Text(
                                    'Bulk Contracts (${UserSession.instance.requisitions.length})',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(
                                        color: Colors.white70),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else ...[
                    // Normal User Banner (Original)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.borderWarm,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEAF5DD),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.forestGreen,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Verified Specialists',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Zero agency fees',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: AppColors.forestGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Search Bar with Clear Button
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.borderWarm,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF8C7D71),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              color: AppColors.textDark,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: isEnterprise
                                  ? 'Search bulk trades: carpenters, electricians...'
                                  : 'Search electricians, plumbers, painters...',
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                color: const Color(0xFF9E8F83),
                              ),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            color: AppColors.textMuted,
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Category Pills Carousel
                  SizedBox(
                    height: 36,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final catName = cat['name'] as String;
                        final catIcon = cat['icon'] as IconData;
                        final isSelected = _selectedCategory == catName;

                        return InkWell(
                          onTap: () =>
                              setState(() => _selectedCategory = catName),
                          borderRadius: BorderRadius.circular(20),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryTerracotta
                                  : AppColors.primaryWhite,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primaryTerracotta
                                    : AppColors.borderWarm,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  catIcon,
                                  size: 14,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF883D0E),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  catName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textBody,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Section Count Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEnterprise
                            ? 'Available Bulk Trades'
                            : 'Available Services',
                        style: GoogleFonts.fraunces(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Showing ${services.length} of ${dummyServicesList.length}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Grid of Services or Empty State
                  if (services.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 52,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No matching services found',
                            style: GoogleFonts.fraunces(
                              fontSize: 18,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try searching for plumber, carpenter, painter or electrician',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedCategory = 'All';
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF883D0E),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            child: const Text('Show All Services'),
                          ),
                        ],
                      ),
                    )
                  else
                    GridView.builder(
                      itemCount: services.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.84,
                      ),
                      itemBuilder: (context, index) {
                        final service = services[index];
                        return _ServiceCard(
                          service: service,
                          isEnterprise: isEnterprise,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaceholderScreen(
                                  service: service,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceItem service;
  final bool isEnterprise;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.service,
    required this.isEnterprise,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderWarm,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Static Logo/Icon Banner with Overlaid Badges
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      service.bgTint,
                      service.accentColor.withValues(alpha: 0.14),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Subtle background watermark icon
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        service.icon,
                        size: 76,
                        color: service.accentColor.withValues(alpha: 0.10),
                      ),
                    ),

                    // Centered Gradient Icon Emblem
                    Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: service.gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: service.gradientColors.first
                                  .withValues(alpha: 0.30),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            service.icon,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ),

                    // Floating Top-Left: Tag Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isEnterprise
                              ? const Color(0xFFF9EDE5)
                              : service.accentColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEnterprise ? 'BULK CONTRACT' : service.tag,
                          style: GoogleFonts.plusJakartaSans(
                            color: isEnterprise
                                ? AppColors.primaryTerracotta
                                : service.accentColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // Floating Top-Right: Rating Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.amberStar,
                              size: 13,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              service.rating.toStringAsFixed(1),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Details section below image
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fraunces(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        isEnterprise ? 'Contract: ' : 'Starts at ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        isEnterprise
                            ? '₹16,500/mo'
                            : service.startingPrice,
                        style: GoogleFonts.fraunces(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF883D0E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isEnterprise ? 'Federation Pool' : service.craftCount,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10,
                        color: AppColors.primaryTerracotta,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}