import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import '../../../../res/colors/app_color.dart';

class CreateAddsScreen extends StatefulWidget {
  const CreateAddsScreen({super.key});

  @override
  State<CreateAddsScreen> createState() => _CreateAddsScreen();
}

class _CreateAddsScreen extends State<CreateAddsScreen> {
  int selectedTab = 0;
  bool _isBottomSheetShown = false;

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
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (!_isBottomSheetShown) {
        _showBottomSheet();
        _isBottomSheetShown = true;
      }
    });
  }

  void _showBottomSheet() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'BottomSheet',
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Create new listening",
                      style: TextStyle(
                        color: Color(0xFF0F1828),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "------ Pay a \$1 to post anything -----",
                      style: TextStyle(color: Color(0xFF0F1828), fontSize: 14),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        Get.toNamed(RoutesName.addPaymentScreen);
                        await Future.delayed(Duration(seconds: 1));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColor.primeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Text(
                          "Pay Now",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                            onTap: () => setState(() => selectedTab = 0),
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
