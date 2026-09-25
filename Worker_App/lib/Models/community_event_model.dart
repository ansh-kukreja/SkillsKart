class CommunityEvent {
  final String id;
  String title;
  String category;
  String organization;
  String location;
  String date;
  String time;
  String description;
  String tag;
  int currentParticipants;
  int targetParticipants;
  String contactPhone;
  bool isBloodCamp;
  List<String> bloodGroupsNeeded;
  String imageUrl;
  String status; // 'Live Today', 'Upcoming', 'Completed'

  CommunityEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.organization,
    required this.location,
    required this.date,
    required this.time,
    required this.description,
    required this.tag,
    required this.currentParticipants,
    required this.targetParticipants,
    required this.contactPhone,
    this.isBloodCamp = false,
    this.bloodGroupsNeeded = const [],
    required this.imageUrl,
    this.status = 'Upcoming',
  });

  double get progress => targetParticipants > 0
      ? (currentParticipants / targetParticipants).clamp(0.0, 1.0)
      : 0.0;
}

class EventAttendee {
  final String id;
  final String name;
  final String phone;
  final String eventId;
  final String eventTitle;
  final String registrationDate;
  bool attended;
  final String? bloodGroup;
  final String role; // 'Donor', 'Beneficiary', 'Volunteer'

  EventAttendee({
    required this.id,
    required this.name,
    required this.phone,
    required this.eventId,
    required this.eventTitle,
    required this.registrationDate,
    this.attended = false,
    this.bloodGroup,
    this.role = 'Participant',
  });
}

// Initial realistic static mock data for Community Org
final List<CommunityEvent> initialCommunityEvents = [
  CommunityEvent(
    id: 'comm_1',
    title: 'Mega Blood Donation Camp & Awareness Drive',
    category: 'Health & Blood',
    organization: 'Red Cross Society & Local Artisan Guild',
    location: 'Community Center, Civil Lines, Rajpura',
    date: 'Sunday, 15 Sept 2024',
    time: '9:00 AM - 4:00 PM',
    description: 'Urgent requirement for local emergency blood reserves. Refreshments, donor certificates, and free hemoglobin testing provided.',
    tag: 'Urgent Need',
    currentParticipants: 42,
    targetParticipants: 60,
    contactPhone: '+91 98765 43210',
    isBloodCamp: true,
    bloodGroupsNeeded: ['O+', 'O-', 'A+', 'B+', 'AB+'],
    imageUrl: 'assets/images/events/event_blood_camp.jpg',
    status: 'Live Today',
  ),
  CommunityEvent(
    id: 'comm_2',
    title: 'Free Health & Eye Checkup Camp for Elders',
    category: 'Health & Blood',
    organization: 'Rotary Club & Civil Hospital Specialists',
    location: 'Gandhi Memorial Hall, Near Bus Stand, Rajpura',
    date: 'Wednesday, 18 Sept 2024',
    time: '10:00 AM - 3:00 PM',
    description: 'Free cataract screening, blood sugar checkup, and complimentary prescription spectacles for artisan families and elders.',
    tag: 'Free Medical Aid',
    currentParticipants: 78,
    targetParticipants: 100,
    contactPhone: '+91 98123 45678',
    isBloodCamp: false,
    imageUrl: 'assets/images/events/event_health_camp.jpg',
    status: 'Upcoming',
  ),
  CommunityEvent(
    id: 'comm_3',
    title: 'Winter Clothes & Warm Blanket Collection Drive',
    category: 'Donation Drives',
    organization: 'SkillsKart Seva Mission & Volunteers',
    location: 'Main Market Drop-off Point, Shop #12, Rajpura',
    date: 'Open until 30 Sept 2024',
    time: '10:00 AM - 7:00 PM',
    description: 'Help vulnerable migrant families and rural artisans prepare for cold winter. Drop fresh clean blankets and warm clothes.',
    tag: 'Winter Relief',
    currentParticipants: 135,
    targetParticipants: 200,
    contactPhone: '+91 98881 22334',
    isBloodCamp: false,
    imageUrl: 'assets/images/events/event_blanket_drive.jpg',
    status: 'Upcoming',
  ),
];

final List<EventAttendee> initialEventAttendees = [
  EventAttendee(
    id: 'att_01',
    name: 'Gursharan Singh',
    phone: '+91 98140 12091',
    eventId: 'comm_1',
    eventTitle: 'Mega Blood Donation Camp',
    registrationDate: 'Today • 9:30 AM',
    attended: true,
    bloodGroup: 'O+',
    role: 'Donor',
  ),
  EventAttendee(
    id: 'att_02',
    name: 'Simran Kaur',
    phone: '+91 98722 44319',
    eventId: 'comm_1',
    eventTitle: 'Mega Blood Donation Camp',
    registrationDate: 'Today • 10:15 AM',
    attended: true,
    bloodGroup: 'A+',
    role: 'Donor',
  ),
  EventAttendee(
    id: 'att_03',
    name: 'Baljit Kumar',
    phone: '+91 94178 77622',
    eventId: 'comm_1',
    eventTitle: 'Mega Blood Donation Camp',
    registrationDate: 'Today • 11:00 AM',
    attended: false,
    bloodGroup: 'B+',
    role: 'Donor',
  ),
  EventAttendee(
    id: 'att_04',
    name: 'Neha Gupta',
    phone: '+91 99150 33810',
    eventId: 'comm_2',
    eventTitle: 'Free Health & Eye Checkup Camp',
    registrationDate: 'Yesterday',
    attended: false,
    role: 'Beneficiary',
  ),
];
