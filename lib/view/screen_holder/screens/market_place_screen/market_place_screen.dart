import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/models/category_model.dart';
import 'package:gig/res/routes/routes.dart';
import 'package:gig/view_models/controller/market_place/market_place_model.dart';
import '../../../../res/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';

import '../../../../res/colors/app_color.dart';

class MarketPplaceScreen extends StatefulWidget {
  const MarketPplaceScreen({super.key});

  @override
  State<MarketPplaceScreen> createState() => _MarketPplaceScreen();
}

class _MarketPplaceScreen extends State<MarketPplaceScreen> {
  int selectedTab = 0;
  List<CategoryModel>? categories;

  List<Map<String, String>> items = [
    {
      "image": "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
      "title": "simply dummy text",
    },
    {
      "image": "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
      "title": "simply dummy text",
    },
    {
      "image": "https://images.unsplash.com/photo-1525097487452-6278ff080c31",
      "title": "simply dummy text",
    },
    {
      "image": "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce",
      "title": "simply dummy text",
    },
    {
      "image": "https://images.unsplash.com/photo-1503342217505-b0a15ec3261c",
      "title": "simply dummy text",
    },
    {
      "image": "https://images.unsplash.com/photo-1530554764233-e79e16c91d08",
      "title": "simply dummy text",
    },
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
                    'Market Place',
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

            // Tabs + Grid in Expanded
            Expanded(
              child: Column(
                children: [
                  // Top Tab Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                                Get.toNamed(RoutesName.createAddsScreen);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 0
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.sell,
                                    color: selectedTab == 0
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Sell",
                                    style: TextStyle(
                                      color: selectedTab == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => selectedTab = 1),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? Colors.orange
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange),
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.category,
                                    color: selectedTab == 1
                                        ? Colors.white
                                        : Colors.orange,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    "Categories",
                                    style: TextStyle(
                                      color: selectedTab == 1
                                          ? Colors.white
                                          : Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Grid View
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.90,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed(RoutesName.singleProductScreen);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item['image']!,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                item['title']!,
                                style: TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
