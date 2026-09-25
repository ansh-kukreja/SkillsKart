import 'package:flutter/material.dart';

enum JobLeadStatus {
  available,
  accepted,
  inProgress,
  completed,
  declined,
}

class JobLead {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final double distanceKm;
  final String serviceCategory;
  final String title;
  final int payout;
  final String estimatedTime;
  final String urgency;
  final String requestedTime;
  final List<String> checklist;
  final String otp;
  JobLeadStatus status;
  final String imageUrl;

  JobLead({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.distanceKm,
    required this.serviceCategory,
    required this.title,
    required this.payout,
    required this.estimatedTime,
    required this.urgency,
    required this.requestedTime,
    required this.checklist,
    required this.otp,
    this.status = JobLeadStatus.available,
    required this.imageUrl,
  });
}

class SkillVerificationItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isVerified;
  final String verificationDate;
  final String certificateNo;

  const SkillVerificationItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isVerified,
    required this.verificationDate,
    required this.certificateNo,
  });
}

class WorkerReview {
  final String author;
  final double rating;
  final String date;
  final String comment;
  final String service;

  const WorkerReview({
    required this.author,
    required this.rating,
    required this.date,
    required this.comment,
    required this.service,
  });
}

// Initial realistic static mock data for Gig Worker
final List<JobLead> initialJobLeads = [
  JobLead(
    id: 'lead_101',
    customerName: 'Amit Sharma',
    customerPhone: '+91 98721 34567',
    address: 'Flat 402, Royal Palms, Civil Lines, Rajpura',
    distanceKm: 1.4,
    serviceCategory: 'Electrician',
    title: 'Short Circuit & Switchboard Sparking',
    payout: 499,
    estimatedTime: '45 mins',
    urgency: 'Emergency • Arrive within 25 min',
    requestedTime: 'Immediate',
    checklist: [
      'Isolate main circuit breaker before inspection',
      'Test phase lines with digital multimeter',
      'Replace burnt 16A modular socket switch',
      'Verify earth leakage with socket tester',
    ],
    otp: '4829',
    status: JobLeadStatus.available,
    imageUrl: 'assets/images/gigs/gig_electrical.jpg',
  ),
  JobLead(
    id: 'lead_102',
    customerName: 'Sunita Mehra',
    customerPhone: '+91 98144 56789',
    address: 'House #84, Sector 3, Near Old Bus Stand, Rajpura',
    distanceKm: 2.8,
    serviceCategory: 'Electrician',
    title: 'Inverter Battery Setup & Heavy Load Wiring',
    payout: 750,
    estimatedTime: '1 hr 15 mins',
    urgency: 'Today • 3:30 PM Slot',
    requestedTime: '3:30 PM Today',
    checklist: [
      'Mount tubular battery rack securely',
      'Connect pure sinewave inverter terminals with grease',
      'Wire bypass emergency changeover switch',
      'Conduct 10-minute full backup load test',
    ],
    otp: '9152',
    status: JobLeadStatus.available,
    imageUrl: 'assets/images/gigs/gig_fan.jpg',
  ),
  JobLead(
    id: 'lead_103',
    customerName: 'Karan Malhotra',
    customerPhone: '+91 94172 88990',
    address: 'Shop 12, Guru Nanak Market, Rajpura',
    distanceKm: 0.9,
    serviceCategory: 'Electrician',
    title: 'Commercial Ceiling Fan & Chandelier Installation',
    payout: 600,
    estimatedTime: '50 mins',
    urgency: 'Scheduled • 5:00 PM',
    requestedTime: '5:00 PM Today',
    checklist: [
      'Assemble fan blades and motor downrod',
      'Install heavy duty ceiling expansion anchor bolt',
      'Connect safety wire and wire regulator harness',
    ],
    otp: '3718',
    status: JobLeadStatus.available,
    imageUrl: 'assets/images/gigs/gig_solar.jpg',
  ),
];

final List<JobLead> initialActiveJobs = [
  JobLead(
    id: 'lead_099',
    customerName: 'Harpreet Singh',
    customerPhone: '+91 99155 12340',
    address: 'House 142, Defence Colony, Rajpura',
    distanceKm: 0.6,
    serviceCategory: 'Electrician',
    title: 'AC MCB Tripping & Stabilizer Installation',
    payout: 550,
    estimatedTime: '40 mins',
    urgency: 'In Progress',
    requestedTime: 'Ongoing Job',
    checklist: [
      'Check compressor startup surge current',
      'Replace 20A C-Curve MCB in bedroom distribution box',
      'Test automatic voltage stabilizer cut-off',
    ],
    otp: '7741',
    status: JobLeadStatus.inProgress,
    imageUrl: 'assets/images/gigs/gig_ac_repair.jpg',
  ),
];

final List<SkillVerificationItem> staticVerificationItems = [
  const SkillVerificationItem(
    title: 'Aadhaar & Police KYC Verified',
    subtitle: 'Government ID & background verification verified',
    icon: Icons.verified_user_rounded,
    isVerified: true,
    verificationDate: 'Completed on 14 Jan 2024',
    certificateNo: 'KYC-IN-8924-SK',
  ),
  const SkillVerificationItem(
    title: 'Guild Trade Skill Assessment (Grade-A)',
    subtitle: 'Hands-on practical test passed at SkillsKart Center',
    icon: Icons.electric_bolt_rounded,
    isVerified: true,
    verificationDate: 'Score 98% • Valid till Jan 2026',
    certificateNo: 'SK-ELEC-GRD-A-412',
  ),
  const SkillVerificationItem(
    title: 'Professional Safety Kit & Tool Audit',
    subtitle: 'Insulated tools (1000V rated) & safety boots approved',
    icon: Icons.handyman_rounded,
    isVerified: true,
    verificationDate: 'Inspected on 02 Feb 2024',
    certificateNo: 'TOOL-AUDIT-PASS-77',
  ),
  const SkillVerificationItem(
    title: 'Customer Service & Ethics Training',
    subtitle: 'Completed 6-hour soft skills and hygiene module',
    icon: Icons.school_rounded,
    isVerified: true,
    verificationDate: 'Certified on 10 Feb 2024',
    certificateNo: 'CSR-ET-2024-09',
  ),
];

final List<WorkerReview> staticWorkerReviews = [
  const WorkerReview(
    author: 'Gurpreet Kaur',
    rating: 5.0,
    date: 'Yesterday',
    comment: 'Super fast arrival! Fixed the sparking switchboard within 25 minutes and also cleaned up the wall dust.',
    service: 'Short Circuit & Wiring Repair',
  ),
  const WorkerReview(
    author: 'Vikas Sood',
    rating: 5.0,
    date: '3 days ago',
    comment: 'Very polite professional. Brought proper testing equipment and explained why the MCB was tripping.',
    service: 'AC Stabilizer Setup',
  ),
  const WorkerReview(
    author: 'Deepak Sharma',
    rating: 4.8,
    date: '1 week ago',
    comment: 'Great job with inverter battery setup. Neat cabling and tested everything properly.',
    service: 'Inverter Wiring',
  ),
];
