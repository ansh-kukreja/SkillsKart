import 'package:flutter/material.dart';

class CommunityPost {
  final String id;
  final String title;
  final String category;
  final String organization;
  final String location;
  final String date;
  final String time;
  final String description;
  final String tag;
  final Color tagColor;
  final int currentParticipants;
  final int targetParticipants;
  final String contactPhone;
  final bool isBloodCamp;
  final List<String> bloodGroupsNeeded;
  final String? imageUrl;

  const CommunityPost({
    required this.id,
    required this.title,
    required this.category,
    required this.organization,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.tag,
    required this.tagColor,
    required this.currentParticipants,
    required this.targetParticipants,
    required this.contactPhone,
    this.isBloodCamp = false,
    this.bloodGroupsNeeded = const [],
    this.imageUrl,
  });

  double get progress => (currentParticipants / targetParticipants).clamp(0.0, 1.0);

  IconData get categoryIcon {
    if (isBloodCamp) return Icons.bloodtype_rounded;
    switch (category) {
      case 'Health & Blood':
        return Icons.medical_services_rounded;
      case 'Donation Drives':
        return Icons.volunteer_activism_rounded;
      case 'Education & Skills':
        return Icons.school_rounded;
      case 'Environment':
        return Icons.park_rounded;
      default:
        return Icons.diversity_1_rounded;
    }
  }
}

final List<CommunityPost> dummyCommunityPosts = [
  const CommunityPost(
    id: 'comm_1',
    title: 'Mega Blood Donation Camp & Awareness Drive',
    category: 'Health & Blood',
    organization: 'Red Cross Society & Local Artisan Guild',
    location: 'Community Center, Civil Lines, Rajpura',
    date: 'Sunday, 15 Sept 2024',
    time: '9:00 AM - 4:00 PM',
    description:
        'Urgent requirement for local emergency blood reserves. Refreshments, donor certificate, and free hemoglobin test provided to all donors.',
    tag: 'Urgent Need',
    tagColor: Color(0xFFC62828), // Crimson Red
    currentParticipants: 42,
    targetParticipants: 60,
    contactPhone: '+91 98765 43210',
    isBloodCamp: true,
    bloodGroupsNeeded: ['O+', 'O-', 'A+', 'B+', 'AB+'],
    imageUrl: 'assets/images/community/blood_donation.jpg',
  ),
  const CommunityPost(
    id: 'comm_2',
    title: 'Free Health & Eye Checkup Camp for Senior Citizens',
    category: 'Health & Blood',
    organization: 'Rotary Club & Civil Hospital Specialists',
    location: 'Gandhi Memorial Hall, Near Bus Stand',
    date: 'Wednesday, 18 Sept 2024',
    time: '10:00 AM - 3:00 PM',
    description:
        'Free cataract screening, blood sugar testing, and complimentary prescription spectacles for underprivileged elders and artisan families.',
    tag: 'Free Medical Aid',
    tagColor: Color(0xFF2E7D32), // Forest Green
    currentParticipants: 78,
    targetParticipants: 100,
    contactPhone: '+91 98123 45678',
    isBloodCamp: false,
    imageUrl: 'assets/images/community/health_checkup.jpg',
  ),
  const CommunityPost(
    id: 'comm_3',
    title: 'Winter Clothes & Warm Blanket Collection Drive',
    category: 'Donation Drives',
    organization: 'SkillsKart Seva Mission & Khalsa Aid Volunteers',
    location: 'Main Market Drop-off Point, Shop #12',
    date: 'Open until 30 Sept 2024',
    time: 'All Day (10 AM - 8 PM)',
    description:
        'Collecting clean wearable warm clothes, jackets, shawls, and blankets for migrant worker families and night shelter residents before winter arrives.',
    tag: 'Donation Drive',
    tagColor: Color(0xFF8B3E0C), // Terracotta
    currentParticipants: 124,
    targetParticipants: 200,
    contactPhone: '+91 98456 78901',
    isBloodCamp: false,
    imageUrl: 'assets/images/community/blanket_drive.jpg',
  ),
  const CommunityPost(
    id: 'comm_4',
    title: 'Artisan Woodcraft & Pottery Skill Workshop for Youth',
    category: 'Education & Skills',
    organization: 'District Rural Development Agency (DRDA)',
    location: 'Artisan Training Center, Khurja Road',
    date: 'Starts 22 Sept 2024 (7-Day Camp)',
    time: '3:00 PM - 6:00 PM Daily',
    description:
        'Free hands-on masterclasses conducted by national award-winning potters and carpenters. Toolkits provided; certification on completion.',
    tag: 'Free Workshop',
    tagColor: Color(0xFFD84315), // Deep Orange
    currentParticipants: 18,
    targetParticipants: 25,
    contactPhone: '+91 97654 32109',
    isBloodCamp: false,
    imageUrl: 'assets/images/community/pottery_workshop.jpg',
  ),
  const CommunityPost(
    id: 'comm_5',
    title: 'Riverbank Cleanliness & Native Tree Plantation Drive',
    category: 'Environment',
    organization: 'Clean Green Guild & Eco Warriors',
    location: 'Ghaggar Riverfront, North Bridge Point',
    date: 'Saturday, 28 Sept 2024',
    time: '6:30 AM - 10:00 AM',
    description:
        'Join hands to plant 500 indigenous neem, banyan, and peepal saplings and clear plastic waste from the river catchment area. Gloves & tools provided.',
    tag: 'Eco Initiative',
    tagColor: Color(0xFF33691E), // Olive / Leaf Green
    currentParticipants: 65,
    targetParticipants: 80,
    contactPhone: '+91 99887 76655',
    isBloodCamp: false,
    imageUrl: 'assets/images/community/park_cleanup.jpg',
  ),
  const CommunityPost(
    id: 'comm_6',
    title: 'Nutritious Midday Food Relief & Ration Kit Distribution',
    category: 'Donation Drives',
    organization: 'Akshaya Annadanam & Local Grain Merchants',
    location: 'Labour Chowk, Industrial Area Phase 1',
    date: 'Every Sunday',
    time: '12:00 PM - 2:30 PM',
    description:
        'Distributing freshly cooked wholesome meals and 10kg monthly dry ration kits (flour, pulses, mustard oil) to daily wage labor households.',
    tag: 'Food Relief',
    tagColor: Color(0xFFE65100), // Warm Ochre
    currentParticipants: 90,
    targetParticipants: 120,
    contactPhone: '+91 98223 34455',
    isBloodCamp: false,
    imageUrl: 'assets/images/community/food_langar.jpg',
  ),
];
