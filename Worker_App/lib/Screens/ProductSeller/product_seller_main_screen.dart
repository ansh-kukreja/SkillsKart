import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Theme/app_theme.dart';
import '../../Models/seller_product_model.dart';
import '../../Widgets/worker_app_bar.dart';
import '../../Widgets/worker_bottom_nav.dart';
import '../../Widgets/role_switch_sheet.dart';
import '../../Widgets/app_network_image.dart';

class ProductSellerMainScreen extends StatefulWidget {
  const ProductSellerMainScreen({super.key});

  @override
  State<ProductSellerMainScreen> createState() => _ProductSellerMainScreenState();
}

class _ProductSellerMainScreenState extends State<ProductSellerMainScreen> {
  int _currentTab = 0;
  late List<SellerProduct> _products;
  late List<SellerOrder> _orders;

  final List<String> _productPhotoPresets = [
    'assets/images/products/product_vase.jpg',
    'assets/images/products/product_diya.jpg',
    'assets/images/products/product_stole.jpg',
    'assets/images/products/product_cutlery.jpg',
    'assets/images/products/product_craft.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _products = List.from(initialSellerProducts);
    _orders = List.from(initialSellerOrders);
  }


  void _showAddProductDialog() {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final originalPriceController = TextEditingController();
    final stockController = TextEditingController(text: '10');
    final clusterController = TextEditingController(text: 'Mirzapur Craft Hub');
    final descController = TextEditingController();
    String selectedCategory = 'Carpets';
    String selectedPhoto = _productPhotoPresets[0];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: AppColors.primaryWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderWarm,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.productSellerLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.add_photo_alternate_rounded,
                        color: AppColors.productSeller,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'List New Artisan Product',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          'Price & Photos listing for SkillsKart Store',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Select Photo Preview
                Text(
                  'Select Product Photography',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _productPhotoPresets.length,
                    separatorBuilder: (ctx, index) => const SizedBox(width: 10),
                    itemBuilder: (context, idx) {
                      final photo = _productPhotoPresets[idx];
                      final isSelected = selectedPhoto == photo;
                      return GestureDetector(
                        onTap: () => setSheetState(() => selectedPhoto = photo),
                        child: Stack(
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? AppColors.primaryTerracotta : AppColors.borderWarm,
                                  width: isSelected ? 2.5 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AppNetworkImage(
                                  imageUrl: photo,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                  fallbackIcon: Icons.photo_rounded,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryTerracotta,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),

                // Product Title
                _buildFormField('Product Title', titleController, 'e.g. Pure Kashmiri Handloom Pashmina Shawl'),
                const SizedBox(height: 10),

                // Category & Cluster
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButtonFormField<String>(
                            initialValue: selectedCategory,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.borderWarm),
                              ),
                            ),
                            items: ['Carpets', 'Showpieces', 'Pottery', 'Textiles', 'Woodcraft']
                                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: GoogleFonts.plusJakartaSans(fontSize: 13))))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setSheetState(() => selectedCategory = v);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFormField('Craft Origin Cluster', clusterController, 'e.g. Bhadohi, UP'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Price & Original MRP
                Row(
                  children: [
                    Expanded(
                      child: _buildFormField('Selling Price (₹)', priceController, '1899', isNumber: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFormField('Original MRP (₹)', originalPriceController, '2800', isNumber: true),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildFormField('Units in Stock', stockController, '15', isNumber: true),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                _buildFormField('Craft Story & Description', descController, 'Handcrafted using pit loom with pure vegetable dyes...', maxLines: 2),
                const SizedBox(height: 18),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.productSeller,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final title = titleController.text.trim().isEmpty ? 'Handcrafted Artisan Artifact' : titleController.text.trim();
                    final price = int.tryParse(priceController.text) ?? 1499;
                    final origPrice = int.tryParse(originalPriceController.text) ?? (price + 600);
                    final stock = int.tryParse(stockController.text) ?? 10;
                    final cluster = clusterController.text.trim().isEmpty ? 'Local Guild Cluster' : clusterController.text.trim();
                    final desc = descController.text.trim().isEmpty ? 'Authentic handcrafted heritage artisan item.' : descController.text.trim();

                    setState(() {
                      _products.insert(
                        0,
                        SellerProduct(
                          id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
                          title: title,
                          category: selectedCategory,
                          price: price,
                          originalPrice: origPrice,
                          stockQuantity: stock,
                          craftCluster: cluster,
                          imageUrl: selectedPhoto,
                          description: desc,
                          inStock: true,
                          salesCount: 0,
                          rating: 5.0,
                        ),
                      );
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Product "$title" published live on SkillsKart Artisan Store!'),
                        backgroundColor: AppColors.productSeller,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(
                    'Publish to SkillsKart Store',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, TextEditingController controller, String placeholder, {bool isNumber = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBg,
      appBar: const WorkerAppBar(
        currentRole: WorkerRole.productSeller,
      ),
      floatingActionButton: _currentTab == 1 || _currentTab == 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primaryTerracotta,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add_photo_alternate_rounded),
              label: Text(
                'List Product',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
              ),
              onPressed: _showAddProductDialog,
            )
          : null,
      body: IndexedStack(
        index: _currentTab,
        children: [
          _buildSellerDashboardTab(),
          _buildProductsListTab(),
          _buildOrdersTab(),
          _buildStoreProfileTab(),
        ],
      ),
      bottomNavigationBar: WorkerBottomNav(
        currentIndex: _currentTab,
        activeColor: AppColors.primaryTerracotta,
        onTap: (index) => setState(() => _currentTab = index),
        items: const [
          WorkerNavItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
          ),
          WorkerNavItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2_rounded,
            label: 'Products',
          ),
          WorkerNavItem(
            icon: Icons.local_shipping_outlined,
            activeIcon: Icons.local_shipping_rounded,
            label: 'Orders',
          ),
          WorkerNavItem(
            icon: Icons.storefront_outlined,
            activeIcon: Icons.storefront_rounded,
            label: 'My Store',
          ),
        ],
      ),
    );
  }

  // TAB 0: Seller Dashboard
  Widget _buildSellerDashboardTab() {
    final pendingOrdersCount = _orders.where((o) => o.status == OrderStatus.pending).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Status Hero Banner
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2B1B12), AppColors.primaryTerracottaDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryTerracotta.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'ODOP Certified Artisan Store',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.primaryWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(Icons.verified_rounded, color: AppColors.forestGreenLight, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '₹42,850',
                  style: GoogleFonts.fraunces(
                    color: AppColors.primaryWhite,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'September Gross Artisan Store Sales',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 4 Metric Tiles
          Row(
            children: [
              Expanded(
                child: _buildKPI(
                  title: 'Pending Orders',
                  value: '$pendingOrdersCount to pack',
                  icon: Icons.pending_actions_rounded,
                  color: AppColors.amberStar,
                  bg: const Color(0xFFFEF3C7),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKPI(
                  title: 'Active Listings',
                  value: '${_products.length} items',
                  icon: Icons.category_rounded,
                  color: AppColors.productSeller,
                  bg: AppColors.productSellerLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildKPI(
                  title: 'Total Units Sold',
                  value: '214 pieces',
                  icon: Icons.check_circle_outline_rounded,
                  color: AppColors.forestGreen,
                  bg: AppColors.forestGreenLight,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildKPI(
                  title: 'Store Rating',
                  value: '4.9 ★ (188 rev)',
                  icon: Icons.star_rounded,
                  color: AppColors.amberStar,
                  bg: const Color(0xFFFFFBEB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick Action: List Product Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderWarm),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.productSellerLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.productSeller, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'List products: Price & photos',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        'Add handcrafted inventory to the consumer store',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.productSeller,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  onPressed: _showAddProductDialog,
                  child: const Text('Add Item', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Recent Orders Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders for Dispatch',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _currentTab = 2),
                child: Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.productSeller,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ..._orders.take(2).map((order) => _buildOrderTile(order)),
        ],
      ),
    );
  }

  Widget _buildKPI({required String title, required String value, required IconData icon, required Color color, required Color bg}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
                child: Icon(icon, size: 14, color: color),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  // TAB 1: Products Inventory List
  Widget _buildProductsListTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Artisan Catalog (${_products.length})',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Manage pricing, photos, and stock status',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.productSeller,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add', style: TextStyle(fontSize: 12)),
                onPressed: _showAddProductDialog,
              ),
            ],
          ),
          const SizedBox(height: 14),

          ..._products.map((product) => _buildProductInventoryCard(product)),
        ],
      ),
    );
  }

  Widget _buildProductInventoryCard(SellerProduct product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppNetworkImage(
              imageUrl: product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              fallbackIcon: Icons.shopping_bag_rounded,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.productSellerLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.category,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.productSeller,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          product.inStock ? 'In Stock' : 'Out of Stock',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: product.inStock ? AppColors.forestGreen : AppColors.notificationRed,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.7,
                          child: Switch(
                            value: product.inStock,
                            activeThumbColor: AppColors.forestGreen,
                            onChanged: (val) {
                              setState(() => product.inStock = val);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cluster: ${product.craftCluster} • ${product.stockQuantity} units left',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${product.price}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${product.originalPrice}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.productSeller),
                      onPressed: () {
                        final editController = TextEditingController(text: product.price.toString());
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Edit Price', style: GoogleFonts.fraunces()),
                            content: TextField(
                              controller: editController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Selling Price (₹)'),
                            ),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    product.price = int.tryParse(editController.text) ?? product.price;
                                  });
                                  Navigator.pop(ctx);
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TAB 2: Orders Management
  Widget _buildOrdersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Fulfillment Pipeline',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pack and dispatch artisan items directly to buyers',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),

          ..._orders.map((order) => _buildOrderTile(order)),
        ],
      ),
    );
  }

  Widget _buildOrderTile(SellerOrder order) {
    String statusText;
    Color statusColor;
    Color statusBg;

    switch (order.status) {
      case OrderStatus.pending:
        statusText = 'Needs Packing';
        statusColor = AppColors.amberStar;
        statusBg = const Color(0xFFFEF3C7);
        break;
      case OrderStatus.packed:
        statusText = 'Ready for Courier';
        statusColor = AppColors.productSeller;
        statusBg = AppColors.productSellerLight;
        break;
      case OrderStatus.shipped:
        statusText = 'In Transit';
        statusColor = const Color(0xFF2563EB);
        statusBg = const Color(0xFFEFF6FF);
        break;
      case OrderStatus.delivered:
        statusText = 'Delivered';
        statusColor = AppColors.forestGreen;
        statusBg = AppColors.forestGreenLight;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.id,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statusText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AppNetworkImage(
                  imageUrl: order.productImageUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  fallbackIcon: Icons.inventory_2_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      'Qty: ${order.quantity} • Total ₹${order.totalAmount}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Deliver to: ${order.customerName}, ${order.customerAddress}',
            style: GoogleFonts.plusJakartaSans(fontSize: 11.5, color: AppColors.textBody),
          ),
          const Divider(height: 18, color: AppColors.borderLight),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderDate,
                style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted),
              ),
              if (order.status == OrderStatus.pending)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.productSeller,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  onPressed: () {
                    setState(() => order.status = OrderStatus.packed);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order ${order.id} marked Packed! Courier pickup scheduled.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Mark Packed', style: TextStyle(fontSize: 12)),
                )
              else if (order.status == OrderStatus.packed)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  ),
                  onPressed: () {
                    setState(() => order.status = OrderStatus.shipped);
                  },
                  child: const Text('Dispatch / Ship', style: TextStyle(fontSize: 12)),
                )
              else
                Text(
                  'AWB: ${order.trackingNo}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.productSeller,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // TAB 3: Store Profile
  Widget _buildStoreProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryTerracotta, width: 2),
                  ),
                  child: const AppNetworkImage(
                    imageUrl: 'assets/images/banners/artisan_workshop_banner.jpg',
                    width: 88,
                    height: 88,
                    isCircle: true,
                    fallbackIcon: Icons.storefront_rounded,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mirzapur Carpet & Brass Guild',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  'Artisan Cooperative • Bhadohi Cluster',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.productSellerLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ODOP India Verified Seller • GSTIN Verified',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.productSeller,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Store Credentials & Settlement',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),

          _buildProfileTile(Icons.account_balance_rounded, 'Bank Account', 'State Bank of India (••4190) • Verified'),
          _buildProfileTile(Icons.badge_rounded, 'Artisan Registration', 'Ministry of Textiles Pehchan Card #UP-88219'),
          _buildProfileTile(Icons.local_shipping_rounded, 'Courier Logistics', 'Integrated Delhivery & India Post SpeedPost'),
          _buildProfileTile(Icons.policy_rounded, 'Return Policy', '7 Days Easy Replacement for Damaged Handcrafts'),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.notificationRed,
              side: const BorderSide(color: AppColors.notificationRed),
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout_rounded, size: 18),
            label: Text(
              'Log Out of Product Seller',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            onPressed: () => WorkerAppBar.performLogout(context, 'Product Seller'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.productSellerLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.productSeller, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
