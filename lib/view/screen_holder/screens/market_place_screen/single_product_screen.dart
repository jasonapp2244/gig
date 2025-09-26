import 'package:flutter/material.dart';
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

  List<String> sliderImages = [
    'https://images.unsplash.com/photo-1600891964599-f61ba0e24092',
    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c',
  ];

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
                              itemCount: sliderImages.length,
                              onPageChanged: (index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return ClipRRect(
                                  child: Image.network(
                                    sliderImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
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
                          sliderImages.length,
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
                            "Lorem ipsum dolor sit amet",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text(
                                "4.1",
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "| 128 Reviews",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                                      hintText: "Message",
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: Colors.orange,
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Lorem ipsum dolor sit amet, consectetur adip...",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "View more",
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),

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
