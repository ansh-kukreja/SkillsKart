import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String label;
  final IconData icon;
  final String category;
  final String tag;
  final double rating;
  final int reviewsCount;
  final String startingPrice;
  final String craftCount;
  final String description;
  final List<String> commonTasks;
  final List<Color> gradientColors;
  final Color bgTint;
  final Color accentColor;
  final String imageUrl;

  const ServiceItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.category,
    required this.tag,
    required this.rating,
    required this.reviewsCount,
    required this.startingPrice,
    required this.craftCount,
    required this.description,
    required this.commonTasks,
    required this.gradientColors,
    required this.bgTint,
    required this.accentColor,
    required this.imageUrl,
  });
}

class ArtisanSpecialist {
  final String name;
  final String experience;
  final double rating;
  final int jobsCompleted;
  final String hourlyRate;
  final String location;
  final bool isGuildCertified;

  const ArtisanSpecialist({
    required this.name,
    required this.experience,
    required this.rating,
    required this.jobsCompleted,
    required this.hourlyRate,
    required this.location,
    this.isGuildCertified = true,
  });
}

// Ordered with user requested top services and rich representational photography:
// Electricians, Plumbers, Carpenters, Painters, Domestic Helpers, Caregivers, Drivers, Gardeners, Cleaners
final List<ServiceItem> dummyServicesList = [
  // 1. Electricians
  const ServiceItem(
    id: 'serv_electricians',
    label: 'Electricians',
    icon: Icons.electric_bolt_rounded,
    category: 'Home Repair',
    tag: 'Licensed',
    rating: 4.9,
    reviewsCount: 310,
    startingPrice: '₹199',
    craftCount: '64 Pros',
    description:
        'Safe and licensed electrical specialists for wiring diagnostics, fuse box setup, ceiling fan installation, and inverter maintenance.',
    commonTasks: [
      'Short Circuit & Wiring Inspection',
      'Inverter & Battery Wiring',
      'Switchboard & Socket Installation',
      'Decorative Chandelier & Light Setup',
    ],
    gradientColors: [Color(0xFFF59E0B), Color(0xFFD97706)],
    bgTint: Color(0xFFFFFBEB),
    accentColor: Color(0xFFD97706),
    imageUrl:
        'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=600&auto=format&fit=crop&q=80',
  ),

  // 2. Plumbers
  const ServiceItem(
    id: 'serv_plumbers',
    label: 'Plumbers',
    icon: Icons.plumbing_rounded,
    category: 'Home Repair',
    tag: 'Quick Response',
    rating: 4.8,
    reviewsCount: 230,
    startingPrice: '₹199',
    craftCount: '58 Pros',
    description:
        'Certified plumbers for pipe leak repairs, sanitary fittings, water motor servicing, and complete bathroom fixture installation.',
    commonTasks: [
      'Tap & Valve Leakage Repair',
      'Water Tank Cleaning & Motor Setup',
      'Sanitaryware & Basin Installation',
      'Drainage & Blockage Clearing',
    ],
    gradientColors: [Color(0xFF0D9488), Color(0xFF0F766E)],
    bgTint: Color(0xFFF0FDFA),
    accentColor: Color(0xFF0D9488),
    imageUrl:
        'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=600&auto=format&fit=crop&q=80',
  ),

  // 3. Carpenters
  const ServiceItem(
    id: 'serv_carpenters',
    label: 'Carpenters',
    icon: Icons.carpenter_rounded,
    category: 'Wood & Clay',
    tag: 'Guild Verified',
    rating: 4.9,
    reviewsCount: 142,
    startingPrice: '₹349',
    craftCount: '42 Artisans',
    description:
        'Experienced woodwork masters specializing in solid wood furniture, bespoke cabinetry, door repair, and heirloom restorations.',
    commonTasks: [
      'Custom Furniture Making',
      'Door & Window Frame Fitting',
      'Wooden Flooring & Paneling',
      'Polishing & Furniture Restoration',
    ],
    gradientColors: [Color(0xFFC26118), Color(0xFF8B3E0C)],
    bgTint: Color(0xFFFDF4ED),
    accentColor: Color(0xFF8B3E0C),
    imageUrl:
        'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=600&auto=format&fit=crop&q=80',
  ),

  // 4. Painters
  const ServiceItem(
    id: 'serv_painters',
    label: 'Painters',
    icon: Icons.format_paint_rounded,
    category: 'Wood & Clay',
    tag: 'Eco Friendly',
    rating: 4.9,
    reviewsCount: 176,
    startingPrice: '₹399',
    craftCount: '35 Artisans',
    description:
        'Wall painting and wood polishing artists proficient in limewash, natural mineral distemper, and traditional textured wall treatments.',
    commonTasks: [
      'Natural Limewash Application',
      'Wood Stain & PU Coating',
      'Heritage Stencil & Wall Art',
      'Interior & Exterior Wall Repaint',
    ],
    gradientColors: [Color(0xFF0284C7), Color(0xFF0369A1)],
    bgTint: Color(0xFFF0F9FF),
    accentColor: Color(0xFF0284C7),
    imageUrl:
        'https://images.unsplash.com/photo-1589939705384-5185137a7f0f?w=600&auto=format&fit=crop&q=80',
  ),

  // 5. Domestic Helpers
  const ServiceItem(
    id: 'serv_domestic_helpers',
    label: 'Domestic Helpers',
    icon: Icons.home_work_rounded,
    category: 'Maintenance',
    tag: 'Verified ID',
    rating: 4.8,
    reviewsCount: 280,
    startingPrice: '₹299',
    craftCount: '78 Pros',
    description:
        'Background-verified household domestic assistants for daily cleaning, cooking support, kitchen assistance, and household upkeep.',
    commonTasks: [
      'Daily Housekeeping & Floor Mopping',
      'Kitchen Assistance & Meal Prep',
      'Utensil Cleaning & Organizing',
      'Laundry & Folding Assistance',
    ],
    gradientColors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    bgTint: Color(0xFFEEF2FF),
    accentColor: Color(0xFF6366F1),
    imageUrl:
        'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=600&auto=format&fit=crop&q=80',
  ),

  // 6. Caregivers
  const ServiceItem(
    id: 'serv_caregivers',
    label: 'Caregivers',
    icon: Icons.volunteer_activism_rounded,
    category: 'Care & Assist',
    tag: 'Compassionate',
    rating: 4.9,
    reviewsCount: 112,
    startingPrice: '₹499',
    craftCount: '31 Pros',
    description:
        'Trained nursing assistants and companion caregivers for elderly support, post-operative recovery, and daily mobility assistance.',
    commonTasks: [
      'Elderly Mobility & Daily Assistance',
      'Vital Signs & Medication Monitoring',
      'Post-Hospitalization Patient Care',
      'Dementia & Bedridden Patient Support',
    ],
    gradientColors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
    bgTint: Color(0xFFFFF1F2),
    accentColor: Color(0xFFE11D48),
    imageUrl:
        'https://images.unsplash.com/photo-1576765608535-5f04d1e3f289?w=600&auto=format&fit=crop&q=80',
  ),

  // 7. Drivers
  const ServiceItem(
    id: 'serv_drivers',
    label: 'Drivers',
    icon: Icons.directions_car_filled_rounded,
    category: 'Care & Assist',
    tag: 'Verified',
    rating: 4.8,
    reviewsCount: 198,
    startingPrice: '₹349',
    craftCount: '46 Pros',
    description:
        'Experienced personal and commercial drivers with clean driving records for local city runs, highway outstation, and material transit.',
    commonTasks: [
      'Daily Chauffeur Service',
      'Inter-City Highway Driving',
      'Artisan Material Transport Pickup',
      'Late Night & Early Morning Transit',
    ],
    gradientColors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    bgTint: Color(0xFFEFF6FF),
    accentColor: Color(0xFF2563EB),
    imageUrl:
        'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=600&auto=format&fit=crop&q=80',
  ),

  // 8. Gardeners
  const ServiceItem(
    id: 'serv_gardeners',
    label: 'Gardeners',
    icon: Icons.local_florist_rounded,
    category: 'Maintenance',
    tag: 'Organic Care',
    rating: 4.9,
    reviewsCount: 92,
    startingPrice: '₹299',
    craftCount: '22 Pros',
    description:
        'Skilled horticulturists and local gardeners for terrace gardens, lawn trimming, organic composting, and seasonal blooming plants.',
    commonTasks: [
      'Lawn Mowing & Shrub Pruning',
      'Terrace & Balcony Garden Setup',
      'Organic Pest Treatment & Manure',
      'Seasonal Flower & Vegetable Planting',
    ],
    gradientColors: [Color(0xFF16A34A), Color(0xFF15803D)],
    bgTint: Color(0xFFF0FDF4),
    accentColor: Color(0xFF16A34A),
    imageUrl:
        'https://images.unsplash.com/photo-1585320806297-9794b3e4eeae?w=600&auto=format&fit=crop&q=80',
  ),

  // 9. Cleaners
  const ServiceItem(
    id: 'serv_cleaners',
    label: 'Cleaners',
    icon: Icons.cleaning_services_rounded,
    category: 'Maintenance',
    tag: 'Deep Clean',
    rating: 4.8,
    reviewsCount: 215,
    startingPrice: '₹349',
    craftCount: '52 Pros',
    description:
        'Professional deep cleaning specialists for intensive bathroom descaling, kitchen degreasing, sofa shampooing, and water tank scrubbing.',
    commonTasks: [
      'Full Home Deep Scrubbing',
      'Kitchen Chimney & Tile Degreasing',
      'Sofa & Mattress Vacuum Shampooing',
      'Water Tank Disinfection',
    ],
    gradientColors: [Color(0xFF0891B2), Color(0xFF0E7490)],
    bgTint: Color(0xFFECFEFF),
    accentColor: Color(0xFF0891B2),
    imageUrl:
        'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=600&auto=format&fit=crop&q=80',
  ),

  // Other Craft & Specialty Services
  const ServiceItem(
    id: 'serv_pottery',
    label: 'Pottery & Clay Work',
    icon: Icons.interests_rounded,
    category: 'Wood & Clay',
    tag: 'Heritage',
    rating: 4.8,
    reviewsCount: 88,
    startingPrice: '₹299',
    craftCount: '18 Artisans',
    description:
        'Traditional terracotta artisans and clay tile installers for sustainable home cooling, decorative terracotta jalis, and custom pottery.',
    commonTasks: [
      'Terracotta Roof & Wall Tiling',
      'Decorative Clay Jali Work',
      'Custom Planters & Urns',
      'Natural Clay Water Storage Installation',
    ],
    gradientColors: [Color(0xFFE07A2B), Color(0xFFB45309)],
    bgTint: Color(0xFFFEF7EE),
    accentColor: Color(0xFFB45309),
    imageUrl:
        'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=600&auto=format&fit=crop&q=80',
  ),

  const ServiceItem(
    id: 'serv_appliance',
    label: 'Appliance Repair',
    icon: Icons.build_circle_rounded,
    category: 'Home Repair',
    tag: 'Warranty',
    rating: 4.7,
    reviewsCount: 154,
    startingPrice: '₹249',
    craftCount: '29 Pros',
    description:
        'Expert diagnostic and repair services for refrigerators, washing machines, microwaves, water purifiers, and kitchen chimneys.',
    commonTasks: [
      'Refrigerator Gas Refill & Cooling Fix',
      'Washing Machine Motor & Drum Repair',
      'RO Water Purifier Filter Service',
      'Microwave & Oven Heating Repair',
    ],
    gradientColors: [Color(0xFF64748B), Color(0xFF475569)],
    bgTint: Color(0xFFF8FAFC),
    accentColor: Color(0xFF475569),
    imageUrl:
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80',
  ),

  const ServiceItem(
    id: 'serv_pest_control',
    label: 'Eco Pest Control',
    icon: Icons.pest_control_rounded,
    category: 'Maintenance',
    tag: 'Herbal & Safe',
    rating: 4.8,
    reviewsCount: 84,
    startingPrice: '₹449',
    craftCount: '15 Pros',
    description:
        'Non-toxic and odor-free herbal pest treatments safe for kids, pets, and pregnant women. Termite and cockroach eradication guaranteed.',
    commonTasks: [
      'Gel-Based Cockroach Management',
      'Pre & Post Construction Termite Control',
      'Bed Bug Elimination',
      'Mosquito & Fly Fogging',
    ],
    gradientColors: [Color(0xFF84CC16), Color(0xFF65A30D)],
    bgTint: Color(0xFFF7FEE7),
    accentColor: Color(0xFF65A30D),
    imageUrl:
        'https://images.unsplash.com/photo-1632733711679-529326f6db37?w=600&auto=format&fit=crop&q=80',
  ),

  const ServiceItem(
    id: 'serv_security',
    label: 'Security Personnel',
    icon: Icons.security_rounded,
    category: 'Care & Assist',
    tag: 'Trained Guard',
    rating: 4.7,
    reviewsCount: 76,
    startingPrice: '₹499',
    craftCount: '20 Pros',
    description:
        'Disciplined and verified security guards for community residential gates, artisan workshops, warehouses, and event oversight.',
    commonTasks: [
      'Day / Night Gate Entry Vigilance',
      'Workshop & Warehouse Security',
      'Visitor Registry & CCTV Monitoring',
      'Event & Exhibition Crowd Support',
    ],
    gradientColors: [Color(0xFF52525B), Color(0xFF3F3F46)],
    bgTint: Color(0xFFFAFAFA),
    accentColor: Color(0xFF3F3F46),
    imageUrl:
        'https://images.unsplash.com/photo-1557597774-9d273605dfa9?w=600&auto=format&fit=crop&q=80',
  ),
];

final List<ArtisanSpecialist> dummySpecialists = [
  const ArtisanSpecialist(
    name: 'Ramesh Sharma',
    experience: '14 Years Experience',
    rating: 4.9,
    jobsCompleted: 340,
    hourlyRate: '₹350/hr',
    location: 'Civil Lines, Rajpura',
    isGuildCertified: true,
  ),
  const ArtisanSpecialist(
    name: 'Gurpreet Singh',
    experience: '9 Years Experience',
    rating: 4.8,
    jobsCompleted: 215,
    hourlyRate: '₹320/hr',
    location: 'Sector 4, Zirakpur',
    isGuildCertified: true,
  ),
  const ArtisanSpecialist(
    name: 'Mohammad Tariq',
    experience: '18 Years Experience',
    rating: 5.0,
    jobsCompleted: 480,
    hourlyRate: '₹400/hr',
    location: 'Khurja Road Cluster',
    isGuildCertified: true,
  ),
];
