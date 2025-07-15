import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gig/res/routes/routes_name.dart';
import '../../res/colors/app_color.dart';
import '../../res/fonts/app_fonts.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String selectedPlanTitle = 'Basic';
  String selectedPlanPrice = '\$2.99/month';

  final List<SubscriptionPlan> plans = [
    SubscriptionPlan(
      title: 'Basic',
      price: '\$2.99/month',
      features: ['Ads free', 'Weekly Updates'],
    ),
    SubscriptionPlan(
      title: 'Standard',
      price: '\$4.99/month',
      features: [
        'Ads free',
        'Weekly Updates',
        'Offline Access',
        'Weekly Magazines',
        'Premium Content & Exclusive Articles',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBodyBG,
      body: SafeArea(
        child: Column(
          children: [
            // Back Button
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: AppColor.primeColor),
                ),
              ),
            ),
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Select Your Plan to \nStay Informed & Connected',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColor.secondColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: List.generate(plans.length, (index) {
                        bool isSelected =
                            plans[index].title == selectedPlanTitle;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPlanTitle = plans[index].title;
                              selectedPlanPrice = plans[index].price;
                              print(
                                '=========================== $selectedPlanTitle',
                              );
                              print(
                                '=========================== $selectedPlanPrice',
                              );
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // color: const Color(0xFF0A0F1C),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColor.secondColor
                                    : Colors.white24,
                                width: 1.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plans[index].title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      plans[index].price,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 12,
                                      runSpacing: 8,
                                      children: plans[index].features.map((
                                        feature,
                                      ) {
                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check,
                                              color: AppColor.primeColor,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              feature,
                                              style: TextStyle(
                                                color: AppColor.primeColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppColor.secondColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
                top: 10,
              ),
              
              child: 
              InkWell(
                onTap: () {
                  Get.toNamed(
                    RoutesName.paymentMethodScreen,
                    arguments: {
                      'selectedPlan': selectedPlanTitle,
                      'selectedPrice': selectedPlanPrice,
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColor.primeColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Subscribe',
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: 16,
                      fontFamily: AppFonts.appFont,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionPlan {
  final String title;
  final String price;
  final List<String> features;

  SubscriptionPlan({
    required this.title,
    required this.price,
    required this.features,
  });
}
