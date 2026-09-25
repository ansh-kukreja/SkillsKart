enum ApplicantStatus {
  applied,
  shortlisted,
  hired,
  rejected,
}

class PostedJob {
  final String id;
  String title;
  String description;
  String salary;
  String jobType;
  String location;
  String postedDate;
  int vacancies;
  bool isActive;
  String category;
  String imageUrl;
  List<String> requirements;
  int applicantCount;

  PostedJob({
    required this.id,
    required this.title,
    required this.description,
    required this.salary,
    required this.jobType,
    required this.location,
    required this.postedDate,
    required this.vacancies,
    this.isActive = true,
    required this.category,
    required this.imageUrl,
    required this.requirements,
    this.applicantCount = 0,
  });
}

class JobApplicant {
  final String id;
  final String name;
  final String phone;
  final String jobId;
  final String appliedJobTitle;
  final String experience;
  final List<String> skills;
  final String appliedDate;
  ApplicantStatus status;
  final String education;

  JobApplicant({
    required this.id,
    required this.name,
    required this.phone,
    required this.jobId,
    required this.appliedJobTitle,
    required this.experience,
    required this.skills,
    required this.appliedDate,
    this.status = ApplicantStatus.applied,
    required this.education,
  });
}

// Initial realistic static mock data for Business Owner
final List<PostedJob> initialPostedJobs = [
  PostedJob(
    id: 'job_01',
    title: 'Salesman for my Clothing Store',
    description: 'Need a salesman for our clothing store in the main market. Should be good at customer interaction, inventory folding, and POS counter billing.',
    salary: '₹10,000 / month',
    jobType: 'Full-Time Job',
    location: 'Main Market, Rajpura',
    postedDate: '02 Sept 2024',
    vacancies: 2,
    isActive: true,
    category: 'Retail & Sales',
    imageUrl: 'assets/images/jobs/job_retail.jpg',
    requirements: [
      'Minimum 1 year retail sales experience',
      'Fluent in Hindi and Punjabi',
      'Polite and proactive customer service',
    ],
    applicantCount: 12,
  ),
  PostedJob(
    id: 'job_02',
    title: 'Delivery Partner for Grocery Mart',
    description: 'Need a delivery partner with own two-wheeler for quick grocery orders within a 5km radius. Fuel allowance and weekly incentives provided.',
    salary: '₹12,500 + Fuel',
    jobType: 'Full-Time Job',
    location: 'Sector 4, Zirakpur',
    postedDate: '08 Sept 2024',
    vacancies: 4,
    isActive: true,
    category: 'Logistics',
    imageUrl: 'assets/images/jobs/job_driver.jpg',
    requirements: [
      'Valid driving license & two-wheeler',
      'Smartphone with GPS navigation capability',
      'Punctual and familiar with local streets',
    ],
    applicantCount: 9,
  ),
  PostedJob(
    id: 'job_03',
    title: 'Counter Staff at LaPinoz Pizzeria',
    description: 'Energetic front counter executive for customer greeting, order punch-in, bill settlement, and dining floor coordination.',
    salary: '₹11,000 / month',
    jobType: 'Shift-Based',
    location: 'Liberty Square, Rajpura',
    postedDate: '10 Sept 2024',
    vacancies: 1,
    isActive: true,
    category: 'Hospitality',
    imageUrl: 'assets/images/jobs/job_cafe.jpg',
    requirements: [
      'Basic computer and POS register familiarity',
      'Pleasing personality and team communication',
      'Shift timings: 11 AM - 9 PM with meal included',
    ],
    applicantCount: 7,
  ),
];

final List<JobApplicant> initialJobApplicants = [
  JobApplicant(
    id: 'app_101',
    name: 'Ramesh Kumar',
    phone: '+91 98144 23112',
    jobId: 'job_01',
    appliedJobTitle: 'Salesman for my Clothing Store',
    experience: '2.5 Years in Garment Retail',
    skills: ['Customer Relations', 'Stock Auditing', 'POS Billing'],
    appliedDate: 'Yesterday • 3:20 PM',
    status: ApplicantStatus.applied,
    education: 'Higher Secondary (12th Pass)',
  ),
  JobApplicant(
    id: 'app_102',
    name: 'Manpreet Singh',
    phone: '+91 98721 88410',
    jobId: 'job_02',
    appliedJobTitle: 'Delivery Partner for Grocery Mart',
    experience: '1.5 Years in Courier Delivery',
    skills: ['Clean Driving Record', 'Two Wheeler Ready', 'Route Knowledge'],
    appliedDate: '2 days ago',
    status: ApplicantStatus.shortlisted,
    education: 'Matriculation (10th Pass)',
  ),
  JobApplicant(
    id: 'app_103',
    name: 'Priya Sharma',
    phone: '+91 94170 56231',
    jobId: 'job_03',
    appliedJobTitle: 'Counter Staff at LaPinoz Pizzeria',
    experience: '1 Year at Cafe Bistro',
    skills: ['Order Management', 'Cashier Handling', 'English & Hindi'],
    appliedDate: 'Yesterday • 6:10 PM',
    status: ApplicantStatus.applied,
    education: 'Graduate (B.Com)',
  ),
  JobApplicant(
    id: 'app_104',
    name: 'Vikramaditya Sood',
    phone: '+91 99155 44220',
    jobId: 'job_01',
    appliedJobTitle: 'Salesman for my Clothing Store',
    experience: '3 Years Men Apparel Store',
    skills: ['Showroom Display', 'Client Handling', 'Inventory Tracking'],
    appliedDate: '3 days ago',
    status: ApplicantStatus.hired,
    education: 'Higher Secondary (12th Pass)',
  ),
];
