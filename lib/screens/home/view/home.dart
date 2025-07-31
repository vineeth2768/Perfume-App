import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/home/controller/product_controller.dart';
import 'package:flutter_application_2/screens/home/model/product_model.dart';
import 'package:flutter_application_2/widgets/home_app_bar.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ProductController productController = Get.put(ProductController());

  // Define consistent text styles for headers
  static const TextStyle _headerTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontFamily: 'Hellix',
    fontWeight: FontWeight.w700,
  );

  static const TextStyle _viewAllTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Hellix',
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
  );

  // A list of soft colors for category backgrounds
  final List<Color> categoryBackgroundColors = [
    Colors.yellow[100]!,
    Colors.blue[100]!,
    Colors.red[100]!,
    Colors.green[100]!,
    Colors.purple[100]!,
    Colors.orange[100]!,
    Colors.teal[100]!,
    Colors.brown[100]!,
    Colors.cyan[100]!,
    Colors.indigo[100]!,
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const HomeAppBar(), // Your custom app bar
      body: Obx(() {
        if (productController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (productController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    productController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 25),
                  ElevatedButton.icon(
                    onPressed: () => productController.getProduct(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry', style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (productController.carouselBanners.isEmpty &&
            productController.brands.isEmpty &&
            productController.categories.isEmpty &&
            productController.justLaunchedProducts.isEmpty &&
            productController.bestsellersProducts.isEmpty &&
            productController.rfqBanner.value == null &&
            productController.futureOrderBanner.value == null &&
            productController.bannerGridItems.isEmpty &&
            productController.bottomBanner.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Banner Slider (Carousel) ---
                if (productController.carouselBanners.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: CarouselSlider.builder(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        height: screenHeight * 0.20,
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                      itemCount: productController.carouselBanners.length,
                      itemBuilder: (context, index, realIndex) {
                        final item = productController.carouselBanners[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              item.image ??
                                  'https://via.placeholder.com/600x200?text=No+Image',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blueAccent,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // --- Header for "Shop by brands" ---
                if (productController.brands.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shop by brands', style: _headerTextStyle),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'View All',
                            style: _viewAllTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Brands List (Horizontal) ---
                if (productController.brands.isNotEmpty)
                  SizedBox(
                    height: screenHeight * 0.12,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: productController.brands.length,
                      itemBuilder: (context, index) {
                        final brand = productController.brands[index];
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            width: screenWidth * 0.4,
                            margin: const EdgeInsets.only(right: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.08),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Image.network(
                              brand.image ??
                                  'https://via.placeholder.com/80/000000/FFFFFF?text=Brand',
                              width: screenWidth * 0.15,
                              height: screenWidth * 0.1,
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.blueAccent,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    brand.name ?? 'Brand',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // --- Header for "Our Categories" ---
                if (productController.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Our Categories', style: _headerTextStyle),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'View All',
                            style: _viewAllTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Categories Grid ---
                if (productController.categories.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: productController.categories.length,
                      itemBuilder: (context, index) {
                        final category = productController.categories[index];
                        final Color backgroundColor =
                            categoryBackgroundColors[index %
                                categoryBackgroundColors.length];

                        return InkWell(
                          onTap: () {
                            print('Tapped on category: ${category.name}');
                          },
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: backgroundColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Image.network(
                                      category.image ??
                                          'https://via.placeholder.com/100?text=No+Image',
                                      width: screenWidth * 0.15,
                                      height: screenWidth * 0.15,
                                      fit: BoxFit.contain,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.blueAccent,
                                              ),
                                            );
                                          },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 30,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8), // Increased spacing
                              Text(
                                category.name ?? 'Category',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontFamily: 'Hellix',
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                // --- Request for Quote (RFQ) Banner ---
                if (productController.rfqBanner.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        height: screenHeight * 0.22,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Image.network(
                              productController.rfqBanner.value!.image ??
                                  'https://via.placeholder.com/800x300?text=RFQ+Banner',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.blueAccent,
                                      ),
                                    );
                                  },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Colors.black.withOpacity(0.6),
                                      Colors.black.withOpacity(0.1),
                                    ],
                                    stops: const [0.0, 0.7],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 25,
                              left: 20,
                              child: Text(
                                'Request for Quote',
                                style: _headerTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  print('Create RFQ button tapped');
                                },
                                icon: const Icon(
                                  Icons.note_add_outlined,
                                  color: Colors.black87,
                                ),
                                label: const Text(
                                  'Create RFQ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 16,
                                    fontFamily: 'Hellix',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // --- Header for "Just Launched" Products ---
                if (productController.justLaunchedProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Just Launched', style: _headerTextStyle),
                        InkWell(
                          onTap: () {},
                          child: const Text(
                            'View All',
                            style: _viewAllTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Just Launched Products List (Horizontal Scroll) ---
                if (productController.justLaunchedProducts.isNotEmpty)
                  SizedBox(
                    height: screenHeight * 0.32,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: productController.justLaunchedProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productController.justLaunchedProducts[index];
                        return _buildProductCard(
                          product,
                          screenWidth,
                          screenHeight,
                        );
                      },
                    ),
                  ),

                // --- Future Order Banner ---
                if (productController.futureOrderBanner.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          print('Future Order Banner tapped');
                          // Navigate to future order screen
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.network(
                            productController.futureOrderBanner.value!.image ??
                                'https://via.placeholder.com/800x300?text=Future+Order+Banner',
                            width: double.infinity,
                            height: screenHeight * 0.20,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // --- Banner Grid ---
                if (productController.bannerGridItems.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                0.8, // Adjusted aspect ratio for banners
                          ),
                      itemCount: productController.bannerGridItems.length,
                      itemBuilder: (context, index) {
                        final banner = productController.bannerGridItems[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              print(
                                'Banner Grid Item tapped: ${banner.id} - ${banner.type}',
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                banner.image ??
                                    'https://via.placeholder.com/400x200?text=Banner+Grid',
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.fill,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.blueAccent,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                // --- Header for "Our Bestsellers" Products ---
                if (productController.bestsellersProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Our Bestsellers', style: _headerTextStyle),
                        InkWell(
                          onTap: () {
                            print('View All Bestsellers tapped');
                          },
                          child: const Text(
                            'View All',
                            style: _viewAllTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),

                // --- Our Bestsellers Products Grid ---
                if (productController.bestsellersProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                      itemCount: productController.bestsellersProducts.length,
                      itemBuilder: (context, index) {
                        final product =
                            productController.bestsellersProducts[index];
                        return _buildProductCard(
                          product,
                          screenWidth,
                          screenHeight,
                        );
                      },
                    ),
                  ),

                // --- Bottom Single Banner ---
                if (productController.bottomBanner.value != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {
                          print(
                            'Bottom Banner tapped: ${productController.bottomBanner.value!.id} - ${productController.bottomBanner.value!.type}',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Image.network(
                            productController.bottomBanner.value!.image ??
                                'https://via.placeholder.com/800x300?text=Bottom+Banner',
                            width: double.infinity,
                            height: screenHeight * 0.20,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
      }),
    );
  }

  //  product card
  Widget _buildProductCard(
    Product product,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      width: screenWidth * 0.50,
      margin: const EdgeInsets.only(right: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.image ??
                      'https://via.placeholder.com/200x200?text=No+Image',
                  height: screenHeight * 0.15,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.blueAccent,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              if (product.offer != null &&
                  product.offer!.isNotEmpty &&
                  product.offer != '0% OFF')
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product.offer!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    print('Wishlist toggled for ${product.name}');
                  },
                  child: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 26,
                    shadows: const [
                      Shadow(
                        blurRadius: 4.0,
                        color: Colors.black38,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    product.name ?? 'No Name',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                      fontFamily: 'Hellix',
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  if (product.actualPrice != null &&
                      product.actualPrice!.isNotEmpty &&
                      product.actualPrice != product.price)
                    Text(
                      '${product.currency ?? ''}${product.actualPrice}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'Hellix',
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey,
                      ),
                    ),
                  const SizedBox(height: 3),
                  Text(
                    '${product.currency ?? ''}${product.price ?? 'N/A'}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Hellix',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            print('RFQ button tapped for ${product.name}');
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.grey,
                              width: 1.5,
                            ), // Blue outline
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            foregroundColor: Colors.black,
                          ),
                          child: const Text(
                            'RFQ',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Hellix',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('Add to Cart tapped for ${product.name}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                          ),
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'Hellix',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
