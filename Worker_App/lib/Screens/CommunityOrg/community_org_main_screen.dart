import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Models/community_event_model.dart';
import '../../Widgets/worker_app_bar.dart';
import '../../Widgets/worker_bottom_nav.dart';
import '../../Widgets/role_switch_sheet.dart';
import '../../Widgets/app_network_image.dart';

class CommunityOrgMainScreen extends StatefulWidget {
  const CommunityOrgMainScreen({super.key});

  @override
  State<CommunityOrgMainScreen> createState() => _CommunityOrgMainScreenState();
}

class _CommunityOrgMainScreenState extends State<CommunityOrgMainScreen> {
  int _currentTab = 0;
  late List<CommunityEvent> _events;
  late List<EventAttendee> _attendees;

  @override
  void initState() {
    super.initState();
    _events = List.from(initialCommunityEvents);
    _attendees = List.from(initialEventAttendees);
  }


  void _showPostEventDialog() {
    final titleController = TextEditingController();
    final venueController = TextEditingController(text: 'Community Hall, Civil Lines, Rajpura');
    final dateController = TextEditingController(text: 'Sunday, 22 Sept 2024');
    final timeController = TextEditingController(text: '9:00 AM - 3:00 PM');
    final targetController = TextEditingController(text: '75');
    final phoneController = TextEditingController(text: '+91 98765 43210');
    final descController = TextEditingController();
    String selectedCategory = 'Health & Blood';
    bool isBloodCamp = true;
    final List<String> bloodGroups = ['O+', 'O-', 'A+', 'B+', 'AB+'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.communityOrgLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.campaign_rounded,
                        color: AppColors.communityOrg,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post Community Event',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Health camps, blood donation drives & relief',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _buildField('Event Title', titleController, 'e.g. Free Cataract & Dental Camp'),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            items: ['Health & Blood', 'Free Medical Aid', 'Donation Drives', 'Skill Training']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.plusJakartaSans(fontSize: 12.5))))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setSheetState(() {
                                  selectedCategory = v;
                                  isBloodCamp = v == 'Health & Blood';
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField('Target Donors/Attendees', targetController, '60', isNumber: true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(child: _buildField('Date', dateController, 'Sunday, 22 Sept')),
                    const SizedBox(width: 10),
                    Expanded(child: _buildField('Timings', timeController, '9 AM - 4 PM')),
                  ],
                ),
                const SizedBox(height: 10),

                _buildField('Venue / Hall Address', venueController, 'Community Center, Civil Lines'),
                const SizedBox(height: 10),
                _buildField('Helpline / Contact Phone', phoneController, '+91 98765 43210'),
                const SizedBox(height: 10),
                _buildField('Camp Description & Instructions', descController, 'Free checkup with prescription glasses and certificates provided...', maxLines: 2),
                const SizedBox(height: 14),

                Row(
                  children: [
                    Checkbox(
                      value: isBloodCamp,
                      activeColor: const Color(0xFFC62828),
                      onChanged: (val) {
                        setSheetState(() => isBloodCamp = val ?? false);
                      },
                    ),
                    Text(
                      'This is an Emergency Blood Donation Drive',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.communityOrg,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim().isEmpty ? 'General Health Camp' : titleController.text.trim();
                    final venue = venueController.text.trim().isEmpty ? 'Rajpura Community Hall' : venueController.text.trim();
                    final date = dateController.text.trim().isEmpty ? 'This Weekend' : dateController.text.trim();
                    final time = timeController.text.trim().isEmpty ? '10 AM - 3 PM' : timeController.text.trim();
                    final target = int.tryParse(targetController.text) ?? 50;
                    final phone = phoneController.text.trim().isEmpty ? '+91 98123 45678' : phoneController.text.trim();
                    final desc = descController.text.trim().isEmpty ? 'Public community initiative for welfare.' : descController.text.trim();

                    setState(() {
                      _events.insert(
                        0,
                        CommunityEvent(
                          id: 'comm_${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          category: selectedCategory,
                          organization: 'Red Cross & SkillsKart Seva Mission',
                          location: venue,
                          date: date,
                          time: time,
                          description: desc,
                          tag: isBloodCamp ? 'Blood Donation' : 'Free Health Camp',
                          currentParticipants: 1,
                          targetParticipants: target,
                          contactPhone: phone,
                          isBloodCamp: isBloodCamp,
                          bloodGroupsNeeded: isBloodCamp ? bloodGroups : [],
                          imageUrl: isBloodCamp
                              ? 'assets/images/events/event_blood_camp.jpg'
                              : 'assets/images/events/event_health_camp.jpg',
                          status: 'Upcoming',
                        ),
                      );
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Event "$title" posted live to citizen app!'),
                        backgroundColor: AppColors.communityOrg,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Publish Community Event',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String placeholder, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textDark)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderWarm)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.borderWarm)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: const WorkerAppBar(
        currentRole: WorkerRole.communityOrg,
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.communityOrg,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_location_alt_rounded),
              label: Text('Post Event', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
              onPressed: _showPostEventDialog,
            )
          : null,
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildEventsDashboardTab(),
          _buildAttendeesRosterTab(),
          _buildOrgProfileTab(),
        ],
      ),
      bottomNavigationBar: WorkerBottomNav(
        currentIndex: _currentTab,
        activeColor: AppColors.communityOrg,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          WorkerNavItem(
            icon: Icons.event_note_outlined,
            activeIcon: Icons.event_note_rounded,
            label: 'Camps & Drives',
          ),
          WorkerNavItem(
            icon: Icons.how_to_reg_outlined,
            activeIcon: Icons.how_to_reg_rounded,
            label: 'Attendees',
          ),
          WorkerNavItem(
            icon: Icons.shield_outlined,
            activeIcon: Icons.shield_rounded,
            label: 'NGO Profile',
          ),
        ],
      ),
    );
  }

  // TAB 0: Community Org Dashboard
  Widget _buildEventsDashboardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2B1B12), AppColors.primaryTerracottaDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTerracotta.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Verified Social Impact Organizer',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.volunteer_activism_rounded, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Red Cross & SkillsKart Seva',
                  style: GoogleFonts.fraunces(
                    color: AppColors.primaryWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '12 Community Health Camps & Blood Drives Hosted',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4 Impact Counters
          Row(
            children: [
              Expanded(
                child: _buildCounter('Lives Impacted', '1,240+', Icons.favorite_rounded, const Color(0xFFE11D48), const Color(0xFFFFE4E6)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounter('Blood Units', '480 Pints', Icons.water_drop_rounded, const Color(0xFFC62828), const Color(0xFFFFEBEE)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildCounter('Free Checkups', '820 Seniors', Icons.medical_services_rounded, AppColors.forestGreen, AppColors.forestGreenLight),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCounter('Volunteers', '45 Registered', Icons.group_rounded, AppColors.primaryTerracotta, AppColors.creamBg),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Active & Upcoming Camps
          Text(
            'Active Camps & Initiatives (${_events.length})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          ..._events.map((event) => _buildEventCard(event)),
        ],
      ),
    );
  }

  Widget _buildCounter(String title, String value, IconData icon, Color color, Color bg) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted)),
              Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)), child: Icon(icon, size: 14, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textDark)),
        ],
      ),
    );
  }

  Widget _buildEventCard(CommunityEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Cover Dummy Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(
              imageUrl: event.imageUrl,
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
              fallbackIcon: event.isBloodCamp ? Icons.bloodtype_rounded : Icons.volunteer_activism_rounded,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: event.isBloodCamp ? const Color(0xFFFFEBEE) : AppColors.forestGreenLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.tag,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: event.isBloodCamp ? const Color(0xFFC62828) : AppColors.forestGreen,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: event.status == 'Live Today' ? const Color(0xFFDCFCE7) : AppColors.creamBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  event.status,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: event.status == 'Live Today' ? AppColors.forestGreen : AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            event.title,
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.primaryTerracotta),
              const SizedBox(width: 4),
              Text('${event.date} • ${event.time}', style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textBody)),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Expanded(child: Text(event.location, style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted))),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar of attendees
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Registrations Progress', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted)),
              Text(
                '${event.currentParticipants} / ${event.targetParticipants} joined',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.textDark),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: event.progress,
              backgroundColor: AppColors.surfaceWarm,
              valueColor: AlwaysStoppedAnimation(event.isBloodCamp ? const Color(0xFFC62828) : AppColors.primaryTerracotta),
              minHeight: 6,
            ),
          ),
          const Divider(height: 20, color: AppColors.borderLight),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Helpline: ${event.contactPhone}', style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
                onPressed: () => setState(() => _currentTab = 1),
                child: const Text('View Roster', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: Attendees Roster Tab
  Widget _buildAttendeesRosterTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Citizen Registrations (${_attendees.length})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Donor verification, attendance check-in, and certificate issuance',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          ..._attendees.map((att) => _buildAttendeeCard(att)),
        ],
      ),
    );
  }

  String _getAttendeeAvatar(String id) {
    switch (id) {
      case 'att_01':
        return 'assets/images/avatars/avatar_rajesh.jpg';
      case 'att_02':
        return 'assets/images/avatars/avatar_meena.jpg';
      case 'att_03':
        return 'assets/images/avatars/avatar_amit.jpg';
      case 'att_04':
        return 'assets/images/avatars/avatar_sunita.jpg';
      default:
        return 'assets/images/avatars/avatar_user.jpg';
    }
  }

  Widget _buildAttendeeCard(EventAttendee att) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AppNetworkImage(
                imageUrl: _getAttendeeAvatar(att.id),
                width: 46,
                height: 46,
                isCircle: true,
                fallbackIcon: Icons.person_rounded,
              ),
              if (att.bloodGroup != null)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC62828),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop_rounded, size: 10, color: Colors.white),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      att.name,
                      style: GoogleFonts.plusJakartaSans(fontSize: 14.5, fontWeight: FontWeight.w800, color: AppColors.textDark),
                    ),
                    if (att.bloodGroup != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC62828),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          att.bloodGroup!,
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                Text(
                  'Event: ${att.eventTitle}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.communityOrg, fontWeight: FontWeight.w600),
                ),
                Text(
                  '${att.role} • Registered ${att.registrationDate}',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.phone_rounded, color: AppColors.forestGreen, size: 18),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${att.name} (${att.phone})...')));
                      },
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: att.attended ? AppColors.forestGreen : AppColors.communityOrg,
                        side: BorderSide(color: att.attended ? AppColors.forestGreen : AppColors.borderWarm),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      icon: Icon(att.attended ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, size: 14),
                      label: Text(att.attended ? 'Checked In' : 'Mark Present', style: const TextStyle(fontSize: 11)),
                      onPressed: () {
                        setState(() => att.attended = !att.attended);
                      },
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

  // TAB 2: Organization Profile
  Widget _buildOrgProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryTerracotta, width: 2),
                  ),
                  child: const AppNetworkImage(
                    imageUrl: 'assets/images/banners/community_center_banner.jpg',
                    width: 88,
                    height: 88,
                    isCircle: true,
                    fallbackIcon: Icons.volunteer_activism_rounded,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Red Cross & SkillsKart Seva',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'Registered Non-Profit • Healthcare & Social Aid',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.communityOrgLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'NGO Darpan Reg: #PB-NGO-2024-819',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.communityOrg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Organization Credentials',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          _buildInfoItem(Icons.verified_rounded, '80G & 12A Tax Exemption', 'Tax exemption certificates verified by Income Tax Dept'),
          _buildInfoItem(Icons.health_and_safety_rounded, 'Blood Bank Affiliation', 'Partnered with Rajpura Civil Hospital Blood Bank'),
          _buildInfoItem(Icons.location_on_rounded, 'Secretariat Office', 'Red Cross Bhawan, Near District Court, Rajpura'),
          _buildInfoItem(Icons.contact_phone_rounded, 'Nodal Officer Hotline', '+91 98765 43210 (24x7 Emergency helpline)'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.notificationRed,
              side: const BorderSide(color: AppColors.notificationRed),
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              'Log Out of Community Org',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            onPressed: () => WorkerAppBar.performLogout(context, 'Community Org'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.communityOrgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.communityOrg, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.textDark),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
