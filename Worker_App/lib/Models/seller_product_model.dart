enum OrderStatus {
  pending,
  packed,
  shipped,
  delivered,
}

class SellerProduct {
  final String id;
  String title;
  String category;
  int price;
  int originalPrice;
  int stockQuantity;
  String craftCluster;
  String imageUrl;
  String description;
  bool inStock;
  int salesCount;
  double rating;

  SellerProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.originalPrice,
    required this.stockQuantity,
    required this.craftCluster,
    required this.imageUrl,
    required this.description,
    this.inStock = true,
    this.salesCount = 0,
    this.rating = 4.9,
  });

  int get discountPercent => originalPrice > price
      ? (((originalPrice - price) / originalPrice) * 100).round()
      : 0;
}

class SellerOrder {
  final String id;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final String productTitle;
  final String productImageUrl;
  final int quantity;
  final int totalAmount;
  final String orderDate;
  OrderStatus status;
  final String trackingNo;

  SellerOrder({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.productTitle,
    required this.productImageUrl,
    required this.quantity,
    required this.totalAmount,
    required this.orderDate,
    this.status = OrderStatus.pending,
    required this.trackingNo,
  });
}

// Initial realistic static mock data for Product Seller
final List<SellerProduct> initialSellerProducts = [
  SellerProduct(
    id: 'prod_carpet_1',
    title: 'Handmade Bhadohi Woolen Carpet',
    category: 'Carpets',
    price: 2899,
    originalPrice: 4200,
    stockQuantity: 14,
    craftCluster: 'Bhadohi, UP',
    imageUrl: 'assets/images/products/product_vase.jpg',
    description: 'Authentic hand-knotted 100% natural wool carpet crafted on traditional pit looms with floral medallion borders.',
    inStock: true,
    salesCount: 38,
    rating: 4.9,
  ),
  SellerProduct(
    id: 'prod_showpiece_1',
    title: 'Handcrafted Brass Peacock Showpiece',
    category: 'Showpieces',
    price: 1249,
    originalPrice: 1799,
    stockQuantity: 26,
    craftCluster: 'Moradabad Metal Guild',
    imageUrl: 'assets/images/products/product_diya.jpg',
    description: 'Intricately hand-etched brass royal peacock figurine with feather filigree detailing and rich vintage antique patina.',
    inStock: true,
    salesCount: 64,
    rating: 5.0,
  ),
  SellerProduct(
    id: 'prod_showpiece_2',
    title: 'Handcrafted Sheesham Elephant Showpiece',
    category: 'Showpieces',
    price: 980,
    originalPrice: 1450,
    stockQuantity: 8,
    craftCluster: 'Saharanpur Wood Carvers',
    imageUrl: 'assets/images/products/product_stole.jpg',
    description: 'Hand-carved solid Indian rosewood elephant with delicate jaali undercutting and auspicious royal trunk posture.',
    inStock: true,
    salesCount: 52,
    rating: 4.8,
  ),
  SellerProduct(
    id: 'prod_carpet_2',
    title: 'Handmade Kashmiri Silk Floor Rug',
    category: 'Carpets',
    price: 3499,
    originalPrice: 5200,
    stockQuantity: 5,
    craftCluster: 'Srinagar Weavers Co-op',
    imageUrl: 'assets/images/products/product_craft.jpg',
    description: 'Hand-knotted mulberry silk carpet featuring intricate chinar tree and garden motifs woven with natural mineral plant dyes.',
    inStock: true,
    salesCount: 19,
    rating: 4.9,
  ),
  SellerProduct(
    id: 'prod_pottery_1',
    title: 'Blue Pottery Ceramic Flower Vase',
    category: 'Pottery',
    price: 650,
    originalPrice: 950,
    stockQuantity: 18,
    craftCluster: 'Jaipur Blue Pottery Cluster',
    imageUrl: 'assets/images/products/product_cutlery.jpg',
    description: 'Quartz dough and natural copper oxide blue glazed decorative urn vase with traditional Mughal motifs.',
    inStock: true,
    salesCount: 41,
    rating: 4.7,
  ),
];

final List<SellerOrder> initialSellerOrders = [
  SellerOrder(
    id: 'ORD-8942',
    customerName: 'Pooja Batra',
    customerAddress: 'Flat 302, Green Avenue, Sector 68, Mohali, Punjab',
    customerPhone: '+91 98729 11022',
    productTitle: 'Handmade Bhadohi Woolen Carpet',
    productImageUrl: 'assets/images/products/product_vase.jpg',
    quantity: 1,
    totalAmount: 2899,
    orderDate: 'Today • 11:20 AM',
    status: OrderStatus.pending,
    trackingNo: 'SK-DEL-894210',
  ),
  SellerOrder(
    id: 'ORD-8938',
    customerName: 'Aakash Verma',
    customerAddress: 'House 19, Model Town, Civil Lines, Ludhiana',
    customerPhone: '+91 98150 99441',
    productTitle: 'Handcrafted Brass Peacock Showpiece',
    productImageUrl: 'assets/images/products/product_diya.jpg',
    quantity: 2,
    totalAmount: 2498,
    orderDate: 'Yesterday • 4:45 PM',
    status: OrderStatus.packed,
    trackingNo: 'SK-DEL-893844',
  ),
  SellerOrder(
    id: 'ORD-8921',
    customerName: 'Sunita Mehra',
    customerAddress: 'House 44B, Sector 15, Chandigarh',
    customerPhone: '+91 94172 00192',
    productTitle: 'Handcrafted Sheesham Elephant Showpiece',
    productImageUrl: 'assets/images/products/product_stole.jpg',
    quantity: 1,
    totalAmount: 980,
    orderDate: '12 Sept 2024',
    status: OrderStatus.shipped,
    trackingNo: 'SK-DEL-892190',
  ),
];
