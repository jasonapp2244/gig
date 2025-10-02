import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:gig/models/category_model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../res/colors/app_color.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({super.key});

  @override
  State<SingleProductScreen> createState() => _SingleProductScreen();
}

class _SingleProductScreen extends State<SingleProductScreen> {
  bool descExpanded = false;
  bool infoExpanded = false;
  bool reviewExpanded = false;

  final PageController _pageController = PageController();
  int _currentIndex = 0;
  List<CategoryModel>? categories;


  late Map<String, dynamic> productData;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get product data passed from previous screen
    productData = Get.arguments ?? {};
  }

  // Helper function to get image URLs
  String _getImageUrl(dynamic imageData) {
    if (imageData == null) return 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c';
    
    String path = imageData;
    if (path.startsWith('http')) {
      return 'https://gig.devonlinetestserver.com/storage/$path';
    } else {
      return 'https://gig.devonlinetestserver.com/storage/$path';
    }
  }

  List<String> get _productImages {
    List<String> images = [];
    if (productData['images'] != null && productData['images'].isNotEmpty) {
      for (var image in productData['images']) {
        images.add(_getImageUrl(image['path']));
      }
    }
    // Add placeholder if no images
    if (images.isEmpty) {
      images.add('https://images.unsplash.com/photo-1600585154340-be6161a56a0c');
    }
    return images;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Area
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 35,
                  left: 35,
                  child: Text(
                    'Product',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColor.secondColor,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            // Body content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _productImages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    _productImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 220,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value:
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 220,
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: Icon(
                              Icons.shopping_cart_checkout,
                              color: AppColor.primeColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _productImages.length,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData['title'] ?? 'No Title',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '\$${productData['new_price'] ?? '0'}',
                                style: TextStyle(
                                  color: AppColor.primeColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 12),
                              if (productData['old_price'] !=
                                  productData['new_price'])
                                Text(
                                  '\$${productData['old_price'] ?? '0'}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                productData['location'] ??
                                    'Location not specified',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 12),
                              Icon(
                                Icons.category,
                                color: Colors.grey,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                productData['category']?['category'] ??
                                    'No Category',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    productData['user']?['profile_image'] !=
                                        null
                                    ? NetworkImage(
                                        productData['user']['profile_image'],
                                      )
                                    : null,
                                child:
                                    productData['user']?['profile_image'] ==
                                        null
                                    ? Icon(Icons.person, color: Colors.white)
                                    : null,
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['user']?['name'] ??
                                        'Unknown Seller',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Member since ${DateTime.parse(productData['user']?['created_at'] ?? DateTime.now().toString()).year}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Send seller a message",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade700),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.messageSquare,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      hintText: "Message seller...",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: AppColor.primeColor,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // Accordion Section
                          buildAccordion(
                            "Description",
                            descExpanded,
                            () {
                              setState(() => descExpanded = !descExpanded);
                            },
                            "Detailed description here.",
                          ),

                          buildAccordion(
                            "Additional information",
                            infoExpanded,
                            () {
                              setState(() => infoExpanded = !infoExpanded);
                            },
                            "Weight: 1kg\nMaterial: Organic",
                          ),

                          buildAccordion("Reviews(0)", reviewExpanded, () {
                            setState(() => reviewExpanded = !reviewExpanded);
                          }, "No reviews yet."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAccordion(
    String title,
    bool expanded,
    VoidCallback onTap,
    String content,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(title, style: TextStyle(color: Colors.white)),
          trailing: Icon(
            expanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onTap: onTap,
        ),
        if (expanded)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(content, style: TextStyle(color: Colors.white70)),
          ),
      ],
    );
  }
}
