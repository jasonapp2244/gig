import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../res/colors/app_color.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({super.key});

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  late dynamic product;
  int _currentImageIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Get the product data passed from the previous screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.arguments != null) {
        setState(() {
          product = Get.arguments;
          _isLoading = false;
        });
      }
    });
  }

  String _getImageUrl(dynamic imageData) {
    if (imageData['path'] != null) {
      String path = imageData['path'];
      // Check if the path is a full URL or needs to be constructed
      if (path.startsWith('http')) {
        return path;
      } else {
        return 'https://lavender-buffalo-882516.hostingersite.com/gig_app/storage/app/public/$path';
      }
    }
    // Return a placeholder image if no image is available
    return 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(color: AppColor.primeColor),
              )
            : Column(
                children: [
                  // AppBar with back button and title
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          bottom: 10,
                          top: 10,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.arrow_back,
                              color: AppColor.primeColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 35,
                        left: 35,
                        child: Text(
                          'Product Details',
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

                  // Product Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image Carousel
                          Container(
                            height: 300,
                            child: Stack(
                              children: [
                                // Main Image
                                PageView.builder(
                                  itemCount: product['images'] != null
                                      ? product['images'].length
                                      : 1,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product['images'] != null &&
                                                product['images'].isNotEmpty
                                            ? _getImageUrl(
                                                product['images'][index],
                                              )
                                            : _getImageUrl({}),
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (
                                              BuildContext context,
                                              Widget child,
                                              ImageChunkEvent? loadingProgress,
                                            ) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
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

                                // Image Indicator
                                if (product['images'] != null &&
                                    product['images'].length > 1)
                                  Positioned(
                                    bottom: 10,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        product['images'].length,
                                        (index) => Container(
                                          width: 8,
                                          height: 8,
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _currentImageIndex == index
                                                ? AppColor.primeColor
                                                : Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),

                          // Product Title
                          Text(
                            product['title'] ?? 'No Title',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          SizedBox(height: 10),

                          // Price Information
                          Row(
                            children: [
                              Text(
                                '\$${product['new_price'] ?? '0'}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primeColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              if (product['old_price'] != null &&
                                  product['old_price'] != product['new_price'])
                                Text(
                                  '\$${product['old_price']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Product Details Card
                          Card(
                            color: AppColor.grayColor,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Product Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 15),

                                  // Condition
                                  _buildDetailRow(
                                    'Condition',
                                    product['condition'] ?? 'Not specified',
                                  ),
                                  SizedBox(height: 10),

                                  // Category
                                  _buildDetailRow(
                                    'Category',
                                    product['category'] != null
                                        ? product['category']['category'] ??
                                              'Not specified'
                                        : 'Not specified',
                                  ),
                                  SizedBox(height: 10),

                                  // Location
                                  _buildDetailRow(
                                    'Location',
                                    product['location'] ?? 'Not specified',
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Description
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            product['description'] ??
                                'No description available',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),

                          SizedBox(height: 30),

                          // Contact Seller Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Implement contact functionality
                                Get.snackbar(
                                  'Contact Seller',
                                  'This would open a chat with the seller',
                                  backgroundColor: AppColor.primeColor,
                                  colorText: Colors.white,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.primeColor,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Contact Seller',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:gig/res/routes/routes_name.dart';

// import '../../../../res/colors/app_color.dart';

// class DetailScreenView extends StatefulWidget {
//   const DetailScreenView({super.key});

//   @override
//   State<DetailScreenView> createState() => _DetailScreenView();
// }

// class _DetailScreenView extends State<DetailScreenView> {
//   int selectedTab = 0;

//   List<Map<String, String>> items = [
//     {
//       "image": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
//       "title": "simply dummy text",
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
//       "title": "simply dummy text",
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1525097487452-6278ff080c31",
//       "title": "simply dummy text",
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce",
//       "title": "simply dummy text",
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c",
//       "title": "simply dummy text",
//     },
//     {
//       "image": "https://images.unsplash.com/photo-1530554764233-e79e16c91d08",
//       "title": "simply dummy text",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.appBodyBG,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // AppBar Area
//             Stack(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: InkWell(
//                       onTap: () => Navigator.pop(context),
//                       child: Icon(Icons.arrow_back, color: AppColor.primeColor),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 10,
//                   right: 35,
//                   left: 35,
//                   child: Text(
//                     'Market Place',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: AppColor.secondColor,
//                       fontWeight: FontWeight.w400,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),

//             // Tabs + Grid in Expanded
//             Expanded(
//               child: Column(
//                 children: [
//                   // Top Tab Buttons
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 16,
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => setState(() => selectedTab = 0),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               decoration: BoxDecoration(
//                                 color: selectedTab == 0
//                                     ? Colors.white
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.white),
//                               ),
//                               alignment: Alignment.center,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.sell,
//                                     color: selectedTab == 0
//                                         ? Colors.black
//                                         : Colors.white,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     "Sell",
//                                     style: TextStyle(
//                                       color: selectedTab == 0
//                                           ? Colors.black
//                                           : Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 12),
//                         Expanded(
//                           child: GestureDetector(
//                             onTap: () => setState(() => selectedTab = 1),
//                             child: Container(
//                               padding: EdgeInsets.symmetric(vertical: 12),
//                               decoration: BoxDecoration(
//                                 color: selectedTab == 1
//                                     ? Colors.orange
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.orange),
//                               ),
//                               alignment: Alignment.center,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.category,
//                                     color: selectedTab == 1
//                                         ? Colors.white
//                                         : Colors.orange,
//                                   ),
//                                   SizedBox(width: 6),
//                                   Text(
//                                     "Categories",
//                                     style: TextStyle(
//                                       color: selectedTab == 1
//                                           ? Colors.white
//                                           : Colors.orange,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Grid View
//                   Expanded(
//                     child: GridView.builder(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 0,
//                       ),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 1,
//                         crossAxisSpacing: 16,
//                         childAspectRatio: 0.90,
//                       ),
//                       itemCount: items.length,
//                       itemBuilder: (context, index) {
//                         final item = items[index];
//                         return GestureDetector(
//                           onTap: () {
//                             Get.toNamed(RoutesName.singleProductScreen);
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: Image.network(
//                                   item['image']!,
//                                   height: 120,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               SizedBox(height: 6),
//                               Text(
//                                 item['title']!,
//                                 style: TextStyle(color: Colors.white70),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
