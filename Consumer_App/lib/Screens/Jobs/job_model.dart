import 'package:flutter/material.dart';

class JobModel {
  final String title;
  final String description;
  final String salary;
  final String jobType;
  final String location;
  final String date;
  final String? imageUrl; // thumbnail/banner image

  const JobModel({
    required this.title,
    required this.description,
    required this.salary,
    required this.jobType,
    required this.location,
    required this.date,
    this.imageUrl,
  });

  IconData get tradeIcon {
    final t = title.toLowerCase();
    if (t.contains('salesman') || t.contains('clothing')) return Icons.storefront_rounded;
    if (t.contains('helper') && t.contains('d-mart')) return Icons.shopping_bag_rounded;
    if (t.contains('pizzeria') || t.contains('counter')) return Icons.local_pizza_rounded;
    if (t.contains('driver') || t.contains('van')) return Icons.directions_bus_rounded;
    if (t.contains('dhaba') || t.contains('kitchen')) return Icons.soup_kitchen_rounded;
    if (t.contains('delivery') || t.contains('grocery')) return Icons.two_wheeler_rounded;
    if (t.contains('guard') || t.contains('security')) return Icons.shield_rounded;
    if (t.contains('dairy') || t.contains('milk')) return Icons.water_drop_rounded;
    if (t.contains('cook') || t.contains('tiffin')) return Icons.restaurant_rounded;
    if (t.contains('warehouse') || t.contains('loader')) return Icons.inventory_2_rounded;
    return Icons.work_outline_rounded;
  }

  Color get tradeColor {
    final t = title.toLowerCase();
    if (t.contains('clothing')) return const Color(0xFF883D0E);
    if (t.contains('d-mart')) return const Color(0xFF2E7D32);
    if (t.contains('pizzeria')) return const Color(0xFFD84315);
    if (t.contains('driver')) return const Color(0xFF1565C0);
    if (t.contains('dhaba')) return const Color(0xFFE65100);
    if (t.contains('delivery')) return const Color(0xFF00897B);
    if (t.contains('security')) return const Color(0xFF455A64);
    if (t.contains('dairy')) return const Color(0xFF0288D1);
    if (t.contains('cook')) return const Color(0xFFC2185B);
    if (t.contains('warehouse')) return const Color(0xFF5D4037);
    return const Color(0xFF883D0E);
  }
}

// Curated blue-collar & trade job listings with realistic relevant imagery
final List<JobModel> dummyJobs = [
  const JobModel(
    title: 'Salesman for my Clothing Store',
    description:
        'Need a salesman for our clothing store in the main market. Should be good at talking to customers and handling billing.',
    salary: '₹9,000',
    jobType: 'Full-Time Job',
    location: 'Rajpura, Punjab',
    date: '28 Mar, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Need a helper for D-Mart Retail',
    description:
        'Required a helper for stocking shelves and assisting customers at retail store. Morning shift only, 6am to 2pm.',
    salary: '₹10,000',
    jobType: 'Full-Time Job',
    location: 'Zirakpur, Punjab',
    date: '02 Apr, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Counter Staff at LaPinoz Pizzeria',
    description:
        'Need an energetic person for order taking and counter management at our outlet. Timings: 10:00 am to 10:00 pm.',
    salary: '₹12,000',
    jobType: 'Full-Time Job',
    location: 'Rajpura, Punjab',
    date: '20 Apr, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Driver Needed for School Van',
    description:
        'Looking for an experienced driver with valid commercial badge for daily school pickup and drop. Clean record required.',
    salary: '₹8,000',
    jobType: 'Part-Time Job',
    location: 'Mohali, Punjab',
    date: '02 May, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Kitchen Helper for Highway Dhaba',
    description:
        'Need a kitchen helper for cutting vegetables and cleaning utensils at our highway dhaba. Fresh wholesome food and stay included.',
    salary: '₹7,000',
    jobType: 'Full-Time Job',
    location: 'Ambala, Haryana',
    date: '15 May, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1556910103-1c02745aae4d?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Delivery Partner for Grocery Mart',
    description:
        'Need a delivery partner with own two-wheeler for quick grocery deliveries within a 5km radius. Fuel allowance provided.',
    salary: '₹9,500',
    jobType: 'Full-Time Job',
    location: 'Rajpura, Punjab',
    date: '18 May, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1617347454431-f49d7ff5c3b1?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Security Guard for Residential Society',
    description:
        'Need a responsible security guard for night shift duty at society entry gate. Uniform and safety gear provided.',
    salary: '₹11,000',
    jobType: 'Full-Time Job',
    location: 'Zirakpur, Punjab',
    date: '20 May, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1582139329536-e7284fece509?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Helper for Dairy Collection Center',
    description:
        'Need an early riser helper for milk collection, fat measurement assistance and local distribution. 5:00 AM to 9:30 AM only.',
    salary: '₹5,500',
    jobType: 'Part-Time Job',
    location: 'Patiala, Punjab',
    date: '28 May, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1527153857715-3908f2ae5e81?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Cook Required for Tiffin Service',
    description:
        'Need an experienced cook who can prepare authentic home-style nutritious meals for our office tiffin service twice a day.',
    salary: '₹10,000',
    jobType: 'Full-Time Job',
    location: 'Chandigarh',
    date: '01 Jun, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1507048331197-7d4ac70811cf?w=600&auto=format&fit=crop&q=80',
  ),
  const JobModel(
    title: 'Warehouse Loader / Unloader',
    description:
        'Need 3 energetic workers for handling and loading packages at our logistics depot. Same-day daily wages disbursed.',
    salary: '₹500/day',
    jobType: 'Daily Wage Job',
    location: 'Derabassi, Punjab',
    date: '03 Jun, 2024',
    imageUrl:
        'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=600&auto=format&fit=crop&q=80',
  ),
];