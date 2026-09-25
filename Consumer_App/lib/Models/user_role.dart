import 'package:flutter/material.dart';

/// Supported user types for SkillsKart
enum UserRole {
  normal,
  enterprise,
}

/// Status of a bulk booking requisition sent to the artisan/gig federation
enum RequisitionStatus {
  submitted,
  federationReview,
  matchmakerAssigned,
  approved,
  deployed,
}

extension RequisitionStatusExtension on RequisitionStatus {
  String get label {
    switch (this) {
      case RequisitionStatus.submitted:
        return 'Submitted to Federation';
      case RequisitionStatus.federationReview:
        return 'Under Federation Review';
      case RequisitionStatus.matchmakerAssigned:
        return 'Guild Matchmaker Assigned';
      case RequisitionStatus.approved:
        return 'Federation Approved';
      case RequisitionStatus.deployed:
        return 'Artisans Deployed';
    }
  }

  Color get color {
    switch (this) {
      case RequisitionStatus.submitted:
        return const Color(0xFFE5881C); // Amber
      case RequisitionStatus.federationReview:
        return const Color(0xFF0284C7); // Blue
      case RequisitionStatus.matchmakerAssigned:
        return const Color(0xFF8B3E0C); // Terracotta
      case RequisitionStatus.approved:
        return const Color(0xFF4C7B1E); // Forest green
      case RequisitionStatus.deployed:
        return const Color(0xFF1E3A15); // Dark badge green
    }
  }
}

/// Model representing a contract-based bulk booking or federation requisition
class EnterpriseRequisition {
  final String id;
  final String organizationName;
  final String gstinOrId;
  final String contactPerson;
  final String contactPhone;
  final String tradeTitle;
  final int workerCount;
  final String duration;
  final int durationMonths;
  final String shift;
  final String siteLocation;
  final String slaTier;
  final int totalEstimatedAmount;
  final RequisitionStatus status;
  final DateTime createdAt;
  final String? notes;

  const EnterpriseRequisition({
    required this.id,
    required this.organizationName,
    required this.gstinOrId,
    required this.contactPerson,
    required this.contactPhone,
    required this.tradeTitle,
    required this.workerCount,
    required this.duration,
    required this.durationMonths,
    required this.shift,
    required this.siteLocation,
    required this.slaTier,
    required this.totalEstimatedAmount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  EnterpriseRequisition copyWith({
    RequisitionStatus? status,
  }) {
    return EnterpriseRequisition(
      id: id,
      organizationName: organizationName,
      gstinOrId: gstinOrId,
      contactPerson: contactPerson,
      contactPhone: contactPhone,
      tradeTitle: tradeTitle,
      workerCount: workerCount,
      duration: duration,
      durationMonths: durationMonths,
      shift: shift,
      siteLocation: siteLocation,
      slaTier: slaTier,
      totalEstimatedAmount: totalEstimatedAmount,
      status: status ?? this.status,
      createdAt: createdAt,
      notes: notes,
    );
  }
}

/// Sample requisitions for enterprise demonstration
final List<EnterpriseRequisition> dummyEnterpriseRequisitions = [
  EnterpriseRequisition(
    id: 'FED-BLKR-2024-8841',
    organizationName: 'Loom & Craft Studios Pvt Ltd',
    gstinOrId: '03AAACL1234F1Z8',
    contactPerson: 'Vikram Mehrotra',
    contactPhone: '+91 98765 11223',
    tradeTitle: 'Carpenters & Woodcrafters',
    workerCount: 15,
    duration: '3 Months Contract',
    durationMonths: 3,
    shift: 'General Day Shift (8 hrs)',
    siteLocation: 'Industrial Area Phase 7, Mohali',
    slaTier: 'Priority 24hr Federation SLA',
    totalEstimatedAmount: 765000,
    status: RequisitionStatus.matchmakerAssigned,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    notes: 'Need guild certified wood turners and joinery specialists for export order fabrication.',
  ),
  EnterpriseRequisition(
    id: 'FED-BLKR-2024-8719',
    organizationName: 'Metro Infrastructure Hub',
    gstinOrId: '03AABCM5678K1Z2',
    contactPerson: 'Ananya Deshmukh',
    contactPhone: '+91 99123 44556',
    tradeTitle: 'Electricians',
    workerCount: 20,
    duration: '6 Months Contract',
    durationMonths: 6,
    shift: 'Rotational 24x7 Shift',
    siteLocation: 'Sector 62 Logistics Hub, Rajpura',
    slaTier: 'Standard 48hr SLA',
    totalEstimatedAmount: 1920000,
    status: RequisitionStatus.approved,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    notes: 'Licensed industrial electricians required for warehouse automated line wiring.',
  ),
];
