import 'package:flutter/material.dart';

class ArtisanProduct {
  final String id;
  final String title;
  final String artisan;
  final String location;
  final int price;
  final int originalPrice;
  final double rating;
  final String category;
  final String imageUrl;
  final bool isDirectArtisan;
  final String description;

  const ArtisanProduct({
    required this.id,
    required this.title,
    required this.artisan,
    required this.location,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.category,
    required this.imageUrl,
    this.isDirectArtisan = true,
    this.description = '',
  });

  int get discountPercent =>
      (((originalPrice - price) / originalPrice) * 100).round();

  IconData get categoryIcon {
    switch (category) {
      case 'Carpets':
        return Icons.texture_rounded;
      case 'Showpieces':
        return Icons.auto_awesome_rounded;
      case 'Clay & Pottery':
        return Icons.palette_outlined;
      case 'Handwoven':
        return Icons.checkroom_rounded;
      case 'Woodcraft':
        return Icons.carpenter_rounded;
      case 'Metalwork':
        return Icons.shield_outlined;
      default:
        return Icons.storefront_rounded;
    }
  }
}

// Curated artisan products matching the reference UI & real Indian artisan clusters
final List<ArtisanProduct> dummyArtisanProducts = [
  // Top Featured: Handmade Carpets & Handcrafted Showpieces
  const ArtisanProduct(
    id: 'prod_carpet_1',
    title: 'Handmade Bhadohi Woolen Carpet',
    artisan: 'Mirzapur Carpet Guild',
    location: 'Bhadohi, UP',
    price: 2899,
    originalPrice: 4200,
    rating: 4.9,
    category: 'Carpets',
    imageUrl: 'assets/images/products/carpet_1.jpg',
    description:
        'Authentic hand-knotted 100% natural wool carpet crafted on traditional pit looms with floral medallion borders and plush density.',
  ),
  const ArtisanProduct(
    id: 'prod_showpiece_1',
    title: 'Handcrafted Brass Peacock Showpiece',
    artisan: 'Moradabad Metal Guild',
    location: 'Moradabad',
    price: 1249,
    originalPrice: 1799,
    rating: 5.0,
    category: 'Showpieces',
    imageUrl: 'assets/images/products/peacock_showpiece.jpg',
    description:
        'Intricately hand-etched brass royal peacock figurine with feather filigree detailing and rich vintage antique patina.',
  ),
  const ArtisanProduct(
    id: 'prod_showpiece_2',
    title: 'Handcrafted Sheesham Elephant Showpiece',
    artisan: 'Saharanpur Wood Carvers',
    location: 'Saharanpur',
    price: 980,
    originalPrice: 1450,
    rating: 4.8,
    category: 'Showpieces',
    imageUrl: 'assets/images/products/elephant_showpiece.jpg',
    description:
        'Hand-carved solid Indian rosewood elephant with delicate jaali undercutting and auspicious royal trunk posture.',
  ),
  const ArtisanProduct(
    id: 'prod_carpet_2',
    title: 'Handmade Kashmiri Silk Floor Rug / Carpet',
    artisan: 'Srinagar Weavers Co-op',
    location: 'Kashmir',
    price: 3499,
    originalPrice: 5200,
    rating: 4.9,
    category: 'Carpets',
    imageUrl: 'assets/images/products/carpet_2.jpg',
    description:
        'Hand-knotted mulberry silk carpet featuring intricate chinar tree and garden motifs woven with natural mineral plant dyes.',
  ),
  const ArtisanProduct(
    id: 'prod_showpiece_3',
    title: 'Handcrafted Dhokra Tribal Horse Showpiece',
    artisan: 'Bastar Tribal Collective',
    location: 'Chhattisgarh',
    price: 1150,
    originalPrice: 1600,
    rating: 4.8,
    category: 'Showpieces',
    imageUrl: 'assets/images/products/dhokra_horse.jpg',
    description:
        'Prehistoric 4000-year-old lost-wax bell metal casting technique passed through generations of Bastar tribal master smiths.',
  ),
  const ArtisanProduct(
    id: 'prod_1',
    title: 'Handmade Terracotta Clay Planter',
    artisan: 'Kamala Devi',
    location: 'Khurja',
    price: 399,
    originalPrice: 599,
    rating: 4.8,
    category: 'Clay & Pottery',
    imageUrl: 'assets/images/products/clay_planter.jpg',
    description:
        'Crafted with river clay from Khurja, hand-etched geometric motifs that allow root breathability naturally.',
  ),
  const ArtisanProduct(
    id: 'prod_2',
    title: 'Handwoven Organic Wool Sweater',
    artisan: 'Kullu Weavers Guild',
    location: 'Himachal',
    price: 1850,
    originalPrice: 2400,
    rating: 4.9,
    category: 'Handwoven',
    imageUrl: 'assets/images/products/wool_sweater.jpg',
    description:
        '100% Himalayan organic wool hand-knitted with traditional cable patterns by master weavers of Kullu valley.',
  ),
  const ArtisanProduct(
    id: 'prod_3',
    title: 'Hand-carved Sheesham Spice Box',
    artisan: 'Saharanpur Craft Collective',
    location: 'Saharanpur',
    price: 749,
    originalPrice: 999,
    rating: 4.7,
    category: 'Woodcraft',
    imageUrl: 'assets/images/products/spice_box.jpg',
    description:
        'Solid Indian rosewood masala box carved with floral filigree, 7 compartments with a glass inspection lid.',
  ),
  const ArtisanProduct(
    id: 'prod_4',
    title: 'Handmade Brass Oil Lamp / Diya',
    artisan: 'Moradabad Metal Guild',
    location: 'Moradabad',
    price: 599,
    originalPrice: 850,
    rating: 5.0,
    category: 'Metalwork',
    imageUrl: 'assets/images/products/brass_diya.jpg',
    description:
        'Pure cast brass diya polished using river sand and mustard oil, resonant chime and timeless auspicious glow.',
  ),
  const ArtisanProduct(
    id: 'prod_5',
    title: 'Jaipur Blue Pottery Floral Vase',
    artisan: 'Kripal Studio',
    location: 'Jaipur',
    price: 890,
    originalPrice: 1200,
    rating: 4.9,
    category: 'Clay & Pottery',
    imageUrl: 'assets/images/products/blue_pottery.jpg',
    description:
        'Hand-glazed quartz and Fuller’s earth pottery fired at low temperature with turquoise mineral pigments.',
  ),
  const ArtisanProduct(
    id: 'prod_6',
    title: 'Organic Indigo Handloom Kurta',
    artisan: 'Varanasi Weavers Co-op',
    location: 'Varanasi',
    price: 1299,
    originalPrice: 1800,
    rating: 4.9,
    category: 'Handwoven',
    imageUrl: 'assets/images/products/handloom_kurta.jpg',
    description:
        'Pure desi cotton spun on traditional amber charkha, fermented plant indigo vat dyed.',
  ),
];
