import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Widgets/curved_app_bar.dart';
import 'community_post_model.dart';

class CommunityWorkScreen extends StatefulWidget {
  const CommunityWorkScreen({super.key});

  @override
  State<CommunityWorkScreen> createState() => _CommunityWorkScreenState();
}

class _CommunityWorkScreenState extends State<CommunityWorkScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Track user volunteer registrations by post ID
  final Set<String> _joinedPostIds = {};

  final List<String> _categories = const [
    'All',
    'Health & Blood',
    'Donation Drives',
    'Education & Skills',
    'Environment',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CommunityPost> get _filteredPosts {
    return dummyCommunityPosts.where((post) {
      final matchesCategory = _selectedCategory == 'All' ||
          post.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.organization.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          post.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  void _toggleJoin(CommunityPost post) {
    final hasJoined = _joinedPostIds.contains(post.id);
    setState(() {
      if (hasJoined) {
        _joinedPostIds.remove(post.id);
      } else {
        _joinedPostIds.add(post.id);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              hasJoined ? Icons.info_outline : Icons.volunteer_activism,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasJoined
                    ? 'Registration cancelled for "${post.title}"'
                    : 'Registered successfully for "${post.title}"! Organizer notified.',
                style: GoogleFonts.plusJakartaSans(color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor:
            hasJoined ? AppColors.primaryTerracottaDark : AppColors.forestGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final posts = _filteredPosts;

    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: const CurvedAppBar(showBrandHeader: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Community Services',
                        style: GoogleFonts.fraunces(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF883D0E),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Blood camps, health checkups & mutual aid drives',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                      Icons.volunteer_activism_rounded,
                      color: Color(0xFF883D0E),
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Emergency Blood Need Notice Banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFA39E)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        color: Color(0xFFC62828),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.bloodtype_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Blood Requirement',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: const Color(0xFFC62828),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Civil Hospital Blood Bank needs O+ & B+ units urgently.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: const Color(0xFF5C1D1D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC62828),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Urgent',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Search Bar
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
                        onChanged: (val) => setState(() => _searchQuery = val),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13.5,
                          color: AppColors.textDark,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: 'Search blood camps, medical aid, donation drives...',
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

              // Category Filter Pills
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;

                    return InkWell(
                      onTap: () => setState(() => _selectedCategory = cat),
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
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
                        child: Center(
                          child: Text(
                            cat,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textBody,
                            ),
                          ),
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
                    'Active Community Drives',
                    style: GoogleFonts.fraunces(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Showing ${posts.length} of ${dummyCommunityPosts.length}',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Community Posts List
              if (posts.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 48,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No community drives found',
                        style: GoogleFonts.fraunces(
                          fontSize: 17,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Try searching for another category or drive name',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final isJoined = _joinedPostIds.contains(post.id);
                    return _CommunityPostCard(
                      post: post,
                      isJoined: isJoined,
                      onToggleJoin: () => _toggleJoin(post),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommunityPostCard extends StatelessWidget {
  final CommunityPost post;
  final bool isJoined;
  final VoidCallback onToggleJoin;

  const _CommunityPostCard({
    required this.post,
    required this.isJoined,
    required this.onToggleJoin,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveParticipants =
        post.currentParticipants + (isJoined ? 1 : 0);
    final progress =
        (effectiveParticipants / post.targetParticipants).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderWarm,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional Header Image
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Stack(
                children: [
                  Image.asset(
                    post.imageUrl!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: post.tagColor.withValues(alpha: 0.12),
                      child: Center(
                        child: Icon(
                          post.categoryIcon,
                          size: 40,
                          color: post.tagColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: post.tagColor.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (post.isBloodCamp) ...[
                            const Icon(Icons.bloodtype,
                                color: Colors.white, size: 14),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            post.tag,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Tag (if no image)
                if (post.imageUrl == null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: post.tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      post.tag,
                      style: GoogleFonts.plusJakartaSans(
                        color: post.tagColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                // Post Title
                Text(
                  post.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),

                // Organizing body
                Row(
                  children: [
                    const Icon(
                      Icons.verified_rounded,
                      size: 14,
                      color: AppColors.forestGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        post.organization,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  post.description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textBody,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),

                // Blood groups needed badge chips (if blood donation camp)
                if (post.isBloodCamp && post.bloodGroupsNeeded.isNotEmpty) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Groups Needed: ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFC62828),
                        ),
                      ),
                      Wrap(
                        spacing: 6,
                        children: post.bloodGroupsNeeded.map((bg) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFFCDD2),
                              ),
                            ),
                            child: Text(
                              bg,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFC62828),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // Metadata: Location & Date
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF7F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: Color(0xFF883D0E),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${post.date} • ${post.time}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: Color(0xFF883D0E),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              post.location,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Participation / Volunteer Progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.isBloodCamp
                          ? '$effectiveParticipants Donors Registered'
                          : '$effectiveParticipants Volunteers Joined',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Goal: ${post.targetParticipants}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: const Color(0xFFECE4D8),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      post.isBloodCamp
                          ? const Color(0xFFC62828)
                          : AppColors.forestGreen,
                    ),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onToggleJoin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isJoined
                              ? const Color(0xFFEDF5E5)
                              : (post.isBloodCamp
                                  ? const Color(0xFFC62828)
                                  : const Color(0xFF883D0E)),
                          foregroundColor: isJoined
                              ? AppColors.forestGreen
                              : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: isJoined
                                ? const BorderSide(color: AppColors.forestGreen)
                                : BorderSide.none,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isJoined
                                  ? Icons.check_circle_rounded
                                  : (post.isBloodCamp
                                      ? Icons.bloodtype_rounded
                                      : Icons.volunteer_activism_rounded),
                              size: 16,
                              color: isJoined
                                  ? AppColors.forestGreen
                                  : Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isJoined
                                  ? 'Registered ✓'
                                  : (post.isBloodCamp
                                      ? 'Register as Donor'
                                      : 'Volunteer / Join'),
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: isJoined
                                    ? AppColors.forestGreen
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF7F2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderWarm),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.share_outlined,
                          size: 18,
                          color: Color(0xFF883D0E),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Share link for "${post.title}" copied to clipboard!',
                                style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white),
                              ),
                              backgroundColor: AppColors.primaryTerracottaDark,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}