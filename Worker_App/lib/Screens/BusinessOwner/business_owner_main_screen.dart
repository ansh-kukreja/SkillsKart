import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Models/business_job_model.dart';
import '../../Widgets/worker_app_bar.dart';
import '../../Widgets/worker_bottom_nav.dart';
import '../../Widgets/role_switch_sheet.dart';
import '../../Widgets/app_network_image.dart';

class BusinessOwnerMainScreen extends StatefulWidget {
  const BusinessOwnerMainScreen({super.key});

  @override
  State<BusinessOwnerMainScreen> createState() => _BusinessOwnerMainScreenState();
}

class _BusinessOwnerMainScreenState extends State<BusinessOwnerMainScreen> {
  int _currentTab = 0;
  late List<PostedJob> _postedJobs;
  late List<JobApplicant> _applicants;

  @override
  void initState() {
    super.initState();
    _postedJobs = List.from(initialPostedJobs);
    _applicants = List.from(initialJobApplicants);
  }


  void _showPostJobDialog() {
    final titleController = TextEditingController();
    final salaryController = TextEditingController();
    final locationController = TextEditingController(text: 'Main Market, Rajpura');
    final vacanciesController = TextEditingController(text: '2');
    final descController = TextEditingController();
    final reqController = TextEditingController(text: 'Good communication, punctual, honest');
    String selectedCategory = 'Retail & Sales';
    String selectedJobType = 'Full-Time Job';

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
                        color: AppColors.businessOwnerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.post_add_rounded,
                        color: AppColors.businessOwner,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Post a Local Job',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Local job posting for nearby workers in Punjab',
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

                _buildField('Job Title', titleController, 'e.g. Store Helper, Billing Cashier, Salesman'),
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
                            items: ['Retail & Sales', 'Logistics', 'Hospitality', 'Office Help', 'Driver']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.plusJakartaSans(fontSize: 12.5))))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setSheetState(() => selectedCategory = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Job Type', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            initialValue: selectedJobType,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            items: ['Full-Time Job', 'Part-Time Job', 'Shift-Based']
                                .map((j) => DropdownMenuItem(value: j, child: Text(j, style: GoogleFonts.plusJakartaSans(fontSize: 12.5))))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setSheetState(() => selectedJobType = v);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildField('Monthly Salary', salaryController, 'e.g. ₹11,000 / month'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildField('Vacancies', vacanciesController, '2', isNumber: true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                _buildField('Work Location', locationController, 'e.g. Sector 2, Rajpura'),
                const SizedBox(height: 10),
                _buildField('Job Description', descController, 'Describe shift hours and main responsibilities...', maxLines: 2),
                const SizedBox(height: 10),
                _buildField('Requirements (comma separated)', reqController, '1 yr exp, valid license, 10th pass'),
                const SizedBox(height: 18),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.businessOwner,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim().isEmpty ? 'General Store Staff' : titleController.text.trim();
                    final salary = salaryController.text.trim().isEmpty ? '₹10,500 / month' : salaryController.text.trim();
                    final loc = locationController.text.trim().isEmpty ? 'Rajpura, Punjab' : locationController.text.trim();
                    final vac = int.tryParse(vacanciesController.text) ?? 1;
                    final desc = descController.text.trim().isEmpty ? 'Immediate hiring for store assistant.' : descController.text.trim();
                    final reqs = reqController.text.split(',').map((r) => r.trim()).where((r) => r.isNotEmpty).toList();

                    setState(() {
                      _postedJobs.insert(
                        0,
                        PostedJob(
                          id: 'job_${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          description: desc,
                          salary: salary,
                          jobType: selectedJobType,
                          location: loc,
                          postedDate: 'Today',
                          vacancies: vac,
                          isActive: true,
                          category: selectedCategory,
                          imageUrl: 'assets/images/jobs/job_retail.jpg',
                          requirements: reqs.isEmpty ? ['Immediate joiner preferred'] : reqs,
                          applicantCount: 0,
                        ),
                      );
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Job "$title" posted live to local job seekers!'),
                        backgroundColor: AppColors.businessOwner,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Publish Local Job Posting',
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
        currentRole: WorkerRole.businessOwner,
      ),
      floatingActionButton: _currentTab == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.businessOwner,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.post_add_rounded),
              label: Text('Post a Job', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700)),
              onPressed: _showPostJobDialog,
            )
          : null,
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildJobsDashboardTab(),
          _buildApplicantsPipelineTab(),
          _buildBusinessProfileTab(),
        ],
      ),
      bottomNavigationBar: WorkerBottomNav(
        currentIndex: _currentTab,
        activeColor: AppColors.businessOwner,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          WorkerNavItem(
            icon: Icons.work_outline_rounded,
            activeIcon: Icons.work_rounded,
            label: 'My Jobs',
          ),
          WorkerNavItem(
            icon: Icons.people_outline_rounded,
            activeIcon: Icons.people_rounded,
            label: 'Applicants',
          ),
          WorkerNavItem(
            icon: Icons.store_outlined,
            activeIcon: Icons.store_rounded,
            label: 'Business',
          ),
        ],
      ),
    );
  }

  // TAB 0: Business Owner Dashboard & Jobs
  Widget _buildJobsDashboardTab() {
    final totalApplicants = _applicants.length;
    final shortlisted = _applicants.where((a) => a.status == ApplicantStatus.shortlisted).length;
    final hired = _applicants.where((a) => a.status == ApplicantStatus.hired).length;

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
                colors: [AppColors.businessOwnerDark, AppColors.businessOwner],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.businessOwner.withValues(alpha: 0.25),
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
                        'Verified Local Employer',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Rajpura Retail Mart & Cafe',
                  style: GoogleFonts.fraunces(
                    color: AppColors.primaryWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Shop Act License #PB-RP-4412 • 3 Active Vacancies',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Hiring KPI stats
          Row(
            children: [
              Expanded(
                child: _buildTile('Active Postings', '${_postedJobs.length} jobs', Icons.business_center_rounded, AppColors.businessOwner, AppColors.businessOwnerLight),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTile('Applications', '$totalApplicants candidates', Icons.badge_outlined, const Color(0xFF2563EB), const Color(0xFFEFF6FF)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildTile('Shortlisted', '$shortlisted ready for call', Icons.star_border_rounded, AppColors.amberStar, const Color(0xFFFFFBEB)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildTile('Hired', '$hired joined team', Icons.how_to_reg_rounded, AppColors.forestGreen, AppColors.forestGreenLight),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const SizedBox(height: 16),

          // Job Listings Header
          Text(
            'Your Job Listings',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          ..._postedJobs.map((job) => _buildJobCard(job)),
        ],
      ),
    );
  }

  Widget _buildTile(String title, String value, IconData icon, Color color, Color bg) {
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

  Widget _buildJobCard(PostedJob job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.businessOwnerLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  job.jobType,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.businessOwner),
                ),
              ),
              Row(
                children: [
                  Text(
                    job.isActive ? 'Accepting' : 'Paused',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: job.isActive ? AppColors.forestGreen : AppColors.textMuted,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch(
                      value: job.isActive,
                      activeThumbColor: AppColors.forestGreen,
                      onChanged: (val) {
                        setState(() => job.isActive = val);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dummy Image for Job Work Environment
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AppNetworkImage(
                  imageUrl: job.imageUrl,
                  width: 74,
                  height: 74,
                  fit: BoxFit.cover,
                  fallbackIcon: Icons.storefront_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee_rounded, size: 14, color: AppColors.forestGreen),
                        Text(
                          job.salary,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.forestGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMuted),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            job.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            job.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textBody),
          ),
          const Divider(height: 20, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${job.applicantCount} Total Applicants',
                style: GoogleFonts.plusJakartaSans(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.businessOwner),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.businessOwner,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
                onPressed: () => setState(() => _currentTab = 1),
                child: const Text('View Candidates', style: TextStyle(fontSize: 11.5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 1: Applicants Pipeline Tab
  Widget _buildApplicantsPipelineTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Candidate Applications (${_applicants.length})',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Review verified profiles, call applicants, and manage hiring pipeline',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          ..._applicants.map((applicant) => _buildApplicantCard(applicant)),
        ],
      ),
    );
  }

  String _getApplicantAvatar(String id) {
    switch (id) {
      case 'app_101':
        return 'assets/images/avatars/avatar_amit.jpg';
      case 'app_102':
        return 'assets/images/avatars/avatar_rahul.jpg';
      case 'app_103':
        return 'assets/images/avatars/avatar_priya.jpg';
      case 'app_104':
        return 'assets/images/avatars/avatar_vikram.jpg';
      default:
        return 'assets/images/avatars/avatar_user.jpg';
    }
  }

  Widget _buildApplicantCard(JobApplicant app) {
    Color badgeColor;
    Color badgeBg;
    String badgeText;

    switch (app.status) {
      case ApplicantStatus.applied:
        badgeColor = const Color(0xFF2563EB);
        badgeBg = const Color(0xFFEFF6FF);
        badgeText = 'New Application';
        break;
      case ApplicantStatus.shortlisted:
        badgeColor = AppColors.amberStar;
        badgeBg = const Color(0xFFFEF3C7);
        badgeText = 'Shortlisted';
        break;
      case ApplicantStatus.hired:
        badgeColor = AppColors.forestGreen;
        badgeBg = AppColors.forestGreenLight;
        badgeText = 'Hired & Joined';
        break;
      case ApplicantStatus.rejected:
        badgeColor = AppColors.notificationRed;
        badgeBg = const Color(0xFFFEE2E2);
        badgeText = 'Archived';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                app.appliedJobTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.businessOwner,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              AppNetworkImage(
                imageUrl: _getApplicantAvatar(app.id),
                width: 44,
                height: 44,
                isCircle: true,
                fallbackIcon: Icons.person_rounded,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      '${app.experience} • ${app.education}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone_rounded, color: AppColors.forestGreen),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling ${app.name} (${app.phone})...'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: app.skills.map((s) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.creamBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.borderWarm),
                ),
                child: Text(
                  s,
                  style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textBody),
                ),
              );
            }).toList(),
          ),
          const Divider(height: 18, color: AppColors.borderLight),
          Row(
            children: [
              Text(
                app.appliedDate,
                style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textMuted),
              ),
              const Spacer(),
              if (app.status == ApplicantStatus.applied) ...[
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.businessOwner,
                    side: const BorderSide(color: AppColors.businessOwner),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                  onPressed: () {
                    setState(() => app.status = ApplicantStatus.shortlisted);
                  },
                  child: const Text('Shortlist', style: TextStyle(fontSize: 11)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  ),
                  onPressed: () {
                    setState(() => app.status = ApplicantStatus.hired);
                  },
                  child: const Text('Hire', style: TextStyle(fontSize: 11)),
                ),
              ] else if (app.status == ApplicantStatus.shortlisted) ...[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  ),
                  onPressed: () {
                    setState(() => app.status = ApplicantStatus.hired);
                  },
                  child: const Text('Confirm Hire', style: TextStyle(fontSize: 11)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // TAB 2: Business Profile
  Widget _buildBusinessProfileTab() {
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
                    imageUrl: 'assets/images/banners/storefront_banner.jpg',
                    width: 88,
                    height: 88,
                    isCircle: true,
                    fallbackIcon: Icons.business_rounded,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Rajpura Retail Mart & Pizzeria',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'Retail & Quick Service Restaurant Group',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.businessOwnerLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Punjab Labor & Shop Act Reg: #PB-ACT-8819',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.businessOwner,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Company Information',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          _buildInfoTile(Icons.location_on_rounded, 'Business Address', 'Shop #12-14, Liberty Square, Main Market, Rajpura'),
          _buildInfoTile(Icons.phone_rounded, 'Recruitment Helpline', '+91 98144 99001 (Mon - Sat, 9 AM - 7 PM)'),
          _buildInfoTile(Icons.badge_rounded, 'GST Number', '03AAACR8821N1ZM (Verified)'),
          _buildInfoTile(Icons.verified_user_rounded, 'Employer Trust Score', '96% (Timely salary disbursement badge)'),
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
              'Log Out of Business Owner',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            onPressed: () => WorkerAppBar.performLogout(context, 'Business Owner'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
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
              color: AppColors.businessOwnerLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.businessOwner, size: 20),
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
