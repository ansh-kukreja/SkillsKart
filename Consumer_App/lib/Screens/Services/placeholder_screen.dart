import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Widgets/curved_app_bar.dart';
import '../../Services/user_session.dart';
import '../Enterprise/bulk_booking_sheet.dart';
import 'service_model.dart';

class PlaceholderScreen extends StatefulWidget {
  final String? title;
  final ServiceItem? service;

  const PlaceholderScreen({
    super.key,
    this.title,
    this.service,
  });

  @override
  State<PlaceholderScreen> createState() => _PlaceholderScreenState();
}

class _PlaceholderScreenState extends State<PlaceholderScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlot = 'Morning (9 AM - 12 PM)';

  final List<String> _slots = const [
    'Morning (9 AM - 12 PM)',
    'Afternoon (1 PM - 4 PM)',
    'Evening (4 PM - 7 PM)',
  ];

  void _showBookingSheet(String specialistName, String hourlyRate) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(
                    'Book $specialistName',
                    style: GoogleFonts.fraunces(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rate: $hourlyRate • Direct artisan payment on completion',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Select Appointment Date',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 30)),
                            );
                            if (picked != null) {
                              setSheetState(() => _selectedDate = picked);
                            }
                          },
                          icon: const Icon(Icons.calendar_today_rounded, size: 16),
                          label: Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF883D0E),
                            side: const BorderSide(color: AppColors.borderWarm),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select Convenient Time Slot',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _slots.map((slot) {
                      final isSel = _selectedSlot == slot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSel,
                        selectedColor: const Color(0xFF883D0E),
                        labelStyle: GoogleFonts.plusJakartaSans(
                          color: isSel ? Colors.white : AppColors.textDark,
                          fontSize: 12,
                          fontWeight:
                              isSel ? FontWeight.bold : FontWeight.w500,
                        ),
                        onSelected: (_) {
                          setSheetState(() => _selectedSlot = slot);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Appointment booked with $specialistName for ${_selectedDate.day}/${_selectedDate.month} ($_selectedSlot)!',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: AppColors.forestGreen,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF883D0E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Confirm Direct Booking',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service ??
        dummyServicesList.firstWhere(
          (s) => s.label == widget.title,
          orElse: () => dummyServicesList.first,
        );

    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        final isEnterprise = UserSession.instance.isEnterprise;

        return Scaffold(
          backgroundColor: AppColors.creamBg,
          appBar: CurvedAppBar(
            title: service.label,
            showBrandHeader: false,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Overview Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderWarm),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15)),
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                service.bgTint,
                                service.accentColor.withValues(alpha: 0.16),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -12,
                                bottom: -16,
                                child: Icon(
                                  service.icon,
                                  size: 115,
                                  color: service.accentColor
                                      .withValues(alpha: 0.08),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 58,
                                  height: 58,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: service.gradientColors,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: service.gradientColors.first
                                            .withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      service.icon,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: service.gradientColors,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: service.gradientColors.first
                                            .withValues(alpha: 0.35),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Icon(
                                      service.icon,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.label,
                                        style: GoogleFonts.fraunces(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star_rounded,
                                            size: 15,
                                            color: AppColors.amberStar,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            '${service.rating} (${service.reviewsCount} reviews)',
                                            style:
                                                GoogleFonts.plusJakartaSans(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.textDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isEnterprise
                                        ? const Color(0xFFEDF7ED)
                                        : const Color(0xFFEDF5E5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    isEnterprise
                                        ? '₹16,500/mo'
                                        : service.startingPrice,
                                    style: GoogleFonts.fraunces(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.forestGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              service.description,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textBody,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // ============================================================
                // ENTERPRISE EXCLUSIVE BULK BOOKING & FEDERATION REQUISITION
                // ============================================================
                if (isEnterprise) ...[
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF7F2),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.borderWarm,
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
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
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryTerracotta,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.groups_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Bulk Staffing & Contracts',
                                        style: GoogleFonts.fraunces(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF3E7DC),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'ENTERPRISE',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.primaryTerracotta,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Contract-based booking & direct Federation service requisition',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Action 1: Book gig workers in bulk (Contract-based)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderWarm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.handshake_rounded,
                                    color: AppColors.primaryTerracotta,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Book ${service.label} in Bulk',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Deploy 5 to 100+ contracted workers for 1-12 months. Includes transparent payroll calculation & shift selection.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.textBody,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      BulkContractBookingSheet.show(
                                    context,
                                    tradeTitle: service.label,
                                    defaultBaseMonthlyRate: 16500,
                                  ),
                                  icon: const Icon(Icons.calculate_outlined,
                                      size: 17),
                                  label: const Text(
                                    'Configure Bulk Contract (5-100+ Workers)',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTerracotta,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Action 2: Request service to the Federation
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.borderWarm),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_rounded,
                                    color: AppColors.primaryTerracotta,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Request Federation for Bulk Booking',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Send formal requisition ticket directly to District Artisan Council with Priority 24hr / Standard 48hr SLA.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.textBody,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 42,
                                child: OutlinedButton.icon(
                                  onPressed: () =>
                                      FederationRequisitionSheet.show(
                                    context,
                                    initialTrade: service.label,
                                  ),
                                  icon: const Icon(Icons.send_rounded, size: 16),
                                  label: const Text(
                                    'Send Service Requisition to Federation',
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.primaryTerracotta,
                                    side: const BorderSide(
                                      color: AppColors.primaryTerracotta,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textStyle: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Federation assurance tags
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _buildBenefitBadge('Guild Verified'),
                            _buildBenefitBadge('Supervisor Included'),
                            _buildBenefitBadge('Statutory Compliance'),
                            _buildBenefitBadge('Replacement SLA'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Common Tasks Checklist
                Text(
                  'Services & Tasks Covered',
                  style: GoogleFonts.fraunces(
                    fontSize: 17.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderWarm),
                  ),
                  child: Column(
                    children: service.commonTasks.map((task) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 18,
                              color: AppColors.forestGreen,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                task,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Verified Local Artisans Available
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        isEnterprise
                            ? 'Certified Craftsmen / Team Leads'
                            : 'Verified Local Craftsmen',
                        style: GoogleFonts.fraunces(
                          fontSize: 17.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEnterprise
                          ? 'Federation Certified'
                          : service.craftCount,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Specialist profiles list
                ...dummySpecialists.map((specialist) {
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
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1E6D8),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: AppColors.borderWarm),
                              ),
                              child: Center(
                                child: Text(
                                  specialist.name.substring(0, 1),
                                  style: GoogleFonts.fraunces(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF883D0E),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        specialist.name,
                                        style: GoogleFonts.fraunces(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textDark,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: AppColors.forestGreen,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '${specialist.experience} • ${specialist.jobsCompleted} Jobs Done',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.5,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  specialist.hourlyRate,
                                  style: GoogleFonts.fraunces(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF883D0E),
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 14,
                                      color: AppColors.amberStar,
                                    ),
                                    Text(
                                      specialist.rating.toStringAsFixed(1),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Calling ${specialist.name}... Direct connect initiated.',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: const Color(0xFF883D0E),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.phone_outlined, size: 16),
                                label: const Text('Call Direct'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF883D0E),
                                  side: const BorderSide(
                                    color: Color(0xFF883D0E),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _showBookingSheet(
                                  specialist.name,
                                  specialist.hourlyRate,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF883D0E),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Text(
                                  isEnterprise ? 'Book Specialist' : 'Book Visit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBenefitBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2EB),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 11, color: AppColors.primaryTerracotta),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryTerracotta,
            ),
          ),
        ],
      ),
    );
  }
}