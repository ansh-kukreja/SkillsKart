import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Models/user_role.dart';
import '../../Services/user_session.dart';

/// Modal bottom sheet for booking gig workers in bulk on a contract basis
class BulkContractBookingSheet extends StatefulWidget {
  final String tradeTitle;
  final int defaultBaseMonthlyRate;

  const BulkContractBookingSheet({
    super.key,
    required this.tradeTitle,
    this.defaultBaseMonthlyRate = 17500,
  });

  static Future<void> show(
    BuildContext context, {
    required String tradeTitle,
    int defaultBaseMonthlyRate = 17500,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => BulkContractBookingSheet(
        tradeTitle: tradeTitle,
        defaultBaseMonthlyRate: defaultBaseMonthlyRate,
      ),
    );
  }

  @override
  State<BulkContractBookingSheet> createState() =>
      _BulkContractBookingSheetState();
}

class _BulkContractBookingSheetState extends State<BulkContractBookingSheet> {
  int _workerCount = 10;
  int _durationMonths = 3;
  String _selectedShift = 'General Day Shift (8 hrs)';
  final TextEditingController _siteController =
      TextEditingController(text: 'Phase 8 Industrial Park, Mohali');
  final TextEditingController _notesController = TextEditingController();

  final List<int> _workerPresets = [5, 10, 20, 35, 50, 100];
  final List<Map<String, dynamic>> _durations = [
    {'label': '1 Month', 'months': 1},
    {'label': '3 Months', 'months': 3},
    {'label': '6 Months', 'months': 6},
    {'label': '12 Months', 'months': 12},
  ];

  final List<String> _shifts = [
    'General Day Shift (8 hrs)',
    'Night Shift (8 hrs)',
    'Rotational 24x7 Shift (3 Shifts)',
  ];

  @override
  void dispose() {
    _siteController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  int get _monthlyPerWorker => widget.defaultBaseMonthlyRate;

  int get _shiftMultiplier {
    if (_selectedShift.contains('24x7')) return 2;
    if (_selectedShift.contains('Night')) return 1;
    return 1;
  }

  int get _totalContractValue =>
      _workerCount * _monthlyPerWorker * _durationMonths * _shiftMultiplier;

  void _submitContractBooking() {
    final session = UserSession.instance;
    final requisitionId =
        'FED-CNT-${DateTime.now().year}-${1000 + (DateTime.now().millisecondsSinceEpoch % 9000)}';

    final newReq = EnterpriseRequisition(
      id: requisitionId,
      organizationName: session.orgName,
      gstinOrId: session.orgGstin,
      contactPerson: session.userName,
      contactPhone: session.userPhone,
      tradeTitle: widget.tradeTitle,
      workerCount: _workerCount,
      duration: '$_durationMonths Month${_durationMonths > 1 ? "s" : ""} Contract',
      durationMonths: _durationMonths,
      shift: _selectedShift,
      siteLocation: _siteController.text.trim().isNotEmpty
          ? _siteController.text.trim()
          : 'Corporate Site Location',
      slaTier: 'Priority Federation Enterprise SLA',
      totalEstimatedAmount: _totalContractValue,
      status: RequisitionStatus.matchmakerAssigned,
      createdAt: DateTime.now(),
      notes: _notesController.text.trim(),
    );

    session.addRequisition(newReq);
    Navigator.pop(context);

    _showBookingSuccessDialog(context, newReq);
  }

  void _showBookingSuccessDialog(
      BuildContext context, EnterpriseRequisition req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(22),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFDF4ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryTerracotta,
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Bulk Contract Confirmed!',
              style: GoogleFonts.fraunces(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Requisition Reference:',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderWarm),
              ),
              child: Text(
                req.id,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTerracotta,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${req.workerCount} ${req.tradeTitle} contracted for ${req.duration}.\nArtisan Federation Matchmaker has been assigned.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: AppColors.textBody,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Track in Enterprise Desk'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: SingleChildScrollView(
        child: Column(
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
            const SizedBox(height: 14),

            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: AppColors.primaryTerracotta,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Book Bulk Gig Workers',
                        style: GoogleFonts.fraunces(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Contract-based staffing for ${widget.tradeTitle}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.borderWarm),

            // Headcount Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Workers Required',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_workerCount Gig Workers',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTerracotta,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Presets
            Wrap(
              spacing: 8,
              children: _workerPresets.map((count) {
                final isSel = _workerCount == count;
                return ChoiceChip(
                  label: Text('$count Workers'),
                  selected: isSel,
                  selectedColor: AppColors.primaryTerracotta,
                  labelStyle: GoogleFonts.plusJakartaSans(
                    color: isSel ? Colors.white : AppColors.textDark,
                    fontSize: 11.5,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                  ),
                  onSelected: (val) {
                    if (val) setState(() => _workerCount = count);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Headcount Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: AppColors.primaryTerracotta,
                thumbColor: AppColors.primaryTerracottaDark,
                overlayColor: AppColors.primaryTerracotta.withValues(alpha: 0.15),
              ),
              child: Slider(
                value: _workerCount.toDouble(),
                min: 3,
                max: 100,
                divisions: 97,
                label: '$_workerCount workers',
                onChanged: (val) => setState(() => _workerCount = val.toInt()),
              ),
            ),
            const SizedBox(height: 16),

            // Contract Duration
            Text(
              'Contract Duration',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _durations.map((d) {
                final isSel = _durationMonths == d['months'];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3.0),
                    child: InkWell(
                      onTap: () =>
                          setState(() => _durationMonths = d['months'] as int),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primaryTerracotta : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel
                                ? AppColors.primaryTerracotta
                                : AppColors.borderWarm,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            d['label'] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              fontWeight:
                                  isSel ? FontWeight.bold : FontWeight.w500,
                              color: isSel ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Shift Configuration
            Text(
              'Shift / Deployment Mode',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderWarm),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedShift,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: _shifts.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(
                        s,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textDark,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedShift = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Site Address
            Text(
              'Work Site / Project Address',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _siteController,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on_outlined, size: 18),
                hintText: 'Enter factory, warehouse, or construction site',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: const Color(0xFFFAF7F2),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderWarm),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderWarm),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Federation Compliance Guarantee Callout
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EFEA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderWarm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security_rounded,
                    color: AppColors.primaryTerracotta,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Includes Federation Guild Supervisor, Verified IDs, ESI Assistance & Standard Wage Compliance.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textBody,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Live Budget Summary Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.borderWarm,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly Rate per Worker',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '₹$_monthlyPerWorker/mo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Monthly Staffing Total ($_workerCount workers)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      Text(
                        '₹${(_workerCount * _monthlyPerWorker).toString()}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.borderWarm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Total Contract Value',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryTerracotta,
                            ),
                          ),
                          Text(
                            'For $_durationMonths Month${_durationMonths > 1 ? "s" : ""}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹$_totalContractValue',
                        style: GoogleFonts.fraunces(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryTerracotta,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitContractBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.handshake_rounded, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Confirm Bulk Contract Booking',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
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
    );
  }
}

/// Modal bottom sheet to submit a formal service requisition to the Artisan Federation
class FederationRequisitionSheet extends StatefulWidget {
  final String? initialTrade;

  const FederationRequisitionSheet({
    super.key,
    this.initialTrade,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialTrade,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => FederationRequisitionSheet(
        initialTrade: initialTrade,
      ),
    );
  }

  @override
  State<FederationRequisitionSheet> createState() =>
      _FederationRequisitionSheetState();
}

class _FederationRequisitionSheetState
    extends State<FederationRequisitionSheet> {
  late String _trade;
  int _workerCount = 15;
  String _slaTier = 'Priority 24hr Federation SLA';
  int _durationMonths = 3;

  late TextEditingController _orgController;
  late TextEditingController _gstinController;
  late TextEditingController _contactController;
  late TextEditingController _phoneController;
  final TextEditingController _siteController =
      TextEditingController(text: 'Sector 62 Logistics Park, Rajpura');
  final TextEditingController _requirementsController = TextEditingController();

  final List<String> _trades = [
    'Carpenters & Woodcrafters',
    'Electricians',
    'Plumbers & Pipefitters',
    'Painters & Surface Finishers',
    'Cleaners & Facility Maintenance',
    'Security Personnel',
    'Masons & Clay Artisans',
    'Drivers & Material Transit',
  ];

  @override
  void initState() {
    super.initState();
    final session = UserSession.instance;
    _trade = widget.initialTrade ?? _trades.first;
    _orgController = TextEditingController(text: session.orgName);
    _gstinController = TextEditingController(text: session.orgGstin);
    _contactController = TextEditingController(text: session.userName);
    _phoneController = TextEditingController(text: session.userPhone);
  }

  @override
  void dispose() {
    _orgController.dispose();
    _gstinController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _siteController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  void _submitToFederation() {
    final session = UserSession.instance;
    final ticketId =
        'FED-BLKR-${DateTime.now().year}-${2000 + (DateTime.now().millisecondsSinceEpoch % 8000)}';

    final estAmount = _workerCount * 18000 * _durationMonths;

    final req = EnterpriseRequisition(
      id: ticketId,
      organizationName: _orgController.text.trim(),
      gstinOrId: _gstinController.text.trim(),
      contactPerson: _contactController.text.trim(),
      contactPhone: _phoneController.text.trim(),
      tradeTitle: _trade,
      workerCount: _workerCount,
      duration: '$_durationMonths Months Contract',
      durationMonths: _durationMonths,
      shift: 'Custom Enterprise Deployment',
      siteLocation: _siteController.text.trim(),
      slaTier: _slaTier,
      totalEstimatedAmount: estAmount,
      status: RequisitionStatus.submitted,
      createdAt: DateTime.now(),
      notes: _requirementsController.text.trim(),
    );

    session.addRequisition(req);
    Navigator.pop(context);

    _showFederationDispatchConfirmation(context, req);
  }

  void _showFederationDispatchConfirmation(
      BuildContext context, EnterpriseRequisition req) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(22),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                color: Color(0xFFFDF4ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.mark_email_read_rounded,
                color: AppColors.primaryTerracotta,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Requisition Dispatched to Federation!',
              style: GoogleFonts.fraunces(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Federation Requisition ID',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                color: AppColors.textMuted,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderWarm),
              ),
              child: Text(
                req.id,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTerracotta,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your bulk booking request for ${req.workerCount} ${req.tradeTitle} has been submitted to the District Guild Federation Council. Response SLA is guaranteed within ${_slaTier.contains("24hr") ? "24 hours" : "48 hours"}.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: AppColors.textBody,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('View All Requisitions'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.92,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            const SizedBox(height: 14),

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDF4ED),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.primaryTerracotta,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Federation Service Requisition',
                        style: GoogleFonts.fraunces(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Direct bulk booking request to Regional Artisan Council',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 24, color: AppColors.borderWarm),

            // Select Trade
            Text(
              'Required Trade / Skill Specialty',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderWarm),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _trades.contains(_trade) ? _trade : _trades.first,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: _trades.map((t) {
                    return DropdownMenuItem(
                      value: t,
                      child: Text(
                        t,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.textDark,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _trade = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Number of workers needed
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Headcount (Workers)',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton.filledTonal(
                            onPressed: _workerCount > 5
                                ? () => setState(() => _workerCount -= 5)
                                : null,
                            icon: const Icon(Icons.remove, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF0DFD1),
                              foregroundColor: AppColors.primaryTerracotta,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '$_workerCount Pros',
                                style: GoogleFonts.fraunces(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryTerracotta,
                                ),
                              ),
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: () =>
                                setState(() => _workerCount += 5),
                            icon: const Icon(Icons.add, size: 18),
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xFFF0DFD1),
                              foregroundColor: AppColors.primaryTerracotta,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF7F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderWarm),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _durationMonths,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                  value: 1, child: Text('1 Month')),
                              DropdownMenuItem(
                                  value: 3, child: Text('3 Months')),
                              DropdownMenuItem(
                                  value: 6, child: Text('6 Months')),
                              DropdownMenuItem(
                                  value: 12, child: Text('12 Months')),
                            ],
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _durationMonths = v);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // SLA Tier
            Text(
              'Federation Deployment SLA Tier',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSlaOption(
                    title: 'Priority 24hr',
                    sub: 'Emergency matching',
                    isSel: _slaTier.contains('24hr'),
                    onTap: () => setState(
                      () => _slaTier = 'Priority 24hr Federation SLA',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSlaOption(
                    title: 'Standard 48hr',
                    sub: 'Regular guild pool',
                    isSel: _slaTier.contains('48hr'),
                    onTap: () => setState(
                      () => _slaTier = 'Standard 48hr Federation SLA',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Organization & Contact Info
            Text(
              'Corporate Details & Project Location',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            _buildInput(
              controller: _orgController,
              label: 'Organization Name',
              icon: Icons.business_rounded,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInput(
                    controller: _gstinController,
                    label: 'GSTIN / Reg No.',
                    icon: Icons.pin_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildInput(
                    controller: _phoneController,
                    label: 'Contact Phone',
                    icon: Icons.phone_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInput(
              controller: _siteController,
              label: 'Work Site / Project Address',
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _requirementsController,
              maxLines: 2,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                color: AppColors.textDark,
              ),
              decoration: InputDecoration(
                hintText:
                    'Special skill requirements, toolkits, safety certifications...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: const Color(0xFFFAF7F2),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderWarm),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.borderWarm),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitToFederation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Submit Requisition to Federation',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5,
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
    );
  }

  Widget _buildSlaOption({
    required String title,
    required String sub,
    required bool isSel,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFFDF4ED) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSel ? AppColors.primaryTerracotta : AppColors.borderWarm,
            width: isSel ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSel ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 14,
                  color:
                      isSel ? AppColors.primaryTerracotta : AppColors.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSel
                        ? AppColors.primaryTerracotta
                        : AppColors.textDark,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 2),
              child: Text(
                sub,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12.5,
        color: AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 11.5,
          color: AppColors.textMuted,
        ),
        prefixIcon: Icon(icon, size: 17, color: AppColors.textMuted),
        filled: true,
        fillColor: const Color(0xFFFAF7F2),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderWarm),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderWarm),
        ),
      ),
    );
  }
}

/// Modal bottom sheet displaying active enterprise bulk contracts & requisitions
class EnterpriseRequisitionsSheet extends StatelessWidget {
  const EnterpriseRequisitionsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const EnterpriseRequisitionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: UserSession.instance,
      builder: (context, _) {
        final requisitions = UserSession.instance.requisitions;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enterprise Bulk Desk',
                        style: GoogleFonts.fraunces(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Active Contracts & Federation Requisitions (${requisitions.length})',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 20, color: AppColors.borderWarm),

              Expanded(
                child: requisitions.isEmpty
                    ? Center(
                        child: Text(
                          'No bulk contracts yet.\nTap "Request Federation" or "Book in Bulk" on any service.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: requisitions.length,
                        itemBuilder: (ctx, idx) {
                          final req = requisitions[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAF7F2),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.borderWarm),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      req.id,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTerracotta,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: req.status.color
                                            .withValues(alpha: 0.12),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        req.status.label,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: req.status.color,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${req.workerCount} × ${req.tradeTitle}',
                                  style: GoogleFonts.fraunces(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_rounded,
                                      size: 13,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      req.duration,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        color: AppColors.textBody,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.place_outlined,
                                      size: 13,
                                      color: AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        req.siteLocation,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      req.slaTier,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        color: AppColors.primaryTerracotta,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Est: ₹${req.totalEstimatedAmount}',
                                      style: GoogleFonts.fraunces(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTerracotta,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
